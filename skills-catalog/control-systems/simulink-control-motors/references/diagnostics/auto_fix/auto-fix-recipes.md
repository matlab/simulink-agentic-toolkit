# Auto-Fix Recipes

> **Purpose:** Diagnose and fix common motor-control simulation failures.
> The agent reads these recipes and applies fixes using `model_edit` / `evaluate_matlab_code`.

---

## Quick Symptom Map

| Symptom | Recipe |
|---------|--------|
| Motor spins wrong direction | [Fix Phase Order](#fix-phase-order) |
| Simulation fails with algebraic loop error | [Fix Algebraic Loop](#fix-algebraic-loop) |
| Current oscillates at high frequency, speed overshoots | [Reduce PI Bandwidth](#reduce-pi-bandwidth) |
| NaN / divergence / "Derivative not finite" after short time | [Fix Voltage Saturation](#fix-voltage-saturation) |
| Motor vibrates but doesn't spin (hardware) | [Calibrate ADC Offset](#calibrate-adc-offset) |
| Need overcurrent/overvoltage/watchdog protection | [Build Protection Subsystem](#build-protection-subsystem) |
| Verify protection logic after build | [Test Protection Subsystem](#test-protection-subsystem) |

---

## Fix Phase Order

### When to Use
- Motor spins opposite to the commanded direction in simulation or on hardware.

### Root Cause
Phase sequence (A-B-C) determines rotation direction. If wiring or model convention doesn't match the physical motor, it spins backwards.

### Why Two Methods Are Equivalent
In FOC, the speed reference determines the sign of iq (torque-producing current). Negating speed negates iq, which negates torque and reverses rotation. Swapping any two phases reverses the rotating magnetic field by inverting one orthogonal axis in the Clarke transform. Both achieve the same result through different mechanisms.

### Why "Negate" Is Default
- Reversible and auditable (parameter change visible in diffs).
- No risk of introducing algebraic loops from rewiring.
- No risk of incorrect port connections (swapping A↔C instead of B↔C could cause asymmetric behavior).
- Doesn't require physical manipulation on hardware.

### Default Method
If no method is specified, default to `negate` (simpler, no rewiring needed).

### Method 1: Negate Speed Reference (preferred for simulation)
1. Find the speed reference Constant block:
   - Search: `find_system(mdl, 'BlockType', 'Constant', 'Name', '*peed*')` (wildcard catches "Speed", "speed", "SpeedRef", etc.)
   - Fallback: `find_system(mdl, 'BlockType', 'Constant', 'Name', '*ref*')`
2. Wrap the existing Value expression in negation: `-(original_value)`.
3. If no Constant found: manually add a Gain block with value -1 on the speed reference signal path.
4. Simulate briefly — verify speed sign matches reference sign.

### Method 2: Swap Phases B and C (hardware-equivalent)
1. Locate the Inverse Clarke Transform block:
   - Search: `find_system(mdl, 'MaskType', 'Inverse Clarke Transform')`
   - Fallback: `find_system(mdl, 'Name', '*Clarke*')`
2. Rewire outputs so that the Vb and Vc signals are exchanged downstream.
3. Partial alternative: insert a Gain of -1 on one phase (simplified — full fix requires actual Vb↔Vc signal swap at the wiring level).

**Why B↔C specifically:** Any two-phase swap reverses direction, but B↔C is the industry convention because it preserves phase A as the oscilloscope reference channel for debugging.

**Encoder synchronization warning:** If phases are swapped but encoder channels are not adjusted, measured position lags by 180° electrical, causing commutation errors (q-axis torque becomes d-axis flux weakening). Always check encoder configuration when changing phase order.

### Method 3: Encoder Direction
- Swap QEP channels A and B (reverses encoder direction sense).
- Or negate the direction bit in the encoder processing subsystem.

### Validation
Run a short simulation. The measured speed signal must have the same sign as the speed reference after transient settles.

---

## Fix Algebraic Loop

### When to Use
- Simulink reports "Algebraic loop" error during compilation or simulation.
- Typically occurs when FOC Current Controller output feeds directly back to the plant input within the same time step.

### Detection Strategy

**Strategy 1 — Structural search (fast):**
1. Find the FOC Current Controller block (MaskType = `FOC Current Controller` or name containing `FOC`).
2. Find the PMSM plant block (MaskType = `Interior PMSM`).
3. Get all outport handles from the FOC CC block. Iterate through ALL outports — each may participate in a loop.
4. If there is no Unit Delay between FOC CC output and the plant input, the loop exists.

**Strategy 2 — Compile-based detection:**
1. Call `Simulink.BlockDiagram.getAlgebraicLoops(mdl)` after compiling.
2. Parse the returned loop paths to identify which signals participate.
3. The first block in the loop path that is NOT a gain/sum/mux is the insertion point.

### Fix Procedure
1. Identify the signal between FOC CC output and the plant input (typically after V2D scaling, before the Average-Value Inverter or PWM block).
2. For each outport participating in a loop, add a Unit Delay block:
   - Naming convention: `AlgLoopBreak_1`, `AlgLoopBreak_2`, etc. (one per outport).
   - `SampleTime` = `-1` (inherits from context)
   - `InitialCondition` = `0`
3. Rewiring procedure:
   - Get the existing line's `SrcPortHandle` and `DstPortHandle`.
   - Delete the existing line.
   - Connect: source port → Unit Delay input; Unit Delay output → original destination port.
   - Use port handle-based `add_line` (not name-based) for reliability.

### Why Unit Delay (Not Memory Block)
- Unit Delay with `SampleTime=-1` inherits from context, ensuring lock-step execution with the ISR sample rate.
- Memory block has no explicit sample time parameter and can cause sample time propagation issues in multi-rate models.
- Unit Delay produces simpler generated C code (single static variable) vs Memory (may generate wrapper calls).
- InitialCondition = 0 is safe because at startup, voltage commands are zero anyway (FOC controllers initialize to zero current).

### Why Structural Search Is Primary (Not Compile-Based)
Structural search is faster and doesn't require the model to be in a compilable state (all parameters defined, no other errors). Compile-based detection is the fallback for cases where the structural search misses non-obvious loops.

### Why It Works
The Unit Delay introduces one-sample separation between the controller output and the plant input, breaking the instantaneous feedback path. At typical PWM frequencies (10–20 kHz), one-sample delay is negligible for control performance.

### Edge Cases
- **Multiple destinations:** A signal can fan out to multiple blocks. When rewiring, reconnect ALL destination ports (iterate `DstPortHandle` array).
- **FOC and PMSM in different subsystems:** Structural search only works if both blocks are in the same subsystem or the search traverses hierarchy. If they're in different subsystems, fall back to compile-based detection.
- **Block name collision:** Check if `AlgLoopBreak_N` already exists before adding (skip if present).

### Validation
- Re-compile model after fix: `feval(mdl, [], [], [], 'compile')` then `'term'`. Always terminate compilation in a try-catch (model might already be terminated).
- Model compiles without algebraic loop warning.
- Simulation runs to completion.
- No visible degradation in current tracking (< 1% additional error).

---

## Reduce PI Bandwidth

### When to Use
- Phase currents oscillate at high frequency (near kHz range).
- Speed response has excessive overshoot or sustained ringing.
- System was stable at lower speeds but oscillates at higher speeds.

### Parameters
- `reduction_factor`: Multiplier for Kp (default 0.5 = reduce by 50%). Use 0.7 for mild reduction, 0.3 for aggressive.

### Block Search Order
Search sequentially with fallbacks (strict → permissive):
1. `find_system(mdl, 'MaskType', 'PI Controller')` — definitive MCB library identifier
2. `find_system(mdl, 'MaskType', 'PI')` — alternate mask name
3. `find_system(mdl, 'Name', '*PI*', 'BlockType', 'SubSystem')` — heuristic (user-named blocks)

Use the first non-empty result. MaskType is searched first because it's a library block property that uniquely identifies MCB blocks regardless of user renaming; Name is user-editable and unreliable.

### Procedure
1. For each PI block found:
   - Read the current `Kp` parameter string.
   - Evaluate it in the base workspace to get the numeric value.
   - Compute `Kp_new = Kp_old * reduction_factor`.
   - Create a workspace variable named `Kp_<BlockName>_reduced` (spaces replaced with underscores).
   - Assign Kp_new to this variable in base workspace.
   - Set the block's `Kp` parameter to reference the new variable name.
2. Keep the Ki/Kp ratio unchanged (preserving integral time constant τ_i = Kp/Ki). Reducing only Ki would slow steady-state convergence without fixing the high-frequency oscillation caused by excessive proportional gain.
3. Process each block in a try-catch — skip blocks whose Kp can't be evaluated (e.g., undefined variable) and continue with the rest.

**Important pattern:** Block parameters can be symbolic strings (e.g., `'pmsm.Kp_current'`), not just numeric values. Use `evalin('base', Kp_str)` to resolve the actual numeric value from the base workspace before scaling.

### Stability Check
After reduction, report the new Kp alongside the model sample time:
- Read model's `FixedStep` via `str2double(get_param(mdl, 'FixedStep'))` to get Ts.
- Rule of thumb: `Kp < 2 * L / Ts` where L is phase inductance.
- **Why this matters:** If Kp is too high relative to Ts, the discrete-time PI controller approaches the Nyquist frequency (fs/2), causing aliasing and instability. Flag a warning if violated.

### Why 0.5 Is the Default Factor
50% reduction cuts bandwidth in half — large enough to observe improvement, but not so aggressive that it causes sluggish response. Starting at 0.5 avoids over-damping in mild cases; iterate to 0.3 only if needed.

### Iteration
If oscillation persists after 50% reduction, call again with factor 0.3. If still oscillating at factor 0.3, the problem may not be PI bandwidth — investigate plant model fidelity or sample time aliasing.

### Validation
- Re-simulate: current waveforms should be smooth (no kHz ringing).
- Speed overshoot should be < 10% of step amplitude.

---

## Fix Voltage Saturation

### When to Use
- Simulation diverges (NaN in signals) after motor reaches target speed.
- "Derivative not finite" error after a short time.
- Motor doesn't reach commanded speed (stalls below target).
- Occurs most often at high speed + high torque operating points.

### Design Philosophy
This recipe is **diagnostic only** — it returns recommended actions but never auto-applies them. Voltage saturation is fundamentally a requirements/physics conflict. The agent needs human judgment on which constraint to relax (speed? torque? DC bus voltage?). Return action strings to PROPOSE fixes to the user.

The "success" flag means "diagnostic completed successfully," NOT "operating point is valid." It's always true if the computation runs without error, even when saturated.

### Diagnostic Computation

Given motor parameters (`pmsm`), inverter (`inverter`), and operating point (`speed_rpm`, `id`, `iq`):

1. **Electrical speed:** `we = p * speed_rpm * pi / 30`
2. **Inductances:** Use `Ld`, `Lq`, `FluxPM` from motor struct. Check `isfield(pmsm, 'PMSMLUT')` to determine if nonlinear. If LUT-based, interpolate using `interp2(iqVec, idVec, Table, iq, id)`.

   **Critical interp2 axis ordering:** LUT tables are `[nId x nIq]` (rows=id, columns=iq). `interp2(X, Y, V, Xq, Yq)` expects X=columns, Y=rows. Therefore: X=iqVec, Y=idVec, query with (iq, id). Wrong ordering silently returns incorrect values — this is a common bug source.
3. **Steady-state voltages:**
   - `Vd = Rs * id - we * Lq * iq`
   - `Vq = Rs * iq + we * Ld * id + we * FluxPM`
4. **Voltage magnitude:** `Vmag = sqrt(Vd^2 + Vq^2)`
5. **Voltage limit:** `Vmax = V_dc / sqrt(3)`
6. **Margin:** `margin_pct = (1 - Vmag/Vmax) * 100`

### Decision Logic
- **margin >= 5%:** No saturation. Action = `none`. Return immediately.
- **margin 0% to -20%:** Mild saturation. Action = `enable_field_weakening`. Recommend enabling FW in LUT Reference block.
- **margin < -20%:** Severe saturation. Action = `reduce_speed`. Recommend reducing speed to 80% of current value.

**Why 5% threshold:** Leaves headroom for inverter dead-time voltage drop and transient overshoots during load changes.

**Why -20% threshold for "severe":** Beyond -20%, field weakening requires very large id injection that severely reduces available torque capacity. Speed reduction is more effective at this level of saturation.

**Why base speed is approximate:** The formula `Vmax / (FluxPM * p * pi/30)` ignores the resistive voltage drop (Rs * id) and assumes id=0. This is adequate for initial guidance but may underestimate base speed by 2-5% for motors with high Rs.

### Recommended Fixes (priority order)
1. **Reduce speed reference** below the approximate base speed: `base_speed ≈ Vmax / (FluxPM * p * pi/30)` in RPM.
2. **Enable field weakening** — generate id/iq LUT using `mcb.generateMotorLUT(pmsm, inverter, 'idiqluts')` and wire LUT Reference block.
3. **Reduce torque** — decrease `|iq|` reference.
4. **Increase DC bus voltage** — compute minimum needed: `Vdc_needed = Vmag * sqrt(3) * 1.1` (10% margin).

### Validation
After applying fix, re-run diagnostic. Target: margin > 5%.

---

## Calibrate ADC Offset

### When to Use
- Motor vibrates but doesn't spin on hardware.
- Current sensors read non-zero with motor stationary.
- Phase currents show a DC bias in simulation when using realistic ADC models.

### Concept
12-bit ADCs use bipolar encoding with midscale representing 0 A: code 2048 out of 4096 (12-bit) or 32768 out of 65536 (16-bit). This allows both positive and negative currents to be measured. Manufacturing offsets shift this value by a few LSBs, causing false current readings that produce torque ripple or vibration.

**Why default is 2048, not 0:** If offset defaults to 0, negative currents would clip. The 2048 default provides a safe startup value before calibration runs — the ISR will subtract a reasonable midscale, preventing large false currents that could cause startup vibration.

**Why 1024 samples default:** 2^10 enables efficient integer division (bit-shift on embedded targets), provides ~32x noise reduction (√1024 ≈ 32) for typical ±2 LSB ADC noise, and completes in ~50 ms at 20 kHz ISR rate — good balance of accuracy vs. startup time.

### ADC Block Detection
Search for ADC blocks in the model to determine integration approach:
1. `find_system(mdl, 'Name', '*ADC*', 'BlockType', 'SubSystem')`
2. If no ADC blocks found, generate calibration logic using workspace variables only (no block-level integration).

### Calibration Procedure (hardware startup)
1. Keep motor stationary (no PWM output).
2. Read N consecutive ADC samples per channel (default N = 1024; use 2048 for higher accuracy).
3. Compute average for each phase: `offset_x = sum(samples_x) / N`.
4. Expected values: approximately 2048 (12-bit) or 32768 (16-bit).

### Model Integration
1. Create Data Store Memory blocks at model root level:
   - `adc_offset_a` — InitialValue = 2048
   - `adc_offset_b` — InitialValue = 2048
   - `adc_offset_c` — InitialValue = 2048
2. In the FOC ISR subsystem, subtract offsets before current scaling:
   - `Ia = (adc_raw_a - adc_offset_a) * current_scale`
   - `Ib = (adc_raw_b - adc_offset_b) * current_scale`
   - `Ic = -(Ia + Ib)` (KCL reconstruction — do NOT use third ADC directly)
3. Create workspace variables as fallback: `ADC_CAL_SAMPLES = N`, `adc_offset_a/b/c = 2048`.

**Why Data Store Memory instead of workspace variables:** DSM blocks persist across function-call subsystems and atomic subsystem boundaries, enabling real-time offset updates from a startup calibration subsystem to the FOC ISR subsystem. Workspace variables don't update mid-simulation. Fallback to workspace variables when DSM creation fails (e.g., model root is locked or inside a referenced model).

**Why KCL reconstruction (Ic = -(Ia+Ib)) instead of a third sensor:**
- Only 2 ADC channels needed (cost saving).
- Enforces Kirchhoff's Current Law, which filters out common-mode noise.
- More accurate: two independent measurements have lower cumulative error than three.
- The third measurement is mathematically redundant (Ia + Ib + Ic = 0 by constraint).

### Validation
With motor stationary and calibration applied, all reconstructed phase currents must be < 50 mA magnitude.

**Safety-critical:** Motor MUST be stationary during calibration (PWM disabled). If spinning, measured currents include real motor current, causing wrong offsets → DC bias in current sensing → constant torque at zero speed command → potential motor runaway.

---

## Build Protection Subsystem

### When to Use
- Model needs overcurrent, overvoltage, and watchdog protection before hardware deployment.
- Required for any model targeting real inverter hardware.

### Pre-check
Before building, check if `[mdl '/Protection']` already exists. If it does, skip (subsystem already built).

### Architecture

```
[Sensor Inputs] → [Fault Detection] → [State Machine] → [PWM Enable]
                                                        → [Fault Code]
                                                        → [State]
```

### Key Design Decisions

**Why cascaded Switches for this use case:**
- Lightweight: state machine has only 4 states and 4 transitions — cascaded Switches are sufficient and keep the subsystem self-contained.
- Every intermediate signal is probeable via signal logging (useful for fault analysis).
- Generates minimal C code (nested if-else) suitable for tight ISR timing budgets.

**Why Unit Delay as state register (not Memory block):**
- `SampleTime=-1` inherits from context, locks to ISR rate.
- `InitialCondition=0` explicitly sets power-on state (IDLE) — visible in diagram.
- Simpler generated code (single static int variable).

**Why fault is latched (SAFE state requires explicit Reset):**
- Safety standard compliance (IEC 61508): faulted state persists until operator acknowledges.
- Preserves fault code for diagnostic readout (auto-recovery would overwrite evidence).
- Prevents fault cycling on intermittent faults (e.g., loose wire → repeated start/trip → thermal stress).

**Why Run_Cmd is dual-purpose (enable + watchdog heartbeat):**
- Port economy: saves one input in space-constrained models.
- Fail-safe: if wire breaks or external controller hangs, signal goes low → motor stops AND watchdog triggers.
- Mirrors hardware convention (gate driver enable pins with watchdog refresh).

### Interface

| Port | Direction | Signal | Description |
|------|-----------|--------|-------------|
| 1 | Input | Ia | Phase A current (A) |
| 2 | Input | Ib | Phase B current (A) |
| 3 | Input | Vdc | DC bus voltage (V) |
| 4 | Input | Run_Cmd | Enable command (1=run, 0=stop; also serves as watchdog heartbeat) |
| 5 | Input | Reset | Fault reset command (pulse high to clear) |
| 1 | Output | PWM_Enable | Gate driver enable (boolean: 1 when state=RUN) |
| 2 | Output | Fault_Code | Priority-encoded fault (0=none, 1=OC, 2=OV, 3=WD) |
| 3 | Output | State | Current state (0=IDLE, 1=RUN, 2=FAULT, 3=SAFE) |

### Fault Detection Blocks

**Overcurrent (OC):**
- Computes 2-phase current magnitude: `|Is| = sqrt(Ia^2 + Ib^2 + Ia*Ib)`
  - **Derivation:** From KCL, Ic = -(Ia+Ib). True 3-phase magnitude = sqrt(Ia²+Ib²+Ic²) = sqrt(2*(Ia²+Ib²+Ia*Ib)). The constant sqrt(2) is absorbed into the threshold, leaving sqrt(Ia²+Ib²+Ia*Ib).
- Implementation: Ia² (Math Function, square) + Ib² (Math Function, square) + Ia*Ib (Product block, inputs `**`) → Sum (inputs `+++`) → Sqrt → Compare To Constant.
- Threshold: `PROT_OC_THRESHOLD * pmsm.I_rated` (default PROT_OC_THRESHOLD = 1.2, i.e., 120% of rated current).
  - **Why 1.2×:** Industry standard for servo drives — 20% margin before thermal limit, accounts for measurement noise.
- Compare operator: `>`.

**Overvoltage (OV):**
- Compare To Constant on Vdc input.
- Threshold: `PROT_OV_THRESHOLD * inverter.V_dc` (default PROT_OV_THRESHOLD = 1.15, i.e., 115% of nominal bus voltage).
  - **Why 1.15×:** Accounts for DC bus capacitor voltage rating margin and regenerative braking peaks.
- Compare operator: `>`.

**Watchdog (WD):**
- Counter-based software watchdog using Unit Delay register.
- Logic: counter increments each sample tick. If `Run_Cmd` is high (heartbeat alive), counter resets to 0. If `Run_Cmd` stays low, counter accumulates.
- Implementation:
  - Unit Delay (`WD_Counter`, IC=0, SampleTime=-1) holds count.
  - Add block (`WD_Inc`, inputs `++`) adds 1 each tick: `WD_Counter + 1`.
  - Switch block (`WD_Reset`): if Run_Cmd != 0 → output 0 (reset); else → output WD_Inc (keep counting).
  - Switch output feeds back to WD_Counter input.
  - Compare To Constant on WD_Counter: threshold = `PROT_WATCHDOG_MS * 1e-3 / Ts` (default 2 ms timeout, converted to sample count).
  - **Why 2 ms:** Typical host control loop period is 1–5 ms; 2 ms catches a single missed update without false tripping.
- **Why counter-based (not timer-based):** Avoids floating-point time arithmetic in ISR; counter increments lock-step with ISR ticks (deterministic). Threshold converts timeout to integer sample count at compile-time. Automatically scales if sample rate changes.

**Fault OR:**
- 3-input OR gate combining OC, OV, and WD boolean outputs.

### Fault Code Priority Encoder

Priority: OC (highest) > OV > WD > None.

**Why this order:** OC is most destructive (MOSFET/IGBT failure in microseconds) and must be logged first even if multiple faults co-occur. OV damages bus capacitors but propagates slower. WD indicates software/communication fault, not immediate hardware damage, and often co-occurs with other faults (if software hangs, OC/OV may follow). The priority code tells the operator which fault occurred FIRST in a cascade.

Implemented as cascaded Switch blocks:
1. `SW_WD`: if WD triggered → code 3, else → code 0.
2. `SW_OV`: if OV triggered → code 2, else → SW_WD output.
3. `SW_OC`: if OC triggered → code 1, else → SW_OV output.

All Switch blocks use criteria `u2 ~= 0` with threshold 0.5.

### State Machine

Four states implemented as a Unit Delay register (`StateReg`, IC=0) with cascaded Switch next-state logic.

**States:**
| Code | Name | Meaning |
|------|------|---------|
| 0 | IDLE | Waiting for run command |
| 1 | RUN | Normal operation, PWM enabled |
| 2 | FAULT | Fault detected, PWM disabled (transient — 1 sample) |
| 3 | SAFE | Latched safe state, awaiting reset |

**Transitions:**
| From | To | Condition |
|------|-----|-----------|
| IDLE | RUN | `Run_Cmd = 1` |
| RUN | FAULT | Any fault (OC OR OV OR WD) |
| FAULT | SAFE | Unconditional (immediate, 1 sample — see note below) |
| SAFE | IDLE | `Reset = 1` AND no active fault |

**Implementation:**
- Four Compare To Constant blocks test current state (IsIDLE: ==0, IsRUN: ==1, IsFAULT: ==2, IsSAFE: ==3).
- Transition AND gates:
  - T1_AND (2 inputs): IsIDLE AND Run_Cmd
  - T2_AND (2 inputs): IsRUN AND Fault_OR
  - T4_AND (3 inputs): IsSAFE AND Reset AND NOT(Fault_OR)
- NOT gate on Fault_OR for T4 condition.
- Next-state priority (cascaded Switches, lowest to highest):
  1. `SW_T4`: if T4 → 0, else → hold (StateReg output)
  2. `SW_FAULT`: if IsFAULT → 3, else → SW_T4
  3. `SW_T1`: if T1 → 1, else → SW_FAULT
  4. `SW_T2`: if T2 → 2, else → SW_T1 (highest priority)
- `SW_T2` output feeds back to `StateReg` input (closes the loop).

**Why FAULT→SAFE is immediate (1 sample):** FAULT (code=2) is a transient marker for logging only — it appears for exactly one sample in recorded timeseries, enabling post-mortem identification of the fault detection instant. SAFE (code=3) is the persistent latched state. If the system stayed in FAULT, logic might re-evaluate and accidentally transition back to RUN.

**Output Logic:**
- `PWM_Enable` = Compare To Constant on StateReg output (== 1, i.e., true only in RUN state).
- `Fault_Code` = SW_OC output (latched priority code).
- `State` = StateReg output.

### Workspace Parameters Created
- `PROT_OC_THRESHOLD` = 1.2
- `PROT_OV_THRESHOLD` = 1.15
- `PROT_WATCHDOG_MS` = 2

### Connection Guide (after building)
1. Connect Ia, Ib from ADC / current sensor outputs.
2. Connect Vdc from DC bus voltage measurement.
3. Connect Run_Cmd from control logic (1 = enable motor).
4. Connect Reset from UI button or host command interface.
5. Gate PWM: add a 2-input AND block between normal PWM signals and gate driver. Connect `Protection/PWM_Enable` to one AND input, normal PWM to the other.

### Hardware Trip Zone
For sub-cycle (<1 PWM period) shutdown, hardware-level protection is needed in addition to software:
- Configure a trip zone input from an external analog comparator (set to OC threshold).
- Trip action: force all PWM outputs low (gates off).
- Software ISR reads trip flag for fault code logging.

**Why software protection alone is insufficient:**
- Software ISR runs at 10–20 kHz (50–100 µs period); fault detection happens at next sample — up to 100 µs after fault occurs.
- MOSFET/IGBT short-circuit failure occurs in 1–10 µs (faster than ISR period).
- Hardware analog comparator + trip zone shuts down within 50–200 ns (sub-microsecond).
- **Defense in depth:** Hardware protects against catastrophic failures (fast, dumb); software logs fault code and manages recovery sequence (slower, smart). This dual-protection architecture is industry standard for motor drives.

### Block Count
Approximately 30 blocks total, all wired (no empty stubs).

---

## Test Protection Subsystem

### When to Use
- After building the protection subsystem, to verify all state transitions and fault codes function correctly.

### Test Pattern: From Workspace + To Workspace Harness
This uses the "programmable fault injection" pattern:
- **From Workspace** blocks with timeseries data for inputs (allows sample-level control).
- **To Workspace** blocks with timeseries format for outputs (preserves timing for analysis).
- Test vectors computed from motor parameters (e.g., `pmsm.I_rated * 1.5`), so tests scale with model configuration.
- Single `sim(mdl)` call per test case enables batch execution.

### Test Model Setup
1. Create a new temporary model (e.g., `test_prot_harness`).
2. Configure: Fixed-step discrete solver, Ts = 50 us, StopTime = 0.1 s.
3. Define workspace parameters: `Ts = 5e-5`, `pmsm.I_rated = 283`, `inverter.V_dc = 500`.
4. Call `build_protection_subsystem` to create the Protection subsystem inside the test model.

### Test Signal Sources
Use From Workspace blocks (timeseries) for Ia, Vdc, Run_Cmd, Reset. Use a Constant(0) for Ib.

### Test Cases

**Why Ib=0 in all tests:** Simplifies fault math verification. With Ib=0, `|Is| = sqrt(Ia² + 0 + 0) = |Ia|`, so the OC threshold check reduces to `|Ia| > threshold`. This isolates protection logic testing from multi-phase interaction.

**Why fault tests run before normal operation:** Fail-dangerous conditions (protection doesn't trip) are safety-critical and must be validated first. Normal operation (no false trips) is tested last as a sanity check.

**Test timing rationale:** t=0.01 allows 200 samples for state machine to reach RUN. t=0.03 provides clear pre-fault logging window. t=0.07 ensures SAFE state is established before reset attempt. Spacing (20 ms) is >> state machine propagation (1-2 samples) but << total sim time.

**Test 1 — Overcurrent Trip:**
- Run_Cmd goes high at t = 0.01 s (IDLE → RUN).
- At t = 0.03 s, Ia jumps to 1.5 * I_rated (instant overcurrent).
- Reset pulse at t = 0.07–0.075 s.
- Expected: State transitions through RUN → FAULT → SAFE. Fault_Code = 1. PWM_Enable = 0 after fault.
- Pass criteria: `has_run AND has_fault AND oc_code==1 AND pwm_disabled_in_fault`.

**Test 2 — Overvoltage Trip:**
- No overcurrent (Ia = 0 throughout).
- Run_Cmd high at t = 0.01 s.
- At t = 0.03 s, Vdc jumps to 1.3 * V_dc (130% overvoltage).
- Expected: Fault_Code = 2 appears in output.
- Pass criteria: `any(fault_code == 2)`.

**Test 3 — Normal Operation (no fault):**
- Ia = 50% of I_rated (well below threshold).
- Vdc = nominal throughout.
- Run_Cmd high at t = 0.01 s.
- Expected: State stays at RUN (1) after t = 0.02 s. PWM_Enable = 1 throughout.
- Pass criteria: `all(state(t >= 0.02) == 1)`.

### Test Outputs
Log PWM_Enable, Fault_Code, and State using To Workspace blocks (timeseries format).

### Summary Report
Count pass/fail across all tests. Target: 3/3 pass.

### Cleanup
Close and discard test model after verification.

---

## Workspace Parameters Reference

| Variable | Default | Used By |
|----------|---------|---------|
| `PROT_OC_THRESHOLD` | 1.2 | Protection (OC detection) |
| `PROT_OV_THRESHOLD` | 1.15 | Protection (OV detection) |
| `PROT_WATCHDOG_MS` | 2 | Protection (WD timeout) |
| `ADC_CAL_SAMPLES` | 1024 | ADC calibration |
| `adc_offset_a/b/c` | 2048 | ADC offset subtraction |

----
Copyright 2026 The MathWorks, Inc.
----

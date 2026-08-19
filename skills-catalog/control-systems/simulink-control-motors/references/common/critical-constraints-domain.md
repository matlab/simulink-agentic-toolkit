# Critical Constraints — Domain-Specific Rules

> Motor-type-specific, sensorless, LUT, high-speed, and structural rules.
> For base infrastructure rules (algebraic loops, data types, PI config, solver) see `critical-constraints.md`.

---

## Sensorless (SMO) Rules

### Rule 23: SMO Needs I/f Startup Below 5% Speed
SMO cannot estimate angle at very low speed (no back-EMF). Use I/f startup or I-F Controller to:
1. Force angle (open-loop) from 0 to ~5% rated speed
2. Handoff to SMO angle when speed threshold crossed

### Rule 24: SMO Voltage Inputs = Command Voltages
Connect InvPark outputs (Valpha, Vbeta) to SMO, NOT measured/actual phase voltages.
Reason: SMO uses voltage model internally; command voltages are the known input.

### Rule 25: Angle Handoff Switch Logic
```json
{"op": "configure", "target": "Sw_theta", "params": {
    "Criteria": "u2 > Threshold",
    "Threshold": "w_transition"}}
```
Port 1: SMO theta_e (true path), Port 2: Speed for comparison, Port 3: I/f theta_e (false path)

---

## ACIM-Specific Rules

### Rule 26: Slip Angle Must Be Integrated and Wrapped
```matlab
theta_e = mod(integral(p*wm + we_slip), 2*pi);
```
- Use Discrete-Time Integrator with external reset or mod wrapping
- Unwrapped angle -> numerical overflow after extended simulation

### Rule 27: id_ref Must Be Non-Zero for ACIM
In ACIM RFOC, `id_ref` provides magnetizing flux. Setting `id_ref = 0` -> zero torque (unlike PMSM where id=0 is valid).
```matlab
id_ref = motor.FluxPM / motor.Lm;  % Rated magnetizing current
```

### Rule 27b: Simscape IM Rotor Cage Must Be Grounded
For squirrel cage IM in Simscape, `RConn3` (rotor cage port) MUST connect to `Grounded Neutral (Three-Phase)`. Floating rotor causes structural singularity error.

### Rule 27c: ACIM Block Zs/Zr Parameter Format
MCB Induction Motor `model_edit` params use INDUCTANCES in the vector format:
```json
{"op": "configure", "target": "ACIM", "params": {
    "Zs": "[acim.Rs, acim.Lls]",
    "Zr": "[acim.Rr, acim.Llr]",
    "Lm": "acim.Lm"}}
```
- `Zs = [Rs (Ohm), Lls (H)]` — stator resistance + leakage INDUCTANCE
- `Zr = [Rr (Ohm), Llr (H)]` — rotor resistance + leakage INDUCTANCE
- `Lm` — magnetizing INDUCTANCE (H)
- Lls/Llr are LEAKAGE inductances: `Lls = Ls - Lm`, `Llr = Lr - Lm`

**Do NOT use reactances (Ω) here** — despite the "Z" naming, these are [R, L] vectors.

### Rule 27d: ACIM Angle Wrapping — Required for Long Simulations
The synthesized electrical angle `theta_e = integral(p*wm + we_slip)` grows unbounded. MCB Park/InvPark blocks overflow when theta exceeds ~6500 rad, producing NaN.

**When wrapping is needed:**
```matlab
% Overflow time estimate:
t_overflow = 6500 / (motor.p * max_speed_rad + max_slip_rad);
% Example: p=2, wm=62.8 rad/s, slip≈5 rad/s → overflow at ~50s
% Example: p=4, wm=300 rad/s → overflow at ~5.4s
```
- **SimTime < t_overflow/2**: Wrapping NOT needed (safe margin). Short sims (2-3s) at moderate speed work without wrapping.
- **SimTime > t_overflow/2**: Wrapping REQUIRED.
- **High-speed motors (p*wm > 500 rad/s)**: ALWAYS wrap (overflow in <13s).

**Fix:** Add `Math Function (mod)` + `Constant(2*pi)` after integrator:
```json
[
  {"op": "add_block", "type": "Math Function", "name": "Mod_Wrap", "params": {"Operator": "mod"}},
  {"op": "add_block", "type": "Constant", "name": "TwoPi", "params": {"Value": "2*pi"}},
  {"op": "connect", "target": "Theta_Integ.y1 -> Mod_Wrap.u1"},
  {"op": "connect", "target": "TwoPi.y1 -> Mod_Wrap.u2"},
  {"op": "connect", "target": "Mod_Wrap.y1 -> Park.u3"},
  {"op": "connect", "target": "Mod_Wrap.y1 -> InvPark.u3"}
]
```
**Symptom if missing:** Model runs correctly for a while, then speed goes to NaN/Inf. No compile-time warning.

**Also applies to:** I/f startup integrators, any open-loop angle ramp, ACIM slip integrators.

**Note:** The PMSM `MtrElcPos` bus output is already wrapped internally — this rule applies ONLY to synthesized angles (ACIM slip, I/f ramp).

### Rule 27e: ACIM Voltage-Limited Maximum Speed
```matlab
% ACIM max mechanical speed (unlike PMSM which uses FluxPM)
Vmax = inverter.V_dc / sqrt(3);
max_speed_acim_rad = Vmax / (acim.Lm * id_ref * acim.p);  % rad/s
max_speed_acim_rpm = max_speed_acim_rad * 9.55;

% Speed reference MUST be below this limit (use 85% for margin)
speed_ref_rad = min(target_speed, 0.85 * max_speed_acim_rad);
```
**Failure mode:** Once motor exceeds this speed, back-EMF > Vmax → current PI saturates → cannot produce braking torque → uncontrolled acceleration or limit cycle.

### Rule 27f: DefaultUnderspecifiedDataType for MCB Plant Models
MCB plant blocks (Induction Motor, Interior PMSM, BLDC) use single-precision internally. When the model-level `DefaultUnderspecifiedDataType` is set to `'double'`, type propagation conflicts can occur at internal bus boundaries.

**Recommendation:**
- Models using MCB plants: `set_param(mdl, 'DefaultUnderspecifiedDataType', 'single')`
- Add explicit DTC (single→double) blocks on all plant outputs before controller arithmetic
- This matches the proven pattern used in all MCB example models

**Failure mode:** Setting 'double' causes "Data type mismatch" errors inside masked MCB blocks that cannot be fixed without modifying the library block internals.

---

## LUT Control Reference Rules

### Rule 28: NmGrid Must Be Symmetric
```matlab
% WRONG -- only positive torque
NmGrid = linspace(0, T_max, 20);  % Negative torque -> extrapolation -> diverge

% CORRECT -- symmetric
NmGrid = [-fliplr(pos(2:end)), pos];
```

### Rule 29: wrpmVec Must Be Positive Only
```matlab
wrpmVec = linspace(0, N_max, 15);  % Positive only
% Use abs(speed) as LUT input for bidirectional operation
```

---

## Simulink Structural Rules

### Rule 30: Deleting Enable Port Renumbers Outports
After removing an Enable port from a subsystem, all outport numbers shift. Re-verify all parent connections.

### Rule 31: Orphaned Lines After Block Deletion

With SATK `model_edit`, orphaned lines are cleaned automatically when using `delete` operations.
If you encounter orphaned lines from manual edits, use `evaluate_matlab_code`:
```matlab
lines = find_system(subsys, 'FindAll', 'on', 'Type', 'line');
for i = 1:numel(lines)
    if get_param(lines(i), 'SrcBlockHandle') == -1
        delete_line(lines(i));
    end
end
```

### Rule 32: arrangeSystem Before save_system
```matlab
Simulink.BlockDiagram.arrangeSystem(mdl);  % Auto-layout
save_system(mdl);
```
Always arrange before save -- prevents overlapping blocks in saved model.

---

## BLDC Sensorless Rules

### Rule 40: Sensorless Six-Step Block Requires Switching Inverter
The MCB `Sensorless Six-Step Commutation` block detects BEMF zero-crossings from measured terminal voltages. It **CANNOT** work with `BLDC Average-Value Inverter` because:
- Average-value model drives all 3 phases simultaneously (no floating phase)
- Terminal voltage output = applied voltage, NOT voltage including back-EMF on floating phase
- ZC detector counter overflows (stuck in `WaitforzerocrossOL` state)

**Solution for average-value simulation:** Use custom BEMF ZC detection:
1. Read `BackEMF` [3×1] from BLDC motor Info bus via Bus Selector
2. Detect polarity pattern → map to sector (1-6) using MATLAB Function or logic blocks
3. Feed sector to standard `Six Step Commutation` block (InputType='Hall')
4. Use open-loop forced commutation for startup, switch to ZC above threshold speed

### Rule 41: BLDC BackEMF Bus Field is Vector
The BLDC Info bus field `BackEMF` is a **single [3×1] vector** containing `[ea; eb; ec]`.
- Do NOT use `BackEMF_a`, `BackEMF_b`, `BackEMF_c` — these individual field names do not exist
- Use: `set_param(BusSel, 'OutputSignals', 'BackEMF')` → outputs [3×1]
- For individual phases: add Demux after Bus Selector output

### Rule 42: BEMF Polarity-to-Sector Mapping (Sensorless BLDC)
For custom BEMF ZC detection, map back-EMF polarity to Hall-equivalent sector:
```matlab
% Encode polarity as 3-bit code: pa*4 + pb*2 + pc
% where pa = (ea > 0), pb = (eb > 0), pc = (ec > 0)
%
% code → sector mapping (120° commutation):
%   5 [1,0,1] → sector 1
%   4 [1,0,0] → sector 2
%   6 [1,1,0] → sector 3
%   2 [0,1,0] → sector 4
%   3 [0,1,1] → sector 5
%   1 [0,0,1] → sector 6
%   0,7 (invalid) → default to 1
```
This mapping feeds directly into `Six Step Commutation` block with `InputType='Hall'`.

### Rule 43: Sensorless BLDC Startup Requires Open-Loop Forced Commutation
At standstill/low speed, back-EMF amplitude is zero — no zero-crossings to detect.
**Startup sequence:**
1. Time-based ramp → theta_e (forced electrical angle)
2. theta_e → mod(2π) → LUT(Flat interp) → forced sector (1-6)
3. Switch to BEMF ZC sector when speed > threshold (~10-15% rated)

Use `Compare To Constant` + `Switch` block for handoff:
- Switch condition: `abs(speed) > handoff_threshold`
- True path (port 1): BEMF ZC sector
- False path (port 3): open-loop forced sector

### Rule 44: MATLAB Function Block Input Size Must Be Declared for Vector Bus Signals
When a MATLAB Function block receives a vector signal from a Bus Selector (e.g., `BackEMF` [3×1]), the block's type inference defaults to **scalar** — causing "Array element N is out-of-bounds (range 1-1)" at simulation time.

**Fix:** After setting the chart script via Stateflow API, explicitly declare the input size:
```matlab
sf_root = sfroot;
chart = sf_root.find('-isa', 'Stateflow.EMChart', 'Path', [mdl '/BEMF_ZC']);
chart.Script = bemf_code;
% CRITICAL: declare input size — without this, input defaults to scalar
inp = chart.find('-isa', 'Stateflow.Data', 'Name', 'bemf_abc');
inp.Props.Array.Size = '3';  % Match the Bus Selector output dimension
```

**Symptoms if missing:**
- `Array element 2 is out-of-bounds. Modify the index expression to access elements in the range 1-1.`
- Occurs at compile/simulation time, NOT at model build time

**Applies to:** Any MATLAB Function block whose input comes from a Bus Selector outputting a vector field (BackEMF, Iabc, etc.).

---

## High-Speed Motor Rules

### Rule 33: Electrical Frequency vs Current Loop BW
```matlab
f_e_max = N_max_rpm / 60 * pole_pairs;
% Current loop BW must be > 5x f_e for stable FOC
BW_current = 1 / (4 * Ts);  % Approximate achievable BW
assert(BW_current > 5 * f_e_max, 'Ts too large for this motor speed');
```
**Failure mode:** At ultra-high speed (e.g., 100k RPM, 4 poles -> f_e=3.3kHz), a 10kHz PWM rate gives inadequate BW. Reduce Ts or accept degraded control above base speed.

### Rule 34: Simscape Bridge Sign Convention
When replacing MCB discrete plant with Simscape FEM PMSM:
```matlab
% Simscape motor convention: positive torque = motoring
% But angle/speed signs are NEGATED vs MCB convention
speed_for_control = -simscape_speed;
theta_for_control = -simscape_theta;
```
**Failure mode:** Omitting negation causes positive feedback -> immediate runaway.

### Rule 35: SMO Speed Port -- Simulation Workaround
In some MCB releases, SMO Out/2 (speed) is broken in simulation (outputs zero or stale value). Derive speed from position instead:
```matlab
% Add after SMO/1 (theta_e):
% Discrete Derivative: (theta[k] - theta[k-1]) / Ts / pole_pairs
% Then low-pass filter the result
```
Always verify SMO speed output matches expected value before trusting it.

### Rule 36: fixdt Overflow in Code Generation
```matlab
% MCB blocks internally use fixdt(1,16,14) for some signals
% If signal > 2.0 (in PU), overflow wraps silently on target
% ALWAYS verify signal ranges stay within [-2, +2) for 16-bit fixed-point
```
Set `DataTypeOverride='Double'` during desktop simulation to catch overflows.

---

## Current Limiting Rules

### Rule 37: Demagnetization Limit on id
Never allow id below the demagnetization boundary — permanent magnet damage is irreversible:
```
id_demag_limit = -pmsm.FluxPM / pmsm.Ld
Example: FluxPM=0.0064, Ld=0.0002 → id_demag = -32 A
```
```json
{"op": "configure", "target": "Sat_id", "params": {"LowerLimit": "max(-pmsm.FluxPM/pmsm.Ld, -I_max)"}}
```
**Why:** When `Ld*id + FluxPM < 0`, permanent magnet flux is reversed — causes irreversible demagnetization.

### Rule 38: DQ Current Circle Constraint (Priority Limiter)
Limit total current to `I_max = I_rated * sqrt(2)` (peak). **Priority: preserve id, limit iq:**
```matlab
% id is preserved (needed for FW/flux), iq is clipped
iq_max = sqrt(I_max^2 - id_ref^2);
iq_ref_limited = max(-iq_max, min(iq_max, iq_ref));
```

**Simulink implementation:**
```
id_ref ──► Sq(id²) ──┐
                      ├──► Sub(Imax²-id²) ──► Sqrt ──► Saturation(±iq_max) ◄── iq_ref
I_max ──► Sq(Imax²) ─┘
```
**Why:** During field weakening, id is large and negative. If iq is not reduced, total current exceeds inverter/motor rating → overcurrent fault.

### Rule 39: Board Resistance in PI Tuning
Include wiring and inverter MOSFET on-resistance in effective Rs for PI gain computation:
```matlab
Rs_eff = pmsm.Rs + R_board;  % R_board = 0.05-0.2 Ohm typical
% Use Rs_eff for Ki computation (Ki proportional to Rs/L)
% Kp is unaffected (depends only on L and BW)
pmsm_tuning = pmsm;
pmsm_tuning.Rs = Rs_eff;
PI_params = mcb.calcFOCGains(pmsm_tuning, Ts, Ts_speed);
```
**Why:** Underestimating Rs makes Ki too low → slow disturbance rejection. Effect is 20-30% for low-Rs motors with long wiring.

---

## Pattern A Instability in Torque Mode

### Rule 40: Prefer FOC CC Block Over Manual PI + Transform Wiring

Pattern A (manual Park/InvPark + discrete PI controllers) causes speed oscillations when used with the MCB discrete PMSM plant in **torque mode** (closed-loop speed control). The manual transform chain creates algebraic loop dynamics that Unit Delay alone cannot resolve — the discrete plant's internal torque-mode dynamics interact with the external PI/transform loop in ways that produce sustained oscillation regardless of gain tuning.

**Use Pattern B (FOC CC block) for all closed-loop speed control applications.** The FOC CC block handles transforms, decoupling, and anti-windup internally, avoiding the algebraic loop interaction.

```
Pattern A (AVOID for speed control):
  Park → PI_d/PI_q → InvPark → InvClarke → [Delay] → PMSM
  Result: ±360 RPM oscillation, cannot be tuned out

Pattern B (CORRECT):
  FOC_CC → V2D → AVI → [Delay] → PMSM
  Result: Stable, predictable response
```

**When Pattern A IS acceptable:**
- Open-loop voltage testing (no speed feedback)
- Current-mode control where speed loop is external hardware
- Educational/debugging use where instability is acceptable

---

## Simulation Verification Checklist

After building any model, verify:
1. No unconnected ports (set UnconnectedInputMsg to 'error')
2. Simulation runs without algebraic loop warnings
3. Currents stay within +/-2x rated (if not, gains too aggressive)
4. Speed reaches steady-state within expected time
5. No NaN/Inf in outputs (check with `any(isnan(simout))`)
6. SMO speed output is non-zero and matches expected direction (Rule 35)

----
Copyright 2026 The MathWorks, Inc.
----

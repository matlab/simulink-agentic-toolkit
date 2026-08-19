# Detailed Workflow Procedures

> Expanded workflow steps for tuning, nonlinear data, plant conversion, parameter estimation,
> sensorless configuration, and diagnostics. Referenced from SKILL.md section pointers.

---

# Tuning Motor FOC Gains

*Computes PI gains, IIR filters, and PU normalization.*

## Workflow

### 1. Classify Motor Category

| Category | Condition | Tuning Strategy |
|---|---|---|
| A | kt/J > 10,000 (small drones) | Manual Ki_speed override — calcFOCGains output is WRONG |
| B | 1,000 < kt/J ≤ 10,000 | Standard calcFOCGains with SpdLoopFactor=0.5 |
| C | 100 < kt/J ≤ 1,000 | Standard calcFOCGains with SpdLoopFactor=1.0 |
| D | kt/J ≤ 100 (high-J industrial) | Standard calcFOCGains, may need increased BW |

**Where:** kt = 1.5 × p × FluxPM (torque constant), J = rotor inertia

### 2. Compute Current Loop Gains

```matlab
gains = mcb.calcFOCGains(pmsm, inverter, Ts, Ts_speed);
% Returns: Kp_id, Ki_id, Kp_i, Ki_i, Kp_speed, Ki_speed
```

- Use `mcb.calcFOCGains` — **NOT** `mcb.getPIControllerParameters` (gives wrong speed gains)
- Current loop gains are reliable for all categories
- **ACIM exception:** Use transient inductance σ×Ls (not Ls) for current BW

### 3. Compute Speed Loop Gains

- **Category B/C/D:** Use calcFOCGains output (apply SpdLoopFactor if needed)
- **Category A:** OVERRIDE Ki_speed manually. Typical: Kp_speed=0.5-2.0, Ki_speed=5-30
- **Verify:** Simulate at 70% of max speed (NOT max speed — instability is masked at saturation)

### 4. Set Gain Convention

MCB uses **Ki×Ts convention**:
```matlab
KiTs_id = gains.Ki_id * Ts;      % This goes into the PI block
KiTs_i = gains.Ki_i * Ts;
KiTs_speed = gains.Ki_speed * Ts_speed;
```

Set `UseKiTs='on'` on PI blocks. The `'I'` mask parameter receives Ki×Ts, NOT raw Ki.

### 5. Compute Supporting Parameters

| Parameter | Formula | Reference |
|---|---|---|
| IIR cutoff | 2-5× speed loop BW | Match to speed PI bandwidth |
| iq_sat | `accel_limit_rpm_per_step / (kt/J × Ts_speed × 9.55)` | Limit rpm-per-step, not just current |
| PU I_base | I_rated or I_peak (per application) | — |
| PU V_base | Vdc / sqrt(3) | — |
| PU speed_base | Rated speed in rad/s | — |

### 6. Voltage Headroom Check

Before declaring tuning complete:
```matlab
max_speed_rpm = speed_ref_max;
headroom_speed = 0.9 * (Vdc/2) / (FluxPM * p) * 9.55;
assert(max_speed_rpm < headroom_speed, 'Speed ref exceeds voltage limit → PI will saturate');
```

## Key Rules

- **Ki×Ts convention** — never pass raw Ki to MCB PI blocks
- **calcFOCGains, NOT getPIControllerParameters** for speed PI
- **Category A motors** — always override Ki_speed manually
- **ACIM uses σ×Ls** — leakage factor σ = 1 - Lm²/(Ls×Lr)
- **Validate at 70% speed** — not max speed (saturation masks instability)
- **IIR cutoff tracks speed BW** — default 200Hz is almost always wrong

## Reference Files

- `references/tuning/parameter-computation.md` — gain formulas, generateMotorLUT, PU system
- `references/tuning/parameter-computation-motors.md` — motor structs, LUT data, power classes
- `references/shared/gain-formulas.md` — MCB API primary, manual fallbacks

---

# Importing Nonlinear Motor Data

*Generates, validates, and processes LUTs from FEA/measurement data for MTPA, FW, flux maps, and loss tables.*

## Workflow

### 1. Identify Data Source

| Source | Processing Needed |
|---|---|
| MCB motor struct (pmsm with Ld/Lq) | `mcb.generateMotorLUT` with appropriate purpose |
| FEA export (flux vs id, iq grid) | Import, validate conventions, transform to MCB format |
| Motor-CAD exported file | Extract tables, map to MCB breakpoint conventions |
| Measurement data (dynamometer) | Interpolate to regular grid, validate coverage |

### 2. Generate LUTs

Use `mcb.generateMotorLUT` with the correct purpose:

| Purpose String | Output | Use For |
|---|---|---|
| `'idiqluts'` | idTable, iqTable vs (torque × speed) | General id/iq current reference |
| `'idiqlutswt'` | idTable, iqTable vs (speed × torque) | General id/iq current reference |
| `'idiq3dluts'` | idTable, iqTable vs (torque × speed × voltage) | General id/iq current reference |
| `'idiq3dlutswtv'` | idTable, iqTable vs (speed × torque × voltage) | General id/iq current reference |
| `'eesmirefluts'` | EESM current references | Externally-excited SynRM |
| `'ifuncflux'` | idTable, iqTable vs (fluxD × fluxQ) | Motor id/iq currents with respect to flux linkages for PTBS motor plant models |

### 3. Validate Generated Data

**Critical checks (MUST do):**

| Check | Rule | Failure Mode If Skipped |
|---|---|---|
| trefVec symmetry | Must include negative torque: `[-fliplr(pos(2:end)), pos]` | Divergence on braking/reverse |
| FluxDTable first row | Must be zero (id breakpoints ≥ 0 only) | Algebraic constraint crash mid-sim |
| Speed coverage | wrpmVec must span full operating range | Extrapolation at high speed |
| Sign convention | Negative torque → negative id (not negative iq) for braking | Wrong braking direction |
| Monotonicity | id/iq should vary smoothly with torque | Chattering in controller |
| Table dimensions | [nTorque × nSpeed] orientation correct | Silent wrong indexing |

### 4. Post-Processing & Visualization

```matlab
% Plot MTPA/FW trajectory on id-iq plane
figure; plot(idTable(:,1), iqTable(:,1), 'b-', 'LineWidth', 2); % MTPA at zero speed
hold on; plot(idTable(:,end), iqTable(:,end), 'r--'); % FW at max speed
xlabel('id (A)'); ylabel('iq (A)'); title('Operating Trajectories');

% Validate coverage
surf(wrpmVec, trefVec, idTable); xlabel('Speed'); ylabel('Torque'); zlabel('id*');
```

### 5. SynRM / Reluctance Motor Axis Convention

SynRM and PM-assisted SynRM motors may use a different dq axis definition. MCB blocks have a `dqAxesDef` parameter:

| Value | Convention | Description |
|-------|-----------|-------------|
| `'Q1'` | Academic | d-axis aligned with high-permeance iron path (max inductance Ld). **id > 0 for MTPA.** |
| `'Q2'` | Industrial | d-axis aligned with maximum reluctance/air barriers (max inductance Lq). **id < 0 for MTPA.** |

**Critical:** If FEA data uses Q2 convention but MCB blocks expect Q1, the MTPA trajectory is in the wrong quadrant — motor produces negative torque or no torque.

### 6. ACIM / Induction Motor

For induction motor, in the motor parameter structure, set `motor.LUT.motorType='acim'` while calling `mcb.generateMotorLUT` — it will take care of axis rotation automatically.

## Key Rules

- **trefVec MUST be symmetric** for bidirectional torque — asymmetric tables cause divergence
- **FluxDTable first row = 0** — negative id breakpoints crash the solver
- **Use abs(speed) for bidirectional** — wrpmVec is positive only, use abs(speed) input
- **Braking convention: negative torque → negative id** (not negative iq)
- **Always plot before using** — visual sanity check catches most data issues
- **generateMotorLUT purpose strings are NOT interchangeable** — each produces different table structure

## Reference Files

- `references/nonlinear-data/pmsmlut-structure.md` — PMSMLUT format, FEA import pipeline, validation

---

# Building Motor Plant

*Converts between MCB ideal plants, Simscape electrical, and FEM-parameterized models.*

## Workflow

### 1. Identify Conversion Type

Recipes are in `references/plants/plant-model-converters.md`. Plant block configurations are in `references/plants/block-configurations-plants.md`. ACIM-specific configuration is in `references/plants/acim-configuration.md`.

| From | To | Key Challenges |
|---|---|---|
| MCB PMSM | Simscape FEM-Parameterized PMSM | Angle convention (rad → PU), solver, current sensor |
| MCB ACIM | Simscape Squirrel Cage IM | Rotor flux angle, initial conditions, solver |
| Linear PMSM | FEM-Parameterized (nonlinear) | Flux table convention, id≥0 only |
| MCB plant | Powertrain Blockset plant | Interface ports differ |

### 2. Follow Conversion Recipe

Each recipe covers:
1. **Remove** old plant block
2. **Add** new plant block (correct type)
3. **Rewire** sensor feedback paths (current, speed, angle)
4. **Adapt** angle convention (add Gain(1/(2*pi)) if needed)
5. **Switch solver** (ode14x for Simscape)
6. **Add** Solver Configuration block (Simscape requirement)
7. **Set** initial conditions (lambda_dr_d for ACIM)
8. **Validate** flux table conventions (FEM)

### 3. Critical Rules

- **Solver MUST change to ode14x** when Simscape blocks are introduced
- **Angle adapter: Gain(1/(2*pi))** — Simscape outputs radians, MCB expects PU [0,1)
- **Do NOT change `selectedRange`** on MechToElec block — output also changes, breaking downstream
- **FEM FluxDTable first row = 0** — id breakpoints must be ≥ 0 only
- **Set lambda_dr_d initial condition** for ACIM Simscape (avoids zero-flux stall)
- **Add Solver Configuration block** — required for any Simscape network
- **Gains will likely need re-tuning** after plant swap — advise user to run tuning workflow

---

# Estimating Motor Parameters

*Commissioning workflows for Rs, Ld, Lq, FluxPM, J, B using MCB estimation blocks and offline methods.*

## Workflow

### 1. Determine What's Missing

| Parameter | Source | Estimation Method |
|---|---|---|
| Rs (stator resistance) | Datasheet or DC injection | MCB Rs Estimation block |
| Ld, Lq (inductances) | Datasheet or AC injection | MCB Ld Lq Estimation block |
| FluxPM (PM flux linkage) | Datasheet or back-EMF test | Open-circuit voltage at known speed |
| J (inertia) | Mechanical test or coast-down | MCB Mechanical Parameter Estimation |
| B (friction) | Mechanical test | MCB Mechanical Parameter Estimation |
| p (pole pairs) | Always from datasheet | Cannot estimate — must be known |

### 2. Estimation Sequence (MUST follow this order)

```
1. Rs estimation (motor stationary, DC injection)
   ↓
2. Ld/Lq estimation (motor stationary, AC injection at known angle)
   ↓
3. FluxPM estimation (spin motor at known speed, measure back-EMF)
   ↓
4. J/B estimation (apply known torque, measure acceleration)
   ↓
5. → Feed parameters into mcb.calcFOCGains for PI tuning
```

### 3. Execute Estimation

See `references/estimation/estimation-procedures.md` for detailed block configuration and procedures.

### 4. Validate Results

| Parameter | Sanity Check |
|---|---|
| Rs | 0.001–10 Ω typical (scales with motor size inversely) |
| Ld, Lq | 0.01–100 mH typical; Lq > Ld for IPMSM |
| FluxPM | 0.01–1.0 Wb typical; T_rated ≈ 1.5·p·FluxPM·I_rated |
| J | 1e-6–10 kg·m² (scales with rotor volume) |
| B | Usually 1e-5–0.1 N·m·s/rad (often negligible) |

### 5. Handoff to Gain Tuning

See `references/estimation/estimation-to-tuning.md` for how estimated parameters feed into `mcb.calcFOCGains`.

## Key Rules

- **Estimate Rs FIRST** — other estimations depend on accurate Rs
- **Motor must be STATIONARY for Rs and Ld/Lq** — any rotation invalidates results
- **Motor must be FREE-SPINNING for J/B** — no mechanical load connected
- **Do NOT run estimation during closed-loop operation** — disable FOC first
- **Store results before overwriting** — estimation outputs are workspace variables

---

# Estimating Sensorless Motor Position

*Configures I/F startup, SMO, HFI, EEMF observers, and manages handoff logic between estimation methods.*

## Reference Files

- `references/sensorless/sensorless-blocks.md` — SMO/I-F block port maps, mask parameters, voltage path, Switch handoff, speed-from-position derivative, validated motor sets
- `references/sensorless/hfi-scheduler.md` — HFI+SMO hybrid: PHFO block, blending scheduler, tuning procedure, 4-state machine

## Workflow

### 1. Select Observer Method

| Method | Speed Range | Best For | Limitation |
|---|---|---|---|
| **SMO** (Sliding Mode Observer) | >10% rated speed | General purpose, robust | No standstill |
| **EEMF** (Extended EMF) | >10% rated speed | IPM motors, smooth | No standstill |
| **HFI** (High-Frequency Injection) | 0-20% rated speed | Standstill + low speed | Acoustic noise, needs saliency (Ld≠Lq) |
| **Flux Observer** | >5% rated speed | ACIM, wide speed | Needs accurate Rs |
| **HFI + SMO hybrid** | Full range (0-100%) | Premium sensorless | Complex, needs both observers |

**Decision rule:**
- SPM (Ld=Lq): Cannot use HFI → SMO + I/F startup
- IPM (Ld≠Lq): HFI at low speed + SMO at high speed (hybrid)
- ACIM: Flux Observer + I/F startup

### 2. Configure I/F Startup

I/F (open-loop current injection at ramping frequency) is needed for ALL methods at standstill except HFI.

| Parameter | Formula/Rule |
|---|---|
| I/F current magnitude | 50-100% of rated current (higher = more starting torque) |
| Frequency ramp rate | 5-50 Hz/s (slower = safer, faster = quicker startup) |
| Handoff speed | Speed where observer has reliable angle (typically 10-15% rated) |
| Handoff method | Blend (smooth) or hard-switch (simpler) |

**Critical:** I/F angle is OPEN-LOOP — it does NOT track the rotor. The motor locks to the injected field. If load torque > I/F current × kt, motor stalls.

### 3. Configure Observer

#### SMO Configuration
- `PositionUnit = 'Radians'` — **MANDATORY** (default is Degrees → 57× error → zero torque)
- Observer gain: typically 2-5× back-EMF magnitude at min operating speed
- PLL bandwidth: 50-200 Hz (tracks angle, filters noise)
- Output: electrical angle (radians) + estimated speed

#### HFI Configuration
- Injection frequency: 500-2000 Hz (above current loop BW, below PWM/2)
- Injection voltage: 10-40V (enough to excite saliency, not enough to disturb torque)
- Demodulation filter: bandpass centered at injection frequency
- Polarity detection: needed for IPM (N/S ambiguity at standstill)

#### Hybrid HFI + SMO
- Handoff: blend angle estimates over speed window (e.g., 10-20% rated)
- `angle_out = alpha * hfi_angle + (1-alpha) * smo_angle` where alpha ramps 1→0

### 4. Tune Handoff Logic

| Parameter | Rule |
|---|---|
| Handoff start speed | Speed where observer error < 5° electrical |
| Handoff end speed | Start + 5-10% of rated speed (blending window) |
| Blending function | Linear ramp or S-curve (avoid discontinuity) |
| Fallback logic | If observer diverges, revert to I/F (safety) |

**Validation:** Compare observer angle vs I/F angle during startup. If difference > 30° at handoff speed, observer gains need tuning.

### 5. Debugging Sensorless Failures

| Symptom | Likely Cause | Fix |
|---|---|---|
| Zero torque from standstill | SMO in degrees mode | Set PositionUnit='Radians' |
| Motor stalls at low speed | I/F current too low for load | Increase I/F magnitude |
| Current spike at handoff | Angle discontinuity (I/F ≠ observer) | Reduce handoff speed or use blending |
| Oscillation above handoff | SMO gain too high | Reduce observer gain, check PLL BW |
| Runs backward briefly at start | HFI polarity detection failed | Add N/S detection pulse |
| NaN after 20s | ACIM angle overflow | Add mod(theta, 2*pi) |

## Key Rules

- **SMO PositionUnit = 'Radians'** — the #1 sensorless failure. Default 'Degrees' gives 57× error.
- **I/F current must exceed load torque** — or motor stalls during startup
- **Handoff must be ABOVE observer minimum speed** — below this, angle estimate is noise
- **HFI needs saliency** — SPM motors (Ld=Lq) CANNOT use HFI
- **ACIM angle wrapping** — flux observer angle is unbounded integral, add mod(theta, 2*pi)
- **Test startup under load** — zero-load commissioning hides handoff problems

---

# Diagnosing Motor Control

*Diagnoses errors, oscillations, zero-torque, and overcurrent using structured checklists and auto-fix recipes.*

## Workflow

### 1. Identify Symptom Category

| Symptom | Diagnostic Checklist |
|---|---|
| Zero torque / motor doesn't move | 8-step zero-torque checklist |
| Oscillation (speed or current) | 6-step oscillation checklist |
| Motor drifts / runs backward slowly | FOC CC VLimits check |
| Diverges after N seconds | Time-dependent failure check |
| Overcurrent / large current spike | Current limiting check |
| Compile error / block error | Error pattern matching |

### 2. Run Structured Diagnostic

**DO NOT troubleshoot randomly.** Follow the checklist for the identified symptom.

#### Zero-Torque Checklist (8 steps)
1. Park `ThetaInput` mode → must be 'Electrical position' (not sin/cos 4-port)
2. SMO `PositionUnit` → must be 'Radians' (not default 'Degrees')
3. FOC CC PIConfig → must NOT be [0;0;0;0]
4. PMSM `P` → must be pole pairs (not doubled)
5. Angle source connected to Park port 3?
6. Current sensor polarity correct?
7. Inverter enable signal active (=1)?
8. Reference signal non-zero?

#### Oscillation Checklist (6 steps)
1. Ki convention → Ki×Ts used? (not raw Ki = 1000× too much integral)
2. Motor category → Category A needs Ki override
3. IIR cutoff → must be 2-5× speed BW (not default 200Hz)
4. iq_sat → sized by rpm-per-step? (not just I_rated)
5. Pattern → Pattern A? (switch to B — structural instability)
6. Voltage headroom → speed_ref < 90% of Vmax/(FluxPM×p)×9.55?

#### Drift Backward Checklist (3 steps)
1. FOC CC Port 6 VLimits → q-axis must be 0: [Vmax;-Vmax;**0;0**]
2. Park/InvPark angle sign convention
3. Current sensor phase order (a,b,c vs a,c,b)

#### Time-Dependent Failure (4 steps)
1. ACIM angle overflow → unbounded integral, add mod(theta, 2*pi)
2. LUT extrapolation → trefVec not symmetric, negative torque diverges
3. Single-precision accumulator drift → add DTC (double) after plant
4. Thermal protection threshold reached

### 3. Apply Fix

After identifying root cause:
1. Look up fix in `references/diagnostics/auto_fix/auto-fix-recipes.md`
2. Apply fix via `model_edit` or `evaluate_matlab_code`
3. Re-run sanity check (`references/diagnostics/model-sanity-check.md`)
4. Verify symptom is resolved

### 4. If Fix Doesn't Work

- Try next item in checklist (don't stop at first guess)
- If checklist exhausted, consult `references/diagnostics/auto_fix/ERROR_PATTERNS.md` for broader pattern matching
- After 2 failed auto-fix attempts → **escalate to user** (don't keep trying)

## Reference Files

| File | Purpose |
|------|---------|
| `references/diagnostics/model-sanity-check.md` | Index → 3-part structured checklist |
| `references/diagnostics/model-sanity-check-infrastructure.md` | Part 1: Solver, plant, transforms, data types |
| `references/diagnostics/model-sanity-check-control.md` | Part 2: PI, speed loop, inverter, enable |
| `references/diagnostics/model-sanity-check-domain.md` | Part 3: Sensorless, ACIM, angle, workspace |
| `references/diagnostics/validation-checks.md` | Pre-sim assertion functions |
| `references/diagnostics/recovery-protocol.md` | Fix in place — incremental recovery |
| `references/diagnostics/auto_fix/ERROR_PATTERNS.md` | 40+ symptom → root cause table |
| `references/diagnostics/auto_fix/auto-fix-recipes.md` | Step-by-step fix procedures |

## Key Rules

- **NEVER rebuild from scratch** — use `references/diagnostics/recovery-protocol.md` to fix in place
- **NEVER abandon MCB blocks** for MATLAB Function block reimplementation
- **Always run the full checklist** — don't stop at the first plausible cause
- **Validate the fix** — re-run sanity check after applying any change
- **Pre-sim validation** — run `references/diagnostics/validation-checks.md` assertions before first sim


----
Copyright 2026 The MathWorks, Inc.
----

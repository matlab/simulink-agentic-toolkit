# Critical Constraints & Pitfalls

> Rules that MUST be followed to avoid simulation failures, incorrect behavior, or subtle bugs.
> Violations cause: algebraic loops, dimension errors, divergence, or silent incorrect results.

---

## Algebraic Loop Prevention

### Rule 1: Unit Delay on Voltage Path
**Always** place a Unit Delay between the inverter/InvClarke output and the PMSM voltage input.
```json
[
  {"op": "add_block", "type": "Unit Delay", "name": "Delay_V", "ref": "dv", "params": {"SampleTime": "Ts"}},
  {"op": "connect", "target": "Mux_V.y1 -> #dv.u1"},
  {"op": "connect", "target": "#dv.y1 -> PMSM.u2"}
]
```
**Why:** PMSM computes currents from voltages, and current feedback drives voltage computation. Without delay, circular dependency.

### Rule 2: Unit Delay in Voltage-Feedback Field Weakening
When computing `|Vdq| = sqrt(Vd² + Vq²)` for FW, place Unit Delay BEFORE the comparison:
```
Vd,Vq → sqrt(Vd²+Vq²) → [Unit Delay] → Sum(Vmax - Vs_delayed)
```
**Why:** Vd/Vq are PI outputs that depend on id_ref, which depends on FW output → loop.

### Rule 3: FOC CC Vabc → Delay before SMO voltage inputs
When using FOC CC output voltages as SMO inputs, delay is required:
```
FOC_CC/1 → Delay_Vabc → Demux → Clarke → SMO/1,2
```

---

## Data Type Rules

### Rule 3b: PMSM Outputs Are Single Precision — DTC Required When Model Uses Double
PMSM/IM outputs y2 (phase currents) and y3 (speed) are **single precision**. DTC handling depends on model-level `DefaultUnderspecifiedDataType`:

**When `DefaultUnderspecifiedDataType='double'` (manual builds):**
Add Data Type Conversion blocks before ANY double-precision arithmetic:
```json
[
  {"op": "add_block", "type": "Data Type Conversion", "name": "DTC_I", "ref": "dtci", "params": {"OutDataTypeStr": "double"}},
  {"op": "add_block", "type": "Data Type Conversion", "name": "DTC_Spd", "ref": "dtcs", "params": {"OutDataTypeStr": "double"}},
  {"op": "connect", "target": "PMSM.y2 -> #dtci.u1"},
  {"op": "connect", "target": "#dtci.y1 -> Demux_I.u1"},
  {"op": "connect", "target": "PMSM.y3 -> #dtcs.u1"},
  {"op": "connect", "target": "#dtcs.y1 -> IIR_Spd.u1"}
]
```

**When `DefaultUnderspecifiedDataType='single'` (RECOMMENDED — matches MCB convention):**
NO DTC blocks needed — all blocks inherit single precision, avoiding type mismatches inside MCB masked blocks. This is the pattern used by all proven builds. Set via:
```matlab
set_param(mdl, 'DefaultUnderspecifiedDataType', 'single');
```

**Failure mode (double mode only):** Single-to-double implicit conversion can cause subtle numerical issues in PI integrators and transform computations, especially in closed-loop torque mode where accumulated errors compound through the mechanical feedback path.

### Rule 4: Six Step Commutation Output is Boolean
```json
[
  {"op": "add_block", "type": "Data Type Conversion", "name": "DTC_bool", "ref": "dtcb", "params": {"OutDataTypeStr": "double"}},
  {"op": "connect", "target": "SixStep.y1 -> #dtcb.u1"},
  {"op": "connect", "target": "#dtcb.y1 -> Gain_Vdc.u1"}
]
```
**Failure mode:** Boolean × double = 0 in some solvers (silent zero output).

### Rule 5: SMO Output May Be Single Precision
```json
[
  {"op": "add_block", "type": "Data Type Conversion", "name": "DTC_theta", "ref": "dtct", "params": {"OutDataTypeStr": "double"}},
  {"op": "connect", "target": "SMO.y1 -> #dtct.u1"},
  {"op": "connect", "target": "#dtct.y1 -> Park.u3"}
]
```

### Rule 6: DefaultUnderspecifiedDataType Consistency
Set at model level (`evaluate_matlab_code` — model-level config):
```matlab
set_param(mdl, 'DefaultUnderspecifiedDataType', 'double'); % or 'single'
```

---

## Bus Selector vs Selector Block

### Rule 7: PMSM Info Bus → Bus Selector ONLY
```json
[
  {"op": "add_block", "type": "Bus Selector", "name": "BusSel", "ref": "bs", "params": {"OutputSignals": "MtrElcPos"}},
  {"op": "connect", "target": "PMSM.y1 -> #bs.u1"}
]
```
**WRONG:** Using `"type": "Selector"` — causes "Power Accounting Bus Creator" error.
**Why:** PMSM/1 outputs a bus object, not a vector. Selector expects vector indexing.

### Valid Bus Signal Names
- `'MtrPos'` — Mechanical position (rad, continuous)
- `'MtrElcPos'` — Electrical position (rad, wrapped)
- `'MtrSpd'` — Mechanical speed (rad/s)

---

## MTPA Control Reference

### Rule 7c: MTPA Speed Input is MECHANICAL rad/s
The MTPA Control Reference block's u2 port expects **mechanical speed in rad/s**. The block converts to electrical speed internally using the `polePairs` mask parameter.
```
CORRECT:  PMSM.y3 → DTC_Spd → IIR_Spd → MTPA.u2  (mechanical rad/s)
WRONG:    PMSM.y3 → DTC_Spd → Gain(pmsm.p) → MTPA.u2  (electrical rad/s — BROKEN)
```
**Failure mode:** Feeding electrical rad/s causes FW to engage at 1/p of the correct speed (e.g., at 200 RPM instead of 800 RPM for p=4). Symptom: id* saturates to -I_rated and iq*=0 at low speed → motor produces no torque and stalls.

### Rule 7d: MTPA Torque Saturation in Nm (Not Amps)
When PI_speed feeds MTPA.u1 (torque reference), the saturation block must limit in **Nm**:
```
CORRECT:  Sat_Tref limits = ±T_rated  where T_rated = 1.5*p*FluxPM*I_rated
WRONG:    Sat_Iq limits = ±iq_sat (Amps) — under-constrains torque authority
```
**Failure mode:** Using current saturation (e.g., 0.35A) as torque limit means max torque command = 0.35 Nm, which is often too small for acceleration. Motor creeps slowly or stalls.

---

## PI Controller Configuration

### Rule 7b: Prefer MCB PI Controller Over Standard PID
**Strongly prefer** `"mcbcontrolslib/PI Controller"` for all current and speed loops. The standard `slpidlib/PID Controller` can be used (e.g., for gain scheduling) but requires explicit configuration of TimeDomain, LimitOutput, IntegratorMethod, and Controller type — omitting any one causes silent misbehavior. See `block-configurations.md` → "Alternative: Standard PID" for the required settings.

**Common failure when using standard PID without full configuration:**
- Defaults to continuous-time → discrete model gets wrong integral action
- Saturation limits ignored (LimitOutput defaults to 'off')
- Ki convention reversed (standard PID uses raw Ki, MCB PI uses Ki*Ts)
- These errors compound to produce currents in wrong dq-axis directions, often misdiagnosed as "angle convention mismatch"

### Rule 8: All Three Params for 1-Input Mode
ALL three must be set in `model_edit` configure — omitting ANY switches to 3-port mode:
```json
{"op": "configure", "target": "PI_d", "params": {
    "ControllerParametersSource": "internal",
    "ExternalReset": "none",
    "InitialConditionSource": "internal"}}
```
**Failure mode:** Block shows 3 input ports instead of 1, wiring breaks silently.

### Rule 9: UseKiTs Convention
When `UseKiTs='on'`, the I parameter expects `Ki * Ts` (pre-multiplied):
```json
{"op": "configure", "target": "PI_d", "params": {"I": "Ki_id * Ts"}}
```
**WRONG:** `{"params": {"I": "Ki_id"}}` — passes raw Ki, integral action is Ts² too strong → oscillation.

---

## Transform Port Ordering and Convention

### Rule 9b: Park/InvPark AxisAlignment Must Be 'D-axis'
The default `AxisAlignment='D-axis'` means alpha-axis aligns with d-axis at θ_e=0. This matches the PMSM plant's `MtrElcPos` output convention exactly. Do NOT change this setting.

**Convention:** `MtrElcPos` = electrical angle of the rotor d-axis (flux direction). Using `Park(Iabc, MtrElcPos)` gives Id/Iq consistent with the PMSM's internal `IdSync`/`IqSync` signals.

### Rule 10: Park/InvPark Always Need theta_e on Port 3
```matlab
% Port 1: signal_alpha (or Vd)
% Port 2: signal_beta (or Vq)
% Port 3: theta_e (electrical angle, RADIANS)
```
Swapping port 1↔2 gives wrong projection. Swapping port 3 with signal port = model error.

### Rule 11: Clarke Takes Scalars, Not Vectors
```json
// CORRECT: two separate scalar connections
{"op": "connect", "target": "Demux_I.y1 -> Clarke.u1"},
{"op": "connect", "target": "Demux_I.y2 -> Clarke.u2"}

// WRONG: connecting vector to port 1 → DIMENSION ERROR
{"op": "connect", "target": "Mux_Iab.y1 -> Clarke.u1"}
```

---

## Mechanical-to-Electrical Conversion

### Rule 12: MechToElec selectedRange = 'Radians'
```json
{"op": "configure", "target": "MechToElec", "params": {"selectedRange": "Radians"}}
```
Do NOT change to 'Per-Unit' or 'Degrees' — downstream Park/InvPark expect radians.

### Rule 13: Angle Input to Park Must Be Electrical
```
theta_e = theta_mech * p   (where p = pole pairs)
```
If using raw PMSM mechanical position, MUST pass through MechToElec block first.

---

## Speed Feedback Path

### Rule 14: IIR Filter on Speed, NOT on Current
- Speed measurement is noisy (discrete derivative of position) → filter it
- Current measurement is already band-limited by PWM → do NOT filter
- Filtering current adds phase lag that destabilizes current loop

### Rule 15: Speed Feedback Units Must Match Reference
If speed reference is in RPM, speed feedback must also be RPM. Mismatch = wrong error signal.
```matlab
% Convert rad/s to RPM if needed
speed_rpm = speed_rads * 60 / (2*pi);
```

### Rule 15b: Speed Loop Operates in rad/s (PMSM.y3 is rad/s)
**PMSM output y3 is mechanical speed in rad/s.** The speed error sum, PI controller, and IIR filter all operate in rad/s unless you explicitly add a conversion gain. When logging speed for verification, convert to RPM: `speed_rpm = logged_value * 9.5493`.
```matlab
% Common trap: seeing "52.4" and thinking RPM when it's rad/s (= 500 RPM)
% The Step block reference must also be in rad/s:
speed_ref_rad = speed_ref_rpm * 2*pi/60;  % e.g., 500 RPM → 52.36 rad/s
```
**Failure mode:** Misinterpreting rad/s as RPM → believing model has 90% error when it's actually at setpoint.

---

## Inverter and Modulation

### Rule 16: PWM Ref Gen Inputs Must Be Per-Unit
```matlab
Valpha_PU = Valpha / Vmax;  % where Vmax = Vdc/sqrt(3)
Vbeta_PU = Vbeta / Vmax;
```
Connecting un-normalized voltages → duty > 1 → clipping → distortion.

### Rule 17: V2D Conversion Formula
```matlab
% Volts → Duty for Average-Value Inverter
Vmax = Vdc / sqrt(3);          % max linear phase voltage
duty = voltage / (2*Vmax) + 0.5;
% Equivalent: duty = voltage * sqrt(3) / (2*Vdc) + 0.5
% Range: voltage in [-Vmax, +Vmax] maps to duty in [0, 1]

% AVI internal: Saturation [0,1] then Vout = (Duty - mean(Duty)) * Vdc
% WARNING: AVI clips duty outside [0,1]! Using 1/Vdc instead of 1/(2*Vmax)
% causes duty to exceed [0,1] at full modulation → clipping → distortion.

% FOC CC output range: [-Vmax, +Vmax] (verified on mcbfoclib block)
% Pattern A InvClarke output range: [-Vmax, +Vmax] (balanced 3-phase)
% Both REQUIRE the 1/(2*Vmax) formula, NOT 1/Vdc.
```
**Simulink pattern (SI mode) — `model_edit`:**
```json
[
  {"op": "add_block", "type": "Gain", "name": "V2D_Gain", "ref": "v2d", "params": {"Gain": "1/(2*inverter.V_dc/sqrt(3))"}},
  {"op": "add_block", "type": "Add", "name": "V2D_Add", "ref": "v2a", "params": {"Inputs": "++"}},
  {"op": "add_block", "type": "Constant", "name": "Half", "ref": "hf", "params": {"Value": "0.5"}},
  {"op": "connect", "target": "FOC_CC.y1 -> #v2d.u1"},
  {"op": "connect", "target": "#v2d.y1 -> #v2a.u1"},
  {"op": "connect", "target": "#hf.y1 -> #v2a.u2"},
  {"op": "connect", "target": "#v2a.y1 -> AVI.u1"}
]
```
**Alternative (using Vmax workspace variable):**
```json
[
  {"op": "add_block", "type": "Gain", "name": "V2D_Gain", "ref": "v2d", "params": {"Gain": "1/(2*Vmax)"}},
  {"op": "add_block", "type": "Bias", "name": "V2D_Bias", "ref": "v2b", "params": {"Bias": "0.5"}},
  {"op": "connect", "target": "FOC_CC.y1 -> #v2d.u1"},
  {"op": "connect", "target": "#v2d.y1 -> #v2b.u1"},
  {"op": "connect", "target": "#v2b.y1 -> AVI.u1"}
]
```

### Rule 18: Mux Duty Before Inverter
Average-Value Inverter expects [Da;Db;Dc] as single 3×1 vector on port 1.
```json
[
  {"op": "add_block", "type": "Mux", "name": "Mux_Duty", "ref": "mxd", "params": {"Inputs": "3"}},
  {"op": "connect", "target": "Da_src.y1 -> #mxd.u1"},
  {"op": "connect", "target": "Db_src.y1 -> #mxd.u2"},
  {"op": "connect", "target": "Dc_src.y1 -> #mxd.u3"},
  {"op": "connect", "target": "#mxd.y1 -> AVI.u1"}
]
```

---

## Model Workspace Rules

### Rule 19: ALL Parameters in Model Workspace
Use `evaluate_matlab_code` for workspace assignment (not structural):
```matlab
mdlWks = get_param(mdl, 'ModelWorkspace');
assignin(mdlWks, 'varName', value);
```
- Never use base workspace (pollutes, non-portable)
- Never use InitFcn callback (fragile, hard to debug)
- Never use Simulink.Parameter objects unless code-gen required

### Rule 20: Parameter Values Must Reference Workspace Variables
```json
// CORRECT — workspace variable reference (evaluated at sim time)
{"op": "configure", "target": "PI_d", "params": {"P": "Kp_id"}}

// WRONG — literal number (won't update if workspace changes)
{"op": "configure", "target": "PI_d", "params": {"P": "2.5"}}
```
In `model_edit`, all param values are strings. Use workspace variable names (e.g., `"Kp_id"`) so the model stays parametric. Literal numbers are acceptable only for true constants.

---

## Solver Rules

### Rule 21: FixedStepDiscrete for MCB Plants
Use `evaluate_matlab_code` for model-level solver config:
```matlab
set_param(mdl, 'Solver', 'FixedStepDiscrete', 'FixedStep', 'Ts');
```
MCB plant blocks (Interior PMSM, BLDC) are discrete — variable-step solvers waste time.

### Rule 22: ode14x for Simscape Plants
```matlab
set_param(mdl, 'Solver', 'ode14x', 'FixedStep', 'Ts');
```
Simscape requires implicit solver. Explicit (ode4, ode45) → divergence.

---

---

## Angle Feedback Path

### Rule 16b: Prefer MtrPos → MechToElec Over MtrElcPos Direct
**Recommended:** `BusSel('MtrPos') → MechToElec → Park/InvPark`
- Matches hardware signal chain (encoder → mech angle → electrical conversion)
- MechToElec wraps output to [0, 2π] and handles pole-pair multiplication
- Proven pattern that matches hardware signal chain (encoder → mech angle → electrical conversion)

**Acceptable (simulation shortcut):** `BusSel('MtrElcPos') → Park/InvPark` directly
- Works correctly in simulation (PMSM block provides correct theta_e)
- Does NOT emulate hardware measurement path

**NEVER:** `BusSel('MtrElcPos') → MechToElec → Park` — double pole-pair multiplication!

---

## Quick Wrong/Right Reference

| # | Wrong | Right | Consequence |
|---|-------|-------|-------------|
| 1 | `add_block('simulink/Signal Routing/Selector', ...)` for PMSM bus | `add_block('simulink/Signal Routing/Bus Selector', ...)` | "Power Accounting Bus Creator" error |
| 2 | `set_param(blk, 'I', 'Ki_id')` with UseKiTs='on' | `set_param(blk, 'I', 'Ki_id * Ts')` | Integral action Ts² too strong → oscillation |
| 3 | `Mux([Ia;Ib]) → Clarke/1` | `Demux → Ia→Clarke/1, Ib→Clarke/2` | Dimension mismatch error |
| 4 | `BusSel('MtrElcPos') → MechToElec → Park/3` | `BusSel('MtrPos') → MechToElec → Park/3` | Double pole-pair multiplication → wrong angle |
| 5 | `set_param(blk, 'Solver', 'ode4')` with Simscape | `set_param(blk, 'Solver', 'ode14x')` | Divergence (explicit solver on DAE) |
| 6 | Passing radians to PWM Ref Gen position port | Divide by 2*pi (expects per-unit [0,1)) | Wrong duty cycles → overcurrent |
| 7 | `duty = Vabc / Vdc + 0.5` (wrong scale) | `duty = Vabc / (2*Vmax) + 0.5` where Vmax=Vdc/√3 | Duty exceeds [0,1] at full modulation → AVI clips → distortion |
| 8 | Raw `mcb.calcFOCGains(...).Ki_id` in PI block | `Ki_id * Ts` (pre-multiply for UseKiTs) | Same as #2 |
| 9 | `PIConfig = [0;0;0;0]` in FOC CC port 5 | Actual `[Kp_d; Ki_d*Ts; Kp_q; Ki_q*Ts]` | Zero output → motor uncontrolled |
| 10 | `set_param(mdl, 'Solver', 'VariableStepAuto')` for MCB | `'FixedStepDiscrete'` with explicit Ts | Wrong timing, excessive computation |
| 11 | `PositionObserver='FO'` (string) in calcFOCGains | `obs.Type='FO'; obs.Parameters.CutOffFrq=200;` (struct) | MATLAB error |
| 12 | FOC CC output → directly to AVI | FOC CC → V2D_Gain(1/(2*Vmax)) → Add(+0.5) → AVI | Voltage interpreted as duty → clipping |
| 13 | `UnconnectedOutputMsg='warning'` (default) | `'error'` for Input/Output/Line messages | Unconnected ports hide wiring bugs |
| 14 | `BusSel('MtrPos')` + MechToElec for angle | `BusSel('MtrElcPos')` directly to Park/InvPark | MtrElcPos provides theta_e natively |
| 15 | `slpidlib/PID Controller` with default settings | `mcbcontrolslib/PI Controller` (or slpidlib with ALL 8 params set) | Continuous-time default + missing LimitOutput → broken control loop |
| 16 | Changing Park `AxisAlignment` to `'Q-axis'` | Keep default `'D-axis'` (matches PMSM MtrElcPos) | Id/Iq swapped relative to PMSM internal frame |
| 17 | `PMSM.y3 → PI` (no DTC) | `PMSM.y3 → DTC(double) → IIR → PI` | Single×double in PI integrator → subtle drift |
| 18 | `PMSM.y2 → Demux → Clarke` (no DTC) | `PMSM.y2 → DTC(double) → Demux → Clarke` | Single-precision currents → transform errors |
| 19 | `mcb.calcFOCGains(m, Ts, Ts_spd)` with raw speed gains | `mcb.calcFOCGains(m, Ts, Ts_spd, 'SpdLoopFactor', 0.05)` | Speed oscillation from overly aggressive gains |
| 20 | `set_param(blk, 'MeasurementsBusFlag', ...)` | (parameter doesn't exist — remove the call) | Error: invalid parameter for Interior PMSM |
| 21 | Speed ref = 2000 RPM with Vdc=24V, FluxPM=0.0226, p=4 | Compute max: `Vdc/sqrt(3)/(FluxPM*p)*9.55` = 1464 RPM; use 90% | PI saturates → limit cycle oscillation |
| 22 | Speed PI saturation = ±I_rated (7.1A) for J=7e-6 no-load | Limit iq_sat so `iq*kt/J*Ts_speed < 10 RPM/step` (≈0.3A) | 651 RPM/step acceleration → violent oscillation |
| 23 | IIR filter fc=200 Hz with speed BW=7 Hz | Set IIR fc = 2×–5× speed BW (14–35 Hz) | Noise passes through → triggers speed PI → oscillation |
| 24 | `mcb.calcFOCGains(motor, Ts, Ts_speed)` for J=200 ship motor | Manual: `Kp=2*J*BW`, `Ki=J*BW²` (calcFOCGains derates 22×) | Sluggish response, never reaches setpoint |
| 25 | Park/InvPark without `ThetaInput='Electrical position'` | Always set `ThetaInput='Electrical position'` + `AngleInput='Radians'` | 4-port sin/cos mode: theta on port 3 misinterpreted → Park_iq ≠ IqSync → no torque |
| 26 | Testing speed loop ONLY near max_speed (90%) where voltage limit prevents overshoot | Test at 70% of max_speed for all categories (exposes tuning bugs) | Voltage-limit masking: motor appears stable near ceiling, oscillates at lower speeds |
| 27 | Ki_speed from calcFOCGains (e.g., 0.4) for J=7e-6 no-load | Cap Ki_speed ≤ 0.005 for Cat A motors (integral windup) | Integral accumulates during ramp → can't brake after overshoot → oscillation |
| 28 | Ki_speed from calcFOCGains with SpdLoopFactor=0.02 (gives ~0.18 for J=7e-6) | Override Ki_speed=0.005 directly (ignore calcFOCGains Ki for Cat A) | Integral windup: accumulates during accel ramp, takes >1s to unwind → 40%+ overshoot that settles only after 2s |
| 29 | Testing speed control only at 90% of max_speed_rpm | Always verify at 70% of max_speed — voltage limit masks tuning bugs at 90% | "Works" near Vmax ceiling (can't overshoot past voltage limit), oscillates at lower refs |
| 29 | Logging speed and interpreting as RPM | PMSM.y3 is rad/s; multiply by 9.55 for RPM | Misdiagnose "52 RPM" as 90% error when it's actually 500 RPM at setpoint |
| 30 | InvClarke → V2D_Gain → V2D_Bias → PMSM.u2 (Pattern A) | InvClarke → Mux → UnitDelay → PMSM.u2 (direct volts, NO V2D) | V2D outputs duty [0,1]; PMSM.u2 expects volts → motor sees 0.5V instead of ±13.8V |
| 31 | `set_param(PMSM, 'P', 'pmsm.p*2')` (treating P as poles) | `set_param(PMSM, 'P', 'pmsm.p')` — P is pole PAIRS | Wrong electrical frequency → angle mismatch → zero/oscillating torque |
| 32 | Hardcoding library paths for `add_block` (paths change between releases) | Use `model_edit` with display name `"Mechanical to Electrical Position"` — SATK resolves the correct library path | Block not found error when library path changes between MATLAB versions |
| 33 | `set_param(MechToElec, 'polePairs', 'pmsm.p')` | `set_param(MechToElec, 'NrPP', 'pmsm.p')` | "does not have a parameter named polePairs" error |
| 34 | Interior PMSM with default `sim_type='Continuous'` + FixedStepDiscrete solver | Always set `sim_type='Discrete'` and `Ts='Ts'` | "contains continuous states" solver error |
| 35 | FOC CC VLimits (port 6) = `[Vmax;-Vmax;Vmax;-Vmax]` (non-zero q-axis) | `[Vmax;-Vmax;0;0]` — q-axis elements MUST be 0 | Silent motor drift: motor runs at constant negative speed (~-17 rad/s for typical EV motor) with NO error. Speed PI cannot correct it. |
| 36 | FOC CC output → V2D_Gain → V2D_Bias → AVI → UnitDelay → PMSM (for simulation) | FOC CC → UnitDelay → PMSM.u2 directly (simulation shortcut) | V2D+AVI adds complexity and potential scaling errors. Direct path is simpler and proven stable. Only use V2D+AVI when modeling inverter nonlinearity. |
| 37 | Step block params `Before`/`After` in `model_edit configure` | For `model_edit`: use `InitialValue`, `FinalValue`. For `set_param`: BOTH `Before`/`After` AND `InitialValue`/`FinalValue` work | `Before`/`After` fail silently in `model_edit configure` only — they DO work with `set_param` in evaluate_matlab_code |
| 38 | FOC CC `model_edit configure` with `Units`, `polePairs`, `SampleTime` | Only set `AngleUnit='Radians'` via configure; block inherits Ts from solver | These params do NOT exist on FOC CC mask — silent failure, no error |
| 39 | `mcb.computeSMOParameters(pmsm, Ts, PU)` without `pmsm.N_base` | Add `pmsm.N_base = pmsm.N_max` before calling | `mcb.getPMSMParameters` does NOT return N_base — "Unrecognized field" error |
| 40 | I/f integrator with `Constant(speed_ref_rad * p)` as input | Use `Ramp(0 → target, slope=target/0.15)` + Saturate | Constant speed creates instantly-rotating field; rotor can't sync → zero net torque, motor doesn't move |
| 41 | Using SMO.y2 (speed) for handoff threshold comparison | Use `PMSM.y3 → DTC → IIR → Abs → Compare` (actual motor speed) | SMO speed is unreliable at low speed in simulation — gives false high readings triggering premature handoff |
| 42 | SMO angle (y1) in FOC control loop during simulation | Use `BusSel('MtrElcPos')` for control, SMO in parallel for monitoring | SMO PLL locks to commanded voltage frequency (not rotor), causing 2× rate error during I/f→SMO transition in sim |
| 43 | Scope block with default ports + connect to `.u2` | Set `NumInputPorts='N'` in add_block params, or use Mux before Scope | "Port u2 does not exist" error — Scope defaults to 1 input |
| 44 | `set_param(mcb_block, 'DataLogging', 'on')` for signal logging | Add `To Workspace` block via model_edit and connect to signal | MCB masked blocks (IIR, PI, SMO, PMSM, FOC CC) don't expose DataLogging — use ToWorkspace instead |
| 45 | Adding logging blocks AFTER model build via evaluate_matlab_code + add_block/add_line | Include ToWorkspace blocks in initial model_edit (layout_mode="full") | Violates model-edit-first; requires exact library paths; cannot use blk_id refs |
| 46 | ACIM theta_e integrator without mod wrapping | Always add `Math Function(mod)` + `Constant(2*pi)` after theta integrator | Park/InvPark uint16 LUT overflow after ~6500 rad → NaN → motor runaway (no compile warning) |
| 47 | `DefaultUnderspecifiedDataType='double'` with MCB plant blocks | Use `'single'` + explicit DTC(double) on plant outputs | MCB internal bus signals are single — double propagation causes type mismatch inside masked blocks |
| 48 | ACIM speed ref above `Vmax/(Lm*id_ref*p)` | Compute max speed, use 85% headroom: `speed_ref < 0.85*Vmax/(Lm*id*p)` | Back-EMF exceeds voltage → current PI saturates → uncontrolled acceleration or limit cycle |
| 49 | ACIM current PI tuned with full Ls (stator inductance) | Use transient inductance: `L_sigma = sigma * Ls` where `sigma = 1 - Lm²/(Ls*Lr)` | Gains ~5× too large → current oscillation. Effective plant inductance seen by controller is sigma*Ls, not Ls |
| 50 | Discrete-Time Integrator `WrappedStateUpperValue` / `WrapState` params | These params do NOT exist. Use DTI → Math Function(mod) → Constant(2*pi) chain | Silent param failure → angle grows unbounded → NaN after ~1-2s simulation |

---

> For domain-specific rules (SMO, ACIM, LUT, high-speed, structural) see `critical-constraints-domain.md`.

----
Copyright 2026 The MathWorks, Inc.
----

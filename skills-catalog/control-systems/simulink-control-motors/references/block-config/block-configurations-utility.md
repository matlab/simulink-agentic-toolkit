# Block Configuration Reference — Utility & Support Blocks

> I-F Controller, MechToElec, Speed Measurement, IIR Filter, Six Step Commutation, Induction Motor, Model-Level Settings, Utility Blocks, and Plant Model Tiers.
> For motor/inverter/observer blocks see `block-configurations-plants.md`.
> For control blocks (PI, Clarke, Park, MTPA, FOC CC, PWM) see `block-configurations.md`.

---

## I-F Controller

**Type (model_edit):** `"I-F Controller"` (resolves by name via SATK)

**Port Map:**
| Port | Direction | Signal |
|------|-----------|--------|
| In/1 | Input | Enable (0/1) |
| In/2 | Input | theta_e (from observer) |
| In/3 | Input | w_m_ref (speed reference) |
| In/4 | Input | w_m (measured/estimated speed) |
| In/5 | Input | Iq (measured q-axis current) |
| In/6 | Input | Vq (measured q-axis voltage) |
| Out/1 | Output | Id_ref |
| Out/2 | Output | Iq_ref |
| Out/3 | Output | theta_e_ref (angle for FOC during startup) |
| Out/4 | Output | Status (0=I-F active, 1=closed-loop) |

**Key Parameters:**
| Parameter | Description |
|-----------|-------------|
| `OlClSpeed` | Open-loop -> closed-loop transition speed |
| `ClOlSpeed` | Closed-loop -> open-loop transition speed |
| `MaxStartingCurrent` | Max current during I-F phase |
| `MaxAcceleration` | Acceleration limit |

**Gotchas:**
- Output 3 (theta_e_ref) replaces observer angle during startup
- Output 4 (Status) controls speed loop enable Switch
- Supports bidirectional (auto re-enters I-F if speed drops below ClOlSpeed)

---

## Mechanical to Electrical Position

**Type (model_edit):** `"Mechanical to Electrical Position"` (resolves by name via SATK)

**Settings (`model_edit`):**
```json
{"op": "configure", "target": "MechToElec", "params": {
    "selectedRange": "Radians",
    "NrPP": "pmsm.p",
    "MechOfstInputType": "Specify via dialog",
    "mechOffsetIn": "0"}}
```

**Settings (`evaluate_matlab_code` / `set_param`):**
```matlab
set_param([mdl '/MechToElec'], 'NrPP', 'pmsm.p', ...
    'selectedRange', 'Radians', ...
    'MechOfstInputType', 'Specify via dialog', ...
    'mechOffsetIn', '0', ...
    'InputDataType', 'double');  % PMSM bus outputs single; set to match or use 'double' after DTC
```

**All mask parameters:**
| Parameter | Options | Notes |
|-----------|---------|-------|
| `NrPP` | `"pmsm.p"` | Pole pairs (NOT `polePairs` — that name doesn't exist!) |
| `selectedRange` | `"Radians"` or `"Per-Unit"` | Keep Radians for Park/InvPark |
| `MechOfstInputType` | `"Specify via dialog"` / `"Input port"` | Dialog = 1 input; Input port = 2 inputs (adds offset port) |
| `mechOffsetIn` | `"0"` | Only used in dialog mode |
| `InputDataType` | `"single"` / `"double"` | Default is `single`; set to `double` if input was DTC'd |
| `VariantSelect` | `"floating-point"` / `"fixed-point"` | Keep floating-point for simulation |

**Gotchas:**
- Use display name `"Mechanical to Electrical Position"` with model_edit — do NOT hardcode library paths
- **Parameter is `NrPP`** (not `polePairs`) — using `polePairs` causes "does not have a parameter" error
- `MechOfstInputType` defaults to `'Input port'` which adds a second input port — always set to `'Specify via dialog'` unless you need runtime offset
- Output is wrapped electrical angle (theta_e = p * theta_mech, mod 2*pi)
- Do NOT change `selectedRange` — downstream Park/InvPark expect radians
- **Alternative (SIMPLER for simulation):** Use `BusSel('MtrElcPos')` from PMSM Info bus directly (avoids this block entirely, proven stable)

---

## Speed Measurement

**Type (model_edit):** `"Speed Measurement"` (resolves by name via SATK)

**Key Parameters:**
| Parameter | Value | Notes |
|-----------|-------|-------|
| `PositionUnit` | `'Radians'` | Match PMSM output |
| `SpeedUnit` | `'Radians/Sec'` | Or `'RPM'` |
| `SpeedCalculationMode` | `'Maximum application speed'` | Preferred mode |
| `MaximumApplicationSpeed` | `'PU_System.N_base * 2'` | **ALWAYS in RPM** regardless of SpeedUnit |
| `SampleTimeAsync` | `'Ts'` | Asynchronous sample time |

**Gotchas:**
- `MaximumApplicationSpeed` is ALWAYS in RPM (even if SpeedUnit='Radians/Sec') — setting rad/s value causes 10× speed error + sign inversion
- **Alternative A:** Use `PMSM/3` (MtrSpd port) directly + IIR filter — simpler, avoids this block entirely
- **Alternative B:** Use `simulink/Discrete/Discrete Derivative` block — takes position input, outputs speed. Simplest option for servo/position models: `BusSel('MtrPos') → Discrete Derivative → IIR_Spd`. No configuration params needed (inherits sample time from model).

---

## IIR Filter

**Type (model_edit):** `"IIR Filter"` (resolves by name via SATK)

**Settings (`model_edit`):**
```json
[
  {"op": "add_block", "type": "IIR Filter", "name": "IIR_Spd", "ref": "iir", "params": {"Filter_constant": "IIR_coeff", "Ts": "Ts"}},
]
```
**CRITICAL:** Parameter name is `Filter_constant` (with underscore) — NOT `IIR_coeff`, `IIRCoefficient`, `FilterCoefficient`, or `Coefficient`. Using wrong names silently fails.

**Settings (`evaluate_matlab_code` / `set_param`):**
```matlab
set_param([mdl '/IIR_Spd'], 'Filter_constant', 'IIR_coeff', 'Ts', 'Ts');
% NOTE: param names are 'Filter_constant' and 'Ts' — NOT 'FilterCoefficient' or 'SampleTime'
```

**Key Parameters:**
| Parameter | Options | Notes |
|-----------|---------|-------|
| `VariantSelect` | `'Low-pass'`, `'High-pass'` | |
| `FilterConstantInputType` | `'Specify via dialog'`, `'Input port'` | |
| `Filter_constant` | Alpha coefficient (dialog mode only) | |
| `cutOff_freq` | Cutoff frequency in Hz | **PREFERRED** — computes alpha internally, avoids manual formula |
| `Ts` | Sample time string (e.g., `"Ts"`) | NOT `SampleTime` — that name does NOT exist |
| `ExternalReset` | `'none'`, `'active high resets to initial condition'` | |

**Preferred usage (model_edit):** Use `cutOff_freq` instead of computing alpha manually:
```json
[
  {"op": "add_block", "type": "IIR Filter", "name": "IIR_Spd", "ref": "iir", "params": {"cutOff_freq": "50", "Ts": "Ts"}}
]
```

**Dialog mode:** 1 input, 1 output. **Input port mode:** 2 inputs (adds filter constant), 1 output.

**Coefficient formula:**
```matlab
alpha = 2*pi*fc*Ts / (1 + 2*pi*fc*Ts);  % fc = cutoff frequency (Hz)
```

**Gotchas:**
- Use on **speed feedback**, NOT on current (current filtering adds destabilizing phase lag)
- `'Input port'` mode enables speed-dependent filtering

---

## Six Step Commutation

**Type (model_edit):** `"Six Step Commutation"` (resolves by name via SATK)

**Port Map:**
| Port | Direction | Signal |
|------|-----------|--------|
| In/1 | Input | Hall value (3-bit encoded) |
| In/2 | Input | TorqueSign (+1 or -1) |
| Out/1 | Output | Switching vector [6x1 boolean] |

**Key Parameters:** `InputType` ('Hall'/'Position'), `CommutationMode` ('120 deg'/'180 deg'), `SequencePos` ([5,4,6,2,3,1])

**Gotchas:**
- Output is **boolean** -- MUST add DTC (->double) before multiplication/gain blocks

---

## Induction Motor

**Type (model_edit):** `"Induction Motor"` (resolves by name via SATK)

**Port Map:** Same as PMSM (2 in: TL + Vabc, 3 out: Info + Iabc + Speed)

**Mandatory Settings (`model_edit`):**
```json
{"op": "configure", "target": "ACIM", "params": {
    "P": "acim.p",
    "Zs": "[acim.Rs, acim.Lls]",
    "Zr": "[acim.Rr, acim.Llr]",
    "Lm": "acim.Lm",
    "mechanical": "[acim.J, acim.B, 0]",
    "sim_type": "Discrete",
    "Ts": "Ts"}}
```

**Parameter Clarification (despite "Z" naming, values are [R, L]):**
| Parameter | Format | Unit | Notes |
|-----------|--------|------|-------|
| `Zs` | `[Rs, Lls]` | [Ω, H] | Stator resistance + leakage INDUCTANCE |
| `Zr` | `[Rr, Llr]` | [Ω, H] | Rotor resistance + leakage INDUCTANCE |
| `Lm` | scalar | H | Magnetizing inductance |
| `P` | scalar | — | Pole PAIRS (same as PMSM) |
| `sim_type` | `"Discrete"` | — | MUST set — defaults to Continuous |

**Derived quantities for control tuning:**
```matlab
Ls = acim.Lls + acim.Lm;    % Total stator inductance
Lr = acim.Llr + acim.Lm;    % Total rotor inductance
sigma = 1 - acim.Lm^2/(Ls*Lr);  % Leakage factor
L_sigma = sigma * Ls;       % Transient inductance (use for PI tuning!)
Tr = Lr / acim.Rr;          % Rotor time constant (for slip calc)
```

**Info Bus Fields (Output 1):**
Same structure as PMSM (12 fields): IaStator, IbStator, IcStator, IdSync, IqSync, VdSync, VqSync, MtrSpd, MtrPos, MtrElcPos, MtrTrq, PwrInfo

**Gotchas:**
- `Zs`/`Zr` are [R, L] vectors using INDUCTANCES (H), NOT reactances (Ω) — the "Z" naming is misleading
- `Lls`/`Llr` are **leakage** inductances: `Lls = Ls - Lm`, `Llr = Lr - Lm`
- **Inline leakage calc in Zs/Zr:** If workspace stores total inductances (Ls, Lr), use inline subtraction: `"Zs": "[acim.Rs, acim.Ls - acim.Lm]"`, `"Zr": "[acim.Rr, acim.Lr - acim.Lm]"` — both forms are valid
- `sim_type` defaults to `'Continuous'` — MUST set to `'Discrete'` (same as PMSM)
- Outputs y2/y3 are **single precision** — DTC required before arithmetic
- Use `DefaultUnderspecifiedDataType='single'` at model level to avoid type conflicts

---

## Dead-Time Compensator

**Type (model_edit):** `"Dead-Time Compensator"` (resolves by name via SATK)

**Purpose:** Compensates voltage distortion from inverter dead-time (blanking time). Without this, current THD increases and torque ripple appears at 6× electrical frequency.

**Port Map:**
| Port | Direction | Signal |
|------|-----------|--------|
| u1 | Input | Ia (phase A current) |
| u2 | Input | Ib (phase B current) |
| u3 | Input | Ic (phase C current) |
| y1 | Output | Vcomp_a (compensation voltage A) |
| y2 | Output | Vcomp_b (compensation voltage B) |
| y3 | Output | Vcomp_c (compensation voltage C) |

**Key Parameters:**
| Parameter | Type | Description |
|-----------|------|-------------|
| `DeadTime` | scalar (s) | Inverter dead-time (typical 0.5–4 µs) |
| `Vdc` | scalar (V) | DC bus voltage |
| `CompensationMethod` | enum | `'Voltage feedforward'`, `'Current polarity'` |
| `CurrentThreshold` | scalar (A) | Zero-crossing hysteresis band (avoid chattering near zero) |

**Usage:** Add compensation voltages to the modulation signal path (AFTER InvPark/PWM computation, BEFORE gate driver). Typically: `Vabc_ref + Vcomp → PWM comparator`.

**Gotchas:**
- Only effective if dead-time is significant relative to PWM period (Td/Tpwm > 1%)
- Compensation causes high-frequency spikes in voltage — add LPF if feeding to scope
- At very low currents (< CurrentThreshold), disable compensation to avoid chattering
- For FOC CC block users: FOC CC does NOT include dead-time compensation internally — add externally if needed

---

## Parameter Estimation Blocks

MCB provides several blocks for online/offline estimation of motor parameters. These are commissioning tools, not control-loop blocks.

### Resistance Estimation

**Type (model_edit):** `"Rs Estimation"` (resolves by name via SATK)

| Parameter | Description |
|-----------|-------------|
| `InjectionCurrent` | DC current injected for measurement (30–50% of rated) |
| `MeasurementDuration` | Time to average voltage measurement (0.5–2 s) |
| `PolePairs` | Pole pairs (for per-phase computation) |

**Output:** Estimated Rs (ohm). Inject DC current, measure voltage, compute R = V/I.

### Inductance Estimation (Ld, Lq)

**Type (model_edit):** `"Ld Lq Estimation"` (resolves by name via SATK)

| Parameter | Description |
|-----------|-------------|
| `InjectionFrequency` | AC frequency for impedance measurement (100–500 Hz) |
| `InjectionAmplitude` | AC voltage amplitude |
| `DAxisAngle` | Electrical angle for d-axis alignment |

**Output:** Estimated Ld, Lq (H). Uses AC injection at known angle, measures current response.

### Inertia Estimation (J, B)

**Type (model_edit):** `"Mechanical Parameter Estimation"` (resolves by name via SATK)

| Parameter | Description |
|-----------|-------------|
| `AccelerationTorque` | Known torque applied during test |
| `SpeedRange` | [min, max] speed for measurement window (RPM) |

**Output:** Estimated J (kg·m²), B (N·m·s). Applies known torque, measures acceleration.

**Common Pattern:** Run estimation blocks BEFORE tuning gains — they provide motor parameters that feed into `mcb.calcFOCGains`.

**Gotchas:**
- Estimation blocks require motor to be STATIONARY (Rs) or FREE-SPINNING (J, B)
- Do NOT run during normal closed-loop operation
- Results are workspace variables — store before overwriting pmsm struct fields

---

## DQ Limiter

**Type (model_edit):** `"DQ Limiter"` (resolves by name via SATK)

**Purpose:** Limits the dq voltage vector magnitude to stay within the inverter voltage hexagon. Used between PI outputs (Vd, Vq) and InvPark, or internally within FOC CC.

**Port Map:**
| Port | Direction | Signal |
|------|-----------|--------|
| u1 | Input | Vd (from d-axis PI) |
| u2 | Input | Vq (from q-axis PI) |
| u3 | Input | Vmax (maximum voltage magnitude) |
| y1 | Output | Vd_limited |
| y2 | Output | Vq_limited |
| y3 | Output | Saturated flag (0/1) |

**Key Parameters:**
| Parameter | Value Options | Description |
|-----------|--------------|-------------|
| `SaturationMethod` | `'D-Q Equivalence'` | Scales both axes proportionally (preserves angle) |
| | `'D-axis Priority'` | Clamps Vd first, gives remainder to Vq |
| | `'Q-axis Priority'` | Clamps Vq first, gives remainder to Vd |

**Method selection guide:**
| Method | When to Use |
|--------|-------------|
| D-Q Equivalence | General purpose (default for FOC CC) |
| D-axis Priority | Field weakening active (need guaranteed Vd for negative id) |
| Q-axis Priority | Torque-critical apps (maximize iq headroom) |

**Gotchas:**
- FOC CC uses DQ limiting INTERNALLY — do NOT add an external DQ Limiter when using FOC CC
- For manual Pattern A (separate PI controllers): add DQ Limiter between PI outputs and InvPark
- The `Saturated` output (y3) can drive PI anti-windup externally
- Vmax input should be `Vdc/sqrt(3)` for linear modulation, or `Vdc/sqrt(3) * 1.15` if overmodulation is allowed

---

## FOC Default Controller Gains

**Type (model_edit):** `"FOC Default Controller Gains"` (resolves by name via SATK)

**Purpose:** Computes default PI gains at model initialization using motor parameters stored in the mask. Convenience block for rapid prototyping — outputs gain vector compatible with FOC CC port u5.

**Port Map:**
| Port | Direction | Signal |
|------|-----------|--------|
| y1 | Output | [Kp_d; Ki_d*Ts; Kp_q; Ki_q*Ts] (4×1 for FOC CC u5) |
| y2 | Output | [Kp_speed; Ki_speed*Ts] (2×1 for Speed PI) |

**Key Parameters:**
| Parameter | Description |
|-----------|-------------|
| `Rs` | Stator resistance (Ohm) |
| `Ld` | d-axis inductance (H) |
| `Lq` | q-axis inductance (H) |
| `FluxPM` | PM flux linkage (Wb) |
| `PolePairs` | Pole pairs |
| `J` | Rotor inertia (kg·m²) |
| `Ts` | Current loop sample time (s) |
| `Ts_speed` | Speed loop sample time (s) |

**Gotchas:**
- Runs ONCE at model init — gains are constant (no online adaptation)
- Uses same algorithm as `mcb.calcFOCGains` — same Category A issues apply
- For production: compute gains with `mcb.calcFOCGains` in MATLAB, store in workspace, feed as Constant to FOC CC u5
- This block is a convenience wrapper — prefer explicit gain computation for traceability

---

## FOC Autotuner

**Type (model_edit):** `"FOC Autotuner"` (resolves by name via SATK)

**Purpose:** Online autotuning — perturbs the system during operation and adapts PI gains. Uses relay feedback or PRBS injection to estimate plant transfer function, then computes optimal gains.

**Key Parameters:**
| Parameter | Description |
|-----------|-------------|
| `AutotuneMode` | `'Current loop'`, `'Speed loop'`, `'Both'` |
| `PerturbationType` | `'Relay'`, `'PRBS'` |
| `TargetBandwidth` | Desired closed-loop BW (Hz) |
| `PhaseMargin` | Target phase margin (°, default 60) |

**Gotchas:**
- Autotuner injects perturbations — motor WILL vibrate/oscillate during tuning
- Requires motor to be spinning at steady state before triggering
- Result gains overwrite existing gains — save originals before running
- NOT suitable for sensorless at low speed (SMO noise corrupts identification)
- For simulation validation: use `mcb.calcFOCGains` instead (faster, no physical risk)

---

## Model-Level Settings

Use `evaluate_matlab_code` for model-level configuration (solver, diagnostics):
```matlab
% MCB discrete plants (no MTPA block)
set_param(mdl, 'Solver', 'FixedStepDiscrete', 'FixedStep', num2str(Ts));

% MCB plants WITH MTPA block (has internal continuous states)
set_param(mdl, 'Solver', 'ode3', 'FixedStep', num2str(Ts));

% Simscape plants (implicit solver required)
set_param(mdl, 'Solver', 'ode14x', 'FixedStep', num2str(Ts));

% Recommended diagnostics
set_param(mdl, ...
    'UnconnectedInputMsg', 'error', ...
    'UnconnectedOutputMsg', 'warning', ...
    'DefaultUnderspecifiedDataType', 'double');
```
**Note:** Model-level settings (solver, diagnostics) use `evaluate_matlab_code` because `model_edit configure` targets blocks, not the model object.

---

## Utility Blocks Quick Reference

| Block | Library | Inputs | Outputs | Key Setting |
|-------|---------|--------|---------|-------------|
| Discrete Derivative | `simulink/Discrete/Discrete Derivative` | 1 | 1 | MUST use full path — short name `"Discrete Derivative"` resolves to continuous `Derivative` |
| Unit Delay | `simulink/Discrete/Unit Delay` | 1 | 1 | `SampleTime='Ts'` |
| Rate Transition | `simulink/Signal Attributes/Rate Transition` | 1 | 1 | `OutPortSampleTime` |
| Bus Selector | `simulink/Signal Routing/Bus Selector` | 1 | N | `OutputSignals='field1,field2'` |
| Demux | `simulink/Signal Routing/Demux` | 1 | N | `Outputs='3'` |
| Mux | `simulink/Signal Routing/Mux` | N | 1 | `Inputs='3'` |
| DTC | `simulink/Signal Attributes/Data Type Conversion` | 1 | 1 | `OutDataTypeStr='double'` |
| Scope | `simulink/Sinks/Scope` | 1 (default) | 0 | `NumInputPorts='3'` for multi-signal |
| To Workspace | `simulink/Sinks/To Workspace` | 1 | 0 | `VariableName`, `SaveFormat='Timeseries'` |
| Terminator | `simulink/Sinks/Terminator` | 1 | 0 | (none) |
| Sum | `simulink/Math Operations/Sum` | N | 1 | `Inputs='\|+-'` for error; **default is `\|++`** — MUST set explicitly for subtraction |
| Product | `simulink/Math Operations/Product` | N | 1 | `Inputs='*/'` for division (first=numerator, second=denominator) |
| Gain | `simulink/Math Operations/Gain` | 1 | 1 | `Gain='expression'` — supports workspace vars and expressions |
| Discrete-Time Integrator | `simulink/Discrete/Discrete-Time Integrator` | 1 | 1 | `IntegratorMethod='Integration: Forward Euler'`, `SampleTime='Ts'` |
| Math Function | `simulink/Math Operations/Math Function` | 1-2 | 1 | `Operator='mod'` (2 inputs: signal, modulus), `'square'`, `'sqrt'` |
| Constant | `simulink/Sources/Constant` | 0 | 1 | `Value='varname'` — verify value after complex model_edit sequences |
| Saturation | `simulink/Discontinuities/Saturation` | 1 | 1 | `UpperLimit='iq_sat'`, `LowerLimit='-iq_sat'` |

### Scope Block
**Type:** `"Scope"` (resolves by name)

| Parameter | Description | Default |
|-----------|-------------|---------|
| `NumInputPorts` | Number of input ports | `1` — MUST set explicitly for multi-signal |

**Gotcha:** Scope defaults to 1 input port. Connecting to `.u2` without setting `NumInputPorts` first causes "Port u2 does not exist" error. Either:
- Set `NumInputPorts` in params when adding: `{"type": "Scope", "params": {"NumInputPorts": "3"}}`
- Or use a Mux before the Scope to combine signals into one vector

### To Workspace Block
**Type:** `"To Workspace"` (resolves by name)

| Parameter | Value | Notes |
|-----------|-------|-------|
| `VariableName` | `"speed_log"` | Name in simOut struct |
| `SaveFormat` | `"Timeseries"` | Always use Timeseries (NOT Array) |
| `MaxDataPoints` | `"inf"` | **MUST set** — default (1000) truncates data |
| `Decimation` | `"10"` | Reduce data volume |
| `SampleTime` | `"Ts_speed"` | Match signal rate |

**Gotcha:** Default `MaxDataPoints=1000` captures only last 50ms at Ts=50µs. Always set to `"inf"`.

### DataLogging Limitation

**MCB masked blocks (IIR Filter, PI Controller, SMO, PMSM, FOC CC) do NOT support the `DataLogging` parameter.** Attempting `set_param(blk, 'DataLogging', 'on')` on these blocks produces an error. Always use ToWorkspace blocks for logging instead.

### Step Block Parameters

**Type:** `"Step"` (resolves by name)

| Parameter | Alias | Description |
|-----------|-------|-------------|
| `Time` | — | Step time (s) |
| `Before` | `InitialValue` | Value before step |
| `After` | `FinalValue` | Value after step |
| `SampleTime` | — | Sample time (set to `'Ts'` for discrete models) |

**Note:** `Before`/`After` and `InitialValue`/`FinalValue` are interchangeable aliases — both work. `get_param` returns the value regardless of which name you use.

**Gotcha:** Step params may silently revert to defaults (Time=1, After=1) if set before other block configurations in the same script. Always set Step params AFTER all other `set_param` calls, or verify with `get_param` after setting.

**Gotcha:** Step blocks default to `SampleTime='0'` (continuous). In discrete models (`FixedStepDiscrete` solver), this causes "contains continuous states" error. Always set `SampleTime='Ts'` explicitly.

### Ramp Block Parameters

**Type:** `"Ramp"` (resolves via `simulink/Sources/Ramp`)

| Parameter | Description |
|-----------|-------------|
| `slope` | Ramp rate (units/s) |
| `start` | Start time (default 0) |
| `InitialOutput` | Initial value before ramp starts |

**Gotcha:** Ramp block has **continuous states** — incompatible with `FixedStepDiscrete` solver. For discrete models, replace with: `Constant(slope) → Discrete-Time Integrator(ForwardEuler, SampleTime=Ts) → Saturation(max_value)`.

### Rate Limiter Block

**Type:** `"Rate Limiter"` (resolves via `simulink/Discontinuities/Rate Limiter`)

**Gotcha:** Rate Limiter has **continuous states** — incompatible with `FixedStepDiscrete` solver. For discrete models, either:
- Replace with `Gain(1)` passthrough (if rate limiting is non-critical)
- Use `Rate Limiter Dynamic` block with explicit sample time
- Use a custom discrete implementation (clamp delta per step)

---

## Parameter Setting Order (Critical for Correctness)

Several Simulink blocks silently revert parameter values under specific conditions. Follow this mandatory ordering:

**1. MCB PI Controller — Mode + Gains in One Call:**
All params can be set in a single `set_param` or `model_edit configure` call:
```
ControllerParametersSource = 'internal'
ExternalReset = 'none'
InitialConditionSource = 'internal'
P = '5.5', I = '0.02', SampleTime = 'Ts'
UpperSaturationLimit = 'Vmax', LowerSaturationLimit = '-Vmax'
```
P/I values survive the mode switch. However, `SampleTime` defaults to `-1` and saturation limits default to `1`/`-1` — always set these explicitly even if setting gains in the same call.

**2. Constant and Step Blocks — Verify After Complex Operations:**
- In some scenarios (large models, workspace variable resolution failures, or multi-step model_edit sequences), Constant `Value` and Step `InitialValue`/`FinalValue`/`Time` have been observed to revert to defaults (`'1'` for Constant, Time=1/FinalValue=1 for Step).
- **Best practice:** Always verify critical Constant/Step values with `model_query_params` or `get_param` after model construction is complete. If values are wrong, re-apply them.

**3. Bus Selector OutputSignals — Re-apply After Layout:**
- `OutputSignals` may show `'signal1,signal2'` (defaults) after model compilation or layout ops.
- **Fix:** Re-apply `set_param(blk, 'OutputSignals', 'MtrPos,MtrTrq')` after model_edit layout.

**4. ToWorkspace VariableName — Verify After Configuration:**
- `VariableName` may revert to `'simout'` if set before block is fully compiled.
- **Fix:** Set after all other block configurations, or verify with `get_param`.

**Recommended Build Order:**
1. Create model + workspace variables
2. Add blocks (MCB via dynamic resolution, Simulink by name)
3. Configure PI mode params (Step 1 above)
4. Configure PI gains/limits (Step 2 above)
5. Configure all other block params
6. Wire connections (model_edit connect ops)
7. Set Constant/Step values LAST
8. Verify critical params with `get_param`

---

## Voltage Limits and High-Speed Motors

**Maximum achievable speed (no field weakening):**
```matlab
Vmax = inverter.V_dc / sqrt(3);          % Max line-to-neutral voltage
max_speed_mech = Vmax / (pmsm.FluxPM * pmsm.p);  % rad/s mechanical
```

When back-EMF (`FluxPM × p × wm`) exceeds Vmax, the inverter saturates and current control is lost. This is a **physical limit**, not a control bug.

**High-KV motors (drones, spindles):** Motors with large `FluxPM × p` product hit this limit at relatively low speeds. Solutions:
- Increase Vdc (higher battery voltage)
- Field weakening (negative id, reduces effective flux) — requires IPMSM
- Accept the speed limit as the motor's base speed

**Propeller/Fan Quadratic Load:**
```matlab
T_load = k_prop * wm^2   % Quadratic torque-speed characteristic
```
Use `Math Function` block (Operator=`'square'`) on speed signal, then `Gain(k_prop)` to compute load torque.

---

## Plant Model Tiers

| Tier | Block | Fidelity | Solver |
|------|-------|----------|--------|
| MCB | Interior/Surface PMSM | Medium (discrete, lumped) | FixedStepDiscrete |
| PTBS | autolibemachines PMSM | Medium-High (flux maps) | FixedStepDiscrete |
| Simscape | FEM-Parameterized PMSM | High (physical domain) | ode14x (implicit) |

MCB and Simscape FEM 2D use the **same data format** (Ld/Lq/FluxPM tables) -- no conversion needed.

----
Copyright 2026 The MathWorks, Inc.
----

# Block Configuration Reference — Plants, Sensors & Utilities

> MCB plant blocks, sensorless observers, sensor decoders, and utility blocks.
> For control blocks (PI, Clarke, Park, MTPA, FOC CC, PWM) see `block-configurations.md`.
> For tool selection rules see `tool-routing.md`.

---

## Interior PMSM

**Type (model_edit):** `"Interior PMSM"` (resolves by name via SATK)
**Fallback (if SATK fails):** Use `model_read` to browse mcblib for the correct display name, then retry model_edit with the resolved name.

**Port Map:**
| Port | Notation | Signal |
|------|----------|--------|
| u1 | Input | Load torque TL (Nm) |
| u2 | Input | Phase voltages [Va; Vb; Vc] (V) |
| y1 | Output | Info bus (12 fields, see below) |
| y2 | Output | Phase currents [Ia; Ib; Ic] (A) — **single precision** |
| y3 | Output | Mechanical speed wm (rad/s) — **single precision** |

**Mandatory Parameters:**

| Parameter | Value | Notes |
|-----------|-------|-------|
| port_config | `"Torque"` | `"Torque"` (u1=TL) or `"Speed"` (u1=wref) |
| P | `"pmsm.p"` | Pole pairs (uppercase P) |
| Rs | `"pmsm.Rs"` | Stator resistance |
| Ldq | `"[pmsm.Ld pmsm.Lq]"` | Vector [Ld, Lq] |
| lambda_pm | `"pmsm.FluxPM"` | PM flux linkage — NOT `FluxPM` as param name! |
| mechanical | `"[pmsm.J pmsm.B 0]"` | [J, B, TL_init] |
| sim_type | `"Discrete"` | MUST match solver |
| Ts | `"Ts"` | Sample time |

**Info Bus Fields (Output 1) — Use Bus Selector ONLY:**
| Index | Field | Unit | Notes |
|-------|-------|------|-------|
| 1-3 | IaStator, IbStator, IcStator | A | Phase currents |
| 4-5 | IdSync, IqSync | A | dq currents |
| 6-7 | VdSync, VqSync | V | dq voltages (NOT speed!) |
| 8 | MtrSpd | rad/s | Mechanical speed |
| 9 | MtrPos | rad | Mechanical position |
| 10 | MtrElcPos | rad | Electrical angle (theta_e) |
| 11 | MtrTrq | Nm | Electromagnetic torque |
| 12 | PwrInfo | W | Power |

**Extracting theta_e and wm (two options):**

Option 1 (RECOMMENDED — matches hardware): Use MtrPos + MechToElec block
```json
{"op": "configure", "target": "BusSel", "params": {"OutputSignals": "MtrPos"}}
```
Output 1 = mechanical pos → MechToElec(selectedRange='Radians') → theta_e
This emulates the real encoder → electrical angle conversion and is the proven standard pattern.
**NOTE:** Do NOT chain MtrElcPos → MechToElec (double pole-pair multiplication!)

Option 2 (simulation shortcut): Use MtrElcPos directly
```json
{"op": "configure", "target": "BusSel", "params": {"OutputSignals": "MtrSpd,MtrElcPos"}}
```
Output 2 = theta_e (rad) → feed to Park/InvPark port 3 directly (no MechToElec needed)

**Multi-Rate Plant Pattern (RECOMMENDED for accuracy):**

Run the PMSM at `Ts/2` (half the control sample time) for better numerical accuracy. Add Rate Transitions between plant and controller:
```matlab
% In evaluate_matlab_code — set plant sample time to Ts/2:
set_param([mdl '/PMSM'], 'Ts', 'Ts/2');
% Model solver FixedStep must be Ts/2 (GCD of all sample times):
set_param(mdl, 'FixedStep', 'Ts/2');
```
```json
[
  {"op": "add_block", "type": "Rate Transition", "name": "RT_V2Plant", "params": {"OutPortSampleTime": "Ts/2"}},
  {"op": "add_block", "type": "Rate Transition", "name": "RT_I2Ctrl", "params": {"OutPortSampleTime": "Ts"}},
  {"op": "connect", "target": "Delay_V.y1 -> RT_V2Plant.u1"},
  {"op": "connect", "target": "RT_V2Plant.y1 -> PMSM.u2"},
  {"op": "connect", "target": "PMSM.y2 -> RT_I2Ctrl.u1"},
  {"op": "connect", "target": "RT_I2Ctrl.y1 -> DTC_I.u1"}
]
```
For simple simulations, using a single Ts everywhere is acceptable.

**Gotchas:**
- **`sim_type` defaults to `'Continuous'`** — you MUST set `'Discrete'` explicitly or simulation will fail with FixedStepDiscrete solver (error: "contains continuous states")
- **`P` is pole PAIRS (not number of poles)** — set `P = 'pmsm.p'` where pmsm.p=4 for an 8-pole motor. Using `pmsm.p*2` doubles the electrical frequency → wrong angle → zero or oscillating torque
- Input port order: **1=TL, 2=Voltage** (NOT voltage first!)
- All outputs are **single precision** — add DTC (double) before PI/Sum blocks
- Use Bus Selector, NEVER Selector (causes "Power Accounting Bus Creator" error)
- `lambda_pm` must be > 0; for SynRM use `1e-6`
- Does NOT support LUT-based Ld/Lq in R2025+ (lumped params only)
- `port_config='Extended'` does NOT exist — only `'Torque'` or `'Speed'`
- `'MeasurementsBusFlag'` does NOT exist as a parameter — do not attempt to set it
- `'InitialConditions'` is NOT a valid param name — initial conditions are set via `mechanical` ([J, B, TL_init])

---

## Surface Mount PMSM

**Type (model_edit):** `"Surface Mount PMSM"` (resolves by name via SATK)

Same port structure as Interior PMSM. Key difference in inductance parameter:

| Motor Type | Parameter | Value | Notes |
|-----------|-----------|-------|-------|
| Interior | Ldq | `"[pmsm.Ld pmsm.Lq]"` | Vector [Ld, Lq] |
| Surface Mount | Ldq_ | `"pmsm.Ld"` | Scalar — trailing underscore! Ld = Lq |

**Gotchas:**
- MTPA Control Reference divides by (Lq-Ld); for SPMSM set `Lq = Ld + 1e-9` or use `VariantSelect="Surface PMSM"` (outputs id=0)
- Parameter name `Ldq_` has **trailing underscore** (different from Interior's `Ldq`)

---

## BLDC Motor

**Type (model_edit):** `"BLDC"` (resolves by name via SATK)

**Port Map:** Same as Interior PMSM (2 in, 3 out)

**Mandatory Settings (`model_edit`):**
```json
{"op": "configure", "target": "BLDC", "params": {
    "SimType": "Discrete",
    "sim_type": "Discrete",
    "BlockSampleTime": "Ts",
    "p": "pmsm.p",
    "Rs": "pmsm.Rs",
    "Ld": "pmsm.Ld",
    "Lq": "pmsm.Lq",
    "Lambda": "pmsm.FluxPM",
    "J": "pmsm.J",
    "B": "pmsm.B"}}
```
**Note:** MUST set BOTH `SimType` AND `sim_type` to `"Discrete"` — block has dual param names.

**Info Bus Fields (Output 1) — 8 fields (NOT 12 like PMSM):**
| Field | Description |
|-------|-------------|
| IaStator, IbStator, IcStator | Phase currents |
| MtrSpd | Mechanical speed |
| MtrPos | Mechanical position |
| MtrTrq | Electromagnetic torque |
| MtrHall | Hall sensor state |
| BackEMF[3] | Back-EMF per phase |

**Bus Selector usage for BackEMF:**
```json
{"op": "configure", "target": "BusSel_BEMF", "params": {"OutputSignals": "BackEMF"}}
```
Output is a **[3×1] vector** `[ea; eb; ec]`. Do NOT use `BackEMF_a` / `BackEMF_b` / `BackEMF_c` — those individual names do not exist. The single field `BackEMF` contains all three phases as a vector.

**Gotchas:**
- Has BOTH `SimType` AND `sim_type` — must set BOTH to 'Discrete'
- Info bus has 8 fields (different from PMSM's 12) — use Bus Selector with correct field names
- `BackEMF` is a [3×1] vector field — NOT three separate scalar fields
- If Bus Selector fails, use Selector with `InputPortWidth` matching actual bus width
- Six Step Commutation output is **boolean** — MUST add DTC before arithmetic

---

## BLDC Average-Value Inverter

**Type (model_edit):** `"BLDC Average-Value Inverter"`

**Port Map:**
| Port | Notation | Signal |
|------|----------|--------|
| u1 | Input | Switching vector D_sw [6×1] (double, range [0,1]) |
| u2 | Input | Vdc (V) — effective DC bus voltage |
| y1 | Output | Phase voltages V_abc [3×1] (V) |

**Parameters:** NONE (zero configurable mask parameters)

**Behavior:** Converts 6-element switching vector (S1+,S1-,S2+,S2-,S3+,S3-) + Vdc into 3-phase voltages.

**CRITICAL — Incompatibility with Sensorless Six-Step Commutation block:**
The BLDC Average-Value Inverter does NOT model individual switch states or floating phases. All three phases are driven simultaneously. This means:
- There is NO floating phase during commutation (unlike real hardware)
- Terminal voltages do NOT show back-EMF zero-crossings
- The MCB `Sensorless Six-Step Commutation` block CANNOT detect BEMF ZC from this inverter's output
- For sensorless BLDC with average-value model, use custom BEMF ZC detection from BLDC Info bus `BackEMF` field instead

**Gotchas:**
- Input `D_sw` is [6×1] double — NOT boolean (add DTC after Six Step Commutation)
- Duty modulation: use `Product(duty, Vdc)` → port 2, with switching vector → port 1
- Does NOT model deadtime, diode conduction, or floating phase behavior
- For sensorless BEMF detection: read `BackEMF` from BLDC motor Info bus directly

---

## Sensorless Six-Step Commutation

**Type (model_edit):** `"Sensorless Six-Step Commutation"`

**Port Map:**
| Port | Notation | Signal |
|------|----------|--------|
| u1 | Input | StartDir (int16, +1 or -1) — **MUST be int16** |
| u2 | Input | Vabc_Meas [3×1] — measured motor terminal voltages |
| u3 | Input | Vdc_Meas (V) — DC bus voltage |
| u4 | Input | Duty_Ref [0,1] — duty cycle from speed controller |
| u5 | Input | Enable (1=run, 0=stop) |
| y1 | Output | Duty [6×1] — switching pattern with duty modulation |
| y2 | Output | omega_m — estimated mechanical speed (rad/s) |
| y3 | Output | Info — debug bus |
| y4 | Output | ComStatus — commutation state |

**Key Parameters:**
| Parameter | Value | Notes |
|-----------|-------|-------|
| BlockMode | `'Alignment -> Open-loop run -> Controlled commutation'` | Full startup sequence |
| PolePairs | `"motor.p"` | |
| Ts | `"Ts"` | Sample time |
| AlignmentDuty | `"0.2"` | Duty during rotor alignment |
| AlignmentTime | `"0.3"` | Duration of alignment (s) |
| OpenLoopDuty | `"0.25"` | Duty during open-loop ramp |
| TargetOpenLoopSpeed | `"40"` | Target OL speed (rad/s or RPM per SpeedUnit) |
| RampTime | `"0.5"` | OL ramp duration (s) |
| ThresholdOpenLoopSpeed | `"30"` | Speed for handoff to BEMF ZC |
| Tfilter | `"450e-6"` | BEMF signal filter time |
| Tdemagnetization | `"175e-6"` | Blanking time after commutation |
| SpeedUnit | `"Radians/sec"` | |

**CRITICAL — Requires SWITCHING inverter model:**
This block detects BEMF zero-crossings from measured terminal voltages (Vabc_Meas). It ONLY works when:
1. The inverter actually floats one phase during each commutation interval
2. The measured terminal voltage reflects back-EMF on the floating phase

**Does NOT work with:**
- `BLDC Average-Value Inverter` (no floating phase — all phases always driven)
- Any averaged/continuous voltage model

**Works with:**
- Simscape Three-Phase Inverter (actual MOSFET switching)
- Custom switching inverter model with individual phase gates

**Workaround for average-value simulations:**
Use custom BEMF ZC detection via BLDC Info bus → `BackEMF` field → polarity-based sector detector. See `examples/example_bldc_sensorless_bemf.m`.

**Gotchas:**
- `StartDir` input MUST be `int16` — double causes data type mismatch error
- Internal ZC detector uses uint16 counters — counter overflow warning at very low speed is expected during startup
- `Duty_Ref` (u4) is only used during controlled commutation phase (not during alignment or OL ramp)
- Speed output (y2) may read zero if ZC detection fails to lock on

---

## Average-Value Inverter

**Type (model_edit):** `"Average-Value Inverter"` (resolves by name via SATK)
**Fallback (if SATK fails):** Use `model_read` to browse mcblib for the correct display name, then retry model_edit. Note: multiple matches may exist (Synchronous Machine vs Induction Machine paths) — both are identical blocks.

**Port Map:**
| Port | Notation | Signal |
|------|----------|--------|
| u1 | Input | Modulation signal [3×1] — accepts BOTH modes (see below) |
| u2 | Input | Vdc (V) |
| y1 | Output | Phase-neutral voltages [Va;Vb;Vc] (V) |

**Parameters:** NONE (zero configurable mask parameters)

**Two Input Modes (both work — AVI handles internally):**

| Input Source | u1 Range | Conversion Needed | Output |
|-------------|----------|-------------------|--------|
| PWM Ref Gen (enableDutyCycle='off') | [-1.15, +1.15] modulation | NONE — feed directly | `Vabc ≈ modulation × Vdc/2` |
| FOC CC / manual PI (SI volts) | After V2D: [0, 1] duty | V2D: `Gain(1/(2*Vmax)) + Bias(0.5)` | `Vabc = (duty - mean(duty)) × Vdc` |

**Gotchas:**
- Internal port label is `Vabc_mod` (modulation, NOT duty)
- When using PWM_RefGen path: feed output directly to AVI — NO V2D conversion needed
- When using FOC CC or manual PI (SI volts): MUST convert via `duty = Vabc/(2*Vmax) + 0.5` where Vmax=Vdc/√3
- Using `1/Vdc` instead of `1/(2*Vmax)` causes duty to exceed [0,1] → clipping (see Rule 17)
- The internal Switch handles both input ranges — no configuration change needed

---

## Sliding Mode Observer (SMO)

**Type (model_edit):** `"Sliding Mode Observer"` (resolves by name via SATK)

**Port Map:**
| Port | Notation | Signal |
|------|----------|--------|
| u1 | Input | Valpha (V) — from Clarke_V or InvPark output |
| u2 | Input | Vbeta (V) — from Clarke_V or InvPark output |
| u3 | Input | Ialpha (A) — from Clarke_I output |
| u4 | Input | Ibeta (A) — from Clarke_I output |
| u5 | Input | Reset (0=run, 1=reset) |
| y1 | Output | theta_e (estimated electrical angle) |
| y2 | Output | wm (estimated speed) — **BROKEN in simulation** (see below) |

**Mandatory Parameters:**

| Parameter | Value | Notes |
|-----------|-------|-------|
| `InputUnit` | `'SI unit'` | **MUST set explicitly** — controls voltage/current scaling. Default may vary. |
| `BlkSampleTime` | `'Ts'` | **MUST set** — SMO needs explicit sample time for internal discrete filters |
| `StatorResistance` | `'motor.Rs'` | |
| `StatorInductance` | `'Ls_avg'` | Average: `(pmsm.Ld + pmsm.Lq)/2` |
| `DisturbanceObserverGain` | `'0.95'` | Fractional (0-1), NOT large numbers |
| `CurrentObserverGain` | `'0.9'` | Fractional (0-1), NOT large numbers |
| `CutoffFreq` | `'CutoffFreq'` | PLL cutoff (Hz) — see formula below |
| `PolePairs` | `'motor.p'` | |
| `MaxApplicationSpeed` | `'MaxSpeed_RPM'` | Always in RPM |
| `PerUnitSpeed` | `'MaxSpeed_RPM'` | **R2025a+: MUST equal MaxApplicationSpeed** (same value) |
| `MaxStatorVoltage` | `'Vmax'` | = V_dc/sqrt(3) |
| `MaxStatorCurrent` | `'motor.I_rated'` | |
| `PositionUnit` | `'Radians'` | |
| `PositionDataType` | `'single'` | Output type |
| `SpeedUnit` | `'RPM'` | |
| `SpeedDataType` | `'single'` | Output type |

**CutoffFreq Formula:**
```matlab
CutoffFreq_min = MaxSpeed_RPM * pmsm.p / 60 * 2;  % 2× max electrical freq
CutoffFreq = max(500, CutoffFreq_min * 1.5);       % ≥500 Hz floor
```
**Error if too low:** `"CutoffFreq must be greater than X"` — increase until error clears.

**Observer Gain Selection:**
- `DisturbanceObserverGain = 0.95` and `CurrentObserverGain = 0.9` are proven values
- These are **fractional** (0 < gain < 1) — NOT large numbers (500+, 2400, etc.)
- Large gains cause NaN divergence; fractional gains provide stable convergence
- `mcb.computeSMOParameters` can also compute these but the fixed 0.95/0.9 works across motor types

**Complete set_param Example (SI mode):**
```matlab
set_param([mdl '/SMO'], ...
    'InputUnit', 'SI unit', ...
    'BlkSampleTime', 'Ts', ...
    'StatorResistance', 'motor.Rs', ...
    'StatorInductance', 'Ls_avg', ...
    'MaxApplicationSpeed', 'MaxSpeed_RPM', ...
    'PolePairs', 'motor.p', ...
    'MaxStatorVoltage', 'Vmax', ...
    'MaxStatorCurrent', 'motor.I_rated', ...
    'DisturbanceObserverGain', '0.95', ...
    'CurrentObserverGain', '0.9', ...
    'CutoffFreq', 'CutoffFreq', ...
    'PositionUnit', 'Radians', ...
    'PositionDataType', 'single', ...
    'SpeedUnit', 'RPM', ...
    'SpeedDataType', 'single');
```

**Gotchas:**
- **`InputUnit` and `BlkSampleTime` are REQUIRED** — omitting either causes NaN or incorrect behavior. These params are not in the default mask display but exist.
- **Defaults are DEGREES** — `PositionUnit` defaults to `"Degrees"`. MUST set to `'Radians'` for Park/InvPark compatibility.
- **Port y2 (speed) is BROKEN in simulation** — The internal `SpeedGain` (~4.75e-10) is for hardware timer-based measurement, not useful in simulation. **Always derive speed from position** using the delta-theta/Ts pattern (see Speed-from-Position below).
- Voltage inputs = **command** voltages (from FOC CC or InvPark), NOT measured terminal voltages
- Outputs are **single** precision — add DTC (single→double) before arithmetic
- Fails below ~5-10% rated speed — **use I/f startup** for low-speed region (see wiring-topologies-advanced.md § +SMO)
- **With FOC CC block:** Voltage path is `FOC_CC.y1 (Vabc) → Unit Delay → Demux → Clarke_V → Valpha/Vbeta → SMO.u1/u2`
- **NaN at low speed:** Internal atan uses single-precision. Below ~5% rated speed, back-EMF is insufficient → NaN. Solution: I/f startup with time-based handoff (NOT speed-based Switch — NaN propagates through unselected Switch paths).
- **Reset port (u5):** Set to constant 0 (always active). SMO tracks during I/f phase and converges before handoff.
- **`MaxStatorVoltage` / `MaxStatorCurrent`:** Set explicitly for SI mode. In per-unit mode these are computed from PU_System.

### Speed-from-Position (SMO y1 → mechanical speed)

Since SMO port y2 is unreliable, derive speed from position delta:

```
theta(k) - theta(k-1) → wrap to [-π,π] → ÷ (Ts_speed × p) → LPF → ω_mech (rad/s)
```

**Blocks:**
| Block | Type | Setting |
|-------|------|---------|
| SpdFromPos_Delay | Unit Delay | `SampleTime='Ts_speed'` |
| SpdFromPos_Sub | Sum | `Inputs='+-'` (theta - theta_prev) |
| SpdFromPos_Div2Pi | Gain | `1/(2*pi)` |
| SpdFromPos_Round | Rounding Function | `Operator='round'` |
| SpdFromPos_Mul2Pi | Gain | `2*pi` |
| SpdFromPos_Wrap | Sum | `Inputs='+-'` (delta - round_term) |
| SpdFromPos_Gain | Gain | `1/(Ts_speed * pmsm.p)` → rad/s mechanical |
| SpdFromPos_LPF | Discrete Filter | `Num='0.02', Den='[1,-0.98]', SampleTime='Ts_speed'` |

**Wiring:**
```
DTC_pos → SpdFromPos_Sub.u1 (+)
DTC_pos → SpdFromPos_Delay → SpdFromPos_Sub.u2 (-)
SpdFromPos_Sub → SpdFromPos_Div2Pi → SpdFromPos_Round → SpdFromPos_Mul2Pi
SpdFromPos_Sub → SpdFromPos_Wrap.u1 (+)
SpdFromPos_Mul2Pi → SpdFromPos_Wrap.u2 (-)
SpdFromPos_Wrap → SpdFromPos_Gain → SpdFromPos_LPF → speed (rad/s)
```

**LPF coefficient:** alpha=0.02 → fc≈6.4 Hz at Ts_speed=500µs. Attenuates saliency-induced 2nd-harmonic ripple on SMO position.

---

## Flux Observer

**Type (model_edit):** `"Flux Observer"` (resolves by name via SATK)

**Port Map:**
| Port | Notation | Signal |
|------|----------|--------|
| u1 | Input | Valpha (V) |
| u2 | Input | Vbeta (V) |
| u3 | Input | Ialpha (A) |
| u4 | Input | Ibeta (A) |
| u5 | Input | Reset (0=run, 1=reset) |
| y1 | Output | theta_e (estimated electrical angle, rad) |
| y2 | Output | psi (estimated flux magnitude, Wb) |
| y3 | Output | T_e (estimated electromagnetic torque, Nm) |

**Key params:** `StatorResistance`, `StatorDAxisInductance`, `CutoffFreq`, `PolePairs`, `MotorSelection` ('PMSM' or 'Induction')

**Gotchas:**
- Same voltage/current input convention as SMO (command voltages, not measured)
- Works for BOTH PMSM and Induction motors (set `MotorSelection`)
- Fails below ~10% rated speed (same limitation as SMO)

---

## Extended EMF Observer

**Type (model_edit):** `"Extended EMF Observer"` (resolves by name via SATK)

**Port Map:**
| Port | Notation | Signal |
|------|----------|--------|
| u1 | Input | Valpha (V) |
| u2 | Input | Vbeta (V) |
| u3 | Input | Ialpha (A) |
| u4 | Input | Ibeta (A) |
| u5 | Input | Reset (0=run, 1=reset) |
| y1 | Output | theta_e (estimated electrical angle) |
| y2 | Output | wm (estimated mechanical speed) |

**Key params:** `StatorResistance`, `StatorDaxisInductance`, `StatorQaxisInductance`, `EEMFMultiplier`, `Alpha`, `EEMFCutoffFreq`, `Kp`, `Ki`, `SpeedCutoffFreq`, `PolePairs`

**Gotchas:**
- Exploits saliency (Ld ≠ Lq) for better low-speed performance than SMO
- `EEMFMultiplier` > 1 increases robustness but adds phase lag
- Same input convention as SMO (command voltages from InvPark)

---

> For utility/support blocks (I-F Controller, MechToElec, IIR Filter, IM, Six Step, Model Settings) see `block-configurations-utility.md`.

----
Copyright 2026 The MathWorks, Inc.
----

# Sensorless Block Configuration Reference

> Observer blocks, I/F startup, and handoff logic for sensorless motor control.
> For control blocks (PI, FOC CC, Park) see `references/block-config/block-configurations.md`.
> For plant blocks see `references/plants/block-configurations-plants.md`.

---

## Sliding Mode Observer (SMO)

**Type (model_edit):** `"Sliding Mode Observer"` (resolves by name via SATK)
**Fallback:** `find_system('mcblib','SearchDepth',5,'Name','Sliding Mode Observer')` → use returned path

### Port Map (5 inputs, 2 outputs)

| Port | Notation | Signal | Unit | Notes |
|------|----------|--------|------|-------|
| u1 | Input | V_alpha | V | Stator voltage alpha — **from Clarke Transform on voltage** |
| u2 | Input | V_beta | V | Stator voltage beta — **from Clarke Transform on voltage** |
| u3 | Input | I_alpha | A | Stator current alpha — from Clarke on currents |
| u4 | Input | I_beta | A | Stator current beta — from Clarke on currents |
| u5 | Input | Reset | — | 0=run, 1=reset. **MUST connect Constant(0)** — unconnected causes error |
| y1 | Output | theta_e | rad/deg/PU | Estimated electrical angle — **single precision** |
| y2 | Output | omega_m | rad/s/RPM/PU | Estimated mechanical speed — **single precision** |

### Mask Parameters

| Parameter | Type | Valid Values | Notes |
|-----------|------|-------------|-------|
| `StatorResistance` | scalar | Ohm | Use `pmsm.Rs + inverter.R_board` for better accuracy |
| `StatorInductance` | scalar | H | Use `(pmsm.Ld + pmsm.Lq)/2` |
| `DisturbanceObserverGain` | scalar | 0.5–5.0 | From `smo.BackEmfObsGain`. Higher = faster tracking, more noise |
| `CurrentObserverGain` | scalar | 5–50 | From `smo.CurrentObsGain` |
| `CutoffFreq` | scalar | Hz | PLL cutoff. From `smo.CutoffFreq`. Must exceed 2× max electrical freq |
| `PolePairs` | integer | — | Pole PAIRS (not poles) |
| `MaxApplicationSpeed` | scalar | RPM | Motor maximum speed (typically `PU_System.N_base * 2`) |
| `PerUnitSpeed` | scalar | RPM | **MUST equal MaxApplicationSpeed** — mismatch causes speed bias |
| `PositionUnit` | enum | `'Degrees'`, `'Radians'`, `'Per-unit'` | **DEFAULT IS 'Degrees'** — MUST set to `'Radians'` for Park/InvPark |
| `SpeedUnit` | enum | `'Degrees/sec'`, `'Radians/sec'`, `'RPM'`, `'Per-unit'` | **DEFAULT IS 'Degrees/sec'** — set `'Radians/sec'` for rad/s feedback |
| `InputUnit` | enum | `'SI unit'`, `'Per-unit'` | Inputs are ALWAYS in SI (V, A) regardless of this setting |

### Critical Pitfalls

**1. PositionUnit/SpeedUnit defaults are DEGREES:**
```json
{"op": "configure", "target": "SMO", "params": {
    "PositionUnit": "Radians",
    "SpeedUnit": "Radians/sec"
}}
```
Omitting these causes 57× angle error → zero torque.

**2. PerUnitSpeed bias:**
If `PerUnitSpeed ≠ MaxApplicationSpeed`, speed output is biased:
```
actual_speed = internal_speed × (MaxApplicationSpeed / PerUnitSpeed)
```
Default PerUnitSpeed = 6000 RPM. For a 4000 RPM motor, speed reads 67% of actual.
**Fix:** Always set both to the same value.

**3. Single-precision outputs:**
SMO outputs are `single`. Add DTC (Data Type Conversion → double) before any downstream arithmetic blocks.

**4. Reset port:**
MUST connect `Constant(0)` to u5. Leaving unconnected causes compilation error. Do NOT use Reset=1 for "monitoring only" — observer state must accumulate.

**5. Minimum speed for reliable estimation:**
- ≥20 samples per electrical cycle: robust (recommended)
- 10–20 samples: acceptable
- 5–10 samples: marginal (angle error > 15°)
- <5 samples: unreliable (NaN likely)

Check: `1/(f_e_max × Ts) > 20` where `f_e_max = N_max × p / 60`

### SMO Parameter Computation

```matlab
% PREREQUISITES: pmsm struct must have N_base field
pmsm.N_base = pmsm.N_rated;  % Add if missing

% inverter struct must have ISenseMax field
inverter.ISenseMax = pmsm.I_rated * 2;  % Current sensor range

% Compute
PU_System = mcb.getPUSystemParameters(pmsm, inverter);
smo_params = mcb.computeSMOParameters(pmsm, Ts, PU_System);

% smo_params fields: BackEmfObsGain, CurrentObsGain, CutoffFreq
```

---

## I-F Controller

**Type (model_edit):** `"I-F Controller"` (resolves by name via SATK)

### Port Map (3–6 inputs, 4 outputs)

| Port | Notation | Signal | Unit | Visible If |
|------|----------|--------|------|-----------|
| u1 | Input | w_m_ref | rad/s | Always |
| u2 | Input | w_m | rad/s | Always (measured/estimated speed) |
| u3 | Input | Iq | A | Always (measured q-axis current) |
| u4 | Input | Id | A | `CurrentLimitObjective='Reduce power...'` |
| u5 | Input | Vq | V | `CurrentLimitObjective='Reduce power...'` |
| u6 | Input | Power | W | `CurrentLimitObjective='Reduce power...'` |
| y1 | Output | Id_ref | A | Always — d-axis current reference |
| y2 | Output | Iq_ref | A | Always — q-axis current reference |
| y3 | Output | theta_e | rad | Always — I/F angle reference |
| y4 | Output | EnableSpeedLoop | 0/1 | Always — handoff flag (0=I-F, 1=closed-loop) |

### Key Mask Parameters

| Parameter | Type | Description | Typical Value |
|-----------|------|-------------|---------------|
| `PolePairs` | integer | Pole pairs | `pmsm.p` |
| `MaxStartingCurrent` | scalar | I/F current magnitude (A) | 30–70% of I_rated |
| `MaxAcceleration` | scalar | Frequency ramp rate (Hz/s) | 5–50 Hz/s |
| `OlClSpeed` | scalar | Open→closed handoff speed | 10–15% of N_base (electrical rad/s or RPM per SpeedUnit) |
| `ClOlSpeed` | scalar | Closed→open fallback speed | 5–7% of N_base (hysteresis below OlClSpeed) |
| `IdleTime` | scalar | Alignment time before ramp (s) | 0.1–0.5 |
| `PositionUnit` | enum | `'Radians'`, `'Degrees'`, `'Per-unit'` | Use `'Radians'` |
| `SpeedUnit` | enum | `'Radians/sec'`, `'RPM'`, etc. | Match control loop units |

### Handoff Logic

```
y4 (EnableSpeedLoop):
  0 = I/F startup active (use y1, y2, y3 for control)
  1 = Closed-loop active (use speed PI + observer angle)
```

**Transition:** I-F → closed-loop when speed exceeds `OlClSpeed` AND observer angle converges (error < 15° electrical).

---

## Voltage Path for SMO (Pattern B/B-Simple)

When using the FOC CC block (outputs Vabc in volts, 3×1), the SMO needs Valpha/Vbeta as **separate scalar** inputs. The conversion requires:

```
FOC_CC.y1 (Vabc, 3×1) → Demux(3) → [Va, Vb, Vc]
                                       ↓    ↓    ↓
                                    Clarke Transform → Valpha, Vbeta → SMO.u1, SMO.u2
                                                     ↓
                                              Terminator (Vc unused)
```

**Block list for SMO voltage path:**
| Block Name | model_edit type | Purpose |
|---|---|---|
| Demux_V | `"Demux"` | Split Vabc → Va, Vb, Vc |
| Clarke_V | `"Clarke Transform"` | Va, Vb → Valpha, Vbeta |
| Term_Vc | `"Terminator"` | Sink unused Vc |

**NEVER use Mux to combine Va+Vb for SMO.** SMO ports u1 and u2 are SCALAR inputs. Feeding a [2×1] vector from a Mux causes dimension propagation errors throughout the model.

### model_edit for voltage path:
```json
[
  {"op": "add_block", "type": "Demux", "name": "Demux_V", "ref": "dv", "params": {"Outputs": "3"}},
  {"op": "add_block", "type": "Clarke Transform", "name": "Clarke_V", "ref": "cv"},
  {"op": "add_block", "type": "Terminator", "name": "Term_Vc", "ref": "tvc"},
  {"op": "connect", "target": "FOC_CC.y1 -> #dv.u1"},
  {"op": "connect", "target": "#dv.y1 -> #cv.u1"},
  {"op": "connect", "target": "#dv.y2 -> #cv.u2"},
  {"op": "connect", "target": "#dv.y3 -> #tvc.u1"},
  {"op": "connect", "target": "#cv.y1 -> SMO.u1"},
  {"op": "connect", "target": "#cv.y2 -> SMO.u2"}
]
```

---

## Switch-Based Handoff Pattern

Use two Switch blocks: one for angle, one for speed. The Switch passes u1 (SMO) when u2 > threshold, otherwise u3 (true/fallback).

### Angle Switch
```
u1 = SMO.y1 → DTC_SMO_theta (single→double)
u2 = |true_speed| (from PMSM.y3 → DTC → Abs)
u3 = BusSel('MtrElcPos') (true angle for startup)
→ y1 feeds FOC_CC.u3
```

### Speed Switch
```
u1 = SMO.y2 → DTC_SMO_spd (single→double)
u2 = |true_speed| (same criterion signal)
u3 = PMSM.y3 → DTC_Spd (true speed for startup)
→ y1 feeds IIR_Spd → speed feedback
```

**Switch config:** `Criteria='u2 > Threshold'`, `Threshold='0.1 * speed_ref_rad'`

**Why use true speed for threshold criterion (u2):** SMO speed (y2) is unreliable at low speed — using it for the threshold decision creates a chicken-and-egg problem. Use actual motor speed (PMSM.y3) for the handoff decision.

---

## Validated Motor Parameter Sets

### Set A: 200W IPMSM Servo (proven stable, Pattern B-Simple + SMO)
```matlab
pmsm.Rs = 1.39;          % Stator resistance (Ohm)
pmsm.Ld = 5.8e-3;        % d-axis inductance (H)
pmsm.Lq = 8.5e-3;        % q-axis inductance (H)
pmsm.FluxPM = 0.175;     % PM flux linkage (Wb)
pmsm.p = 4;              % Pole pairs
pmsm.J = 0.0004;         % Rotor inertia (kg.m^2)
pmsm.B = 0.001;          % Friction (N.m.s)
pmsm.I_rated = 4.0;      % Rated current (A)
pmsm.N_rated = 2000;     % Rated speed (RPM)
pmsm.N_base = 2000;      % Base speed (= N_rated for SPM/IPMSM below base)

inverter.V_dc = 310;     % DC bus voltage (V) — 220V AC rectified
inverter.ISenseMax = 8;   % Current sensor max (A)
inverter.R_board = 0.01;  % PCB trace resistance (Ohm)

% kt/J = 2625 (NOT Category A) — stable with calcFOCGains defaults
% BEMF at rated: FluxPM × p × wm_rated = 146.6V < Vmax = 178.9V ✓
```

### Set B: 50W IPMSM (small motor, Category A — requires gain override)
```matlab
pmsm.Rs = 0.36;          % Stator resistance (Ohm)
pmsm.Ld = 0.3e-3;        % d-axis inductance (H)
pmsm.Lq = 0.7e-3;        % q-axis inductance (H)
pmsm.FluxPM = 0.0486;    % PM flux linkage (Wb)
pmsm.p = 4;              % Pole pairs
pmsm.J = 1.85e-5;        % Rotor inertia (kg.m^2) — VERY SMALL
pmsm.B = 0;              % Friction
pmsm.I_rated = 4.0;      % Rated current (A)
pmsm.N_rated = 3000;     % Rated speed (RPM)
pmsm.N_base = 3000;

inverter.V_dc = 24;      % DC bus voltage (V)
inverter.ISenseMax = 8;
inverter.R_board = 0.01;

% kt/J = 15762 → Category A! calcFOCGains Ki_speed is TOO HIGH
% Override: Ki_speed = 0.005, iq_sat = 0.5 * I_rated
% WARNING: Current loop may also be unstable with Ts=50µs due to L < 1mH
% Consider Ts = 20µs or use Set A instead for sensorless demos
```

---

## Speed from Position Derivative (Alternative to SMO y2)

When SMO speed output (y2) has bias issues or noise, derive speed from the more reliable position output (y1).

### Concept

```
speed_mech = wrapped_diff(theta_e) / (Ts × p)
```

Where `wrapped_diff` handles 2π discontinuities: `delta - 2π×round(delta/(2π))`

### Signal Flow

```
SMO.y1 → DTC(double) → [Unit Delay + Subtract] → Wrap → Gain(1/(Ts×p)) → LPF → speed_mech
```

### Block Configuration

| Block | Type | Key Parameters |
|-------|------|----------------|
| Delay | `"Unit Delay"` | `SampleTime`: `"Ts"` |
| Subtract | `"Add"` | `Inputs`: `"+-"` |
| Div2Pi | `"Gain"` | `Gain`: `"1/(2*pi)"` |
| Round | `"Rounding Function"` | `Operator`: `"round"` |
| Mul2Pi | `"Gain"` | `Gain`: `"2*pi"` |
| Wrap | `"Add"` | `Inputs`: `"+-"` (delta minus rounded term) |
| ToSpeed | `"Gain"` | `Gain`: `"1/(Ts * pmsm.p)"` |
| LPF | `"Discrete Filter"` | `Numerator`: `"0.02"`, `Denominator`: `"[1, -0.98]"` |

### Wrapping Logic

The key insight is angle wrapping to avoid ±2π jumps:
```
delta = theta_now - theta_prev
wrapped = delta - 2*pi * round(delta / (2*pi))
speed = wrapped / (Ts * p)
```

Without wrapping: speed spikes to ±infinity at 0→2π crossing.

**Why needed:** SMO position (y1) is always accurate; SMO speed (y2) can have PerUnitSpeed bias. This derivative chain gives ratio = 1.0000 vs actual speed in all configurations.

---

## Extended EMF Observer

**Type (model_edit):** `"Extended EMF Observer"` (resolves by name via SATK)
**Library path:** `mcblib/Control/Synchronous Machine/Position Decoders/Sensorless Estimators/Extended EMF Observer`

### Port Map (5 inputs, 2 outputs)

| Port | Notation | Signal | Unit | Notes |
|------|----------|--------|------|-------|
| u1 | Input | V_alpha | V | Stator voltage alpha |
| u2 | Input | V_beta | V | Stator voltage beta |
| u3 | Input | I_alpha | A | Stator current alpha |
| u4 | Input | I_beta | A | Stator current beta |
| u5 | Input | Reset/ParamBus | — | When ParameterBusInput='off': 0=run, 1=reset. When 'on': parameter bus |
| y1 | Output | theta_e | rad/deg/PU | Estimated electrical angle — **single precision** |
| y2 | Output | omega_m | rad/s/RPM/PU | Estimated mechanical speed — **single precision** |

### Mask Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `ParameterBusInput` | enum | `'off'` | Enable runtime parameter bus on u5 |
| `InputUnit` | enum | `'SI unit'` | `'SI unit'` or `'Per-unit'` |
| `PosOut` | enum | `'Electrical position'` | Output position type |
| `BlkSampleTime` | scalar | `'50e-6'` | Observer sample time (s) |
| `MotorSelection` | enum | `'PMSM'` | `'PMSM'` or `'SynRM'` |
| `EEMFMultiplier` | scalar | `'10'` | Extended EMF gain (typ 5-20). Higher = faster response, more noise |
| `StatorResistance` | scalar | `'0.36'` | Rs (Ohm) |
| `StatorDaxisInductance` | scalar | `'0.2e-3'` | Ld (H) |
| `StatorQaxisInductance` | scalar | `'0.2e-3'` | Lq (H) |
| `MaxApplicationSpeed` | scalar | `'6000'` | Maximum speed (RPM) |
| `PolePairs` | integer | `'4'` | Pole pairs |
| `MaxStatorVoltage` | scalar | `'13.8564'` | Vmax for normalization |
| `MaxStatorCurrent` | scalar | `'21.4286'` | Imax for normalization |
| `Alpha` | scalar | `'10'` | Low-speed adaptation gain |
| `EEMFCutoffFreq` | scalar | `'7500'` | EMF estimation cutoff (Hz) |
| `Kp` | scalar | `'250'` | PLL proportional gain |
| `Ki` | scalar | `'200000'` | PLL integral gain |
| `N_points` | integer | `'1024'` | Atan2 lookup table size |
| `SpeedCutoffFreq` | scalar | `'15'` | Speed filter cutoff (Hz) |
| `PositionUnit` | enum | `'Degrees'` | **DEFAULT IS 'Degrees'** — set to `'Radians'` for Park/InvPark |
| `PositionDataType` | enum | `'single'` | Output data type |
| `SpeedUnit` | enum | `'Degrees/sec'` | **DEFAULT IS 'Degrees/sec'** — set `'Radians/sec'` for rad/s |
| `PerUnitSpeed` | scalar | `'6000'` | **MUST equal MaxApplicationSpeed** |
| `SpeedDataType` | enum | `'single'` | Speed output data type |
| `TableDatatype` | enum | `'single'` | Internal LUT data type |

### Key Differences from SMO

| Aspect | SMO | Extended EMF Observer |
|--------|-----|---------------------|
| Estimation method | Sliding mode + PLL | Extended EMF model + PLL |
| Tuning complexity | 2 gains (BackEmfObs, CurrentObs) + CutoffFreq | EEMFMultiplier + Alpha + Kp/Ki |
| Low-speed performance | Poor (needs I-F) | Slightly better due to Alpha adaptation |
| Noise sensitivity | Lower (sliding mode smoothing) | Higher (depends on EEMFMultiplier) |
| Saliency required | No | No (but benefits from Ld≠Lq for EEMF model) |
| Computation | Lighter | Heavier (matrix operations) |

### Critical Pitfalls

Same PositionUnit/SpeedUnit/PerUnitSpeed defaults as SMO — see SMO section for details. Additionally:

1. **EEMFMultiplier too high** → oscillatory speed estimate, noise amplification
2. **EEMFMultiplier too low** → slow convergence, angle lag at speed transients
3. **Kp/Ki PLL gains** → interact with SpeedCutoffFreq. If speed oscillates, reduce Ki first
4. **Single-precision outputs** → same DTC requirement as SMO

### Reference Example

`openExample('mcb/IpeFwciPMSMPhfoSensorlessEemfExample')` — Sensorless EEMF + FWC + Initial Position Estimation

---

## Flux Observer (Synchronous Machine)

**Type (model_edit):** `"Flux Observer"` (resolves by name via SATK — NOTE: exists in both Synchronous and Induction paths)
**Library path:** `mcblib/Control/Synchronous Machine/Position Decoders/Sensorless Estimators/Flux Observer`

### Port Map (5 inputs, 3 outputs)

| Port | Notation | Signal | Unit | Visible If |
|------|----------|--------|------|-----------|
| u1 | Input | V_alpha | V | Always |
| u2 | Input | V_beta | V | Always |
| u3 | Input | I_alpha | A | Always |
| u4 | Input | I_beta | A | Always |
| u5 | Input | Reset/ParamBus | — | Always (0=run when ParameterBusInput='off') |
| y1 | Output | theta_e | rad/deg/PU | PositionSelect='on' |
| y2 | Output | flux | Wb/PU | FluxSelect='on' |
| y3 | Output | torque | Nm/PU | TorqueSelect='on' |

### Mask Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `ParameterBusInput` | enum | `'off'` | Runtime parameter bus |
| `MotorSelection` | enum | `'PMSM'` | `'PMSM'` or `'SynRM'` |
| `BlockInputUnit` | enum | `'SI unit'` | Input unit system |
| `PerUnitVoltage` | scalar | `'13.86'` | V_base (for PU mode) |
| `PerUnitCurrent` | scalar | `'19.3'` | I_base (for PU mode) |
| `PositionSelect` | enum | `'on'` | Enable position output |
| `FluxSelect` | enum | `'on'` | Enable flux output |
| `TorqueSelect` | enum | `'on'` | Enable torque output |
| `PolePairs` | integer | `'4'` | Pole pairs |
| `StatorResistance` | scalar | `'0.36'` | Rs (Ohm) |
| `StatorDAxisInductance` | scalar | `'0.2e-3'` | Ld (H) — for PMSM |
| `StatorLeakageInductance` | scalar | `'0.0068'` | Ls_leak (H) — for ACIM mode |
| `RotorLeakageInductance` | scalar | `'0.0068'` | Lr_leak (H) — for ACIM mode |
| `MagnetizingInductance` | scalar | `'0.0300'` | Lm (H) — for ACIM mode |
| `CutoffFreq` | scalar | `'3.1863'` | Observer bandwidth (Hz) |
| `BlockSampleTime` | scalar | `'50e-6'` | Sample time (s) |
| `PositionUnit` | enum | `'Radians'` | Position output unit |
| `PositionDatatype` | enum | `'single'` | Position data type |
| `FluxUnit` | enum | `'Weber'` | `'Weber'` or `'Per-unit'` |
| `PerUnitFlux` | scalar | `'0.1'` | Flux base (for PU mode) |
| `FluxDatatype` | enum | `'single'` | Flux data type |
| `TorqueUnit` | enum | `'Nm'` | `'Nm'` or `'Per-unit'` |
| `PerUnitTorque` | scalar | `'100'` | Torque base (for PU mode) |
| `TorqueDatatype` | enum | `'single'` | Torque data type |

### Unique Capabilities

1. **Flux estimation output** — useful for DTC (Pattern H) where flux magnitude is controlled directly
2. **Torque estimation output** — provides sensorless torque estimate without load cell
3. **Configurable outputs** — disable unused outputs to reduce computation
4. **ACIM mode** — uses magnetizing + leakage inductances (different param set from PMSM mode)

### When to Use Flux Observer vs SMO vs EEMF

| Scenario | Best Observer |
|----------|--------------|
| Standard sensorless FOC (PMSM) | SMO — simplest, well-documented |
| Need flux estimate (DTC) | Flux Observer — provides flux + torque |
| Need better low-speed (PMSM) | EEMF with Alpha adaptation |
| ACIM sensorless | Flux Observer (Induction Machine version) |
| High saliency IPMSM | SMO or EEMF (both work well) |
| Standstill/very low speed | HFI (Pulsating High Freq Observer) — none of the above work at 0 RPM |

### Reference Example

`openExample('mcb/DirectTorqueControlOfPMSMQuadratureEncoderFluxObserverExample')` — DTC using Flux Observer

---

## Position Compensation

**Type (model_edit):** `"Position Compensation"` (resolves by name via SATK)
**Library path:** `mcblib/Control/Synchronous Machine/Position Decoders/Sensorless Estimators/Position Compensation`

### Port Map (2 inputs, 1 output)

| Port | Notation | Signal | Unit | Notes |
|------|----------|--------|------|-------|
| u1 | Input | theta_raw | rad/deg/PU | Raw estimated angle from any observer |
| u2 | Input | speed | RPM/rad-s/PU | Estimated or measured speed |
| y1 | Output | theta_comp | rad/deg/PU | Delay-compensated angle |

### Mask Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `PhaseCompensationType` | enum | `'Sample delay'` | `'Sample delay'` or `'Cutoff frequency'` |
| `NumberSampleDelay` | integer | `'1'` | Number of sample delays to compensate (typ 1-3) |
| `CutOffFreq` | scalar | `'9.578'` | Cutoff frequency (Hz) — for frequency-based compensation |
| `OffsetValue` | scalar | `'0.1'` | Static offset (rad/deg/PU) |
| `BlkSampleTime` | scalar | `'50e-6'` | Sample time (s) |
| `PositionUnit` | enum | `'Radians'` | Unit of position signals |
| `SpeedUnit` | enum | `'RPM'` | Unit of speed input |
| `MaximumApplicationSpeed` | scalar | `'4000'` | Max speed for normalization |

### Purpose

All sensorless observers introduce computational delay (typically 1-3 Ts). At high speed, even 1 sample of angle lag causes significant torque loss:

```
Angle error = omega_e × N_delay × Ts (radians)
At 3000 RPM, 4 pole pairs, 1 delay: error = 3000/60 × 4 × 2π × 1 × 50e-6 = 6.3° electrical
At 6000 RPM: error = 12.6° → ~5% torque loss
```

Position Compensation predicts the correct angle by adding `speed × delay × Ts` to the raw estimate.

### Placement

```
Observer (SMO/EEMF/FluxObs) → Position Compensation → Park Transform (FOC)
                                       ↑
                              Speed (from observer y2 or external)
```

**Always place AFTER observer, BEFORE Park/InvPark transforms.**

### Configuration Rules

- **Sample delay mode** (default): Set `NumberSampleDelay` = total computation delays (ADC + observer + PWM update). Typically 1 for simulation, 2-3 for hardware deployment.
- **Cutoff frequency mode**: Low-pass filtered compensation — smoother but less precise. Use when speed signal is noisy.

---

## Sensorless Block Summary Table

| Block | Inputs | Outputs | Motor Types | Key Advantage |
|-------|--------|---------|-------------|---------------|
| Sliding Mode Observer | 5 (Vαβ, Iαβ, Reset) | 2 (θe, ωm) | PMSM, SynRM | Simplest, well-supported |
| Extended EMF Observer | 5 (Vαβ, Iαβ, Reset) | 2 (θe, ωm) | PMSM, SynRM | Better low-speed adaptation |
| Flux Observer (Sync) | 5 (Vαβ, Iαβ, Reset) | 3 (θe, flux, torque) | PMSM, SynRM | Flux+torque estimation (DTC) |
| Flux Observer (Induction) | 5 (Vαβ, Iαβ, Reset) | 3 (θe, flux, torque) | ACIM | Induction motor sensorless |
| Pulsating High Freq Observer | 4 (Iαβ_hf, θ_est) | 4 (θe, ωm, err, status) | IPMSM (salient) | Standstill + very low speed |
| Position Compensation | 2 (θ_raw, speed) | 1 (θ_comp) | Any | Delay compensation (all observers) |
| I-F Controller | 3-6 (refs, feedback) | 4 (Id*, Iq*, θ, enable) | Any | Open-loop startup + handoff |

### Common Pitfalls (All Observers)

1. **PositionUnit default is often 'Degrees'** — MUST change to 'Radians' for standard FOC
2. **SpeedUnit default is often 'Degrees/sec'** — MUST change to match control loop expectations
3. **PerUnitSpeed MUST equal MaxApplicationSpeed** — mismatch causes proportional speed bias
4. **All observers output single precision** — add DTC (Data Type Conversion → double) before downstream math
5. **Reset/u5 port MUST be connected** — use Constant(0) if not resetting
6. **Minimum speed for estimation** — all back-EMF observers fail near 0 RPM, use I-F or HFI for startup

----
Copyright 2026 The MathWorks, Inc.
----

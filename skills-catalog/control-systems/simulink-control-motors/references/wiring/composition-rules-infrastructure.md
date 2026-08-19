
# Composition Rules — Infrastructure Features

> Protection, PWM strategy, multi-rate, nonlinear motor, and load models.
> For core FOC features (FW, SMO, GainSched, FF, Position, I/f) see `composition-rules.md`.
> For logging, speed profiles, and feature combining see `composition-rules-integration.md`.

---

## Feature: Protection / Fault Detection

**Prerequisites:** Any working model with current measurement.

**Blocks to add:** Abs, Compare To Constant, OR gate, SR Latch, AND gate (enable gating)

**Wiring:**
```
Ia --> Abs --> Compare(> I_trip) --+
Ib --> Abs --> Compare(> I_trip) --+--> OR --> SR_Latch(Set) --> NOT --> AND_Enable
Ic --> Abs --> Compare(> I_trip) --+                                        |
                                                                              v
Normal_PWM ----------------------------------------------------> AND --> Inverter
```

**Reference:** See `auto_fix/auto-fix-recipes.md` § Build Protection Subsystem

### Common Mistakes

1. **Threshold too tight** — Use I_trip = 1.5 to 2.0x I_rated (not exactly I_rated).
2. **No hysteresis** — Use SR Latch to latch fault; trip at 2x, reset at 1.5x.
3. **Latch without reset** — Always provide a reset mechanism (external signal or timeout).

---

## Feature: PWM Strategy Change (SVM, DPWM, OVM)

**Prerequisites:** FOC producing Valpha, Vbeta (from InvPark outputs).

**Replace V2D+InvClarke path with:**
```
InvPark/1 (Valpha) ──► PWM_Ref_Gen/1
InvPark/2 (Vbeta)  ──► PWM_Ref_Gen/2
theta_e / (2*pi)   ──► PWM_Ref_Gen/3   ← CRITICAL: per-unit [0,1), NOT radians!

PWM_Ref_Gen/1 (Da) ──┐
PWM_Ref_Gen/2 (Db) ──┼──► Mux(3) ──► Avg_Inverter/1
PWM_Ref_Gen/3 (Dc) ──┘
```

**For Overmodulation (OVM):**
```
InvPark/1,2 ──► Mux(2) ──► OVM/1
Constant(Vdc)           ──► OVM/2
OVM/1 ──► Demux(2) ──► PWM_Ref_Gen/1, /2
```

**PWM Ref Gen modes:** 'SPWM', 'SVM', 'DPWM0', 'DPWM1', 'DPWM2', 'DPWM3', 'DPWMMIN', 'DPWMMAX', 'OVM'

**Reference:** See `examples/example_overmodulation_foc.m`

### Common Mistakes

1. **theta in radians instead of per-unit** — PWM Reference Generator expects position as per-unit [0, 1), NOT radians [0, 2*pi). Divide theta_e by `2*pi`. Passing radians produces wildly wrong duty cycles and typically causes overcurrent.
2. **Wrong modType string** — The `ModulationType` parameter is case-sensitive and must exactly match one of: `'SPWM'`, `'SVM'`, `'DPWM0'`, etc. Typos like `'Svm'` or `'spwm'` cause silent fallback or error.
3. **Forgetting Mux after PWM Ref Gen** — PWM Ref Gen outputs 3 SEPARATE scalar duty signals (Da, Db, Dc). The Average-Value Inverter expects a single [3x1] vector at port 1. You MUST add a Mux(3) block to combine them. Connecting only Da to the inverter leaves phases B and C undriven.

---

## Feature: Multi-Rate (Speed Loop at Lower Rate)

**Prerequisites:** Any speed-controlled FOC model.

**Compute:** `Ts_speed = 10 * Ts` (or 20×Ts for bandwidth separation)

**model_edit operations:**
```json
[
  {"op": "configure", "target": "Speed_PI", "params": {"SampleTime": "Ts_speed"}},
  {"op": "add_block", "type": "Rate Transition", "name": "RT_Tref", "ref": "rt1", "params": {"OutPortSampleTime": "Ts"}},
  {"op": "add_block", "type": "Rate Transition", "name": "RT_spd", "ref": "rt2", "params": {"OutPortSampleTime": "Ts_speed"}},
  {"op": "connect", "target": "Speed_PI.y1 -> #rt1.u1"},
  {"op": "connect", "target": "#rt1.y1 -> MTPA.u1"},
  {"op": "connect", "target": "IIR_Spd.y1 -> #rt2.u1"},
  {"op": "connect", "target": "#rt2.y1 -> Speed_Err.u2"}
]
```

**Signal flow:**
```
Speed_PI.y1 → RT_Tref → Control_Ref.u1 (Tref at Ts)
IIR_Spd.y1  → RT_spd  → Speed_Err.u2 (feedback at Ts_speed)
```

---

## Feature: Nonlinear Motor (FEM/Simscape Plant)

**Prerequisites:** FEM flux data available. Model currently uses MCB Interior PMSM.

**Option A: MCB PMSM with LUT mode**
```json
{"op": "configure", "target": "PMSM", "params": {
    "nonLinearityChoice": "LUT",
    "idVec": "pmsm.PMSMLUT.idVec", "iqVec": "pmsm.PMSMLUT.iqVec",
    "LdTable": "pmsm.PMSMLUT.LdTable", "LqTable": "pmsm.PMSMLUT.LqTable"}}
```

**Option B: Simscape FEM-Parameterized PMSM (fl_lib domain)**

Requires complete rewiring — see `examples/example_acim_simscape_rfoc.m` and `converters/plant-model-converters.md` § Simscape FEM 2D.

Key differences:
- Solver must be `ode14x` (implicit), NOT FixedStepDiscrete
- Motor ports are foundation electrical (fl_lib), not composite
- Need fl_lib Controlled Voltage Sources (3x) + Current Sensors (3x)
- Negate BOTH speed AND angle feedback from Simscape (s=-1, a=-1)

---

## Feature: Load Model

> How to add mechanical load torque to any model. Load connects to PMSM port 1 (TL input).

### Load Formula Summary
| Application | Formula | Typical Use |
|-------------|---------|-------------|
| Constant | `TL = T_const` | Conveyor, hoist (steady) |
| Quadratic (fan/pump) | `TL = k × wm² × sign(wm)` where `k = T_rated/wm_rated²` | HVAC fans, centrifugal pumps |
| Gravitational | `TL = m × g × r × direction` | Elevator, crane, winch |
| Periodic | `TL = T_mean + T_ripple × sin(n × theta_mech)` | Compressor, reciprocating pump |
| Friction | `TL = Tc × sign(wm) + B_visc × wm` | All (Coulomb + viscous) |
| Step (test) | `TL = 0→T_step at t=t_step` | Disturbance rejection test |

### Constant Load

```json
[
  {"op": "add_block", "type": "Constant", "name": "TL", "ref": "tl", "params": {"Value": "T_load"}},
  {"op": "connect", "target": "#tl.y1 -> PMSM.u1"}
]
```

### Quadratic (Fan/Pump) Load

`TL = k × wm² × sign(wm)` where `k = T_rated / wm_rated²`

```json
[
  {"op": "add_block", "type": "Abs", "name": "Abs_Spd", "ref": "abs"},
  {"op": "add_block", "type": "Math Function", "name": "Sq_Spd", "ref": "sq", "params": {"Operator": "square"}},
  {"op": "add_block", "type": "Gain", "name": "K_load", "ref": "kl", "params": {"Gain": "k_fan"}},
  {"op": "add_block", "type": "Math Function", "name": "Sign_Spd", "ref": "sgn", "params": {"Operator": "sign"}},
  {"op": "add_block", "type": "Product", "name": "Prod_TL", "ref": "prd"},
  {"op": "connect", "target": "IIR_Spd.y1 -> #abs.u1"},
  {"op": "connect", "target": "#abs.y1 -> #sq.u1"},
  {"op": "connect", "target": "#sq.y1 -> #kl.u1"},
  {"op": "connect", "target": "#kl.y1 -> #prd.u1"},
  {"op": "connect", "target": "IIR_Spd.y1 -> #sgn.u1"},
  {"op": "connect", "target": "#sgn.y1 -> #prd.u2"},
  {"op": "connect", "target": "#prd.y1 -> PMSM.u1"}
]
```

### Gravitational Load

```json
[
  {"op": "add_block", "type": "Constant", "name": "TL_Grav", "ref": "tg", "params": {"Value": "m * g * r"}},
  {"op": "connect", "target": "#tg.y1 -> PMSM.u1"}
]
```

For bidirectional: add a Gain block with `"Gain": "direction"` (+1 or -1) between Constant and PMSM.

### Periodic Load

Sinusoidal torque variation (compressor, reciprocating pump).

```json
[
  {"op": "add_block", "type": "Sine Wave", "name": "TL_Periodic", "ref": "tlp", "params": {
      "SineType": "Sample based", "Amplitude": "T_ripple", "Bias": "T_mean",
      "SamplesPerPeriod": "round(1/(f_load*Ts))", "SampleTime": "Ts"}},
  {"op": "connect", "target": "#tlp.y1 -> PMSM.u1"}
]
```

Alternative (position-based crank):
```json
[
  {"op": "add_block", "type": "Trigonometric Function", "name": "Sin_Pos", "ref": "sp", "params": {"Operator": "sin"}},
  {"op": "add_block", "type": "Gain", "name": "Amp_TL", "ref": "amp", "params": {"Gain": "T_ripple"}},
  {"op": "add_block", "type": "Sum", "name": "Add_Mean", "ref": "am", "params": {"Inputs": "++"}},
  {"op": "add_block", "type": "Constant", "name": "T_Mean", "ref": "tm", "params": {"Value": "T_mean"}},
  {"op": "connect", "target": "BusSel.y1 -> #sp.u1"},
  {"op": "connect", "target": "#sp.y1 -> #amp.u1"},
  {"op": "connect", "target": "#amp.y1 -> #am.u1"},
  {"op": "connect", "target": "#tm.y1 -> #am.u2"},
  {"op": "connect", "target": "#am.y1 -> PMSM.u1"}
]
```

### Friction Load

`TL = Tc×sign(wm) + B_visc×wm`

```json
[
  {"op": "add_block", "type": "Math Function", "name": "Sign_Fric", "ref": "sf", "params": {"Operator": "sign"}},
  {"op": "add_block", "type": "Gain", "name": "Tc_Gain", "ref": "tc", "params": {"Gain": "Tc"}},
  {"op": "add_block", "type": "Gain", "name": "B_Gain", "ref": "bv", "params": {"Gain": "B_visc"}},
  {"op": "add_block", "type": "Sum", "name": "Add_Fric", "ref": "af", "params": {"Inputs": "++"}},
  {"op": "connect", "target": "IIR_Spd.y1 -> #sf.u1"},
  {"op": "connect", "target": "#sf.y1 -> #tc.u1"},
  {"op": "connect", "target": "#tc.y1 -> #af.u1"},
  {"op": "connect", "target": "IIR_Spd.y1 -> #bv.u1"},
  {"op": "connect", "target": "#bv.y1 -> #af.u2"},
  {"op": "connect", "target": "#af.y1 -> PMSM.u1"}
]
```

### Step Load (Disturbance Test)

```json
[
  {"op": "add_block", "type": "Step", "name": "TL_Step", "ref": "tls", "params": {
      "Time": "T_step_time", "InitialValue": "0", "FinalValue": "T_step_mag", "SampleTime": "Ts"}},
  {"op": "connect", "target": "#tls.y1 -> PMSM.u1"}
]
```

---

## Hardware Deployment Notes

### ADC Calibration (Code Generation)

Before deploying to MCU, add ADC offset calibration for current sensors:
```matlab
% At startup (motor disabled), sample N readings and average
% Subtract offset from all subsequent readings
Ia_cal = Ia_raw - Ia_offset;
Ib_cal = Ib_raw - Ib_offset;
```
Without calibration, DC offset causes 6th harmonic torque ripple.

### Encoder Handoff Pattern

For models that support both encoder (low speed) and sensorless (high speed):
```
Below threshold: theta = encoder_theta_e (via MechToElec)
Above threshold: theta = observer_theta_e (SMO/EEMF)
Transition: blend over 50-100 RPM band to avoid step discontinuity
```
Use weighted average during transition: `theta = alpha*obs + (1-alpha)*enc` where alpha ramps 0→1.

---

----
Copyright 2026 The MathWorks, Inc.
----

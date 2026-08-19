# Motor Parameter Estimation Procedures

## 1. Stator Resistance Estimation (Rs)

### MCB Block: Rs Estimation
**Type (model_edit):** `"Rs Estimation"`

### Procedure
1. Ensure motor is stationary and at ambient temperature
2. Inject DC current at 30–50% of rated current
3. Measure steady-state voltage across phases
4. Compute: `Rs = V_measured / I_injected` (per phase)

### Block Configuration
| Parameter | Value | Notes |
|---|---|---|
| InjectionCurrent | `0.3 * pmsm.I_rated` to `0.5 * pmsm.I_rated` | Higher = more accurate, risk of heating |
| MeasurementDuration | `1.0` s | Average over this window |
| PolePairs | `pmsm.p` | For per-phase computation |

### Gotchas
- Temperature affects Rs significantly (+0.4%/°C for copper)
- Measure at operating temperature if possible
- For ACIM: this measures stator Rs only (Rr requires separate method)

---

## 2. Inductance Estimation (Ld, Lq)

### MCB Block: Ld Lq Estimation
**Type (model_edit):** `"Ld Lq Estimation"`

### Procedure
1. Lock rotor (or ensure stationary)
2. Align d-axis using DC injection at known angle
3. Inject AC voltage at d-axis angle → measure current → compute Ld
4. Inject AC voltage at q-axis angle (d + 90° elec) → measure current → compute Lq

### Block Configuration
| Parameter | Value | Notes |
|---|---|---|
| InjectionFrequency | `200` Hz | 100–500 Hz typical; higher for low-L motors |
| InjectionAmplitude | `0.1 * Vdc` | Small signal to stay in linear region |
| DAxisAngle | `0` or from alignment | Electrical angle of d-axis |

### Formulas (manual verification)
```
Z_d = V_inj / I_measured_d    (impedance at injection frequency)
Ld = sqrt(Z_d² - Rs²) / (2·π·f_inj)

Z_q = V_inj / I_measured_q
Lq = sqrt(Z_q² - Rs²) / (2·π·f_inj)
```

### Gotchas
- Inductance varies with current (saturation) — estimate at ~50% rated
- SPMSM: Ld ≈ Lq (no saliency)
- IPMSM: Lq > Ld (saliency ratio 1.2–3.0 typical)
- Requires accurate Rs (estimate Rs first!)

---

## 3. PM Flux Linkage Estimation (FluxPM)

### Method: Back-EMF at Known Speed

No dedicated MCB block — use evaluate_matlab_code.

### Procedure
1. Spin motor at known constant speed (using external drive or dyno)
2. Measure open-circuit line-to-line voltage (RMS)
3. Compute: `FluxPM = V_ll_rms / (√3 · ωe)` where `ωe = p · ωm`

### Alternative: From Torque Constant
```
FluxPM = T_rated / (1.5 · p · I_rated)    % For SPMSM (id=0)
```

### Gotchas
- FluxPM varies with temperature (-0.1%/°C for NdFeB magnets)
- For IPMSM with reluctance torque, simple formula underestimates FluxPM
- Verify: `T_calc = 1.5·p·FluxPM·I_rated` should ≈ T_rated (for SPMSM)

---

## 4. Mechanical Parameter Estimation (J, B)

### MCB Block: Mechanical Parameter Estimation
**Type (model_edit):** `"Mechanical Parameter Estimation"`

### Procedure
1. Disconnect mechanical load (motor free-spinning)
2. Accelerate motor to known speed with known torque
3. Measure acceleration: `J = T_applied / (dω/dt)`
4. At constant speed: `B = T_applied / ω_steady` (friction only)

### Block Configuration
| Parameter | Value | Notes |
|---|---|---|
| AccelerationTorque | Known applied torque (Nm) | From current × torque constant |
| SpeedRange | `[500, 2000]` RPM | Window for linear fit |

### Alternative: Coast-Down Method
```matlab
% Disable drive, let motor coast from ω0 to 0
% Fit exponential: ω(t) = ω0 · exp(-B/J · t)
% Time constant τ = J/B
% Measure τ from 63% decay → J = B·τ
% If pure friction (no load): T_friction = B·ω → B = T_friction/ω
```

### Gotchas
- Must disconnect ALL mechanical load (coupling, gearbox, belt)
- Coulomb friction (constant) confuses B estimation — coast-down is better
- J estimation requires known torque — use current loop with known kt
- Run estimation BEFORE tuning speed PI — you need J for Kp_speed

---

## 5. ACIM-Specific: Rotor Parameters (Rr, Lr, Lm)

### From Datasheet (Preferred)
ACIM parameters usually from manufacturer:
- Rs, Rr (stator/rotor resistance)
- Ls, Lr (stator/rotor self-inductance)
- Lm (magnetizing inductance)

### From No-Load and Locked-Rotor Tests
```matlab
% No-load test (motor spinning unloaded):
% Measure V_nl, I_nl, P_nl
% Xm ≈ V_nl / I_nl (magnetizing reactance at f_rated)
% Lm = Xm / (2·π·f_rated)

% Locked-rotor test (rotor held, reduced voltage):
% Measure V_lr, I_lr, P_lr at reduced frequency (f_lr)
% Z_lr = V_lr / I_lr
% R_lr = P_lr / (3·I_lr²) = Rs + Rr
% X_lr = sqrt(Z_lr² - R_lr²) = 2·π·f_lr·(Lls + Llr)
% Rr = R_lr - Rs (subtract previously measured Rs)
```

### Key Derived Parameters for RFOC
```
Tr = Lr / Rr              % Rotor time constant
σ = 1 - Lm²/(Ls·Lr)      % Leakage factor
L_sigma = σ · Ls          % Transient inductance (plant for PI)
```

---

## Quick Reference: Parameter Estimation Order

```
┌──────────────┐     ┌──────────────┐     ┌──────────────┐     ┌──────────────┐
│  1. Rs       │ ──→ │  2. Ld/Lq    │ ──→ │  3. FluxPM   │ ──→ │  4. J, B     │
│  (stationary)│     │  (stationary)│     │  (spinning)  │     │  (free-spin) │
└──────────────┘     └──────────────┘     └──────────────┘     └──────────────┘
                                                                       │
                                                                       ▼
                                                              ┌──────────────────┐
                                                              │ mcb.calcFOCGains │
                                                              └──────────────────┘
```

----
Copyright 2026 The MathWorks, Inc.
----

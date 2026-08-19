# Workflow: Sensorless Observer Integration

**Scope:** Adding position/speed estimation to an existing sensored FOC model.

## Prerequisites
- Working sensored FOC model (current loop stable, speed loop functional)
- Motor parameters known (Rs, Ld, Lq, FluxPM, p)
- Understanding of speed operating range requirements

## Step 1: Observer Selection

| Condition | Recommended Observer | Reason |
|---|---|---|
| IPMSM, full range (0 → max speed) | HFI + SMO hybrid | HFI at standstill, SMO at speed |
| SPMSM, speed > 5–10% rated | SMO only | No saliency → HFI impossible |
| IPMSM, speed > 10% rated only | SMO only | Simpler, no injection noise |
| ACIM | Indirect RFOC (slip calc) | No PM → no back-EMF for SMO |
| BLDC, cost-sensitive | BEMF zero-crossing | Simplest, trapezoidal only |

**Saliency requirement for HFI:** `Lq/Ld > 1.2` (assert before proceeding)

## Step 2: Verify Prerequisites

Before adding sensorless:
- [ ] Current loop stable with sensored feedback
- [ ] Speed measurement sign convention correct (positive speed = positive direction)
- [ ] θe correctly aligned (d-axis = 0 electrical radians)
- [ ] No unresolved current offset or gain errors

## Step 3a: SMO Configuration (Medium/High Speed)

### MCB Block: Sliding Mode Observer
**Type (model_edit):** `"Sliding Mode Observer"`

### Compute Parameters
```matlab
PU_System = mcb.getPUSystemParameters(pmsm, inverter);
smo = mcb.computeSMOParameters(pmsm, Ts, PU_System);

Ls_avg = (pmsm.Ld + pmsm.Lq) / 2;
N_base = pmsm.N_base;  % or N_rated
CutoffFreq = max(500, N_base * pmsm.p / 60 * 2 * 1.5);
```

### Block Configuration
| Parameter | Value | Notes |
|---|---|---|
| InputUnit | `'Per-unit'` | Inputs must be scaled |
| BlkSampleTime | `'Ts'` | |
| StatorResistance | `'motor.Rs'` | |
| StatorInductance | `'Ls_avg'` | Average of Ld, Lq |
| MaxApplicationSpeed | `'N_base'` | RPM |
| PolePairs | `'motor.p'` | |
| MaxStatorVoltage | `'V_base'` | For PU scaling |
| MaxStatorCurrent | `'I_base'` | For PU scaling |
| DisturbanceObserverGain | `'smo.BackEmfObsGain'` | |
| CurrentObserverGain | `'smo.CurrentObsGain'` | |
| CutoffFreq | `'CutoffFreq'` | LP filter for position |
| PositionUnit | `'Per unit'` | Output in [0, 1) |
| SpeedUnit | `'Per unit'` | |

### Input Scaling (CRITICAL)
SMO requires PU inputs:
```
Ialpha_PU = Ialpha / I_base
Ibeta_PU = Ibeta / I_base
Valpha_PU = Valpha / V_base
Vbeta_PU = Vbeta / V_base
```

### Speed from SMO Position (Preferred over SMO speed output)
```
theta_smo(k) → Unit Delay → theta_smo(k-1)
delta = theta_smo(k) - theta_smo(k-1)
delta_wrapped = delta - round(delta)  % PU wrap correction
speed_PU = delta_wrapped / Ts_speed
speed_rad = speed_PU * w_base
→ LPF (alpha = 0.03)
```

**→ Ref:** `estimating-sensorless-motor-position` § SMO

## Step 3b: HFI Configuration (Zero/Low Speed, IPMSM Only)

### MCB Block: Pulsating High Freq Observer
**Type (model_edit):** `"Pulsating High Freq Observer"`

### Compute Parameters
```matlab
wn_phfo = 2*pi*40;  % PLL natural frequency
zeta_phfo = 0.99;   % Damping
Kp_phfo = 2 * zeta_phfo * wn_phfo / (pmsm.Lq - pmsm.Ld);
Ki_phfo = wn_phfo^2 / (pmsm.Lq - pmsm.Ld);

Vh_pu = 0.4;   % HF injection voltage (PU)
f_hf = 1500;   % Injection frequency (Hz)
f_demod = 100; % Demodulation LP cutoff (Hz)
```

### Block Configuration
| Parameter | Value |
|---|---|
| Voltphf | `'Vh_pu'` (0.3–0.5 PU typical) |
| Frqphf | `'f_hf'` (1000–2000 Hz) |
| Cfrqphf | `'f_demod'` (50–200 Hz) |
| Kp | `'Kp_phfo'` |
| Ki | `'Ki_phfo'` |
| BaseVoltage | `'V_base'` |
| BaseCurrent | `'I_base'` |
| BlkSampleTime | `'Ts'` |

### HFI Current Extraction (HPF Required)
The PHFO needs only the HF current component. Extract via HPF:
```
alpha_hpf = min(2*pi*(f_hf/3)*Ts, 0.5);  % Cutoff at 1/3 injection freq
HPF: H(z) = [1,-1]*alpha / [1, -(1-alpha)]
Ia → HPF → DTC(single) → Clarke → PHFO input
Ib → HPF → DTC(single) →
```

### HFI Voltage Injection
PHFO outputs V_alphabeta [2×1] PU → scale by V_base → InvClarke → add to FOC Vabc output.

**→ Ref:** `estimating-sensorless-motor-position` § HFI

## Step 3c: Flux Observer (ACIM)

For ACIM, sensorless is achieved via indirect RFOC slip calculation:
```
we_slip = iq / (Tr * id)     % Tr = Lr/Rr
theta_e = integral(p*wm + we_slip)
```
No separate observer block needed — angle is computed from speed + slip.

**→ Ref:** configurations/acim-indirect-rfoc.md

## Step 4: Full-Range Hybrid (HFI + SMO)

### Transition Zone
```
w_trans_low = 0.05 * w_base    % 5% rated: HFI → blend begins
w_trans_high = 0.15 * w_base   % 15% rated: blend → SMO only
```

### Blending (Scheduler)
```
alpha = clamp((|w_est| - w_trans_low) / (w_trans_high - w_trans_low), 0, 1)
theta_out = (1 - alpha) * theta_hfi + alpha * theta_smo
speed_out = (1 - alpha) * speed_hfi + alpha * speed_smo
```

### Algebraic Loop Breaking
Blended speed feeds back to scheduler → **Unit Delay required** on feedback path.

**→ Ref:** `estimating-sensorless-motor-position` § Hybrid, configurations/hfi-smo-hybrid.md

## Step 5: Startup Strategy

| Method | When | How |
|---|---|---|
| IPD (Initial Position Detection) | Servo requiring position from t=0 | Dual pulse injection → detect saliency axis |
| I/f ramp | Applications tolerating startup delay | Open-loop current/frequency ramp until observer converges |
| HFI from standstill | IPMSM with saliency | PHFO provides position at zero speed |

## Step 6: Speed Estimation Tuning

### Position-Derivative Method (Preferred)
- Differentiating position → noisy → requires LPF
- LPF cutoff trade-off: lower = smoother but more lag
- Typical: 1st-order LPF with alpha = 0.03–0.1

### Observer Internal Speed
- SMO port 2 provides speed directly, but may have PU bias issues
- Recommendation: use position-derivative for robustness

## Step 7: Gain Derating for Sensorless

Observer adds phase delay to the feedback path → reduce loop gains:

```matlab
PI_params = mcb.calcFOCGains(pmsm, Ts, Ts_speed, 'SpdLoopFactor', 0.3);
```

Rule of thumb: derate speed loop by 3× (factor 0.3) for sensorless.

## Step 8: Validation Tests

| Test | What to Verify |
|---|---|
| Speed step (above transition) | Smooth tracking, no oscillation |
| Load step (above transition) | Fast recovery, no position loss |
| Low-speed crawl (HFI region) | Stable position estimation |
| Transition zone sweep | No glitch during HFI↔SMO handoff |
| Speed reversal | Correct sign handling through zero |
| Startup from standstill | Reliable convergence, correct direction |

---

Copyright 2026 The MathWorks, Inc.

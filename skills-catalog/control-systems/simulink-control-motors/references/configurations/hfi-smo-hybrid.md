# Configuration: HFI + SMO Hybrid Sensorless FOC

**Motor:** IPMSM (MCB Interior PMSM) — requires saliency (Lq/Ld > 1.2)
**Control:** Full-speed-range sensorless: HFI at standstill, SMO at speed, blended transition
**Use case:** Servo applications requiring position from zero to max speed without encoder

## Architecture
```
                    ┌─ HFI (Pulsating High Freq Observer) ← HPF(Iabc) ─┐
Speed_Ref → FOC ──►│                                                     ├─ Blend → θe, ωe
                    └─ SMO (Sliding Mode Observer) ← Iαβ, Vαβ ──────────┘
Blend: α = clamp((|ω|-ω_low)/(ω_high-ω_low), 0, 1)
θ_out = (1-α)*θ_hfi + α*θ_smo
```

## Transition Zone
```matlab
w_trans_low = 0.05 * w_base;    % 5% rated: HFI → blend begins
w_trans_high = 0.15 * w_base;   % 15% rated: blend → SMO only
```

## HFI Block (Pulsating High Freq Observer)
| Parameter | Value | Notes |
|---|---|---|
| Voltphf | 0.3–0.5 PU | HF injection voltage |
| Frqphf | 1000–2000 Hz | Injection frequency |
| Cfrqphf | 50–200 Hz | Demodulation LP cutoff |
| Kp | `2*zeta*wn/(Lq-Ld)` | PLL proportional |
| Ki | `wn^2/(Lq-Ld)` | PLL integral |
| BaseVoltage | V_base | PU scaling |
| BaseCurrent | I_base | PU scaling |

### HFI Current Extraction (HPF Required)
```
alpha_hpf = min(2*pi*(f_hf/3)*Ts, 0.5)
Ia → HPF → DTC(single) → Clarke → PHFO input
```

### HFI Voltage Injection
PHFO outputs V_alphabeta [2×1] PU → scale by V_base → InvClarke → add to FOC Vabc output.

## SMO Block (Sliding Mode Observer)
| Parameter | Value |
|---|---|
| InputUnit | `'Per-unit'` |
| StatorResistance | Rs |
| StatorInductance | (Ld+Lq)/2 |
| MaxApplicationSpeed | N_base (RPM) |
| PolePairs | p |
| MaxStatorVoltage | V_base |
| MaxStatorCurrent | I_base |
| PositionUnit | `'Per unit'` |
| SpeedUnit | `'Per unit'` |

### SMO Input Scaling (CRITICAL)
```
Ialpha_PU = Ialpha / I_base
Ibeta_PU = Ibeta / I_base
Valpha_PU = Valpha / V_base
Vbeta_PU = Vbeta / V_base
```

### Speed from SMO Position (Preferred)
```
delta = theta_smo(k) - theta_smo(k-1)
delta_wrapped = delta - round(delta)     % PU wrap correction
speed_PU = delta_wrapped / Ts_speed
speed_rad = speed_PU * w_base → LPF (alpha=0.03)
```

## Blending Implementation
- α = clamp((|ω_est| - w_trans_low) / (w_trans_high - w_trans_low), 0, 1)
- Unit Delay on blended speed feedback (breaks algebraic loop)
- Speed feeds back to scheduler → delay required

## Gain Derating for Sensorless
- Speed loop: derate by 3× (SpdLoopFactor = 0.3)
- Observer adds phase delay to feedback path

## Saliency Requirement
- Assert `Lq/Ld > 1.2` before using HFI
- SPMSM (Ld≈Lq): HFI impossible → use SMO only (above ~10% speed)

## Things to Avoid
- DO NOT use HFI on SPMSM — no saliency for position detection
- DO NOT omit HPF on current — HFI needs only HF component
- DO NOT forget PU scaling for SMO inputs — wrong scale = wrong angle
- DO NOT use SMO speed output directly — use position-derivative method
- DO NOT omit Unit Delay in blend feedback — algebraic loop

---
**Cross-references:** `wf-sensorless-observer-integration.md`, `gain-formulas.md` § SMO/HFI

---
Copyright 2026 The MathWorks, Inc.

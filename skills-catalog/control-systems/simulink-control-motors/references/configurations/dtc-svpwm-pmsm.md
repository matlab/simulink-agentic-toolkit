# Configuration: Direct Torque Control with SVM (DTC-SVPWM)

**Motor:** IPMSM (MCB Interior PMSM)
**Control:** DTC outer loop (torque + flux estimation) with SVM inner modulation
**Use case:** Fast torque response without current loops, industrial drives

## Architecture
```
Speed_Ref -> Speed_PI -> Tref
Tref, |lambda_s|_ref -> DTC Controller -> V_alpha/V_beta
-> PWM Reference Generator (SVM) -> Duty[3] -> Inverter -> PMSM
Feedback: Clarke(Iabc) + voltage reconstruction -> flux/torque estimation
```

## DTC Principle
1. Estimate stator flux: `lambda_a = integral(V_a - Rs*I_a)`, `lambda_b = integral(V_b - Rs*I_b)`
2. Compute magnitude: `|lambda_s| = sqrt(lambda_a^2 + lambda_b^2)`
3. Compute torque: `Te = 1.5*p*(lambda_a*I_b - lambda_b*I_a)`
4. Hysteresis comparators on torque and flux errors
5. Sector detection: `sector = floor(atan2(lambda_b, lambda_a) / (pi/3)) + 1`
6. Switching table: (delta_T, delta_Phi, sector) -> voltage vector

## DTC-SVPWM Variant (This Configuration)
Instead of pure switching table (variable frequency):
- PI controllers on torque error -> Vq-like component
- PI controllers on flux error -> Vd-like component
- Transform to alpha-beta -> PWM Reference Generator (SVM)
- Gives DTC's fast torque + constant switching frequency

## Flux Estimation
```matlab
% Voltage model (requires Valpha, Vbeta reconstruction):
lambda_a(k) = lambda_a(k-1) + Ts*(V_a - Rs*I_a);
lambda_b(k) = lambda_b(k-1) + Ts*(V_b - Rs*I_b);

% Drift compensation (low-speed fix):
% Combine with current model: lambda_d = Ld*id + FluxPM, lambda_q = Lq*iq
% Crossover at ~5% rated speed
```

## Key Parameters
| Parameter | Value | Notes |
|---|---|---|
| Flux reference | `FluxPM * 1.0` | Rated stator flux magnitude |
| Torque hysteresis | `0.05 * T_rated` | Narrow for SVPWM variant |
| Flux hysteresis | `0.02 * FluxRef` | |
| Ts | 25us | Faster than standard FOC |
| Estimator method | Voltage model + current model blend | |

## Voltage Reconstruction
```
V_alpha = (2*da - db - dc) / 3 * Vdc
V_beta = (db - dc) / sqrt(3) * Vdc
```
Where da, db, dc are duty cycles from previous step (Unit Delay).

## Default Motor
- IPMSM: p=4, Rs=0.36, Ld=3.5mH, Lq=8mH, FluxPM=0.1714
- Vdc=400V, Ts=25us (faster than FOC for DTC bandwidth)

## Strengths and Limitations
| Strength | Limitation |
|---|---|
| Fastest torque response | Flux estimation drift at low speed |
| No current loop tuning | Higher torque ripple than FOC |
| Inherent current limiting (via flux limit) | Rs sensitivity in estimator |
| Natural field weakening (reduce flux ref) | More complex to implement |

## Things to Avoid
- DO NOT use pure voltage-model flux estimation below 5% speed — drift
- DO NOT set hysteresis bands too wide — increases torque ripple
- DO NOT forget Rs compensation in flux estimation — critical
- DO NOT confuse DTC sector (flux angle) with BLDC commutation sector
- DO NOT omit voltage reconstruction — flux estimator needs actual applied voltage

---
**Cross-references:** `wiring-topologies-advanced.md` § DTC, `gain-formulas.md`

---
Copyright 2026 The MathWorks, Inc.

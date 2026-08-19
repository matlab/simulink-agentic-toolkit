# Configuration: Super-Twisting Sliding Mode Speed Control FOC

**Motor:** SPMSM (MCB Surface Mount PMSM)
**Control:** Super-Twisting SMC speed loop (chattering-free), standard PI current loops
**Use case:** Robust speed control with finite-time convergence, matched disturbance rejection

## Architecture
```
Speed_Ref → [ST-SMC] → Tref → id*=0, iq*=Tref/(1.5*p*FluxPM)
id*/iq* - id/iq → PI_d/PI_q → InvPark → Norm(1/Vmax) → PWM_RefGen(SVM) → Duty → Inverter → PMSM
```

## Super-Twisting Control Law
```
s = speed_ref - speed_meas                          (sliding surface)
sign_approx = s / (|s| + epsilon)                   (chattering-free approximation)
Tref = lambda1 * sqrt(|s|) * sign_approx(s) + integral(lambda2 * sign_approx(s))
```

## Key Parameters
| Parameter | Value | Notes |
|---|---|---|
| lambda1 | 1.0 | Proportional gain (sqrt term) |
| lambda2 | 5.0 | Integral gain (sign term) |
| epsilon | 2.0 | Sign smoothing (larger = less chattering) |
| IIR cutoff | 80 Hz | Speed filter |

## Simulink Implementation
- Abs → Sqrt → Product(sqrt(|s|) * sign_approx) → Gain(lambda1) [proportional]
- sign_approx: Divide(s / (|s| + epsilon))
- Gain(lambda2) → Discrete-Time Integrator (Forward Euler, Ts_speed, sat=±T_rated) [integral]
- Add(prop + int) → Saturation(±T_rated) → RT(Ts) → Tref2Iq

## SPMSM id*/iq* (No MTPA needed for SPMSM)
- id* = 0 (constant)
- iq* = Tref / (1.5 * p * FluxPM) (direct torque-to-current conversion)

## Speed Feedback
- BusSel(MtrPos) → MechToElec → SpdMeas → IIR_Spd(80 Hz)
- PMSM/3 terminated

## Default Motor
- SPMSM: p=4, Rs=0.5, Ld=Lq=3mH, FluxPM=0.15, I_rated=10A, J=1e-3
- Vdc=300V, Ts=50us, speed_ref=1500 RPM, load step=3 Nm at t=1.0s

## Things to Avoid
- DO NOT use pure sign() — causes chattering. Always use s/(|s|+eps)
- DO NOT set epsilon too small (<0.01) — chattering returns
- DO NOT set lambda1 too high — high-frequency torque oscillation
- DO NOT forget integrator saturation — unbounded integral causes wind-up

## Pass Criteria
- Steady-state error < 2%, oscillation < 5%
- Finite-time convergence, robust to load step

---
**Cross-references:** `gain-formulas.md` § Sliding Mode, `wiring-topologies.md` § Pattern B

---
Copyright 2026 The MathWorks, Inc.

# Configuration: Backstepping Nonlinear Speed Control FOC

**Motor:** IPMSM (MCB Interior PMSM)
**Control:** Lyapunov-based backstepping speed controller with friction compensation
**Use case:** Applications requiring guaranteed stability margins, robust to parameter variation

## Architecture
```
Speed_Ref → Backstepping Controller → Tref → MTPA(Interior) → id*/iq*
id*/iq* - id/iq → PI_d/PI_q → InvPark → Norm(1/Vmax) → PWM_RefGen → Duty → Inverter → PMSM
```

## Backstepping Control Law
```
e1 = speed_ref - speed_meas
Tref = J*c1*e1 + J*Ki_bs*integral(e1) + B*speed_meas
     = Kp_bs*e1 + Ki_bs_eff*integral(e1) + B_comp*speed_meas
```
- Proportional: physics-based `Kp_bs = J * c1`
- Integral: disturbance rejection `Ki_bs_eff = J * Ki_bs`
- Friction feedforward: `B_comp = B`

## Key Parameters
| Parameter | Value | Notes |
|---|---|---|
| c1 | 100 | Lyapunov gain parameter |
| Ki_bs | 500 | Integral gain for disturbance rejection |
| Kp_bs | J * c1 = 0.1 | Physics-based proportional |
| Ki_bs_eff | J * Ki_bs = 0.5 | Physics-based integral |
| B_comp | B = 1e-4 | Friction compensation |
| IIR cutoff | 50 Hz | Speed filter (critical for overshoot) |

## Simulink Implementation
- Gain(Kp_bs) on speed error
- Discrete-Time Integrator (Forward Euler, Ts_speed, gain=Ki_bs_eff, sat=±T_rated)
- Gain(B_comp) on speed_meas
- Add(+++) three terms → Saturation(±T_rated) → Rate Transition → MTPA

## Speed Feedback
- BusSel outputs: MtrPos (for SpdMeas), MtrElcPos (for Park/InvPark)
- SpdMeas → IIR_Spd (50 Hz) → RT(Ts_speed) → speed loop
- IIR cutoff at 50 Hz is critical — higher causes overshoot

## Default Motor
- IPMSM: p=4, Rs=0.36, Ld=3.5mH, Lq=8mH, FluxPM=0.1714, J=1e-3, B=1e-4
- Vdc=400V, speed_ref=2000 RPM, load step=5 Nm at t=1.0s

## Things to Avoid
- DO NOT omit friction compensation term — causes steady-state offset
- DO NOT use high IIR cutoff (>100 Hz) — causes overshoot in backstepping loop
- DO NOT confuse c1 with Kp_bs — they differ by factor J

## Pass Criteria
- Steady-state error < 2%
- Overshoot < 10%
- Load step recovery without oscillation

---
**Cross-references:** `gain-formulas.md` § Backstepping, `wiring-topologies.md` § Pattern B

---
Copyright 2026 The MathWorks, Inc.

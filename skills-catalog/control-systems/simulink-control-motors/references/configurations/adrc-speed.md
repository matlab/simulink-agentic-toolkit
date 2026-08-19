# Configuration: ADRC Speed Control FOC

**Motor:** IPMSM (MCB Interior PMSM)
**Control:** Extended State Observer (ESO) + ADRC speed loop, standard PI current loops
**Use case:** Servo with large disturbance rejection requirements, parameter uncertainty

## Architecture
```
Speed_Ref → [ADRC: ESO + Controller] → Tref → MTPA → id*/iq*
id*/iq* - id/iq → PI_d/PI_q → InvPark → Norm(1/Vmax) → PWM_RefGen → Duty[3] → Inverter → PMSM
```

## ESO (Extended State Observer)
```
e_obs = y - z1                           (observation error)
z1_dot = z2 + beta1*e_obs + b0*u        (estimated speed)
z2_dot = beta2*e_obs                     (estimated total disturbance)
```

## ADRC Controller
```
u = (Kp_adrc*(ref - z1) - z2) / b0
  = J * (Kp_adrc*(ref - z1) - z2)       (torque command)
```

## Key Parameters
| Parameter | Formula | Typical |
|---|---|---|
| b0 | 1/J | Plant nominal gain |
| omega_o | 2*pi*20 | Observer bandwidth (rad/s) |
| omega_c | 2*pi*8 | Controller bandwidth (rad/s) |
| beta1 | 2*omega_o | ESO gain 1 |
| beta2 | omega_o^2 | ESO gain 2 |
| Kp_adrc | omega_c^2 | Controller proportional |

## Simulink Implementation
- ESO: 2x Discrete-Time Integrator (Forward Euler, Ts_speed)
- z1 limits: ±2*base_speed_rad
- z2 limits: ±2*T_rated*b0
- Gains: beta1, beta2, b0 (standard Gain blocks)
- Controller: Add(ref-z1), Gain(Kp_adrc), Add(Kp*e - z2), Gain(1/b0), Saturation(±T_rated)

## Speed Feedback
- BusSel(MtrPos) → MechToElec → SpdMeas → IIR_Spd (100 Hz cutoff)
- ESO runs at Ts_speed rate (Rate Transition on feedback)
- PMSM/3 terminated (use SpdMeas for proper speed)

## Current Loop
- Standard PI FOC with mcb.calcFOCGains
- MTPA: Units='SI Units', VariantSelect='Interior PMSM'
- PWM path: InvPark → Normalize(1/Vmax) → PWM_RefGen(SVM) → Mux[3] → UnitDelay → Inverter

## Default Motor
- IPMSM: p=4, Rs=0.36, Ld=3.5mH, Lq=8mH, FluxPM=0.1714, J=1e-3
- Vdc=400V, Ts=50us, Ts_speed=500us, speed_ref=2000 RPM

## Things to Avoid
- DO NOT set omega_o > 5*omega_c — observer too aggressive, amplifies noise
- DO NOT omit torque saturation — ADRC can request very large torques during transients
- DO NOT forget b0 update if J changes — ESO accuracy depends on correct plant gain

## Pass Criteria
- Steady-state error < 2%, oscillation < 3%
- Fast disturbance rejection (5 Nm load step at t=1.0s)

---
**Cross-references:** `gain-formulas.md` § ADRC, `wiring-topologies.md` § Pattern B

---
Copyright 2026 The MathWorks, Inc.

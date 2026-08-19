# Configuration: Deadbeat (Predictive) Current Control FOC

**Motor:** IPMSM or SPMSM (MCB Interior PMSM / Surface Mount PMSM)
**Control:** Model-based one-step voltage prediction (replaces PI current loops)
**Use case:** Maximum current-loop bandwidth, applications needing fastest possible response

## Architecture
```
Speed_Ref → Speed_PI → Tref → MTPA → id*/iq*
Deadbeat Vd = Rs*id_ref + Ld*(id_ref - id)/Ts - ωe*Lq*iq
Deadbeat Vq = Rs*iq_ref + Lq*(iq_ref - iq)/Ts + ωe*(Ld*id + FluxPM)
Vd/Vq → Sat → InvPark → InvClarke → Mux[3] → UnitDelay → PMSM
```

## Deadbeat Equations
| Axis | Formula | Terms |
|---|---|---|
| d | `Vd = Rs*id_ref + Ld*(id_ref-id)/Ts - ωe*Lq*iq` | Resistive + Predictive - Cross-coupling |
| q | `Vq = Rs*iq_ref + Lq*(iq_ref-iq)/Ts + ωe*(Ld*id + FluxPM)` | Resistive + Predictive + BEMF |
| ωe | `p * ωm` | Electrical speed from mechanical |

## Simulink Implementation (NO MATLAB Function blocks)
- Gain(Rs) on id_ref/iq_ref for resistive drop
- Gain(Ld/Ts) on (id_ref-id) for d-axis predictive term
- Gain(Lq/Ts) on (iq_ref-iq) for q-axis predictive term
- Product(ωe, Lq*iq) for d-axis cross-coupling
- Product(ωe, Ld*id+FluxPM) for q-axis BEMF+coupling
- Saturation blocks clamp Vd/Vq to [-Vmax, Vmax]

## Voltage Path
```
Sat_Vd/Sat_Vq → InvPark(θe) → InvClarke → Mux[3] → UnitDelay → PMSM/2
```
- Direct voltage to PMSM (no Average-Value Inverter needed for simulation)
- UnitDelay on voltage path breaks algebraic loop

## Speed Loop
- Standard PI speed controller with torque saturation
- Speed from PMSM/3 → IIR filter (50 Hz) → speed PI
- Angle from BusSel(MtrElcPos) on PMSM Info bus

## Default Motor
- IPMSM: p=4, Rs=0.36, Ld=3.5mH, Lq=8mH, FluxPM=0.1714, I_rated=12A
- High-speed variant: p=2, Rs=0.1, Ld=Lq=0.5mH, FluxPM=0.05, Vdc=300V
- Ts=50us, speed_ref=2000 RPM

## Strengths and Limitations
| Strength | Limitation |
|---|---|
| Fastest current response (1-sample settling) | Sensitive to parameter mismatch |
| No PI tuning needed | Requires accurate Rs, Ld, Lq |
| Built-in cross-coupling compensation | Computational delay adds 1 extra sample |
| No integrator windup | No integral action → offset with param error |

## Things to Avoid
- DO NOT use with uncertain motor parameters — deadbeat amplifies model errors
- DO NOT omit voltage saturation — unbounded voltages destroy plant
- DO NOT forget UnitDelay — algebraic loop between voltage and current
- DO NOT use for ACIM — different voltage equations required

## Pass Criteria
- Steady-state error < 2%, oscillation < 3%
- Current settling within 1-2 samples (verify with current waveform)

---
**Cross-references:** `gain-formulas.md` § Deadbeat, `wiring-topologies.md` § Pattern B

---
Copyright 2026 The MathWorks, Inc.

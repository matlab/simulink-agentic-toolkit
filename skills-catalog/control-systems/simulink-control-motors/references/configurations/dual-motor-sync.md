# Configuration: Dual Motor Synchronized FOC

**Motor:** 2x IPMSM (MCB Interior PMSM)
**Control:** Independent speed loops sharing common reference + rate-limited ramp
**Use case:** Gantry, conveyor, synchronized motion (master-slave)

## Architecture
```
Speed_Ref → Rate Limiter → Speed_Err1 → Speed_PI1 → MTPA1 → FOC1 → PMSM1 (TL=10 Nm)
                         → Speed_Err2 → Speed_PI2 → MTPA2 → FOC2 → PMSM2 (TL=40 Nm)
Both motors track same reference; different loads test regulation.
```

## Key Design Choices
| Choice | Value | Reason |
|---|---|---|
| Rate Limiter | ±80 rad/s² | Smooth acceleration |
| Speed PI BW | 2*pi*10 rad/s | Moderate for sync |
| Speed PI sat | 0.8 * T_rated | Prevent current limit |
| IIR cutoff | 20 Hz | Heavy filtering for sync stability |
| Speed feedback | BusSel(MtrSpd) → IIR | Direct from Info bus |

## Per-Motor FOC Chain
Each motor has independent:
- Speed PI → RT(Ts) → MTPA(Interior) → Err_d/Err_q → PI_d/PI_q
- InvPark → InvClarke → Mux[3] → V2D(1/(2*Vdc/sqrt(3))) → Bias(0.5) → Avg-Value Inverter
- Clarke → Park (using BusSel MtrElcPos for angle)

## Voltage Scaling (V2D Pattern)
```
Gain = 1/(2*Vdc/sqrt(3))    % Voltage to duty conversion
Bias = 0.5                   % Center at 50% duty
```

## Default Motor
- IPMSM: p=6, Rs=0.002, Ld=0.15mH, Lq=0.32mH, FluxPM=0.1714, I_rated=283A
- Vdc=500V, N_base=4910 RPM
- TL1=10 Nm (light), TL2=40 Nm (heavy)
- Target: 1000 RPM

## Things to Avoid
- DO NOT use very high speed PI bandwidth — causes oscillation between motors
- DO NOT omit Rate Limiter — sudden steps cause current spikes in both motors
- DO NOT use different PI gains for each motor — causes sync error drift

## Pass Criteria
- Both motors track reference within 5%
- Sync error |M1-M2| < 2% despite asymmetric loads

---
**Cross-references:** `wiring-topologies.md` § Pattern B (duplicated per motor)

---
Copyright 2026 The MathWorks, Inc.

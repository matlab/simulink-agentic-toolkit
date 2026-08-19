# Configuration: BLDC Hall-Sensor Six-Step Commutation

**Motor:** BLDC (MCB BLDC block, trapezoidal BEMF)
**Control:** Hall-based 120 deg six-step commutation + speed PI (duty output)
**Use case:** Standard BLDC drives with Hall position sensors

## Architecture
```
Speed_Ref -> Speed_PI -> Duty -> x Vdc -> BLDC Avg-Value Inverter <- Six Step <- Hall Emulation
                                                                                      |
                                                                                BLDC Info bus
Speed feedback: BLDC/3 (MtrSpd) -> DTC(double) -> IIR -> Speed PI
```

## Hall Emulation (for MCB BLDC block)

MCB BLDC block does not output Hall signals directly. Emulate from Info bus:
```
BusSel(MtrElcPos) -> 1-D LUT (theta_e -> sector 1-6) -> Six Step Commutation
LUT: BP=[0, pi/3, 2*pi/3, pi, 4*pi/3, 5*pi/3, 2*pi]
     Table=[5, 4, 6, 2, 3, 1, 5], Interp=Flat
```

## Solver
- `ode4` (Runge-Kutta) with fixed step = Ts
- NOT FixedStepDiscrete (BLDC block requires continuous solver)
- `BlockSampleTime` on BLDC block is critical — without it, solver crashes

## Block Configuration

### BLDC (`mcblib/.../BLDC`)
| Parameter | Value | Notes |
|---|---|---|
| SimType | `'Discrete'` | |
| BlockSampleTime | `Ts` | CRITICAL — must set explicitly |
| MechInput | `'Torque'` | |
| p, Rs, Ld, Lq, Lambda, J, B | Motor params | |

### Six Step Commutation
| Parameter | Value |
|---|---|
| InputType | `'Hall'` (integer 1-6) |
| CommutationMode | `'120 deg'` |

### Speed PI (duty-cycle output)
| Parameter | Formula |
|---|---|
| Kp | `Lambda*p/Vdc * 2` |
| KiTs | `Kp * 10 * Ts_speed` |
| Saturation | [0.05, 0.95] |
| InitialCondition | `duty_min` |

## Critical Data Types
- Six Step output: boolean [6x1] → MUST DTC to double before BLDC_Inv
- BLDC MtrSpd (port 3): single → DTC to double before arithmetic
- Duty x Vdc: Product block (duty from PI x Vdc constant)

## Algebraic Loop Fix
- Unit Delay on voltage path: BLDC_Inv → Delay_V → BLDC/2 (MANDATORY)

## Default Motor
- BLDC: p=4, Rs=0.36, Ld=Lq=0.2mH, Lambda=0.0064 Wb
- Vdc=24V, I_rated=8A, J=7.06e-6, Ts=25us
- Speed ref: 3000 RPM, load step at t=2s

## Things to Avoid
- DO NOT use FixedStepDiscrete solver with BLDC block
- DO NOT forget BlockSampleTime on BLDC — different from global Ts!
- DO NOT connect boolean Six Step output directly to inverter — DTC required
- DO NOT omit UnitDelay on voltage path — algebraic loop crash
- DO NOT confuse Lambda (BLDC peak flux linkage) with FluxPM (PMSM RMS flux)

## Pass Criteria
- Steady-state error < 5%
- Smooth commutation (no torque spikes > 2x rated)

---
**Cross-references:** `wiring-topologies.md` § BLDC, `gain-formulas.md` § BLDC Six-Step

---
Copyright 2026 The MathWorks, Inc.

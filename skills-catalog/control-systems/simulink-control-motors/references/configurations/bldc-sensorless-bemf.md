# Configuration: BLDC Sensorless Back-EMF Zero-Crossing

**Motor:** BLDC (MCB BLDC block, trapezoidal BEMF)
**Control:** Custom BEMF ZC detection + Six Step Commutation + Speed PI (duty output)
**Use case:** Cost-sensitive applications without Hall sensors (fans, drones)

## Architecture
```
Speed_Ref → Speed_PI → Duty → ×Vdc → BLDC Avg-Value Inverter ← Six Step ← Switch
                                                                    ↗            ↖
                                                           BEMF_ZC sector   OL forced sector
                                                        (polarity detection)  (time ramp → LUT)
Handoff: speed > threshold → switch from OL to BEMF ZC
```

## Why NOT MCB "Sensorless Six-Step Commutation" Block
The MCB SSL block requires measured terminal voltages showing BEMF on the floating phase.
BLDC Average-Value Inverter does NOT model floating phases (all 3 always driven).
SSL's internal ZC detector overflows and never transitions. Must use custom ZC detection.

## BEMF Zero-Crossing Detection (MATLAB Function)
1. BLDC Info bus contains `BackEMF` field [3x1] = [ea; eb; ec]
2. Check polarity: pa=(ea>0), pb=(eb>0), pc=(ec>0)
3. Encode: code = pa*4 + pb*2 + pc
4. Map to sector: {5→1, 4→2, 6→3, 2→4, 3→5, 1→6}
5. Output feeds Six Step Commutation block (same as Hall input)

## Open-Loop Startup
- Ramp → mod(2π) → 1-D LUT → forced sector
- LUT: BP=[0,π/3,2π/3,π,4π/3,5π/3,2π], Table=[5,4,6,2,3,1,5], Flat interp
- Handoff: Compare To Constant (speed > 15 rad/s) → Switch
- Switch: port1=ZC sector (true), port3=OL sector (false)

## Block Configuration

### BLDC (`mcblib/.../BLDC`)
| Parameter | Value |
|---|---|
| SimType | `'Discrete'` |
| BlockSampleTime | `Ts` |
| MechInput | `'Torque'` |
| p, Rs, Ld, Lq, Lambda, J, B | Motor params |

### Six Step Commutation
| Parameter | Value |
|---|---|
| InputType | `'Hall'` |
| CommutationMode | `'120 deg'` |

### Speed PI (duty output)
| Parameter | Value |
|---|---|
| Output range | [0.05, 0.95] |
| Kp | duty_per_radps * 2 |
| KiTs | Kp * 10 * Ts_speed |

## Critical Data Type Notes
- Six Step output is boolean [6x1] → MUST add DTC(double) before BLDC_Inv
- BLDC MtrSpd (port 3) is single → add DTC(double) before PI/Sum
- MATLAB Function bemf_abc input must be declared as size '3'

## Algebraic Loop Fix
- Unit Delay on voltage path: BLDC_Inv → Delay_V → BLDC/2
- MANDATORY for BLDC discrete plant with Six Step feedback

## Solver
- `ode4` (NOT FixedStepDiscrete — BLDC block requires continuous solver with fixed step)
- BlockSampleTime on BLDC block is critical

## Default Motor
- BLDC: p=4, Rs=0.36, Ld=Lq=0.2mH, Lambda=0.0064 Wb, Vdc=24V
- Ts=25us, speed_ref=1000 RPM, handoff=15 rad/s

## Things to Avoid
- DO NOT use MCB SSL block with Average-Value Inverter — ZC detection fails
- DO NOT omit DTC(double) after Six Step — boolean → BLDC_Inv type mismatch
- DO NOT set handoff threshold too low — BEMF too weak for reliable ZC
- DO NOT forget to set MATLAB Function input size to '3' — defaults to scalar

## Pass Criteria
- Steady-state error < 5%, oscillation < 15%
- Smooth OL→ZC handoff without stall

---
**Cross-references:** `wiring-topologies.md` § BLDC, `gain-formulas.md` § BLDC Six-Step

---
Copyright 2026 The MathWorks, Inc.

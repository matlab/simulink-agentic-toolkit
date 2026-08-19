# Architecture Pattern Selection Guide

> High-level overview of MCB architecture patterns (A-H).
> For detailed wiring, see `references/wiring/wiring-topologies.md`.
> For block parameters, see `references/block-config/block-configurations.md`.

---

## Pattern Overview

| Pattern | Name | Use Case | Complexity | Block Count (approx) |
|---------|------|----------|------------|---------------------|
| A | Manual PI FOC | Gain scheduling, feedforward, custom current controllers | Medium | 25-40 |
| B | FOC CC Block | Compact FOC using `Field-Oriented Current Controller` block | Low | 15-25 |
| C | Torque-Only | No speed loop — direct torque command (EPS, haptics) | Low | 15-20 |
| D | Position Control | Cascaded P-PI-PI loops — servo, robotics | High | 35-50 |
| E | V/f Open-Loop | Simple scalar control — pumps, fans (ACIM) | Minimal | 8-12 |
| F | BLDC Six-Step | Trapezoidal commutation — low-cost BLDC | Medium | 20-30 |
| G | Simscape Plant | High-fidelity Simscape Electrical plant model | High | 30-45 |
| H | DTC | Direct Torque Control — hysteresis-based | Medium | 25-35 |

---

## Pattern A: Manual PI FOC (Speed Control)

**Signal flow:**
```
Speed_ref → PI_speed → Tref → [MTPA/ControlRef] → Id_ref, Iq_ref
                                                        ↓
Sensor/Observer → θe, ωm → IIR_Spd → PI_speed     Park ← Ia, Ib (Clarke ← PMSM)
                                                        ↓
                              Id, Iq → PI_d, PI_q → Vd, Vq → InvPark → InvClarke → Vabc → [Inverter] → PMSM
```

**When to use:**
- Gain scheduling with operating-point-dependent PI gains (2-D LUTs → external gain ports)
- Feedforward voltage compensation (nonlinear flux decoupling)
- Custom current controllers (deadbeat, MPC, sliding mode)
- Educational/demonstration purposes (showing FOC internals)

**WARNING:** Pattern A with **MCB discrete PMSM plant** in closed-loop speed control causes structural oscillation that CANNOT be tuned out. For standard speed-FOC with MCB discrete plant, use **Pattern B** instead. Pattern A works correctly with Simscape plants (ode14x solver breaks the algebraic loop) and is required when FOC CC's fixed-gain structure is insufficient (e.g., gain scheduling).

**Key blocks:** Clarke Transform, Park Transform (Clarke to Park Angle Transform), Inverse Park (Park to Clarke Angle Transform), Inverse Clarke Transform, PI Controller ×3 (speed, id, iq), MTPA/LUT Control Reference, Average-Value Inverter, Interior/Surface PMSM

**Gain computation:** `mcb.calcFOCGains(pmsm, Ts, Ts_speed)` → PI_Params struct

---

## Pattern B: FOC CC Block

**Signal flow:**
```
Speed_ref → PI_speed → Tref → [ControlRef] → IdqRef[2]
                                                   ↓
Sensor → θe, ωm → IIR_Spd → PI_speed         FOC CC ← IabMeas[2], θe, Vsat, Kp_KiTs[4], PIConfig[4]
                                                   ↓
                                              Vabc[3] → V2D → Inverter → PMSM
```

**When to use:**
- Simpler topology — FOC CC encapsulates Park, InvPark, PI_d, PI_q, decoupling
- Fewer blocks to wire (single block replaces ~8 individual blocks)
- Official MCB pattern in most shipped examples
- Best when using PWM Reference Generator downstream

**Key blocks:** Field-Oriented Current Controller, PI Controller (speed), MTPA/LUT Control Reference, PWM Reference Generator (optional), Average-Value Inverter, PMSM

**FOC CC ports (CRITICAL):** u1=IdqRef[2], u2=IabMeas[2], u3=theta_e[1], u4=Vsat[1], u5=Kp_KiTs[4], u6=PIConfig[4], u7=Enable[1]. Out1=Vabc[3], Out2=Debug[2]

**FOC CC output is VOLTS** (±Vdc/sqrt(3)). Needs V2D conversion before Average-Value Inverter:
```
Duty = Vabc * 1/(2*Vdc/sqrt(3)) + 0.5
```

---

## Pattern C: Torque-Only (No Speed Loop)

**Signal flow:**
```
Torque_cmd → [ControlRef] → Id_ref, Iq_ref → [Current Loop (A or B)] → Vabc → Inverter → PMSM
```

**When to use:**
- Electric power steering (EPS) — torque assist
- Haptic feedback devices
- Collaborative robots (impedance control)
- External speed/position loop in higher-level controller

**Difference from A:** Remove speed PI and speed feedback path. Torque command feeds directly to control reference.

---

## Pattern D: Position Control (Cascaded)

**Signal flow:**
```
Pos_ref → P_pos → Speed_ref → PI_speed → Tref → [ControlRef] → IdqRef → [Current Loop] → PMSM
                       ↑                                                           ↓
                   Position feedback ←──────────── Encoder/Observer ←──────────────┘
```

**When to use:**
- Servo positioning (CNC, robot joints)
- S-curve/trapezoidal motion profiles
- Crane, elevator, gimbal stabilization

**Key addition:** Position P-controller (proportional only) cascaded outside speed loop. Optional feedforward for improved tracking.

---

## Pattern E: V/f Open-Loop

**Signal flow:**
```
Speed_ref → Ramp → Freq → [VbyF Controller] → Vabc → ACIM
```

**When to use:**
- Simple ACIM/PMSM drives (pumps, fans)
- No position/speed feedback needed
- Lowest cost, minimal sensors
- Often used as startup mode before transitioning to FOC

**Key block:** `VbyF Controller` — outputs 3-phase voltages directly (no inverter block needed for simulation). V/f ratio maintains constant flux.

---

## Pattern F: BLDC Six-Step

**Signal flow:**
```
Speed_ref → PI_speed → DutyRef → [Six-Step Commutation] → Duty[6] → BLDC Motor
                                        ↑
                            Hall sensors / BEMF zero-crossing
```

**When to use:**
- BLDC motors with trapezoidal back-EMF
- Low-cost drives (ceiling fan, consumer appliances)
- Hall sensor or sensorless (BEMF) commutation

**Key blocks:** Sensorless Six-Step Commutation (or Hall-based commutation logic), BLDC motor block

---

## Pattern G: Simscape Electrical Plant

**Signal flow:**
```
[Any controller pattern A-D] → Vabc → [Simscape Bridge] → CVS3 → PMSM(Simscape) → Shaft
                                                                         ↓
                                                   Current Sensor 3 → CS3 → [PS2S] → Iab feedback
                                                   IRMS → speed, angle feedback
```

**When to use:**
- High-fidelity plant with parasitics, thermal, switching
- Simscape FEM-Parameterized PMSM (nonlinear flux maps)
- Mixed continuous/discrete simulation
- Validation against detailed physics

**Key additions:** Controlled Voltage Source 3 (CVS3), Current Sensor 3 (CS3), Ideal Rotational Motion Sensor (IRMS), Simscape Solver Configuration, S2PS/PS2S converters

**Solver:** Must use `ode14x` (implicit) — NOT ode4 or FixedStepDiscrete

---

## Pattern H: Direct Torque Control (DTC)

**Signal flow:**
```
Torque_ref, Flux_ref → [Hysteresis Comparators] → [Switching Table] → Inverter state → PMSM
                              ↑                                              ↓
                     Flux Observer ← Vabc, Iabc ←────────────────────────────┘
```

**When to use:**
- Fast torque response without current loop tuning
- Flux and torque controlled independently
- Higher torque ripple but faster dynamics than FOC

**Key blocks:** Flux Observer, hysteresis comparators (relay blocks), switching table lookup, PMSM

**Reference example:** `mcb/DirectTorqueControlOfPMSMQuadratureEncoderFluxObserverExample`

---

## Pattern Selection Decision

```
Is speed/position feedback available?
├─ NO → Pattern E (V/f) or Pattern F (BLDC sensorless)
└─ YES
    ├─ Motor = BLDC with trapezoidal BEMF? → Pattern F
    ├─ Need direct torque control? → Pattern H (DTC)
    ├─ Need torque-only (no speed loop)? → Pattern C
    ├─ Need position control? → Pattern D
    ├─ Need gain scheduling or custom current control? → Pattern A (Manual PI)
    ├─ Standard FOC (fixed gains)? → Pattern B (FOC CC) — DEFAULT for speed control
    └─ Need Simscape plant fidelity? → Pattern G (with A or B controller)
```

---

## Pattern Migration

| From | To | What Changes |
|------|----|-------------|
| A → B | Replace Park+InvPark+PI_d+PI_q+decoupling with single FOC CC block | Fewer blocks, same performance |
| B → A | Expand FOC CC into individual blocks | More flexibility for gain scheduling |
| A → D | Add position P-loop outside speed loop | Keep all of A, add outer cascade |
| A → G | Replace MCB PMSM with Simscape PMSM + bridge blocks | Controller unchanged, plant higher fidelity |
| E → A | Replace V/f with full FOC (major redesign) | Typically for commissioning → production |
| A → H | Replace current PI loops with hysteresis + switching table | Different control philosophy |

---

## Feature Compatibility Matrix

| Feature | A | B | C | D | E | F | G | H |
|---------|---|---|---|---|---|---|---|---|
| +FW (Field Weakening) | Y | Y | — | Y | — | — | Y | — |
| +SMO (Sensorless) | Y | Y | Y | — | — | — | Y | — |
| +EEMF (Ext. EMF Obs.) | Y | Y | Y | — | — | — | Y | — |
| +HFI (High-Freq Inj.) | Y | Y | — | — | — | — | Y | — |
| +IF (I-F Startup) | Y | Y | — | — | — | — | Y | — |
| +GainSched | Y | — | — | Y | — | — | Y | — |
| +FF (FeedForward) | Y | Y | — | Y | — | — | Y | — |
| +OVM (Overmodulation) | Y | Y | — | Y | — | — | Y | — |
| +PWM (PWM Ref Gen) | Y | Y | — | Y | — | — | Y | — |
| +Protection | Y | Y | Y | Y | Y | Y | Y | Y |

**Note:** Pattern B does not support external gain scheduling because FOC CC uses internal PI gains (Kp_KiTs port). For gain-scheduled nonlinear control, use Pattern A with `slpidlib/PID Controller` in external-gains mode.

---

## Related Resources

- Detailed wiring for each pattern: `references/wiring/wiring-topologies.md`
- Feature composition rules: `references/wiring/composition-rules*.md`
- Block configuration details: `references/block-config/block-configurations.md`
- Constraint curves (operating envelope): `references/design/constraint-curves.md`
- Sensorless observers: `references/sensorless/sensorless-blocks.md`

----
Copyright 2026 The MathWorks, Inc.
----

# Configuration: ACIM Simscape Plant with MCB Controller

**Motor:** Simscape Induction Machine (Squirrel Cage) — continuous physics
**Control:** MCB-based indirect RFOC controller (discrete)
**Use case:** High-fidelity ACIM simulation with Simscape electrical/mechanical domain

## Architecture
```
MCB Controller (discrete, Ts) ←→ Interface ←→ Simscape IM Plant (continuous, ode14x)
Controller: Speed_PI → id*/iq* → PI_d/PI_q → InvPark → InvClarke → Vabc
Interface: Controlled Voltage Source (3-phase) + Current Sensor (3-phase)
Plant: Simscape IM + Mechanical Load + Solver Configuration
```

## Simscape Plant Blocks
| Block | Library | Purpose |
|---|---|---|
| Induction Machine (Squirrel Cage) | Simscape Electrical / Machines | IM plant |
| Controlled Voltage Source (3-phase) | Simscape Electrical / Sources | Vabc input |
| Current Sensor (3-phase) | Simscape Electrical / Sensors | Iabc measurement |
| Grounded Neutral | Simscape Electrical / Connectors | Star point |
| Solver Configuration | Simscape / Utilities | Required for network |
| Mechanical Rotational Reference | Simscape / Foundation | Ground for R port |
| Ideal Rotational Motion Sensor | Simscape / Foundation / Sensors | Speed/angle |
| Inertia | Simscape / Foundation / Mechanical | J load |
| Rotational Damper | Simscape / Foundation / Mechanical | B friction |

## Solver Requirements
- Must use `ode14x` (implicit) for Simscape networks
- FixedStepDiscrete will FAIL with Simscape blocks
- Single Solver Configuration covers entire network

## Interface Pattern
```
CVS3(+) ← Vabc from controller
CVS3(-) → IM stator terminals
CS3 on stator lines → Iabc to controller (Clarke → Park)
IM rotor port → IRMS (speed/angle) → controller feedback
IM mechanical R port → Inertia + Damper + Mech Reference
```

## Controller Side (same as standard RFOC)
- Slip calculation for θe
- PI current loops
- Speed PI with reduced gains (SpdLoopFactor=0.5)

## Things to Avoid
- DO NOT use FixedStepDiscrete solver — Simscape requires implicit solver
- DO NOT forget Solver Configuration block — model won't compile
- DO NOT connect Simscape and Simulink directly — use PS-Simulink/Simulink-PS converters
- DO NOT expect exact match with MCB discrete IM — Simscape models continuous dynamics

---
**Cross-references:** `simscape-plant-patterns.md` § ACIM, `solver-settings-by-plant.md`

---
Copyright 2026 The MathWorks, Inc.

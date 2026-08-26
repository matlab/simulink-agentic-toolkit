# Library Reuse Index

## Priority

1. Custom library blocks (highest priority)
2. Toolbox KB blocks

## Policy

- Always use custom library blocks when available.
- Never fall back to built-in primitives if the same block exists in a declared library.
- Only use built-in blocks when NO equivalent exists in any declared library after searching this index.
- Do not invent custom block names.
- If uncertain, inspect the relevant category page or ask the user.

## Libraries

- Motor Control Blockset

Common blocks: [common.md](common.md) (15 of 80 blocks)

## Categories

- [Control references](control-references.md) — 17 blocks; Torque/current/speed reference generators and feed-forward blocks that produce commands for FOC and vector control loops
- [Controllers](controllers.md) — 8 blocks; Closed-loop current, speed, and voltage controllers plus autotuning and gain-selection helpers
- [Math transforms](math-transforms.md) — 12 blocks; Clarke/Park and multi-phase transforms, PWM math, and trig utilities used inside FOC and vector-control math paths
- [Inverters](inverters.md) — 2 blocks; Average-value inverter models that convert DC bus voltage and modulation signals into three-phase output for simulation
- [Motors](motors.md) — 4 blocks; Electric machine models for BLDC, induction, and PMSM motors used as plants in motor-control simulations
- [Parameter estimation](parameter-estimation.md) — 10 blocks; Blocks that identify motor electrical and mechanical parameters (Rs, Ld, Lq, Rr, inertia, friction) from measured data
- [Protection diagnostics](protection-diagnostics.md) — 4 blocks; Host-side serial communication and protection/diagnostic utilities for embedded motor-control targets
- [Sensor decoders](sensor-decoders.md) — 7 blocks; Position/speed decoders for Hall, quadrature encoder, and resolver sensors, plus watchdog and speed-measurement helpers
- [Sensorless estimators](sensorless-estimators.md) — 4 blocks; Rotor position and speed observers that eliminate the need for a physical position sensor
- [Signal management](signal-management.md) — 12 blocks; Signal packing, filtering, PLLs, dead-time compensation, and protocol codecs for embedded motor-control signal paths

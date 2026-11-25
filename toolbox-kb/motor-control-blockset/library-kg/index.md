---
okf_version: "0.2"
---

# Simulink Block Category

* [Control references](control-references.md) - Torque/current/speed reference generators and feed-forward blocks that produce commands for FOC and vector control loops (17 blocks)
* [Controllers](controllers.md) - Closed-loop current, speed, and voltage controllers plus autotuning and gain-selection helpers (8 blocks)
* [Inverters](inverters.md) - Average-value inverter models that convert DC bus voltage and modulation signals into three-phase output for simulation (2 blocks)
* [Math transforms](math-transforms.md) - Clarke/Park and multi-phase transforms, PWM math, and trig utilities used inside FOC and vector-control math paths (12 blocks)
* [Motors](motors.md) - Electric machine models for BLDC, induction, and PMSM motors used as plants in motor-control simulations (4 blocks)
* [Parameter estimation](parameter-estimation.md) - Blocks that identify motor electrical and mechanical parameters (Rs, Ld, Lq, Rr, inertia, friction) from measured data (10 blocks)
* [Protection diagnostics](protection-diagnostics.md) - Host-side serial communication and protection/diagnostic utilities for embedded motor-control targets (4 blocks)
* [Sensor decoders](sensor-decoders.md) - Position/speed decoders for Hall, quadrature encoder, and resolver sensors, plus watchdog and speed-measurement helpers (7 blocks)
* [Sensorless estimators](sensorless-estimators.md) - Rotor position and speed observers that eliminate the need for a physical position sensor (4 blocks)
* [Signal management](signal-management.md) - Signal packing, filtering, PLLs, dead-time compensation, and protocol codecs for embedded motor-control signal paths (12 blocks)

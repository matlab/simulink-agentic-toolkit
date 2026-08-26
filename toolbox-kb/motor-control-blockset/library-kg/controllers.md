---
type: Simulink Block Category
title: Controllers
description: Closed-loop current, speed, and voltage controllers plus autotuning and gain-selection helpers
tags: [PI, FOC, controller, autotuner, gain, I-F, V/F]
status: stable
source: mathworks_toolbox
library_root: Motor Control Blockset
category_path: Controllers
block_count: 8
---

# Controllers

Use these blocks for controllers.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Derating Function | mcblib/Controls/Controllers/Derating Function | R2023a+ | Reduce a torque or current command based on temperature, DC bus voltage, or other limits — use to keep the drive within safe operating limits without abrupt shutoff |
| FOC Default Controller Gains | mcblib/Controls/Controllers/FOC Default Controller Gains | R2023b+ | Compute default PI gains for current, speed, and flux loops from motor parameters and bandwidth targets — use as a starting point before autotuning or hand tuning |
| Field Oriented Control Autotuner | mcblib/Controls/Controllers/Field Oriented Control Autotuner | R2023a+ | Run a closed-loop system-identification and gain-tuning routine on a live FOC drive — use to derive current, speed, and field-weakening PI gains automatically on target hardware |
| Field-Oriented Current Controller | mcblib/Controls/Controllers/Field-Oriented Current Controller | R2023b+ | Regulate d and q axis currents to their references with decoupled PI loops and voltage limiting — use as the inner current loop of any FOC-based motor drive |
| I-F Controller | mcblib/Controls/Controllers/I-F Controller | R2024a+ | Drive a PMSM in open-loop current mode with a rotating angle ramp — use during sensorless startup before the position observer converges |
| PI Controller | mcblib/Controls/Controllers/PI Controller | R2023a+ | Discrete PI controller with anti-windup and output saturation tailored for motor-control loops — use to build custom current, speed, position, or flux regulators |
| Sensorless Six-Step Commutation | mcblib/Controls/Controllers/Sensorless Six-Step Commutation | R2025a+ | Perform BLDC six-step commutation using back-EMF zero-crossing detection instead of Hall sensors — use for low-cost BLDC drives without position feedback |
| VbyF Controller | mcblib/Controls/Controllers/VbyF Controller | R2023b+ | Produce a stator voltage reference proportional to frequency for scalar V/F control of induction motors — use when full-vector control is unnecessary, e.g. fans and pumps |

---
type: Simulink Block Category
title: Math transforms
description: Clarke/Park and multiphase transforms plus modulation
tags: [math transforms, clarke, park, vsd, pwm, atan2]
status: stable
source: custom_library
library_root: Motor Control Blockset HDL Support
category_path: Math transforms
block_count: 8
---

# Math transforms

Use these blocks for math transforms.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| 6-Phase Inverse VSD Transform | mcbhdllib/Controls/Math Transforms/6-Phase Inverse VSD Transform | R2024b+ | Transform vector-space (d-q-x-y-z-0) components back to six-phase quantities — use to reconstruct phase references for a six-phase machine. |
| 6-Phase VSD Transform | mcbhdllib/Controls/Math Transforms/6-Phase VSD Transform | R2024b+ | Decompose six-phase currents/voltages into vector-space (d-q-x-y-z-0) components — use for control of six-phase machines. |
| Clarke Transform | mcbhdllib/Controls/Math Transforms/Clarke Transform | R2023a+ | Transform three-phase (abc) quantities to the stationary two-axis (αβ) frame — use as the first step of field-oriented control. |
| Inverse Clarke Transform | mcbhdllib/Controls/Math Transforms/Inverse Clarke Transform | R2023a+ | Transform stationary two-axis (αβ) quantities back to three-phase (abc) — use to produce phase voltage references. |
| Inverse Park Transform | mcbhdllib/Controls/Math Transforms/Inverse Park Transform | R2023a+ | Transform rotating d-q quantities to the stationary αβ frame using the rotor angle — use to convert controller outputs back for modulation. |
| PWM Reference Generator | mcbhdllib/Controls/Math Transforms/PWM Reference Generator | R2023a+ | Generate PWM duty-cycle references (e.g., space-vector PWM) from voltage commands — use to drive the inverter switching stage. |
| Park Transform | mcbhdllib/Controls/Math Transforms/Park Transform | R2023a+ | Transform stationary two-axis (αβ) quantities to the rotating d-q frame using the rotor angle — use to obtain DC-like control variables in FOC. |
| atan2 | mcbhdllib/Controls/Math Transforms/atan2 | R2023a+ | Compute the four-quadrant arctangent — use to derive an angle from αβ components, such as a flux or position angle. |

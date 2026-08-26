---
type: Simulink Block Category
title: Motors
description: Electric machine models for BLDC, induction, and PMSM motors used as plants in motor-control simulations
tags: [motor, PMSM, BLDC, induction, machine, plant]
status: stable
source: mathworks_toolbox
library_root: Motor Control Blockset
category_path: Motors
block_count: 4
---

# Motors

Use these blocks for motors.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| BLDC | mcblib/Electrical Systems/Motors/BLDC | R2023a+ | Trapezoidal back-EMF permanent-magnet motor model — use as the plant in six-step commutated BLDC drive simulations |
| Induction Motor | mcblib/Electrical Systems/Motors/Induction Motor | R2023a+ | Squirrel-cage induction machine model with configurable equivalent-circuit parameters — use as the plant for scalar V/F, direct torque, or vector-control simulations |
| Interior PMSM | mcblib/Electrical Systems/Motors/Interior PMSM | R2023a+ | Interior permanent-magnet synchronous machine model with saliency (Ld ≠ Lq) — use as the plant for MTPA, field-weakening, and reluctance-torque studies |
| Surface Mount PMSM | mcblib/Electrical Systems/Motors/Surface Mount PMSM | R2023a+ | Surface-mount permanent-magnet synchronous machine model with symmetric d/q inductance — use as the plant for FOC studies on non-salient PMSMs |

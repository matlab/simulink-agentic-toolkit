---
type: Simulink Block Category
title: Disturbance estimation
description: Disturbance observers and compensators
tags: [disturbance, observer, extended, ultra-local, compensator]
status: stable
source: mathworks_toolbox
library_root: Simulink Control Design
category_path: Disturbance estimation
block_count: 3
---

# Disturbance estimation

Use these blocks for disturbance estimation.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Disturbance Compensator | slctrl_disturbance/Disturbance Compensator | R2024a+ | Estimate and cancel disturbances acting on the plant — use for feedforward rejection of estimated load disturbances |
| Extended State Observer | slctrl_disturbance/Extended State Observer | R2026a+ | Estimate plant states and lumped disturbance — use for reconstructing unmeasured states and total disturbance for ADRC |
| Ultra-Local Model | slctrl_disturbance/Ultra-Local Model | R2026a+ | Approximate plant as a simple integrator chain — use for model-free control design when only input-output data is available |

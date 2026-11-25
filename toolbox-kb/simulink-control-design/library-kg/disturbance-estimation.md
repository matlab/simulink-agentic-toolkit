---
type: Simulink Block Category
title: Disturbance estimation
description: Disturbance observers and compensators (3 blocks)
tags: [toolbox-kb, simulink-control-design, disturbance, observer, extended, ultra-local, compensator]
status: stable
sources:
  - resource: matlab:slctrl_disturbance
source: toolbox_kb
managed_by: satk
library: Simulink Control Design
kb_folder: simulink-control-design
category: disturbance-estimation
block_count: 3
generated: { by: satk-toolbox-build/1, at: "2026-11-23T18:23:30Z" }
---

# Disturbance estimation

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Disturbance Compensator | slctrl_disturbance/Disturbance Compensator | R2024a+ | Estimate and cancel disturbances acting on the plant — use for feedforward rejection of estimated load disturbances |
| Extended State Observer | slctrl_disturbance/Extended State Observer | R2026a+ | Estimate plant states and lumped disturbance — use for reconstructing unmeasured states and total disturbance for ADRC |
| Ultra-Local Model | slctrl_disturbance/Ultra-Local Model | R2026a+ | Approximate plant as a simple integrator chain — use for model-free control design when only input-output data is available |

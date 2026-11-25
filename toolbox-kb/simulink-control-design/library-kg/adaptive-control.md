---
type: Simulink Block Category
title: Adaptive control
description: Adaptive and learning-based controllers (5 blocks)
tags: [toolbox-kb, simulink-control-design, adaptive, adrc, notch, extremum, iterative, mrac]
status: stable
sources:
  - resource: matlab:slctrl_adaptive
source: toolbox_kb
managed_by: satk
library: Simulink Control Design
kb_folder: simulink-control-design
category: adaptive-control
block_count: 5
generated: { by: satk-toolbox-build/1, at: "2026-11-23T18:23:30Z" }
---

# Adaptive control

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Active Disturbance Rejection Control | slctrl_adaptive/Active Disturbance Rejection Control | R2026a+ | Reject unknown disturbances without an explicit plant model — use for robust control when plant dynamics are uncertain or time-varying |
| Adaptive Notch Filter | slctrl_adaptive/Adaptive Notch Filter | R2026a+ | Suppress a varying-frequency disturbance in real time — use for canceling narrowband oscillations whose frequency drifts |
| Extremum Seeking Control | slctrl_adaptive/Extremum Seeking Control | R2023b+ | Find the input that maximizes or minimizes an unknown cost — use for real-time optimization without a plant model |
| Iterative Learning Control | slctrl_adaptive/Iterative Learning Control | R2024b+ | Improve tracking over repeated trials — use for reducing repetitive errors in batch or cyclic processes |
| Model Reference Adaptive Control | slctrl_adaptive/Model Reference Adaptive Control | R2023b+ | Adapt controller gains to match a reference model — use for maintaining performance as plant parameters change |

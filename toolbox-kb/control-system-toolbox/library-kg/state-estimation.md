---
type: Simulink Block Category
title: State estimation
description: Kalman-family and particle filters for online state estimation (4 blocks)
tags: [toolbox-kb, control-system-toolbox, state estimation, kalman, particle filter]
status: stable
sources:
  - resource: matlab:cstblocks
source: toolbox_kb
managed_by: satk
library: Control System Toolbox
kb_folder: control-system-toolbox
category: state-estimation
block_count: 4
generated: { by: satk-toolbox-build/1, at: "2026-11-23T18:23:35Z" }
---

# State estimation

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Extended Kalman Filter | cstblocks/State Estimation/Extended Kalman Filter | R2023a+ | Estimate states of a nonlinear system online by linearizing the dynamics about the current estimate — use for state/parameter estimation when the model is differentiable and only mildly nonlinear. |
| Kalman Filter | cstblocks/State Estimation/Kalman Filter | R2023a+ | Optimal recursive state observer for a linear system with Gaussian noise — use for sensor fusion and state estimation when a linear model is adequate. |
| Particle Filter | cstblocks/State Estimation/Particle Filter | R2023a+ | Estimate states of a highly nonlinear or non-Gaussian system using weighted sample particles — use when Kalman-family filters fail on multimodal or strongly nonlinear problems. |
| Unscented Kalman Filter | cstblocks/State Estimation/Unscented Kalman Filter | R2023a+ | Estimate states of a nonlinear system using sigma-point sampling instead of linearization — use when EKF accuracy degrades from strong nonlinearity. |

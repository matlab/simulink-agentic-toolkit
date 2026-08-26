---
type: Simulink Block Category
title: State estimation
description: Kalman and particle filters for state estimation
tags: [kalman, filter, estimate, state, ekf]
status: stable
source: mathworks_toolbox
library_root: System Identification Toolbox
category_path: State estimation
block_count: 4
---

# State estimation

Use these blocks for state estimation.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Extended Kalman Filter | slident/Estimators/Extended Kalman Filter | R2023a+ | Estimate states of a nonlinear system using the Extended Kalman Filter — use for real-time state estimation when system dynamics are mildly nonlinear |
| Kalman Filter | slident/Estimators/Kalman Filter | R2023a+ | Estimate states of a linear system using a standard Kalman Filter — use for optimal state estimation in linear systems with Gaussian noise |
| Particle Filter | slident/Estimators/Particle Filter | R2023a+ | Estimate states using sequential Monte Carlo sampling — use for state estimation in highly nonlinear or non-Gaussian systems where Kalman filters fail |
| Unscented Kalman Filter | slident/Estimators/Unscented Kalman Filter | R2023a+ | Estimate states using the Unscented Kalman Filter — use for nonlinear state estimation with better accuracy than EKF for strongly nonlinear systems |

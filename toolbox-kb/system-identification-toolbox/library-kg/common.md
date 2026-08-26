---
type: Block Selection Guide
title: Common Blocks
description: High-value blocks selected for quick agent discovery.
status: stable
source: mathworks_toolbox
block_count: 4
---

# Common Blocks

Prefer these blocks when their intent matches the user request.

| Intent | Preferred Block | Library |
|---|---|---|
| Estimate states of a nonlinear system using the Extended Kalman Filter — use for real-time state estimation when system dynamics are mildly nonlinear | Extended Kalman Filter | System Identification Toolbox |
| Estimate states of a linear system using a standard Kalman Filter — use for optimal state estimation in linear systems with Gaussian noise | Kalman Filter | System Identification Toolbox |
| Estimate parameters online using recursive least squares — use for adaptive identification of linear-in-parameters models during simulation | Recursive Least Squares Estimator | System Identification Toolbox |
| Simulate any identified linear model in Simulink — use for embedding estimated transfer functions, state-space, or polynomial models into a system simulation | Idmodel | System Identification Toolbox |

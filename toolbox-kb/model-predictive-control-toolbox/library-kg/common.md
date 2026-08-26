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
| MPC controller that updates its internal plant model online — use for controlling systems whose dynamics change over time or operating conditions | Adaptive MPC Controller | Model Predictive Control Toolbox |
| Standard linear MPC controller with constraint handling — use for multivariable constrained control with output tracking and disturbance rejection | MPC Controller | Model Predictive Control Toolbox |
| General nonlinear MPC with custom cost and constraints — use for controlling highly nonlinear systems where linear MPC provides insufficient performance | Nonlinear MPC Controller | Model Predictive Control Toolbox |
| Pre-built adaptive cruise control using MPC — use for maintaining desired speed while keeping safe following distance from a lead vehicle | Adaptive Cruise Control System | Model Predictive Control Toolbox |

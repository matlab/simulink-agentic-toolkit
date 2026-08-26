---
type: Simulink Block Category
title: Mpc controllers
description: Model predictive control algorithms for constrained optimal control
tags: [mpc, predictive, controller, constraint, optimization]
status: stable
source: mathworks_toolbox
library_root: Model Predictive Control Toolbox
category_path: Mpc controllers
block_count: 8
---

# Mpc controllers

Use these blocks for mpc controllers.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Adaptive MPC Controller | mpclib/Adaptive MPC Controller | R2023a+ | MPC controller that updates its internal plant model online — use for controlling systems whose dynamics change over time or operating conditions |
| Data-Driven MPC | mpclib/Data-Driven MPC | R2026a+ | MPC controller that operates directly from input-output data without an explicit model — use when a first-principles model is unavailable |
| Explicit MPC Controller | mpclib/Explicit MPC Controller | R2023a+ | Pre-computed piecewise-affine MPC controller — use for real-time control on resource-constrained hardware where online optimization is too slow |
| MPC Controller | mpclib/MPC Controller | R2023a+ | Standard linear MPC controller with constraint handling — use for multivariable constrained control with output tracking and disturbance rejection |
| Multiple Explicit MPC Controllers | mpclib/Multiple Explicit MPC Controllers | R2023a+ | Switch between multiple pre-computed explicit MPC controllers — use for gain-scheduled control across operating regions on embedded targets |
| Multiple MPC Controllers | mpclib/Multiple MPC Controllers | R2023a+ | Switch between multiple MPC controllers at runtime — use for gain-scheduled control that adapts to different plant operating modes |
| Multistage Nonlinear MPC | mpclib/Multistage Nonlinear MPC | R2023a+ | Nonlinear MPC with stage-varying costs and constraints — use for trajectory optimization with time-varying objectives or obstacle avoidance |
| Nonlinear MPC Controller | mpclib/Nonlinear MPC Controller | R2023a+ | General nonlinear MPC with custom cost and constraints — use for controlling highly nonlinear systems where linear MPC provides insufficient performance |

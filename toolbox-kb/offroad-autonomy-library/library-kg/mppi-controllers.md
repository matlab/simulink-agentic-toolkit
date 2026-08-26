---
type: Simulink Block Category
title: Mppi controllers
description: Model-predictive path integral controllers for various vehicle types
tags: [mppi, controller, trajectory, path, sampling]
status: stable
source: mathworks_toolbox
library_root: Offroad Autonomy Library
category_path: Mppi controllers
block_count: 4
---

# Mppi controllers

Use these blocks for mppi controllers.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Ackermann MPPI Controller | offroadcontrollerlib/Ackermann MPPI Controller | R2025a+ | Model-predictive path integral controller for Ackermann-steered vehicles — use for sampling-based trajectory optimization in offroad navigation |
| Articulated Steering MPPI Controller | offroadcontrollerlib/Articulated Steering MPPI Controller | R2026a+ | MPPI controller for articulated-steering vehicles — use for trajectory optimization of wheel loaders or articulated dump trucks |
| Bicycle MPPI Controller | offroadcontrollerlib/Bicycle MPPI Controller | R2025a+ | MPPI controller using bicycle kinematic model — use for sampling-based trajectory optimization of car-like vehicles in offroad settings |
| Differential Drive MPPI Controller | offroadcontrollerlib/Differential Drive MPPI Controller | R2025a+ | MPPI controller for differential-drive vehicles — use for sampling-based trajectory optimization of skid-steer or tracked robots |

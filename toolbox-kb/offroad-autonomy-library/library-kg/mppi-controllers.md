---
type: Simulink Block Category
title: Mppi controllers
description: Model-predictive path integral controllers for various vehicle types (4 blocks)
tags: [toolbox-kb, offroad-autonomy-library, mppi, controller, trajectory, path, sampling]
status: stable
sources:
  - resource: matlab:offroadcontrollerlib
source: toolbox_kb
managed_by: satk
library: Offroad Autonomy Library
kb_folder: offroad-autonomy-library
category: mppi-controllers
block_count: 4
generated: { by: satk-toolbox-build/1, at: "2026-11-23T18:23:25Z" }
---

# Mppi controllers

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Ackermann MPPI Controller | offroadcontrollerlib/Ackermann MPPI Controller | R2025a+ | Model-predictive path integral controller for Ackermann-steered vehicles — use for sampling-based trajectory optimization in offroad navigation |
| Articulated Steering MPPI Controller | offroadcontrollerlib/Articulated Steering MPPI Controller | R2026a+ | MPPI controller for articulated-steering vehicles — use for trajectory optimization of wheel loaders or articulated dump trucks |
| Bicycle MPPI Controller | offroadcontrollerlib/Bicycle MPPI Controller | R2025a+ | MPPI controller using bicycle kinematic model — use for sampling-based trajectory optimization of car-like vehicles in offroad settings |
| Differential Drive MPPI Controller | offroadcontrollerlib/Differential Drive MPPI Controller | R2025a+ | MPPI controller for differential-drive vehicles — use for sampling-based trajectory optimization of skid-steer or tracked robots |

---
type: Simulink Block Category
title: Mobile robots
description: Mobile robot kinematic models and path following (5 blocks)
tags: [toolbox-kb, robotics-system-toolbox, ackermann, bicycle, differential, unicycle, pursuit]
status: stable
sources:
  - resource: matlab:robotmobilelib
source: toolbox_kb
managed_by: satk
library: Robotics System Toolbox
kb_folder: robotics-system-toolbox
category: mobile-robots
block_count: 5
generated: { by: satk-toolbox-build/1, at: "2026-11-23T18:23:27Z" }
---

# Mobile robots

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Ackermann Kinematic Model | robotmobilelib/Ackermann Kinematic Model | R2023a+ | Simulate Ackermann-steered vehicle kinematics — use for modeling car-like robots with front-wheel steering |
| Bicycle Kinematic Model | robotmobilelib/Bicycle Kinematic Model | R2023a+ | Simulate bicycle kinematic model — use for simplified car-like vehicle motion with single front and rear wheel |
| Differential Drive Kinematic Model | robotmobilelib/Differential Drive Kinematic Model | R2023a+ | Simulate differential-drive robot kinematics — use for two-wheeled robots steered by wheel speed difference |
| Unicycle Kinematic Model | robotmobilelib/Unicycle Kinematic Model | R2023a+ | Simulate unicycle kinematic model — use for simple point-robot motion with speed and turn rate inputs |
| Pure Pursuit | robotmobilelib/Pure Pursuit | R2023a+ | Track a path using pure pursuit — use for steering a mobile robot along a reference path with lookahead |

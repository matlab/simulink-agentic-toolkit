---
type: Simulink Block Category
title: Vehicle control
description: Lateral and longitudinal vehicle motion controllers
tags: [controller, stanley, steering, throttle, brake]
status: stable
source: mathworks_toolbox
library_root: Automated Driving Toolbox
category_path: Vehicle control
block_count: 2
---

# Vehicle control

Use these blocks for vehicle control.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Lateral Controller Stanley | drivingvehiclecontroller/Lateral Controller Stanley | R2023a+ | Compute steering angle using the Stanley lateral control method — use for path-following where the controller minimizes cross-track error and heading error relative to a reference path |
| Longitudinal Controller Stanley | drivingvehiclecontroller/Longitudinal Controller Stanley | R2023a+ | Compute throttle and brake commands to track a reference speed profile — use with the lateral Stanley controller to achieve combined speed and path tracking for autonomous driving |

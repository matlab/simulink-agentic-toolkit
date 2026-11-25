---
type: Simulink Block Category
title: Vehicle control
description: Blocks for Vehicle control (1 blocks)
tags: [toolbox-kb, automated-driving-toolbox]
status: draft
sources:
  - resource: matlab:drivingvehiclecontroller
source: toolbox_kb
managed_by: satk
library: Automated Driving Toolbox
kb_folder: automated-driving-toolbox
category: vehicle-control
block_count: 1
generated: { by: satk-toolbox-build/1, at: "2026-11-23T18:23:14Z" }
---

# Vehicle control

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Longitudinal Controller Stanley | drivingvehiclecontroller/Longitudinal Controller Stanley | R2023a+ | Compute acceleration and deceleration commands that control the velocity of a vehicle given the reference velocity, the current velocity, and the current driving direction. The controller is implemented as a discrete Proportional-Integral (PI) controller with integral anti-windup. To reset the integral of velocity error to zero, pass a nonzero value to the Reset port. The Direction port accepts a scalar representing the driving direction with two possible values: 1 for forward motion and -1 for reverse motion. The outputs AccelCmd and DecelCmd are saturated by the maximum longitudinal acceleration and the maximum longitudinal deceleration parameters. |

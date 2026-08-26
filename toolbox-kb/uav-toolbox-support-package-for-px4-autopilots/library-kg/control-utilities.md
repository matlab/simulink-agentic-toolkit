---
type: Simulink Block Category
title: Control utilities
description: Control commands, parameters, and logging
tags: [thrust, torque, parameter, log, timestamp]
status: stable
source: mathworks_toolbox
library_root: UAV Toolbox Support Package for PX4 Autopilots
category_path: Control utilities
block_count: 7
---

# Control utilities

Use these blocks for control utilities.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| PX4 Actuator Write | px4Peripheralslib/PX4 Actuator Write | R2024b+ | Command individual actuator outputs on PX4 — use for directly controlling motor ESCs or servos in custom control modes |
| PX4 Read Position Setpoint | px4Utilslib/PX4 Read Position Setpoint | R2023a+ | Read the active position setpoint on PX4 — use for monitoring commanded waypoints in custom navigation logic |
| PX4 ULog | px4Utilslib/PX4 ULog | R2023b+ | Write data to the PX4 onboard ULog — use for recording custom variables for post-flight analysis and replay |
| PX4 Write Parameter | px4Utilslib/PX4 Write Parameter | R2025a+ | Write a PX4 parameter value at runtime — use for updating configuration or tuning values from within custom modules |
| PX4 Write Thrust & Torque Setpoint | px4Utilslib/PX4 Write Thrust & Torque Setpoint | R2025a+ | Command thrust and torque setpoints to PX4 — use for implementing custom low-level controllers that bypass the PX4 rate controller |
| Read Parameter | px4Utilslib/Read Parameter | R2023a+ | Read a PX4 parameter value at runtime — use for accessing configuration or tuning values in custom control code |
| PX4 Timestamp | px4Utilslib/PX4 Timestamp | R2023b+ | Read the PX4 system timestamp — use for time-stamping events or synchronizing with the autopilot clock |

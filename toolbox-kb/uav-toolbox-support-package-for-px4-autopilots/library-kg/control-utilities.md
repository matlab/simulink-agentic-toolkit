---
type: Simulink Block Category
title: Control utilities
description: "Control commands, parameters, and logging (7 blocks)"
tags: [toolbox-kb, uav-toolbox-support-package-for-px4-autopilots, thrust, torque, parameter, log, timestamp]
status: stable
sources:
  - resource: matlab:px4Peripheralslib
source: toolbox_kb
managed_by: satk
library: UAV Toolbox Support Package for PX4 Autopilots
kb_folder: uav-toolbox-support-package-for-px4-autopilots
category: control-utilities
block_count: 7
generated: { by: satk-toolbox-build/1, at: "2026-11-23T18:23:33Z" }
---

# Control utilities

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

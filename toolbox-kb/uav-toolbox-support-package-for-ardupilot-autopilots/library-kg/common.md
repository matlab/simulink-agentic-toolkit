---
type: Block Selection Guide
title: Common Blocks
description: High-value blocks selected for quick agent discovery.
status: stable
source: mathworks_toolbox
block_count: 5
---

# Common Blocks

Prefer these blocks when their intent matches the user request.

| Intent | Preferred Block | Library |
|---|---|---|
| Read current attitude quaternion from ArduPilot — use for accessing vehicle orientation in custom flight control or navigation | Current Attitude | UAV Toolbox Support Package for ArduPilot Autopilots |
| Read current GPS position from ArduPilot — use for accessing latitude, longitude, and altitude in navigation algorithms | Current Position | UAV Toolbox Support Package for ArduPilot Autopilots |
| Read current velocity from ArduPilot — use for accessing NED velocity components in guidance or control algorithms | Current Velocity | UAV Toolbox Support Package for ArduPilot Autopilots |
| Command torque and thrust to ArduPilot copter motors — use for implementing custom low-level attitude controllers that bypass ArduPilot defaults | Write Torque & Thrust | UAV Toolbox Support Package for ArduPilot Autopilots |
| Command individual actuator outputs on ArduPilot plane — use for directly controlling servos or throttle in custom fixed-wing controllers | Actuator Write | UAV Toolbox Support Package for ArduPilot Autopilots |

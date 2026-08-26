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
| Command individual actuator outputs on PX4 — use for directly controlling motor ESCs or servos in custom control modes | PX4 Actuator Write | UAV Toolbox Support Package for PX4 Autopilots |
| Read GPS position and velocity from PX4 — use for accessing navigation data in custom position controllers | GPS | UAV Toolbox Support Package for PX4 Autopilots |
| Read estimated vehicle attitude from PX4 EKF — use for accessing fused orientation in custom guidance algorithms | Vehicle Attitude | UAV Toolbox Support Package for PX4 Autopilots |
| Subscribe to and read a PX4 uORB topic — use for receiving published data from other PX4 modules or sensors | PX4 uORB Read | UAV Toolbox Support Package for PX4 Autopilots |
| Publish data to a PX4 uORB topic — use for broadcasting custom data to other PX4 modules or the ground station | PX4 uORB Write | UAV Toolbox Support Package for PX4 Autopilots |

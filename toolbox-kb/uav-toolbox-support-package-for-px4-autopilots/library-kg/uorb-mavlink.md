---
type: Simulink Block Category
title: Uorb mavlink
description: uORB middleware and MAVLink communication
tags: [uorb, mavlink, publish, subscribe, message]
status: stable
source: mathworks_toolbox
library_root: UAV Toolbox Support Package for PX4 Autopilots
category_path: Uorb mavlink
block_count: 5
---

# Uorb mavlink

Use these blocks for uorb mavlink.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| MAVLink Bridge Sink | px4MAVLinkBridgelib/MAVLink Bridge Sink | R2026a+ | Send data to a ground station via MAVLink — use for publishing custom telemetry through the PX4 MAVLink communication layer |
| MAVLink Bridge Source | px4MAVLinkBridgelib/MAVLink Bridge Source | R2026a+ | Receive data from a ground station via MAVLink — use for accepting commands or parameters through the MAVLink communication layer |
| PX4 uORB Message | px4uORBlib/PX4 uORB Message | R2023a+ | Define a PX4 uORB message structure — use for creating custom inter-module message types on the PX4 middleware |
| PX4 uORB Read | px4uORBlib/PX4 uORB Read | R2023a+ | Subscribe to and read a PX4 uORB topic — use for receiving published data from other PX4 modules or sensors |
| PX4 uORB Write | px4uORBlib/PX4 uORB Write | R2023a+ | Publish data to a PX4 uORB topic — use for broadcasting custom data to other PX4 modules or the ground station |

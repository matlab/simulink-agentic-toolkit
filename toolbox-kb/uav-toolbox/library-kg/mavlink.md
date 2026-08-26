---
type: Simulink Block Category
title: Mavlink
description: MAVLink protocol encoding and decoding
tags: [mavlink, serialize, message, protocol, telemetry]
status: stable
source: mathworks_toolbox
library_root: UAV Toolbox
category_path: Mavlink
block_count: 3
---

# Mavlink

Use these blocks for mavlink.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| MAVLink Blank Message | uavmavlinklib/MAVLink Blank Message | R2023a+ | Create an empty MAVLink message structure — use for initializing MAVLink messages before populating fields for transmission |
| MAVLink Deserializer | uavmavlinklib/MAVLink Deserializer | R2023a+ | Deserialize raw bytes into MAVLink message structures — use for parsing received MAVLink data into usable signal fields |
| MAVLink Serializer | uavmavlinklib/MAVLink Serializer | R2023a+ | Serialize MAVLink messages into raw bytes for transmission — use for encoding MAVLink messages before sending over serial or UDP |

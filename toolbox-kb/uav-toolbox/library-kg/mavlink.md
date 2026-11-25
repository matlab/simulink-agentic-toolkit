---
type: Simulink Block Category
title: Mavlink
description: Blocks for Mavlink (2 blocks)
tags: [toolbox-kb, uav-toolbox]
status: draft
sources:
  - resource: matlab:uavmavlinklib
source: toolbox_kb
managed_by: satk
library: UAV Toolbox
kb_folder: uav-toolbox
category: mavlink
block_count: 2
generated: { by: satk-toolbox-build/1, at: "2026-11-23T18:23:33Z" }
---

# Mavlink

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| MAVLink Blank Message | uavmavlinklib/MAVLink Blank Message | R2023a+ | The MAVLink Blank Message outputs a Simulink bus consisting of fields: Message ID, System ID, Component ID, Sequence, and Payload. The Payload is a Simulink bus representing the payload of the specified MAVLink message type. |
| MAVLink Serializer | uavmavlinklib/MAVLink Serializer | R2023a+ | The MAVLink Serializer accepts a Simulink bus representing a MAVLink message consisting of fields: Message ID, System ID, Component ID, Sequence, and Payload for the specified MAVLink message type. The MAVLink Serializer converts the Simulink bus to a buffer consisting of uint8 values and outputs the buffer. The length of the buffer in the Data outport is the maximum length of the MAVLink message that you select. The Length port outputs the current length of the serialized message in the Data outport. |

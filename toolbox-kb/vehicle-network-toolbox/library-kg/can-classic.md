---
type: Simulink Block Category
title: Can classic
description: Classic CAN bus communication (7 blocks)
tags: [toolbox-kb, vehicle-network-toolbox, can, pack, unpack, receive, transmit]
status: stable
sources:
  - resource: matlab:canlib
source: toolbox_kb
managed_by: satk
library: Vehicle Network Toolbox
kb_folder: vehicle-network-toolbox
category: can-classic
block_count: 7
generated: { by: satk-toolbox-build/1, at: "2026-11-23T18:23:34Z" }
---

# Can classic

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| CAN Configuration | canlib/CAN Configuration | R2023a+ | Configure a CAN channel for communication — use for setting up baud rate, hardware interface, and bus parameters before sending or receiving |
| CAN Log | canlib/CAN Log | R2023a+ | Log CAN bus messages to a file — use for recording raw bus traffic for offline analysis or replay |
| CAN Pack | canlib/CAN Pack | R2023a+ | Pack signal values into a CAN message frame — use for encoding physical signals into the CAN data payload using a DBC definition |
| CAN Receive | canlib/CAN Receive | R2023a+ | Receive CAN messages from the bus — use for reading incoming frames from ECUs or sensors on the CAN network |
| CAN Replay | canlib/CAN Replay | R2023a+ | Replay previously logged CAN messages — use for stimulating a model with recorded real-world bus data |
| CAN Transmit | canlib/CAN Transmit | R2023a+ | Transmit CAN messages to the bus — use for sending frames to ECUs or actuators on the CAN network |
| CAN Unpack | canlib/CAN Unpack | R2023a+ | Unpack signal values from a CAN message frame — use for decoding physical signals from received CAN data using a DBC definition |

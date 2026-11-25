---
type: Simulink Block Category
title: Can fd
description: CAN FD high-bandwidth communication (7 blocks)
tags: [toolbox-kb, vehicle-network-toolbox, canfd, flexible, "64byte", bandwidth, fd]
status: stable
sources:
  - resource: matlab:canfdlib
source: toolbox_kb
managed_by: satk
library: Vehicle Network Toolbox
kb_folder: vehicle-network-toolbox
category: can-fd
block_count: 7
generated: { by: satk-toolbox-build/1, at: "2026-11-23T18:23:34Z" }
---

# Can fd

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| CAN FD Configuration | canfdlib/CAN FD Configuration | R2023a+ | Configure a CAN FD channel — use for setting up CAN FD baud rates and parameters for high-bandwidth vehicle communication |
| CAN FD Log | canfdlib/CAN FD Log | R2023a+ | Log CAN FD messages to a file — use for recording high-bandwidth bus traffic for offline analysis |
| CAN FD Pack | canfdlib/CAN FD Pack | R2023a+ | Pack signal values into a CAN FD message frame — use for encoding signals into CAN FD payloads up to 64 bytes |
| CAN FD Receive | canfdlib/CAN FD Receive | R2023a+ | Receive CAN FD messages from the bus — use for reading high-bandwidth frames from modern vehicle networks |
| CAN FD Replay | canfdlib/CAN FD Replay | R2023a+ | Replay previously logged CAN FD messages — use for stimulating models with recorded CAN FD bus data |
| CAN FD Transmit | canfdlib/CAN FD Transmit | R2023a+ | Transmit CAN FD messages to the bus — use for sending high-bandwidth frames to modern vehicle ECUs |
| CAN FD Unpack | canfdlib/CAN FD Unpack | R2023a+ | Unpack signal values from a CAN FD message frame — use for decoding signals from received CAN FD data |

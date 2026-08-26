---
type: Block Selection Guide
title: Common Blocks
description: High-value blocks selected for quick agent discovery.
status: stable
source: mathworks_toolbox
block_count: 6
---

# Common Blocks

Prefer these blocks when their intent matches the user request.

| Intent | Preferred Block | Library |
|---|---|---|
| Pack signal values into a CAN message data field — use to encode multiple signals into 8-byte CAN payloads for transmission from the embedded target | CAN Pack | Embedded Coder |
| Extract signal values from a received CAN message data field — use to decode individual signals from CAN payloads received on the embedded target | CAN Unpack | Embedded Coder |
| Receive data bytes from the serial port on the embedded target — use for host-target communication during rapid prototyping or external mode data logging | Serial Receive | Embedded Coder |
| Send data bytes through the serial port on the embedded target — use for host-target communication during rapid prototyping or parameter tuning | Serial Send | Embedded Coder |
| Receive UDP datagrams on the embedded target — use for network-based host-target communication or inter-processor data exchange over Ethernet | UDP Receive | Embedded Coder |
| Send UDP datagrams from the embedded target — use for network-based telemetry, logging, or inter-processor communication over Ethernet | UDP Send | Embedded Coder |

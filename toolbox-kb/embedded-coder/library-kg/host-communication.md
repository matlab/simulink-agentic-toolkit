---
type: Simulink Block Category
title: Host communication
description: Host-target communication blocks for serial, CAN, and UDP data exchange
tags: [serial, udp, can, byte, communication]
status: stable
source: mathworks_toolbox
library_root: Embedded Coder
category_path: Host communication
block_count: 10
---

# Host communication

Use these blocks for host communication.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Byte Pack | embeddedtargetslib/Host Communication/Byte Pack | R2023a+ | Pack multiple signals into a byte array for serial or network transmission — use to construct communication payloads with specified byte order and alignment for host-target data exchange |
| Byte Reversal | embeddedtargetslib/Host Communication/Byte Reversal | R2023a+ | Reverse byte order of a multi-byte value between big-endian and little-endian — use when communicating between processors with different endianness |
| Byte Unpack | embeddedtargetslib/Host Communication/Byte Unpack | R2023a+ | Extract signals from a byte array received via serial or network — use to parse communication payloads back into individual signal values with correct data type interpretation |
| CAN Pack | embeddedtargetslib/Host Communication/CAN Pack | R2023a+ | Pack signal values into a CAN message data field — use to encode multiple signals into 8-byte CAN payloads for transmission from the embedded target |
| CAN Unpack | embeddedtargetslib/Host Communication/CAN Unpack | R2023a+ | Extract signal values from a received CAN message data field — use to decode individual signals from CAN payloads received on the embedded target |
| Serial Configuration | embeddedtargetslib/Host Communication/Serial Configuration | R2023a+ | Configure serial port parameters on the embedded target — use to set baud rate, parity, and framing before using Serial Receive/Send blocks for host communication |
| Serial Receive | embeddedtargetslib/Host Communication/Serial Receive | R2023a+ | Receive data bytes from the serial port on the embedded target — use for host-target communication during rapid prototyping or external mode data logging |
| Serial Send | embeddedtargetslib/Host Communication/Serial Send | R2023a+ | Send data bytes through the serial port on the embedded target — use for host-target communication during rapid prototyping or parameter tuning |
| UDP Receive | embeddedtargetslib/Host Communication/UDP Receive | R2023a+ | Receive UDP datagrams on the embedded target — use for network-based host-target communication or inter-processor data exchange over Ethernet |
| UDP Send | embeddedtargetslib/Host Communication/UDP Send | R2023a+ | Send UDP datagrams from the embedded target — use for network-based telemetry, logging, or inter-processor communication over Ethernet |

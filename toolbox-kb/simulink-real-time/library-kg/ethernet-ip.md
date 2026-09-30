---
type: Simulink Block Category
title: Ethernet ip
description: Raw Ethernet and IP communication on the real-time target
tags: [ethernet, ip, udp, tcp]
status: stable
source: custom_library
library_root: Simulink Real-Time
category_path: Ethernet ip
block_count: 15
---

# Ethernet ip

Use these blocks for ethernet ip.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| TCP Client | slrealtimeiplib/TCP Client | R2024a+ | Configure TCP Client |
| TCP Receive | slrealtimeiplib/TCP Receive | R2024a+ | Receive data over TCP network from a remote device. |
| TCP Send | slrealtimeiplib/TCP Send | R2024a+ | Send data over TCP network to a remote device. |
| TCP Server | slrealtimeiplib/TCP Server | R2024a+ | Configure TCP Server |
| UDP Multicast Receive | slrealtimeiplib/UDP Multicast Receive | R2024a+ | Receive multicast data over UDP network from a remote device. Bind to either 0.0.0.0 or a multicast address. |
| UDP Receive | slrealtimeiplib/UDP Receive | R2024a+ | Receive data over UDP network from a remote device. |
| UDP Send | slrealtimeiplib/UDP Send | R2024a+ | Send data over UDP network to a remote device. Send to 255.255.255.255 for broadcast. |
| Ethernet Receive | slrealtimeiplib/Ethernet/Ethernet Receive | R2024a+ | Receive raw Ethernet frames on the real-time target — use for low-level custom-protocol input. |
| Ethernet Send | slrealtimeiplib/Ethernet/Ethernet Send | R2024a+ | Send raw Ethernet frames from the real-time target — use for low-level custom-protocol output. |
| FIFO ASCII read | slrealtimeseriallib/FIFO ASCII read | R2024a+ | FIFO Read using multiple starting ASCII string identifiers |
| FIFO bin read | slrealtimeseriallib/FIFO bin read | R2024a+ | FIFO Read using multiple starting byte numeric value identifiers |
| Shared Memory Pack | slrealtimesharedmemorylib/Shared Memory Pack | R2024a+ | Assembles multiple data elements into a contiguous array of 32-bit words (pack partition data). For use with a shared memory write block. |
| Shared Memory Unpack | slrealtimesharedmemorylib/Shared Memory Unpack | R2024a+ | Extracts multiple data elements from a contiguous array of 32-bit words (unpack partition data). For use with a shared memory read block. |
| Byte Packing | slrealtimeutilitieslib/Byte Packing | R2024a+ | Pack bytes from multiple input vectors into a single output vector. |
| Byte Unpacking | slrealtimeutilitieslib/Byte Unpacking | R2024a+ | Unpack bytes from a single input vector into multiple output vectors. |

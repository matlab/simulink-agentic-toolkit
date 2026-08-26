---
type: Simulink Block Category
title: Network communication
description: TCP and UDP network communication via on-chip Ethernet
tags: [tcp, udp, ethernet, network, socket]
status: stable
source: mathworks_toolbox
library_root: C2000 Microcontroller Blockset
category_path: Network communication
block_count: 12
---

# Network communication

Use these blocks for network communication.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| TCP Receive | c2838x_M4_lib/TCP Receive | R2023a+ | Receive data over a TCP connection — use for reliable stream-based communication with a remote host via the on-chip Ethernet peripheral |
| TCP Send | c2838x_M4_lib/TCP Send | R2023a+ | Send data over a TCP connection — use for reliable stream-based data transfer to a remote host via the on-chip Ethernet peripheral |
| UDP Receive | c2838x_M4_lib/UDP Receive | R2023a+ | Receive UDP datagrams from the network — use for low-latency connectionless communication where occasional packet loss is acceptable |
| UDP Send | c2838x_M4_lib/UDP Send | R2023a+ | Send UDP datagrams over the network — use for low-latency broadcasting or point-to-point data transfer without connection overhead |
| TCP Receive | f28M35x_M3_lib/TCP Receive | R2023a+ | Receive data over a TCP connection — use for reliable stream-based communication with a remote host via the on-chip Ethernet peripheral |
| TCP Send | f28M35x_M3_lib/TCP Send | R2023a+ | Send data over a TCP connection — use for reliable stream-based data transfer to a remote host via the on-chip Ethernet peripheral |
| UDP Receive | f28M35x_M3_lib/UDP Receive | R2023a+ | Receive UDP datagrams from the network — use for low-latency connectionless communication where occasional packet loss is acceptable |
| UDP Send | f28M35x_M3_lib/UDP Send | R2023a+ | Send UDP datagrams over the network — use for low-latency broadcasting or point-to-point data transfer without connection overhead |
| TCP Receive | f28M36x_M3_lib/TCP Receive | R2023a+ | Receive data over a TCP connection — use for reliable stream-based communication with a remote host via the on-chip Ethernet peripheral |
| TCP Send | f28M36x_M3_lib/TCP Send | R2023a+ | Send data over a TCP connection — use for reliable stream-based data transfer to a remote host via the on-chip Ethernet peripheral |
| UDP Receive | f28M36x_M3_lib/UDP Receive | R2023a+ | Receive UDP datagrams from the network — use for low-latency connectionless communication where occasional packet loss is acceptable |
| UDP Send | f28M36x_M3_lib/UDP Send | R2023a+ | Send UDP datagrams over the network — use for low-latency broadcasting or point-to-point data transfer without connection overhead |

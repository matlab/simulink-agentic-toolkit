---
type: Simulink Block Category
title: Communication
description: Network data exchange (5 blocks)
tags: [toolbox-kb, simulink-support-package-for-lego-mindstorms-ev3-hardware, tcp, udp, i2c, network, wifi]
status: stable
sources:
  - resource: matlab:legoev3lib
source: toolbox_kb
managed_by: satk
library: Simulink Support Package for LEGO MINDSTORMS EV3 Hardware
kb_folder: simulink-support-package-for-lego-mindstorms-ev3-hardware
category: communication
block_count: 5
generated: { by: satk-toolbox-build/1, at: "2026-11-23T18:23:32Z" }
---

# Communication

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| I2C Register Read | legoev3lib/I2C Register Read | R2023a+ | Read data from I2C devices connected to EV3 ports — use for interfacing with third-party I2C sensors or devices |
| TCP/IP Receive | legoev3lib/TCP/IP Receive | R2023a+ | Receive data over TCP/IP on EV3 — use for remote monitoring or receiving commands from a host computer over WiFi |
| TCP/IP Send | legoev3lib/TCP/IP Send | R2023a+ | Send data over TCP/IP from EV3 — use for transmitting sensor data or status to a host computer over WiFi |
| UDP Receive | legoev3lib/UDP Receive | R2023a+ | Receive UDP packets on EV3 — use for low-latency data reception from a host computer |
| UDP Send | legoev3lib/UDP Send | R2023a+ | Send UDP packets from EV3 — use for low-latency data transmission to a host computer |

---
type: Simulink Block Category
title: Communication
description: Serial, I2C, and network communication
tags: [serial, i2c, tcp, udp, uart]
status: stable
source: mathworks_toolbox
library_root: Simulink Coder Support Package for NXP FRDM-K64F Board
category_path: Communication
block_count: 8
---

# Communication

Use these blocks for communication.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| I2C Controller Read | frdmk64flib/I2C Controller Read | R2023a+ | Read data from an I2C peripheral on FRDM-K64F — use for communicating with external I2C sensors or EEPROMs |
| I2C Controller Write | frdmk64flib/I2C Controller Write | R2023a+ | Write data to an I2C peripheral on FRDM-K64F — use for configuring or commanding external I2C devices |
| Serial Receive | frdmk64flib/Serial Receive | R2023a+ | Receive data over UART on FRDM-K64F — use for reading data from serial-connected devices or sensors |
| Serial Transmit | frdmk64flib/Serial Transmit | R2023a+ | Transmit data over UART on FRDM-K64F — use for sending data to serial-connected displays or host computers |
| TCP Receive | frdmk64flib/TCP Receive | R2023a+ | Receive data over TCP/IP on FRDM-K64F — use for network data reception via the Ethernet interface |
| TCP Send | frdmk64flib/TCP Send | R2023a+ | Send data over TCP/IP on FRDM-K64F — use for network data transmission via the Ethernet interface |
| UDP Receive | frdmk64flib/UDP Receive | R2023a+ | Receive UDP packets on FRDM-K64F — use for low-latency network data reception |
| UDP Send | frdmk64flib/UDP Send | R2023a+ | Send UDP packets from FRDM-K64F — use for low-latency network data transmission |

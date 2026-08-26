---
type: Simulink Block Category
title: Serial comm
description: Serial port communication with instruments and devices
tags: [serial, uart, rs232, baud, port]
status: stable
source: mathworks_toolbox
library_root: Instrument Control Toolbox
category_path: Serial comm
block_count: 3
---

# Serial comm

Use these blocks for serial comm.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Serial Configuration | instrumentlib/Serial Configuration | R2023a+ | Configure serial port parameters like baud rate and parity — use for setting up RS-232/RS-485 communication before send/receive operations |
| Serial Receive | instrumentlib/Serial Receive | R2023a+ | Receive data from a serial port — use for reading measurement data or responses from serial-connected instruments or microcontrollers |
| Serial Send | instrumentlib/Serial Send | R2023a+ | Send data through a serial port — use for transmitting commands or data to serial-connected instruments or microcontrollers |

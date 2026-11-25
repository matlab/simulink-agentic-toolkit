---
type: Simulink Block Category
title: Serial comm
description: Serial port communication with instruments and devices (3 blocks)
tags: [toolbox-kb, instrument-control-toolbox, serial, uart, rs232, baud, port]
status: stable
sources:
  - resource: matlab:instrumentlib
source: toolbox_kb
managed_by: satk
library: Instrument Control Toolbox
kb_folder: instrument-control-toolbox
category: serial-comm
block_count: 3
generated: { by: satk-toolbox-build/1, at: "2026-11-23T18:23:23Z" }
---

# Serial comm

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Serial Configuration | instrumentlib/Serial Configuration | R2023a+ | Configure serial port parameters like baud rate and parity — use for setting up RS-232/RS-485 communication before send/receive operations |
| Serial Receive | instrumentlib/Serial Receive | R2023a+ | Receive data from a serial port — use for reading measurement data or responses from serial-connected instruments or microcontrollers |
| Serial Send | instrumentlib/Serial Send | R2023a+ | Send data through a serial port — use for transmitting commands or data to serial-connected instruments or microcontrollers |

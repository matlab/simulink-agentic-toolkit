---
type: Simulink Block Category
title: Serial communication
description: Serial port communication with FIFO buffering and ASCII/binary parsing
tags: [serial, FIFO, ASCII, baud, RS232]
status: stable
source: mathworks_toolbox
library_root: Simulink Real-Time
category_path: Serial communication
block_count: 14
---

# Serial communication

Use these blocks for serial communication.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Legacy Serial | slrealtimeseriallib/Mainboard/Legacy Serial | R2024a+ | Configure and access a legacy serial port on the real-time target mainboard |
| Legacy Serial F | slrealtimeseriallib/Mainboard/Legacy Serial F | R2024a+ | Configure and access a legacy serial port with FIFO support on the target mainboard |
| ASCII Decode | slrealtimeseriallib/ASCII Decode | R2024a+ | Decode ASCII-formatted data received from a serial port into numeric signals |
| ASCII Encode | slrealtimeseriallib/ASCII Encode | R2024a+ | Encode numeric signals into ASCII-formatted strings for serial transmission |
| FIFO ASCII read | slrealtimeseriallib/FIFO ASCII read | R2024a+ | Read ASCII data from a serial FIFO buffer with delimiter-based parsing |
| FIFO bin read | slrealtimeseriallib/FIFO bin read | R2024a+ | Read binary data from a serial FIFO buffer with fixed-size frame parsing |
| FIFO read | slrealtimeseriallib/FIFO read | R2024a+ | Read raw bytes from a serial FIFO buffer on the real-time target |
| FIFO write | slrealtimeseriallib/FIFO write | R2024a+ | Write raw bytes to a serial FIFO buffer on the real-time target |
| V2 Ascii Decode | slrealtimeseriallib/V2 Ascii Decode | R2024a+ | Decode ASCII data with enhanced format specification for serial protocols |
| Legacy Serial Read | slrealtimeseriallib/Mainboard/Legacy Serial Read | R2024a+ | Read data from a legacy mainboard serial port on the real-time target |
| Legacy Serial Write | slrealtimeseriallib/Mainboard/Legacy Serial Write | R2024a+ | Write data to a legacy mainboard serial port on the real-time target |
| Modem Control | slrealtimeseriallib/Mainboard/Modem Control | R2024a+ | Set modem control lines on the serial port for hardware handshaking |
| Modem Status | slrealtimeseriallib/Mainboard/Modem Status | R2024a+ | Read modem status lines from the serial port for hardware handshaking |
| Setup | slrealtimeseriallib/Mainboard/Setup | R2024a+ | Configure serial port parameters including baud rate, parity, and data bits |

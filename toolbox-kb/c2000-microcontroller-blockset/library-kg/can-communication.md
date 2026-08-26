---
type: Simulink Block Category
title: Can communication
description: CAN and CAN FD bus communication including message packing and unpacking
tags: [can, mcan, canfd, pack, unpack]
status: stable
source: mathworks_toolbox
library_root: C2000 Microcontroller Blockset
category_path: Can communication
block_count: 59
---

# Can communication

Use these blocks for can communication.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| CAN Receive | c2803xlib/CAN Receive | R2023b+ | Receive CAN messages from the on-chip CAN controller — use to read data frames from a CAN bus in automotive or industrial control networks |
| CAN Transmit | c2803xlib/CAN Transmit | R2023b+ | Transmit CAN messages through the on-chip CAN controller — use to send data frames onto a CAN bus for inter-ECU communication |
| CAN Receive | c2805xlib/CAN Receive | R2023b+ | Receive CAN messages from the on-chip CAN controller — use to read data frames from a CAN bus in automotive or industrial control networks |
| CAN Transmit | c2805xlib/CAN Transmit | R2023b+ | Transmit CAN messages through the on-chip CAN controller — use to send data frames onto a CAN bus for inter-ECU communication |
| CAN Receive | c2806xlib/CAN Receive | R2023b+ | Receive CAN messages from the on-chip CAN controller — use to read data frames from a CAN bus in automotive or industrial control networks |
| CAN Transmit | c2806xlib/CAN Transmit | R2023b+ | Transmit CAN messages through the on-chip CAN controller — use to send data frames onto a CAN bus for inter-ECU communication |
| CAN Receive | c280xlib/CAN Receive | R2023b+ | Receive CAN messages from the on-chip CAN controller — use to read data frames from a CAN bus in automotive or industrial control networks |
| CAN Transmit | c280xlib/CAN Transmit | R2023b+ | Transmit CAN messages through the on-chip CAN controller — use to send data frames onto a CAN bus for inter-ECU communication |
| CAN Receive | c281xlib/CAN Receive | R2023b+ | Receive CAN messages from the on-chip CAN controller — use to read data frames from a CAN bus in automotive or industrial control networks |
| CAN Transmit | c281xlib/CAN Transmit | R2023b+ | Transmit CAN messages through the on-chip CAN controller — use to send data frames onto a CAN bus for inter-ECU communication |
| CAN Receive | c2833xlib/CAN Receive | R2023b+ | Receive CAN messages from the on-chip CAN controller — use to read data frames from a CAN bus in automotive or industrial control networks |
| CAN Transmit | c2833xlib/CAN Transmit | R2023b+ | Transmit CAN messages through the on-chip CAN controller — use to send data frames onto a CAN bus for inter-ECU communication |
| CAN Receive | c2834xlib/CAN Receive | R2023b+ | Receive CAN messages from the on-chip CAN controller — use to read data frames from a CAN bus in automotive or industrial control networks |
| CAN Transmit | c2834xlib/CAN Transmit | R2023b+ | Transmit CAN messages through the on-chip CAN controller — use to send data frames onto a CAN bus for inter-ECU communication |
| CAN Receive | c280013xlib/CAN Receive | R2023b+ | Receive CAN messages from the on-chip CAN controller — use to read data frames from a CAN bus in automotive or industrial control networks |
| CAN Transmit | c280013xlib/CAN Transmit | R2023b+ | Transmit CAN messages through the on-chip CAN controller — use to send data frames onto a CAN bus for inter-ECU communication |
| CAN Receive | c280015xlib/CAN Receive | R2023b+ | Receive CAN messages from the on-chip CAN controller — use to read data frames from a CAN bus in automotive or industrial control networks |
| CAN Transmit | c280015xlib/CAN Transmit | R2023b+ | Transmit CAN messages through the on-chip CAN controller — use to send data frames onto a CAN bus for inter-ECU communication |
| MCAN Interrupt Status | c280015xlib/MCAN Interrupt Status | R2024b+ | Read MCAN interrupt status flags — use to poll or respond to CAN FD communication events like message received, bus-off, or error conditions |
| MCAN Receive | c280015xlib/MCAN Receive | R2024b+ | Receive messages from the MCAN (CAN FD) controller on newer C2000 devices — use for CAN FD communication with hardware message filtering and FIFO buffering |
| MCAN Transmit | c280015xlib/MCAN Transmit | R2024b+ | Transmit messages through the MCAN controller — use to send CAN/CAN FD frames with priority-based arbitration on newer C2000 devices |
| CAN Receive | c28002xlib/CAN Receive | R2023b+ | Receive CAN messages from the on-chip CAN controller — use to read data frames from a CAN bus in automotive or industrial control networks |
| CAN Transmit | c28002xlib/CAN Transmit | R2023b+ | Transmit CAN messages through the on-chip CAN controller — use to send data frames onto a CAN bus for inter-ECU communication |
| CAN Receive | c28003xlib/CAN Receive | R2023b+ | Receive CAN messages from the on-chip CAN controller — use to read data frames from a CAN bus in automotive or industrial control networks |
| CAN Transmit | c28003xlib/CAN Transmit | R2023b+ | Transmit CAN messages through the on-chip CAN controller — use to send data frames onto a CAN bus for inter-ECU communication |
| MCAN Interrupt Status | c28003xlib/MCAN Interrupt Status | R2024b+ | Read MCAN interrupt status flags — use to poll or respond to CAN FD communication events like message received, bus-off, or error conditions |
| MCAN Receive | c28003xlib/MCAN Receive | R2024b+ | Receive messages from the MCAN (CAN FD) controller on newer C2000 devices — use for CAN FD communication with hardware message filtering and FIFO buffering |
| MCAN Transmit | c28003xlib/MCAN Transmit | R2024b+ | Transmit messages through the MCAN controller — use to send CAN/CAN FD frames with priority-based arbitration on newer C2000 devices |
| CAN Receive | c28004xlib/CAN Receive | R2023b+ | Receive CAN messages from the on-chip CAN controller — use to read data frames from a CAN bus in automotive or industrial control networks |
| CAN Transmit | c28004xlib/CAN Transmit | R2023b+ | Transmit CAN messages through the on-chip CAN controller — use to send data frames onto a CAN bus for inter-ECU communication |
| CAN Receive | c2807xlib/CAN Receive | R2023b+ | Receive CAN messages from the on-chip CAN controller — use to read data frames from a CAN bus in automotive or industrial control networks |
| CAN Transmit | c2807xlib/CAN Transmit | R2023b+ | Transmit CAN messages through the on-chip CAN controller — use to send data frames onto a CAN bus for inter-ECU communication |
| CAN Receive | c2837xDlib/CAN Receive | R2023b+ | Receive CAN messages from the on-chip CAN controller — use to read data frames from a CAN bus in automotive or industrial control networks |
| CAN Transmit | c2837xDlib/CAN Transmit | R2023b+ | Transmit CAN messages through the on-chip CAN controller — use to send data frames onto a CAN bus for inter-ECU communication |
| CAN Receive | c2837xSlib/CAN Receive | R2023b+ | Receive CAN messages from the on-chip CAN controller — use to read data frames from a CAN bus in automotive or industrial control networks |
| CAN Transmit | c2837xSlib/CAN Transmit | R2023b+ | Transmit CAN messages through the on-chip CAN controller — use to send data frames onto a CAN bus for inter-ECU communication |
| CAN Receive | c2838xlib/CAN Receive | R2023b+ | Receive CAN messages from the on-chip CAN controller — use to read data frames from a CAN bus in automotive or industrial control networks |
| CAN Transmit | c2838xlib/CAN Transmit | R2023b+ | Transmit CAN messages through the on-chip CAN controller — use to send data frames onto a CAN bus for inter-ECU communication |
| MCAN Interrupt Status | c2838xlib/MCAN Interrupt Status | R2024b+ | Read MCAN interrupt status flags — use to poll or respond to CAN FD communication events like message received, bus-off, or error conditions |
| MCAN Receive | c2838xlib/MCAN Receive | R2024b+ | Receive messages from the MCAN (CAN FD) controller on newer C2000 devices — use for CAN FD communication with hardware message filtering and FIFO buffering |
| MCAN Transmit | c2838xlib/MCAN Transmit | R2024b+ | Transmit messages through the MCAN controller — use to send CAN/CAN FD frames with priority-based arbitration on newer C2000 devices |
| MCAN Interrupt Status | c2838x_M4_lib/MCAN Interrupt Status | R2023a+ | Read MCAN interrupt status flags — use to poll or respond to CAN FD communication events like message received, bus-off, or error conditions |
| MCAN Receive | c2838x_M4_lib/MCAN Receive | R2023a+ | Receive messages from the MCAN (CAN FD) controller on newer C2000 devices — use for CAN FD communication with hardware message filtering and FIFO buffering |
| MCAN Transmit | c2838x_M4_lib/MCAN Transmit | R2023a+ | Transmit messages through the MCAN controller — use to send CAN/CAN FD frames with priority-based arbitration on newer C2000 devices |
| MCAN Interrupt Status | c28P55xlib/MCAN Interrupt Status | R2024b+ | Read MCAN interrupt status flags — use to poll or respond to CAN FD communication events like message received, bus-off, or error conditions |
| MCAN Receive | c28P55xlib/MCAN Receive | R2024b+ | Receive messages from the MCAN (CAN FD) controller on newer C2000 devices — use for CAN FD communication with hardware message filtering and FIFO buffering |
| MCAN Transmit | c28P55xlib/MCAN Transmit | R2024b+ | Transmit messages through the MCAN controller — use to send CAN/CAN FD frames with priority-based arbitration on newer C2000 devices |
| CAN Receive | c28P65xlib/CAN Receive | R2024a+ | Receive CAN messages from the on-chip CAN controller — use to read data frames from a CAN bus in automotive or industrial control networks |
| CAN Transmit | c28P65xlib/CAN Transmit | R2024a+ | Transmit CAN messages through the on-chip CAN controller — use to send data frames onto a CAN bus for inter-ECU communication |
| MCAN Interrupt Status | c28P65xlib/MCAN Interrupt Status | R2024b+ | Read MCAN interrupt status flags — use to poll or respond to CAN FD communication events like message received, bus-off, or error conditions |
| MCAN Receive | c28P65xlib/MCAN Receive | R2024b+ | Receive messages from the MCAN (CAN FD) controller on newer C2000 devices — use for CAN FD communication with hardware message filtering and FIFO buffering |
| MCAN Transmit | c28P65xlib/MCAN Transmit | R2024b+ | Transmit messages through the MCAN controller — use to send CAN/CAN FD frames with priority-based arbitration on newer C2000 devices |
| MCAN Interrupt Status | c29H85xlib/MCAN Interrupt Status | R2026a+ | Read MCAN interrupt status flags — use to poll or respond to CAN FD communication events like message received, bus-off, or error conditions |
| MCAN Receive | c29H85xlib/MCAN Receive | R2026a+ | Receive messages from the MCAN (CAN FD) controller on newer C2000 devices — use for CAN FD communication with hardware message filtering and FIFO buffering |
| MCAN Transmit | c29H85xlib/MCAN Transmit | R2026a+ | Transmit messages through the MCAN controller — use to send CAN/CAN FD frames with priority-based arbitration on newer C2000 devices |
| CAN FD Pack | c2000lib/Target Communication/CAN FD Pack | R2023a+ | Pack signal values into a CAN FD message payload with up to 64 bytes — use to encode signals into flexible data-rate CAN frames for higher-bandwidth communication |
| CAN FD Unpack | c2000lib/Target Communication/CAN FD Unpack | R2023a+ | Extract signal values from a received CAN FD message payload — use to decode signals from flexible data-rate CAN frames with up to 64 data bytes |
| CAN Pack | c2000lib/Target Communication/CAN Pack | R2023a+ | Pack signal values into a CAN message payload according to a defined layout — use to encode multiple signals into the 8-byte CAN data field before transmission |
| CAN Unpack | c2000lib/Target Communication/CAN Unpack | R2023a+ | Extract signal values from a received CAN message payload — use to decode individual signals from the 8-byte CAN data field after reception |

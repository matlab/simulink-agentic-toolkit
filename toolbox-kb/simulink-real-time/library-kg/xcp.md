---
type: Simulink Block Category
title: Xcp
description: XCP measurement and calibration over CAN, CAN FD, and UDP
tags: [xcp]
status: stable
source: custom_library
library_root: Simulink Real-Time
category_path: Xcp
block_count: 12
---

# Xcp

Use these blocks for xcp.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| XCP CAN Configuration | xcprtlib/CAN/XCP CAN Configuration | R2024a+ | Configure an XCP-over-CAN session on the target — required to set up XCP measurement and calibration over CAN. |
| XCP CAN Data Acquisition | xcprtlib/CAN/XCP CAN Data Acquisition | R2024a+ | Acquire (measure) signals from an XCP slave over CAN — use to read measurement/calibration variables during real-time runs. |
| XCP CAN Data Stimulation | xcprtlib/CAN/XCP CAN Data Stimulation | R2024a+ | Stimulate (write) signals to an XCP slave over CAN — use to inject values into an ECU under test. |
| XCP CAN Transport Layer | xcprtlib/CAN/XCP CAN Transport Layer | R2023a+ | Generate and consume XCP messages that are transported by CAN hardware. |
| XCP CAN FD Configuration | xcprtlib/CAN FD/XCP CAN FD Configuration | R2024a+ | Configure an XCP-over-CAN FD session on the target — required to set up XCP over CAN FD. |
| XCP CAN FD Data Acquisition | xcprtlib/CAN FD/XCP CAN FD Data Acquisition | R2024a+ | Acquire signals from an XCP slave over CAN FD — use for higher-bandwidth XCP measurement. |
| XCP CAN FD Data Stimulation | xcprtlib/CAN FD/XCP CAN FD Data Stimulation | R2024a+ | Stimulate signals to an XCP slave over CAN FD — use to inject values into an ECU over CAN FD. |
| XCP CAN FD Transport Layer | xcprtlib/CAN FD/XCP CAN FD Transport Layer | R2023a+ | Generate and consume XCP messages that are transported by CAN FD hardware. |
| XCP UDP Bypass | xcprtlib/UDP/XCP UDP Bypass | R2024a+ | Perform ECU function bypassing over XCP-on-UDP — use to replace an ECU function with a model running on the target. |
| XCP UDP Configuration | xcprtlib/UDP/XCP UDP Configuration | R2024a+ | Configure an XCP-over-UDP/Ethernet session on the target — required to set up XCP over Ethernet. |
| XCP UDP Data Acquisition | xcprtlib/UDP/XCP UDP Data Acquisition | R2024a+ | Acquire signals from an XCP slave over UDP/Ethernet — use for high-rate XCP measurement over Ethernet. |
| XCP UDP Data Stimulation | xcprtlib/UDP/XCP UDP Data Stimulation | R2024a+ | Stimulate signals to an XCP slave over UDP/Ethernet — use to inject values into an ECU over Ethernet. |

---
type: Simulink Block Category
title: Xcp
description: XCP measurement and calibration protocol
tags: [xcp, calibration, measurement, acquisition, stimulation]
status: stable
source: mathworks_toolbox
library_root: Vehicle Network Toolbox
category_path: Xcp
block_count: 12
---

# Xcp

Use these blocks for xcp.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| XCP CAN Transport Layer | vntxcplib/CAN/XCP CAN Transport Layer | R2023a+ | Configure XCP-on-CAN transport — use for setting up measurement and calibration communication over CAN with ECUs |
| XCP CAN Configuration | vntxcplib/CAN/XCP CAN Configuration | R2023a+ | Configure XCP CAN connection parameters — use for defining slave address and timing for XCP measurement sessions |
| XCP CAN Data Acquisition | vntxcplib/CAN/XCP CAN Data Acquisition | R2023a+ | Acquire measurement data from an ECU via XCP-on-CAN — use for real-time signal monitoring during calibration |
| XCP CAN Data Stimulation | vntxcplib/CAN/XCP CAN Data Stimulation | R2023a+ | Stimulate ECU variables via XCP-on-CAN — use for overwriting calibration parameters in real time during testing |
| XCP CAN FD Transport Layer | vntxcplib/CAN FD/XCP CAN FD Transport Layer | R2023a+ | Configure XCP-on-CAN-FD transport — use for high-bandwidth measurement and calibration over CAN FD |
| XCP CAN FD Configuration | vntxcplib/CAN FD/XCP CAN FD Configuration | R2023a+ | Configure XCP CAN FD connection parameters — use for defining XCP session settings over CAN FD |
| XCP CAN FD Data Acquisition | vntxcplib/CAN FD/XCP CAN FD Data Acquisition | R2023a+ | Acquire measurement data via XCP-on-CAN-FD — use for high-bandwidth real-time signal monitoring |
| XCP CAN FD Data Stimulation | vntxcplib/CAN FD/XCP CAN FD Data Stimulation | R2023a+ | Stimulate ECU variables via XCP-on-CAN-FD — use for high-bandwidth calibration parameter injection |
| XCP UDP Bypass | vntxcplib/UDP/XCP UDP Bypass | R2023a+ | Bypass XCP transport for direct UDP access — use for raw XCP communication over Ethernet UDP |
| XCP UDP Configuration | vntxcplib/UDP/XCP UDP Configuration | R2023a+ | Configure XCP-on-UDP connection parameters — use for defining XCP session settings over Ethernet UDP |
| XCP UDP Data Acquisition | vntxcplib/UDP/XCP UDP Data Acquisition | R2023a+ | Acquire measurement data via XCP-on-UDP — use for real-time ECU signal monitoring over Ethernet |
| XCP UDP Data Stimulation | vntxcplib/UDP/XCP UDP Data Stimulation | R2023a+ | Stimulate ECU variables via XCP-on-UDP — use for calibration parameter injection over Ethernet |

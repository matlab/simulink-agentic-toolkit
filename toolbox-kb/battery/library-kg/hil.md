---
type: Simulink Block Category
title: Hil
description: Hardware-in-the-loop interfaces for BMS testing
tags: [hil, interface, emulation, hardware, realtime]
status: stable
source: mathworks_toolbox
library_root: Battery
category_path: Hil
block_count: 3
---

# Hil

Use these blocks for hil.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Active Interface | batt_lib/HIL/Active Interface | R2023a+ | Provide a hardware-in-the-loop interface for active battery emulation — use to connect a real-time battery model to physical BMS hardware for closed-loop HIL testing |
| Passive Balancing Interface | batt_lib/HIL/Passive Balancing Interface | R2023a+ | Interface a physical passive balancing circuit with a real-time battery model — use for HIL testing where real balancing FETs interact with simulated cell voltages |
| Passive Interface | batt_lib/HIL/Passive Interface | R2023a+ | Provide a hardware-in-the-loop interface for passive battery emulation — use to output simulated cell voltages to physical BMS sense wires for HIL validation |

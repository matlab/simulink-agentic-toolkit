---
type: Simulink Block Category
title: Hil
description: Hardware-in-the-loop interfaces for BMS testing (3 blocks)
tags: [toolbox-kb, battery, hil, interface, emulation, hardware, realtime]
status: stable
sources:
  - resource: matlab:batt_lib
source: toolbox_kb
managed_by: satk
library: Battery
kb_folder: battery
category: hil
block_count: 3
generated: { by: satk-toolbox-build/1, at: "2026-11-23T18:23:14Z" }
---

# Hil

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Active Interface | batt_lib/HIL/Active Interface | R2023a+ | Provide a hardware-in-the-loop interface for active battery emulation — use to connect a real-time battery model to physical BMS hardware for closed-loop HIL testing |
| Passive Balancing Interface | batt_lib/HIL/Passive Balancing Interface | R2023a+ | Interface a physical passive balancing circuit with a real-time battery model — use for HIL testing where real balancing FETs interact with simulated cell voltages |
| Passive Interface | batt_lib/HIL/Passive Interface | R2023a+ | Provide a hardware-in-the-loop interface for passive battery emulation — use to output simulated cell voltages to physical BMS sense wires for HIL validation |

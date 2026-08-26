---
type: Block Selection Guide
title: Common Blocks
description: High-value blocks selected for quick agent discovery.
status: stable
source: mathworks_toolbox
block_count: 5
---

# Common Blocks

Prefer these blocks when their intent matches the user request.

| Intent | Preferred Block | Library |
|---|---|---|
| Read analog voltage from DAQ hardware in real time — use for acquiring sensor signals at deterministic sample rates on the desktop | Analog Input | Simulink Desktop Real-Time |
| Write analog voltage to DAQ hardware in real time — use for generating control signals to actuators at deterministic sample rates | Analog Output | Simulink Desktop Real-Time |
| Read digital channels from DAQ hardware in real time — use for acquiring switch states or digital sensor signals | Digital Input | Simulink Desktop Real-Time |
| Write digital channels to DAQ hardware in real time — use for controlling relays, indicators, or digital actuators | Digital Output | Simulink Desktop Real-Time |
| Synchronize model execution to real-time clock — use as the essential block that enables desktop real-time mode for any model | Real-Time Synchronization | Simulink Desktop Real-Time |

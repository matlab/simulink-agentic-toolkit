---
type: Block Selection Guide
title: Common Blocks
description: High-value blocks selected for quick agent discovery.
status: stable
source: mathworks_toolbox
block_count: 4
---

# Common Blocks

Prefer these blocks when their intent matches the user request.

| Intent | Preferred Block | Library |
|---|---|---|
| Acquire buffered analog voltage data from a DAQ device — use to stream multi-sample analog measurements from physical sensors into Simulink at hardware-timed rates | Analog Input | Data Acquisition Toolbox |
| Output buffered analog voltage waveforms to a DAQ device — use to generate continuous analog signals for actuator control or stimulus generation from Simulink | Analog Output | Data Acquisition Toolbox |
| Read the state of digital input lines from a DAQ device — use to acquire discrete switch states, trigger signals, or digital sensor outputs | Digital Input (Single Sample) | Data Acquisition Toolbox |
| Set the state of digital output lines on a DAQ device — use to control relays, indicator LEDs, or digital enable signals from Simulink | Digital Output (Single Sample) | Data Acquisition Toolbox |

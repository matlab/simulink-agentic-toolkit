---
type: Simulink Block Category
title: Data acquisition
description: Hardware DAQ device interface blocks for analog and digital I/O
tags: [daq, analog, digital, acquisition, hardware]
status: stable
source: mathworks_toolbox
library_root: Data Acquisition Toolbox
category_path: Data acquisition
block_count: 6
---

# Data acquisition

Use these blocks for data acquisition.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Analog Input | daqlib/Analog Input | R2023a+ | Acquire buffered analog voltage data from a DAQ device — use to stream multi-sample analog measurements from physical sensors into Simulink at hardware-timed rates |
| Analog Input (Single Sample) | daqlib/Analog Input (Single Sample) | R2023a+ | Read a single analog voltage sample from a DAQ device each time step — use for slow-rate measurements where one sample per Simulink step is sufficient |
| Analog Output | daqlib/Analog Output | R2023a+ | Output buffered analog voltage waveforms to a DAQ device — use to generate continuous analog signals for actuator control or stimulus generation from Simulink |
| Analog Output (Single Sample) | daqlib/Analog Output (Single Sample) | R2023a+ | Write a single analog voltage value to a DAQ device each time step — use for setpoint-style analog outputs where one value per step drives the hardware |
| Digital Input (Single Sample) | daqlib/Digital Input (Single Sample) | R2023a+ | Read the state of digital input lines from a DAQ device — use to acquire discrete switch states, trigger signals, or digital sensor outputs |
| Digital Output (Single Sample) | daqlib/Digital Output (Single Sample) | R2023a+ | Set the state of digital output lines on a DAQ device — use to control relays, indicator LEDs, or digital enable signals from Simulink |

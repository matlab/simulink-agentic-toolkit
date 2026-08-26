---
type: Simulink Block Category
title: Hdl dsp support
description: HDL-compatible DSP System Toolbox blocks for FPGA implementation
tags: [hdl, fpga, dsp, filter, streaming]
status: stable
source: mathworks_toolbox
library_root: DSP System Toolbox HDL Support
category_path: Hdl dsp support
block_count: 6
---

# Hdl dsp support

Use these blocks for hdl dsp support.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Filtering | dsphdlsupportlib/Filtering | R2023a+ | HDL-optimized DSP filters with streaming interfaces — use for hardware-targeted filtering when DSP System Toolbox algorithms must run on FPGA |
| Signal Management | dsphdlsupportlib/Signal Management | R2023a+ | HDL-compatible signal buffering and frame management blocks — use for signal alignment and rate adaptation in FPGA DSP pipelines |
| Signal Operations | dsphdlsupportlib/Signal Operations | R2023a+ | HDL-optimized signal processing operations — use for time-domain signal manipulation in hardware-targeted designs |
| Sinks | dsphdlsupportlib/Sinks | R2023a+ | HDL-compatible signal display and capture blocks — use for debugging and verification within HDL-targeted DSP subsystems |
| Sources | dsphdlsupportlib/Sources | R2023a+ | HDL-compatible signal generators for stimulus and test — use to provide input waveforms within HDL-targeted subsystems |
| Statistics | dsphdlsupportlib/Statistics | R2023a+ | HDL-optimized statistical computations on streaming data — use for running mean, variance, or histogram in FPGA signal processing |

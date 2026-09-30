---
type: Simulink Block Category
title: Sinks
description: Scopes, logging, and simulation control outputs
tags: [scope, display, to file, to workspace, terminator, stop]
status: stable
source: custom_library
library_root: HDL Coder
category_path: Sinks
block_count: 9
---

# Sinks

Use these blocks for sinks.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Scope | hdlsllib/Commonly
Used Blocks/Scope | R2023a+ | Plot signals against time during simulation — use to view waveforms. |
| Display | hdlsllib/Sinks/Display | R2023a+ | Show the current numeric value of a signal — use for quick inspection. |
| Floating
Scope | hdlsllib/Sinks/Floating
Scope | R2023a+ | Scope that displays whichever signals you attach without wired connections — use for flexible signal viewing. |
| Scope | hdlsllib/Sinks/Scope | R2023a+ | Plot signals against time during simulation — use to view waveforms. |
| Stop Simulation | hdlsllib/Sinks/Stop Simulation | R2023a+ | Stop the simulation when its input is non-zero — use to end a run on a condition. |
| Terminator | hdlsllib/Sinks/Terminator | R2023a+ | Cap an unused output port to avoid warnings — use to terminate signals you don't need. |
| To File | hdlsllib/Sinks/To File | R2023a+ | Log a signal to a MAT-file during simulation — use to record data to disk. |
| To Workspace | hdlsllib/Sinks/To Workspace | R2023a+ | Log a signal to a MATLAB workspace variable — use to capture results for post-processing. |
| XY Graph | hdlsllib/Sinks/XY Graph | R2023a+ | Plot one signal against another (X-Y) during simulation — use to view trajectories or phase plots. |

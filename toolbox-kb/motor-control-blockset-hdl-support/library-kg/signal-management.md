---
type: Simulink Block Category
title: Signal management
description: Signal conditioning and compensation (2 blocks)
tags: [toolbox-kb, motor-control-blockset-hdl-support, signal management, dead-time, iir filter]
status: stable
sources:
  - resource: matlab:mcbhdllib
source: toolbox_kb
managed_by: satk
library: Motor Control Blockset HDL Support
kb_folder: motor-control-blockset-hdl-support
category: signal-management
block_count: 2
generated: { by: satk-toolbox-build/1, at: "2026-11-23T18:23:36Z" }
---

# Signal management

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Dead-Time Compensator | mcbhdllib/Signal Management/Dead-Time Compensator | R2024a+ | Compensate inverter dead-time distortion in the voltage command — use to improve current-waveform quality. |
| IIR Filter | mcbhdllib/Signal Management/IIR Filter | R2023a+ | General IIR filter — use for signal conditioning such as smoothing measured feedback in motor control. |

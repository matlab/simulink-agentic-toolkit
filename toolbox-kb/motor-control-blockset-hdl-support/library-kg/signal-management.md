---
type: Simulink Block Category
title: Signal management
description: Signal conditioning and compensation
tags: [signal management, dead-time, iir filter]
status: stable
source: custom_library
library_root: Motor Control Blockset HDL Support
category_path: Signal management
block_count: 2
---

# Signal management

Use these blocks for signal management.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Dead-Time Compensator | mcbhdllib/Signal Management/Dead-Time Compensator | R2024a+ | Compensate inverter dead-time distortion in the voltage command — use to improve current-waveform quality. |
| IIR Filter | mcbhdllib/Signal Management/IIR Filter | R2023a+ | General IIR filter — use for signal conditioning such as smoothing measured feedback in motor control. |

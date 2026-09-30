---
type: Simulink Block Category
title: Signal operations
description: Sample-rate change, delays, and holds
tags: [signal operations, delay, downsample, upsample, repeat, sample and hold, dc blocker]
status: stable
source: custom_library
library_root: DSP System Toolbox HDL Support
category_path: Signal operations
block_count: 6
---

# Signal operations

Use these blocks for signal operations.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| DC Blocker | dsphdlsupportsigops/DC Blocker | R2023a+ | Remove the DC (zero-frequency) component of a signal with a high-pass filter — use to eliminate DC offset. |
| Delay | dsphdlsupportsigops/Delay | R2023a+ | Delay a signal by a fixed number of samples — use for pipeline alignment in hardware datapaths. |
| Downsample | dsphdlsupportsigops/Downsample | R2023a+ | Keep every Nth sample to reduce the sample rate — use for decimation without filtering. |
| Repeat | dsphdlsupportsigops/Repeat | R2023a+ | Repeat each sample N times to increase the sample rate — use for zero-order-hold upsampling. |
| Sample and Hold | dsphdlsupportsigops/Sample and Hold | R2023a+ | Latch the input value on a trigger and hold it until the next trigger — use to sample a signal at events. |
| Upsample | dsphdlsupportsigops/Upsample | R2023a+ | Insert zeros between samples to increase the sample rate — use ahead of an interpolation filter. |

---
type: Simulink Block Category
title: Filtering
description: HDL-optimized streaming filters and rate-change filters
tags: [filtering, biquad, cic, fir, lms]
status: stable
source: custom_library
library_root: DSP System Toolbox HDL Support
category_path: Filtering
block_count: 7
---

# Filtering

Use these blocks for filtering.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Biquad Filter | dsphdlsupportfiltering/Biquad Filter | R2023a+ | HDL-optimized cascaded biquad (second-order-section) IIR filter — use for hardware-efficient IIR filtering of a streaming input. |
| CIC Decimation | dsphdlsupportfiltering/CIC Decimation | R2023a+ | HDL-optimized CIC decimation filter — use for multiplier-free high-ratio downsampling in hardware. |
| CIC Interpolation | dsphdlsupportfiltering/CIC Interpolation | R2023a+ | HDL-optimized CIC interpolation filter — use for multiplier-free high-ratio upsampling in hardware. |
| Discrete FIR Filter | dsphdlsupportfiltering/Discrete FIR Filter | R2023a+ | HDL-optimized FIR filter on a streaming input — use for hardware-efficient linear-phase filtering on FPGA/ASIC. |
| FIR Decimation | dsphdlsupportfiltering/FIR Decimation | R2023a+ | HDL-optimized polyphase FIR decimation filter — use to filter and downsample in one hardware block. |
| FIR Interpolation | dsphdlsupportfiltering/FIR Interpolation | R2023a+ | HDL-optimized polyphase FIR interpolation filter — use to filter and upsample in one hardware block. |
| LMS Filter | dsphdlsupportfiltering/LMS Filter | R2023a+ | HDL-optimized adaptive LMS filter — use for hardware adaptive filtering such as noise/echo cancellation and equalization. |

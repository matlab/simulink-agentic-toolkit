---
type: Simulink Block Category
title: Filtering
description: HDL-optimized streaming filters and rate-change filters
tags: [filtering, filter, cic, fir, biquad, lms, channelizer]
status: stable
source: custom_library
library_root: DSP HDL Toolbox
category_path: Filtering
block_count: 10
---

# Filtering

Use these blocks for filtering.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Biquad Filter | dsphdlfiltering2/Biquad Filter | R2023a+ | HDL-optimized cascaded biquad (second-order-section) IIR filter — use for hardware-efficient IIR filtering of a streaming sample input on FPGA/ASIC. |
| CIC Decimator | dsphdlfiltering2/CIC Decimator | R2023a+ | HDL-optimized CIC (cascaded integrator-comb) decimation filter — use for multiplier-free high-ratio downsampling in hardware. |
| CIC Interpolator | dsphdlfiltering2/CIC Interpolator | R2023a+ | HDL-optimized CIC interpolation filter — use for multiplier-free high-ratio upsampling in hardware. |
| Channel Synthesizer | dsphdlfiltering2/Channel Synthesizer | R2023a+ | HDL-optimized polyphase channel synthesizer — use to combine multiple baseband channels into one wideband stream in hardware. |
| Channelizer | dsphdlfiltering2/Channelizer | R2023a+ | HDL-optimized polyphase channelizer — use to split a wideband signal into multiple frequency channels in hardware. |
| Discrete FIR Filter | dsphdlfiltering2/Discrete FIR Filter | R2023a+ | HDL-optimized FIR filter on a streaming input — use for hardware-efficient linear-phase filtering on FPGA/ASIC. |
| FIR Decimator | dsphdlfiltering2/FIR Decimator | R2023a+ | HDL-optimized polyphase FIR decimation filter — use to filter and downsample in one hardware block. |
| FIR Interpolator | dsphdlfiltering2/FIR Interpolator | R2023a+ | HDL-optimized polyphase FIR interpolation filter — use to filter and upsample in one hardware block. |
| FIR Rate Converter | dsphdlfiltering2/FIR Rate Converter | R2023a+ | HDL-optimized FIR rational-rate (L/M) converter — use for combined interpolation and decimation in hardware. |
| LMS Filter | dsphdlfiltering2/LMS Filter | R2023a+ | HDL-optimized adaptive LMS filter — use for hardware adaptive filtering such as noise/echo cancellation and equalization. |

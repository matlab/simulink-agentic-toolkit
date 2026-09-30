---
type: Simulink Block Category
title: Signal operations
description: HDL-optimized resampling and sample-rate operations
tags: [signal operations, downsampler, upsampler, farrow, nco]
status: stable
source: custom_library
library_root: DSP HDL Toolbox
category_path: Signal operations
block_count: 5
---

# Signal operations

Use these blocks for signal operations.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Downsampler | dsphdlsigops2/Downsampler | R2023a+ | HDL-optimized downsampler that keeps every Nth streaming sample — use to reduce sample rate in hardware. |
| Farrow Rate Converter | dsphdlsigops2/Farrow Rate Converter | R2023a+ | HDL-optimized Farrow fractional-delay rate converter — use for arbitrary/fractional resampling in hardware. |
| NCO | dsphdlsigops2/NCO | R2023a+ | HDL-optimized numerically controlled oscillator generating sine/cosine from a phase accumulator — use as a hardware carrier or local-oscillator source. |
| Upsampler | dsphdlsigops2/Upsampler | R2023a+ | HDL-optimized upsampler that inserts zeros between streaming samples — use to increase sample rate in hardware. |
| NCO | dsphdlsrcs2/NCO | R2023a+ | HDL-optimized numerically controlled oscillator generating sine/cosine from a phase accumulator — use as a hardware carrier or local-oscillator source. |

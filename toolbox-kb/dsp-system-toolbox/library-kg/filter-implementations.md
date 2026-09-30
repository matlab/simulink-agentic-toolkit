---
type: Simulink Block Category
title: Filter implementations
description: Direct filter realizations (FIR/IIR/SOS/allpass)
tags: [filter implementations, fir filter, discrete filter, allpass, allpole, section filter, mimo fir]
status: stable
source: custom_library
library_root: DSP System Toolbox
category_path: Filter implementations
block_count: 12
---

# Filter implementations

Use these blocks for filter implementations.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Allpass Filter | dsparch4/Allpass Filter | R2023a+ | Apply an allpass filter that shapes phase without changing magnitude — use for phase equalization and fractional delay. |
| Allpole Filter | dsparch4/Allpole Filter | R2023a+ | Apply an all-pole (recursive) filter — use to implement AR or synthesis filters. |
| Biquad Filter | dsparch4/Biquad Filter | R2023a+ | Implement a general IIR filter using biquad structures. Biquad implementations of general IIR filters are often preferred due to their desirable numeric properties. |
| Discrete FIR Filter | dsparch4/Discrete FIR Filter | R2023a+ | Apply an FIR filter with given coefficients — use for general linear-phase filtering. |
| Discrete Filter | dsparch4/Discrete Filter | R2023a+ | Apply an IIR filter given numerator and denominator coefficients — use for general recursive filtering. |
| Fourth Order Section Filter | dsparch4/Fourth Order Section Filter | R2023a+ | Implement a filter as cascaded fourth-order sections — use for numerically-robust high-order filtering. |
| Frequency-Domain FIR Filter | dsparch4/Frequency-Domain FIR Filter | R2023a+ | Apply an FIR filter via overlap-add/save in the frequency domain — use for efficient long-FIR filtering. |
| MIMO FIR Filter | dsparch4/MIMO FIR Filter | R2025a+ | Apply a multi-input multi-output FIR filter (filter matrix) — use for multichannel filtering such as beamforming. |
| Second-Order Section Filter | dsparch4/Second-Order Section Filter | R2023a+ | Implement a filter as cascaded biquad (second-order) sections — use for numerically-robust IIR filtering. |
| FIR Decimation | dspmlti4/FIR Decimation | R2023a+ | Apply an FIR filter to the input signal, then downsample the signal by an integer-valued factor. The block implements the FIR filter using a polyphase filter structure. |
| FIR Interpolation | dspmlti4/FIR Interpolation | R2023a+ | Upsample the input signal by an integer-valued factor, then apply an FIR filter. The block scales the filter coefficients by the interpolation factor and implements the FIR filter using a polyphase structure. |
| FIR Rate Conversion | dspmlti4/FIR Rate Conversion | R2023a+ | Upsample the input signal by an integer-valued factor, apply an FIR filter, and downsample the input signal by another integer-valued factor. The block implements the FIR filter using a polyphase structure. |

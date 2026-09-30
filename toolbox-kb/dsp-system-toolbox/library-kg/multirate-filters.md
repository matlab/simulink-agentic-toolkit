---
type: Simulink Block Category
title: Multirate filters
description: Decimators, interpolators, and rate converters
tags: [multirate, decimator, interpolator, channelizer, halfband, rate converter, cic compensation]
status: stable
source: custom_library
library_root: DSP System Toolbox
category_path: Multirate filters
block_count: 17
---

# Multirate filters

Use these blocks for multirate filters.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| CIC Decimation | dspmlti4/CIC Decimation | R2023a+ | Apply a Cascaded Integrator-Comb Decimator filter to the input signal. The inputs and outputs of this block have a signed fixed-point data type with zero bias. You must have a Fixed-Point Designer license to use this block. |
| CIC Interpolation | dspmlti4/CIC Interpolation | R2023a+ | Apply a Cascaded Integrator-Comb Interpolator filter to the input signal. The inputs and outputs of this block have a signed fixed-point data type with zero bias. You must have a Fixed-Point Designer license to use this block. |
| CIC Compensation Decimator | dspmlti4/CIC Compensation Decimator | R2023a+ | Decimate while compensating CIC passband droop with an FIR — use after a CIC stage to flatten the response. |
| CIC Compensation Interpolator | dspmlti4/CIC Compensation Interpolator | R2023a+ | Interpolate while compensating CIC passband droop with an FIR — use before a CIC stage to flatten the response. |
| Channel Synthesizer | dspmlti4/Channel Synthesizer | R2023a+ | Combine multiple baseband channels into one wideband signal via a polyphase filter bank — use for channel multiplexing. |
| Channelizer | dspmlti4/Channelizer | R2023a+ | Split a wideband signal into multiple frequency channels via a polyphase filter bank — use for channel demultiplexing. |
| Complex Bandpass Decimator | dspmlti4/Complex Bandpass Decimator | R2023a+ | Frequency-shift and decimate to extract a complex bandpass channel — use to down-select a band of interest. |
| FIR Halfband Decimator | dspmlti4/FIR Halfband Decimator | R2023a+ | Decimate by two with an efficient FIR halfband filter — use for low-cost 2× downsampling. |
| FIR Halfband Interpolator | dspmlti4/FIR Halfband Interpolator | R2023a+ | Interpolate by two with an efficient FIR halfband filter — use for low-cost 2× upsampling. |
| Farrow Rate Converter | dspmlti4/Farrow Rate Converter | R2023a+ | Resample by an arbitrary/fractional ratio using a Farrow structure — use for continuously-variable sample-rate conversion. |
| IIR Halfband Decimator | dspmlti4/IIR Halfband Decimator | R2023a+ | Decimate by two with a low-cost IIR halfband filter — use for efficient 2× downsampling. |
| IIR Halfband Interpolator | dspmlti4/IIR Halfband Interpolator | R2023a+ | Interpolate by two with a low-cost IIR halfband filter — use for efficient 2× upsampling. |
| Sample-Rate Converter | dspmlti4/Sample-Rate Converter | R2023a+ | Convert between arbitrary sample rates with an automatically-designed multistage filter chain — use for high-quality rate conversion. |
| Variable FIR Decimation | dspmlti4/Variable FIR Decimation | R2023a+ | Decimate by a runtime-variable integer factor with an FIR — use for adjustable downsampling. |
| Variable FIR Interpolation | dspmlti4/Variable FIR Interpolation | R2023a+ | Interpolate by a runtime-variable integer factor with an FIR — use for adjustable upsampling. |
| Farrow Rate Converter | dspsigops/Farrow Rate Converter | R2023a+ | Resample by an arbitrary/fractional ratio using a Farrow structure — use for continuously-variable sample-rate conversion. |
| Sample-Rate Converter | dspsigops/Sample-Rate Converter | R2023a+ | Convert between arbitrary sample rates with an automatically-designed multistage filter chain — use for high-quality rate conversion. |

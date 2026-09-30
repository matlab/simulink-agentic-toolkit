---
type: Simulink Block Category
title: Signal operations
description: Delays, resampling, and up/down-conversion
tags: [signal operations, delay, downsample, down-converter, up-converter, dc blocker, phase extractor, smoother]
status: stable
source: custom_library
library_root: DSP System Toolbox
category_path: Signal operations
block_count: 21
---

# Signal operations

Use these blocks for signal operations.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Constant Ramp | dspsigops/Constant Ramp | R2023a+ | Generate a ramp of length L, where L is the length of the input signal in the dimension specified by the 'Ramp length equals number of' parameter. The output of this block is calculated using output = [0:L-1] * slope + offset |
| Convolution | dspsigops/Convolution | R2023a+ | Convolve two inputs in the time or frequency domain. To allow the block to compute the convolution in the domain that minimizes the number of computations, set the 'Computation domain' parameter to 'Fastest'. To minimize memory usage, set the 'Computation domain' parameter to 'Time'. |
| DC Blocker | dspsigops/DC Blocker | R2023a+ | Remove the DC component of a signal with a high-pass filter — use to eliminate DC offset. |
| Delay | dspsigops/Delay | R2023a+ | Delay a signal by a fixed number of samples — use for timing alignment or transport delay. |
| Digital Down-Converter | dspsigops/Digital Down-Converter | R2023a+ | Mix to baseband, filter, and decimate a passband signal — use to extract a channel to complex baseband. |
| Digital Up-Converter | dspsigops/Digital Up-Converter | R2023a+ | Interpolate, filter, and mix a baseband signal up to a carrier — use to place a channel at a target frequency. |
| Downsample | dspsigops/Downsample | R2023a+ | Keep every Nth sample to reduce the sample rate — use for decimation without filtering. |
| Interpolation | dspsigops/Interpolation | R2023a+ | Interpolate values between real-valued samples in one or more input vectors using linear or FIR interpolation. |
| Pad | dspsigops/Pad | R2023a+ | Append or prepend a constant value to the input along the specified dimensions. Truncation occurs when the specified output dimensions are shorter than the corresponding input dimensions. |
| Parameter Smoother | dspsigops/Parameter Smoother | R2024a+ | Smooth abrupt parameter changes with a one-pole ramp — use to avoid clicks or discontinuities when tuning parameters. |
| Peak Finder | dspsigops/Peak Finder | R2023a+ | Output the number of extrema (maxima and minima) in an input signal. |
| Phase Extractor | dspsigops/Phase Extractor | R2023a+ | Extract the unwrapped phase of a complex signal — use for phase or instantaneous-frequency analysis. |
| Repeat | dspsigops/Repeat | R2023a+ | Repeat input samples L times. |
| Truncate | dspsigops/Truncate | R2026a+ | Truncates input vectors by removing or keeping beginning or ending values. The resulting vectors are either truncated again or zero-padded to the specified output length. |
| Unwrap | dspsigops/Unwrap | R2023a+ | Add or subtract multiples of 2pi to each input element to remove phase discontinuities (unwrap). The input units are radians. |
| Upsample | dspsigops/Upsample | R2023a+ | Upsample by inserting L-1 zeros between input samples. |
| Variable Fractional Delay | dspsigops/Variable Fractional Delay | R2023a+ | Delay discrete-time input by the time-varying fractional number of sample periods specified by the 'Delay' input. The input delay is clipped to a valid range (Dmin to Dmax) that is determined by the parameter settings. The block provides Linear, FIR, and Farrow interpolation modes. In FIR mode, the filter is designed using the 'firnyquist' function when Bandwidth value is 1, and 'intfilt' function from the Signal Processing Toolbox when Bandwidth is smaller than 1. |
| Variable Integer Delay | dspsigops/Variable Integer Delay | R2023a+ | Delay a signal by a runtime-variable integer number of samples — use for adjustable time alignment. |
| Window Function | dspsigops/Window Function | R2023a+ | Generate a window function and/or apply a window function to an input signal. |
| Zero Crossing | dspsigops/Zero Crossing | R2023a+ | Counts the number of zero crossings in a signal. |
| Discrete  Impulse | dspsrcs4/Discrete  Impulse | R2023a+ | Output a discrete unit impulse. The impulse will be offset by the number of samples in the Delay parameter. |

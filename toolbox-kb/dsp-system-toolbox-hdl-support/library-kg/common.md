---
type: Block Selection Guide
title: Common Blocks
description: High-value blocks selected for quick agent discovery.
status: stable
source: custom_library
block_count: 27
---

# Common Blocks

Prefer these blocks when their intent matches the user request.

| Intent | Preferred Block | Library |
|---|---|---|
| HDL-optimized FIR filter on a streaming input — use for hardware-efficient linear-phase filtering on FPGA/ASIC. | Discrete FIR Filter | DSP System Toolbox HDL Support |
| HDL-optimized polyphase FIR decimation filter — use to filter and downsample in one hardware block. | FIR Decimation | DSP System Toolbox HDL Support |
| Convert a signal to a specified data type — use to set fixed-point word length and scaling for HDL-friendly arithmetic. | Data Type  Conversion | DSP System Toolbox HDL Support |
| Select a subset of elements from a signal by index — use to extract specific channels or samples. | Selector | DSP System Toolbox HDL Support |
| Delay a signal by a fixed number of samples — use for pipeline alignment in hardware datapaths. | Delay | DSP System Toolbox HDL Support |
| Output a constant value — use for fixed parameters, thresholds, or test inputs. | Constant | DSP System Toolbox HDL Support |
| Generate a sinusoidal signal — use as a test tone or reference input. | Sine Wave | DSP System Toolbox HDL Support |
| HDL-optimized cascaded biquad (second-order-section) IIR filter — use for hardware-efficient IIR filtering of a streaming input. | Biquad Filter | DSP System Toolbox HDL Support |
| HDL-optimized CIC decimation filter — use for multiplier-free high-ratio downsampling in hardware. | CIC Decimation | DSP System Toolbox HDL Support |
| HDL-optimized CIC interpolation filter — use for multiplier-free high-ratio upsampling in hardware. | CIC Interpolation | DSP System Toolbox HDL Support |
| HDL-optimized polyphase FIR interpolation filter — use to filter and upsample in one hardware block. | FIR Interpolation | DSP System Toolbox HDL Support |
| HDL-optimized adaptive LMS filter — use for hardware adaptive filtering such as noise/echo cancellation and equalization. | LMS Filter | DSP System Toolbox HDL Support |
| Reshape a 1-D signal into a 2-D matrix of specified dimensions — use to form frames or images from a sample stream. | Convert 1-D to 2-D | DSP System Toolbox HDL Support |
| Force a signal's complexity (real/complex) to match a reference input — use to resolve complexity mismatches in a model. | Inherit Complexity | DSP System Toolbox HDL Support |
| Split an input into several outputs by selecting specified rows/columns — use to route subsets of a vector or matrix signal. | Multiport Selector | DSP System Toolbox HDL Support |
| Select rows/columns from a signal using a runtime index input — use for dynamic element selection. | Variable Selector | DSP System Toolbox HDL Support |
| Remove the DC (zero-frequency) component of a signal with a high-pass filter — use to eliminate DC offset. | DC Blocker | DSP System Toolbox HDL Support |
| Keep every Nth sample to reduce the sample rate — use for decimation without filtering. | Downsample | DSP System Toolbox HDL Support |
| Repeat each sample N times to increase the sample rate — use for zero-order-hold upsampling. | Repeat | DSP System Toolbox HDL Support |
| Latch the input value on a trigger and hold it until the next trigger — use to sample a signal at events. | Sample and Hold | DSP System Toolbox HDL Support |
| Insert zeros between samples to increase the sample rate — use ahead of an interpolation filter. | Upsample | DSP System Toolbox HDL Support |
| Show the current numeric value of a signal during simulation — use for quick inspection. | Display | DSP System Toolbox HDL Support |
| Display the frequency spectrum of a signal during simulation — use to inspect spectral content. | Spectrum Analyzer | DSP System Toolbox HDL Support |
| Plot signals against time during simulation — use to view waveforms. | Time Scope | DSP System Toolbox HDL Support |
| Log a signal to a MATLAB workspace variable — use to capture results for post-processing. | To Workspace | DSP System Toolbox HDL Support |
| Compute the running or windowed maximum of a signal — use for peak detection or statistics. | Maximum | DSP System Toolbox HDL Support |
| Compute the running or windowed minimum of a signal — use for trough detection or statistics. | Minimum | DSP System Toolbox HDL Support |

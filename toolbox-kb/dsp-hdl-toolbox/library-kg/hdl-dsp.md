---
type: Simulink Block Category
title: Hdl dsp
description: HDL-optimized DSP blocks for FPGA signal processing
tags: [hdl, fpga, filter, fft, streaming]
status: stable
source: mathworks_toolbox
library_root: DSP HDL Toolbox
category_path: Hdl dsp
block_count: 8
---

# Hdl dsp

Use these blocks for hdl dsp.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Filtering | dsphdllib2/Filtering | R2023a+ | HDL-optimized digital filters (FIR, IIR, CIC) with streaming interfaces for FPGA — use when filter designs must be synthesized to hardware with deterministic latency and resource-efficient architectures |
| Math Functions | dsphdllib2/Math Functions | R2023a+ | HDL-optimized math operations (CORDIC, divide, sqrt) for FPGA — use for arithmetic computations that must map efficiently to hardware resources with fixed-point precision |
| Downsampler | dsphdlsigops2/Downsampler | R2023a+ | Decimate a streaming signal by an integer factor in HDL — use to reduce sample rate in multi-rate FPGA signal processing chains while maintaining streaming data flow |
| Farrow Rate Converter | dsphdlsigops2/Farrow Rate Converter | R2023a+ | Perform fractional sample rate conversion using a Farrow structure in HDL — use when input and output rates are not integer-related and the conversion must run on FPGA |
| NCO | dsphdlsigops2/NCO | R2023a+ | Generate sine/cosine waveforms using a numerically controlled oscillator in HDL — use for digital mixing, carrier generation, or phase modulation in FPGA-based receivers and transmitters |
| Upsampler | dsphdlsigops2/Upsampler | R2023a+ | Interpolate a streaming signal by an integer factor in HDL — use to increase sample rate in multi-rate FPGA signal processing chains |
| Sources | dsphdllib2/Sources | R2023a+ | HDL-compatible signal source blocks for test and stimulus generation — use to provide input waveforms to HDL-targeted signal processing subsystems |
| Transforms | dsphdllib2/Transforms | R2023a+ | HDL-optimized spectral transforms (FFT, IFFT, DCT) with streaming I/O — use for frequency-domain processing in FPGA-based systems requiring real-time spectral analysis |

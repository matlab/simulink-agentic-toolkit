---
type: Block Selection Guide
title: Common Blocks
description: High-value blocks selected for quick agent discovery.
status: stable
source: mathworks_toolbox
block_count: 5
---

# Common Blocks

Prefer these blocks when their intent matches the user request.

| Intent | Preferred Block | Library |
|---|---|---|
| HDL-optimized digital filters (FIR, IIR, CIC) with streaming interfaces for FPGA — use when filter designs must be synthesized to hardware with deterministic latency and resource-efficient architectures | Filtering | DSP HDL Toolbox |
| Decimate a streaming signal by an integer factor in HDL — use to reduce sample rate in multi-rate FPGA signal processing chains while maintaining streaming data flow | Downsampler | DSP HDL Toolbox |
| Generate sine/cosine waveforms using a numerically controlled oscillator in HDL — use for digital mixing, carrier generation, or phase modulation in FPGA-based receivers and transmitters | NCO | DSP HDL Toolbox |
| Interpolate a streaming signal by an integer factor in HDL — use to increase sample rate in multi-rate FPGA signal processing chains | Upsampler | DSP HDL Toolbox |
| HDL-optimized spectral transforms (FFT, IFFT, DCT) with streaming I/O — use for frequency-domain processing in FPGA-based systems requiring real-time spectral analysis | Transforms | DSP HDL Toolbox |

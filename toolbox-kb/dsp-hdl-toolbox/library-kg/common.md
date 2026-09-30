---
type: Block Selection Guide
title: Common Blocks
description: High-value blocks selected for quick agent discovery.
status: stable
source: custom_library
block_count: 17
---

# Common Blocks

Prefer these blocks when their intent matches the user request.

| Intent | Preferred Block | Library |
|---|---|---|
| HDL-optimized CIC (cascaded integrator-comb) decimation filter — use for multiplier-free high-ratio downsampling in hardware. | CIC Decimator | DSP HDL Toolbox |
| HDL-optimized FIR filter on a streaming input — use for hardware-efficient linear-phase filtering on FPGA/ASIC. | Discrete FIR Filter | DSP HDL Toolbox |
| HDL-optimized polyphase FIR decimation filter — use to filter and downsample in one hardware block. | FIR Decimator | DSP HDL Toolbox |
| HDL-optimized polyphase FIR interpolation filter — use to filter and upsample in one hardware block. | FIR Interpolator | DSP HDL Toolbox |
| HDL-optimized numerically controlled oscillator generating sine/cosine from a phase accumulator — use as a hardware carrier or local-oscillator source. | NCO | DSP HDL Toolbox |
| HDL-optimized numerically controlled oscillator generating sine/cosine from a phase accumulator — use as a hardware carrier or local-oscillator source. | NCO | DSP HDL Toolbox |
| HDL-optimized streaming FFT — use for hardware frequency-domain transforms on FPGA/ASIC. | FFT | DSP HDL Toolbox |
| HDL-optimized streaming inverse FFT — use for hardware time-domain reconstruction on FPGA/ASIC. | IFFT | DSP HDL Toolbox |
| HDL-optimized cascaded biquad (second-order-section) IIR filter — use for hardware-efficient IIR filtering of a streaming sample input on FPGA/ASIC. | Biquad Filter | DSP HDL Toolbox |
| HDL-optimized CIC interpolation filter — use for multiplier-free high-ratio upsampling in hardware. | CIC Interpolator | DSP HDL Toolbox |
| HDL-optimized polyphase channel synthesizer — use to combine multiple baseband channels into one wideband stream in hardware. | Channel Synthesizer | DSP HDL Toolbox |
| HDL-optimized polyphase channelizer — use to split a wideband signal into multiple frequency channels in hardware. | Channelizer | DSP HDL Toolbox |
| HDL-optimized FIR rational-rate (L/M) converter — use for combined interpolation and decimation in hardware. | FIR Rate Converter | DSP HDL Toolbox |
| HDL-optimized CORDIC conversion of a complex sample to magnitude and phase angle — use for hardware envelope/phase computation. | Complex to Magnitude-Angle | DSP HDL Toolbox |
| HDL-optimized downsampler that keeps every Nth streaming sample — use to reduce sample rate in hardware. | Downsampler | DSP HDL Toolbox |
| HDL-optimized Farrow fractional-delay rate converter — use for arbitrary/fractional resampling in hardware. | Farrow Rate Converter | DSP HDL Toolbox |
| HDL-optimized upsampler that inserts zeros between streaming samples — use to increase sample rate in hardware. | Upsampler | DSP HDL Toolbox |

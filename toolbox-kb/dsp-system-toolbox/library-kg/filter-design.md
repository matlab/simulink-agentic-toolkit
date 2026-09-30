---
type: Simulink Block Category
title: Filter design
description: Design-and-apply and tunable filter blocks
tags: [filter design, lowpass, highpass, bandpass, bandstop, notch, differentiator, hampel, median, variable bandwidth]
status: stable
source: custom_library
library_root: DSP System Toolbox
category_path: Filter design
block_count: 32
---

# Filter design

Use these blocks for filter design.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Analog Filter Design | dspfdesign/Analog Filter Design | R2023a+ | Design one of several standard analog filters, implemented in state-space form. |
| Bandpass FIR Filter Design | dspfdesign/Bandpass FIR Filter Design | R2024a+ | Design and apply a bandpass FIR filter from specifications — use to pass a frequency band with linear phase. |
| Bandpass IIR Filter Design | dspfdesign/Bandpass IIR Filter Design | R2024a+ | Design and apply a bandpass IIR filter from specifications — use to pass a frequency band at low filter order. |
| Bandstop FIR Filter Design | dspfdesign/Bandstop FIR Filter Design | R2024a+ | Design and apply a bandstop (band-reject) FIR filter — use to reject a frequency band with linear phase. |
| Bandstop IIR Filter Design | dspfdesign/Bandstop IIR Filter Design | R2024a+ | Design and apply a bandstop (band-reject) IIR filter — use to reject a frequency band at low order. |
| Differentiator Filter | dspfdesign/Differentiator Filter | R2023a+ | Apply an FIR differentiator that approximates the derivative — use to estimate a signal's slope or rate of change. |
| Hampel Filter | dspfdesign/Hampel Filter | R2023a+ | Remove outliers using a Hampel identifier over a sliding window — use for robust spike/outlier removal. |
| Highpass FIR Filter Design | dspfdesign/Highpass FIR Filter Design | R2024a+ | Design and apply a highpass FIR filter from specifications — use to remove low-frequency content with linear phase. |
| Highpass Filter | dspfdesign/Highpass Filter | R2023a+ | Apply a tunable highpass filter specified by cutoff frequency — use to remove low-frequency content or DC drift. |
| Highpass IIR Filter Design | dspfdesign/Highpass IIR Filter Design | R2024a+ | Design and apply a highpass IIR filter from specifications — use to remove low-frequency content at low order. |
| Lowpass FIR Filter Design | dspfdesign/Lowpass FIR Filter Design | R2024a+ | Design and apply a lowpass FIR filter from specifications — use for anti-aliasing or smoothing with linear phase. |
| Lowpass Filter | dspfdesign/Lowpass Filter | R2023a+ | Apply a tunable lowpass filter specified by cutoff frequency — use for smoothing or anti-aliasing. |
| Lowpass IIR Filter Design | dspfdesign/Lowpass IIR Filter Design | R2024a+ | Design and apply a lowpass IIR filter from specifications — use for smoothing/anti-aliasing at low order. |
| Median Filter | dspfdesign/Median Filter | R2023a+ | Apply a sliding-window median filter — use to remove impulse noise while preserving edges. |
| Notch-Peak Filter | dspfdesign/Notch-Peak Filter | R2023a+ | Apply a tunable second-order notch or peak filter — use to reject or emphasize a specific frequency. |
| Variable Bandwidth FIR Filter | dspfdesign/Variable Bandwidth FIR Filter | R2023a+ | FIR filter whose bandwidth/cutoff is tunable at runtime — use for adjustable filtering with linear phase. |
| Variable Bandwidth IIR Filter | dspfdesign/Variable Bandwidth IIR Filter | R2023a+ | IIR filter whose bandwidth/cutoff is tunable at runtime — use for low-order adjustable filtering. |
| Digital Filter Design | dspfdesign/Digital Filter Design | R2023a+ | Launches FDATool to design and implement single-rate filters using the Digital Filter block. |
| Bandpass FIR Filter Design | dspfiltersrcs/Bandpass FIR Filter Design | R2024a+ | Design and apply a bandpass FIR filter from specifications — use to pass a frequency band with linear phase. |
| Bandpass IIR Filter Design | dspfiltersrcs/Bandpass IIR Filter Design | R2024a+ | Design and apply a bandpass IIR filter from specifications — use to pass a frequency band at low filter order. |
| Bandstop FIR Filter Design | dspfiltersrcs/Bandstop FIR Filter Design | R2024a+ | Design and apply a bandstop (band-reject) FIR filter — use to reject a frequency band with linear phase. |
| Bandstop IIR Filter Design | dspfiltersrcs/Bandstop IIR Filter Design | R2024a+ | Design and apply a bandstop (band-reject) IIR filter — use to reject a frequency band at low order. |
| Highpass FIR Filter Design | dspfiltersrcs/Highpass FIR Filter Design | R2024a+ | Design and apply a highpass FIR filter from specifications — use to remove low-frequency content with linear phase. |
| Highpass IIR Filter Design | dspfiltersrcs/Highpass IIR Filter Design | R2024a+ | Design and apply a highpass IIR filter from specifications — use to remove low-frequency content at low order. |
| Lowpass FIR Filter Design | dspfiltersrcs/Lowpass FIR Filter Design | R2024a+ | Design and apply a lowpass FIR filter from specifications — use for anti-aliasing or smoothing with linear phase. |
| Lowpass IIR Filter Design | dspfiltersrcs/Lowpass IIR Filter Design | R2024a+ | Design and apply a lowpass IIR filter from specifications — use for smoothing/anti-aliasing at low order. |
| Dyadic Analysis Filter Bank | dspmlti4/Dyadic Analysis Filter Bank | R2023a+ | Compute the Discrete Wavelet Transform or decompose a signal into subbands with smaller bandwidths and slower sample rates. This block uses a filter bank with lowpass and highpass FIR filters that you specify either directly on the block mask, or using wavelets from the Wavelet Toolbox. The lowpass and highpass filters are usually half-band filters designed to complement each other. Inputs are always interpreted as frames. The frame size must be a multiple of 2^n, where you specify n in the 'Number of levels' parameter. When the 'Output' parameter is set to 'Multiple ports', the block outputs each subband from a different port as a vector or matrix. The topmost port outputs the subband with the highest frequency band. When the 'Output' parameter is set to 'Single port', the block outputs one vector or matrix of concatenated subbands. |
| Dyadic Synthesis Filter Bank | dspmlti4/Dyadic Synthesis Filter Bank | R2023a+ | Compute the Inverse Discrete Wavelet Transform or reconstruct a signal from subbands with smaller bandwidths and slower sample rates. This block uses a filter bank with lowpass and highpass FIR filters that you specify either directly on the block mask, or using wavelets from the Wavelet Toolbox. The lowpass and highpass filters are usually half-band filters designed to complement each other. When 'Input' is set to 'Multiple ports', you must provide each subband to the block through a different input port as a vector or matrix. You should input the highest frequency band through the topmost port. When 'Input' is set to 'Single port', the block input must be a vector or matrix of concatenated subbands. |
| Two-Channel Analysis Subband Filter | dspmlti4/Two-Channel Analysis Subband Filter | R2023a+ | Decompose a signal into a high-frequency subband (Hi band) and a low-frequency subband (Lo band) using the specified highpass and lowpass FIR filters. Each subband has half the bandwidth and half the sample rate of the original signal. Usually, the highpass and lowpass filters should be half-band filters designed to complement each other. |
| Two-Channel Synthesis Subband Filter | dspmlti4/Two-Channel Synthesis Subband Filter | R2023a+ | Reconstruct a signal from a high-frequency subband (Hi band) and a low-frequency subband (Lo band) using the specified highpass and lowpass FIR filters. The input subbands should have the same bandwidths and sample rates. Usually, the highpass and lowpass filters should be half-band filters designed to complement each other. |
| Median | dspstat3/Median | R2023a+ | Compute the median value along the specified dimension of the input. The 'Product output' and 'Accumulator' parameters apply only for complex fixed-point inputs. |
| Median Filter | dspstat3/Median Filter | R2023a+ | Apply a sliding-window median filter — use to remove impulse noise while preserving edges. |

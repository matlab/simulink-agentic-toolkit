---
type: Simulink Block Category
title: Rf impairments
description: RF impairment models and their correction
tags: [rf impairments, agc, dpd, nonlinearity, phase noise, thermal noise, imbalance, offset, coarse frequency]
status: stable
source: custom_library
library_root: Communications Toolbox
category_path: Rf impairments
block_count: 13
---

# Rf impairments

Use these blocks for rf impairments.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| AGC | commrfcorlib/AGC | R2023a+ | Automatic gain control that normalizes signal amplitude — use to stabilize level before demodulation or synchronization. |
| DPD | commrfcorlib/DPD | R2023a+ | Apply digital predistortion to linearize a power amplifier — use to compensate PA nonlinearity in the transmitter. |
| DPD Coefficient Estimator | commrfcorlib/DPD Coefficient Estimator | R2023a+ | Estimate digital-predistortion coefficients from PA input/output data — use to train the DPD block. |
| I/Q Imbalance Compensator | commrfcorlib/I/Q Imbalance Compensator | R2023a+ | Correct amplitude and phase imbalance between the I and Q branches — use to fix receiver IQ impairments. |
| Phase/ Frequency Offset | commrfcorlib/Phase/ Frequency Offset | R2023a+ | Apply or model a phase and/or frequency offset on a signal — use to inject or correct carrier offsets. |
| Memoryless Nonlinearity | commrflib2/Memoryless Nonlinearity | R2023a+ | Model a memoryless RF nonlinearity (AM/AM, AM/PM, compression) — use to distort a signal like a nonlinear power amplifier. |
| Phase Noise | commrflib2/Phase Noise | R2023a+ | Add phase noise with a specified spectral profile — use to model oscillator/local-oscillator impairments. |
| Phase/ Frequency Offset | commrflib2/Phase/ Frequency Offset | R2023a+ | Apply or model a phase and/or frequency offset on a signal — use to inject or correct carrier offsets. |
| Receiver Thermal Noise | commrflib2/Receiver Thermal Noise | R2023a+ | Add thermal noise based on noise figure or temperature — use to model receiver front-end noise. |
| Sample Rate Offset | commrflib2/Sample Rate Offset | R2023a+ | Apply a small sampling-clock rate offset — use to model timing-clock mismatch between transmitter and receiver. |
| Free Space Path Loss | commrflib2/Free Space Path Loss | R2023a+ | Reduce the amplitude of the input signal by the amount specified. You specify the loss directly using the 'Decibels' mode or indirectly using the 'Distance and Frequency' mode. The reciprocal of the loss is applied as a gain, e.g., a loss of +20 dB, which reduces the signal by a factor of 10, corresponds to a gain value of 0.1. This block accepts a scalar or column vector input signal. |
| Multiband Combiner | commrflib2/Multiband Combiner | R2023a+ | Combine baseband signals after shifting them to the desired frequency bands. Input signals are interpolated, if needed, to avoid distortion before shifting them per the frequency offsets parameter values. The interpolation factor is determined automatically or per the ratio of output sample rate to input sample rate. |
| Sample-Rate Match | commrflib2/Sample-Rate Match | R2023a+ | Upsample the input signals with different sample rates to a common output sample rate. |

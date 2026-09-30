---
type: Simulink Block Category
title: Channels
description: Channel models: noise, fading, and channel response
tags: [channels, awgn, fading, symmetric channel, channel response]
status: stable
source: custom_library
library_root: Communications Toolbox
category_path: Channels
block_count: 8
---

# Channels

Use these blocks for channels.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| AWGN Channel | commchan3/AWGN Channel | R2023a+ | Add additive white Gaussian noise at a specified SNR/Eb-No to a baseband signal — use to model a noisy channel for BER testing. |
| Binary Symmetric Channel | commchan3/Binary Symmetric Channel | R2023a+ | Flip input bits with a specified probability — use to model a simple binary channel for coding studies. |
| MIMO Fading Channel | commchan3/MIMO Fading Channel | R2023a+ | Model a multi-antenna (MIMO) fading channel with spatial correlation and Doppler — use to test spatial-multiplexing and diversity links. |
| OFDM Channel Response | commchan3/OFDM Channel Response | R2023a+ | Compute the frequency response of a channel across OFDM subcarriers — use to visualize or equalize per-subcarrier channel effects. |
| SISO Fading Channel | commchan3/SISO Fading Channel | R2023a+ | Model a single-antenna Rayleigh/Rician fading channel with Doppler — use to test link robustness to multipath fading. |
| MIMO Fading Channel | commmimo/MIMO Fading Channel | R2023a+ | Model a multi-antenna (MIMO) fading channel with spatial correlation and Doppler — use to test spatial-multiplexing and diversity links. |
| Differential Decoder | commsrccod2/Differential Decoder | R2023a+ | Differentially decode the input data. This block treats columns as channels. The output of this block is the logical difference between the consecutive input elements. |
| Differential Encoder | commsrccod2/Differential Encoder | R2023a+ | Differentially encode the input data. This block treats columns as channels. The output of this block is the logical difference between the current input element and the previous output element. |

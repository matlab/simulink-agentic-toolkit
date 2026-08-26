---
type: Block Selection Guide
title: Common Blocks
description: High-value blocks selected for quick agent discovery.
status: stable
source: mathworks_toolbox
block_count: 6
---

# Common Blocks

Prefer these blocks when their intent matches the user request.

| Intent | Preferred Block | Library |
|---|---|---|
| Model wireless propagation channels including AWGN, fading, and multipath effects — use to simulate realistic signal degradation between transmitter and receiver | Channels | Communications Toolbox |
| Apply communications-specific filters such as raised cosine, Gaussian, and matched filters — use for pulse shaping at the transmitter or matched filtering at the receiver | Comm Filters | Communications Toolbox |
| Display and analyze communications signals with eye diagrams, constellation plots, and BER meters — use for visual inspection and performance measurement of comm links | Comm Sinks | Communications Toolbox |
| Generate communications test signals including random data, PN sequences, and standard waveforms — use as input to modulation and coding blocks during link simulation | Comm Sources | Communications Toolbox |
| Encode and decode data with forward error correction codes (convolutional, turbo, LDPC, Reed-Solomon) — use to add redundancy that enables error-free reception at lower SNR | Error Detection and Correction | Communications Toolbox |
| Map digital data to analog waveforms (QAM, PSK, FSK, OFDM) and demodulate received signals — use as the core physical-layer mapping between bits and transmitted symbols | Modulation | Communications Toolbox |

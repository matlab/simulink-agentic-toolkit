---
type: Simulink Block Category
title: Signal processing
description: Filters, equalizers, synchronization, and sequence operations
tags: [filter, equalizer, synchronization, sequence, spreading]
status: stable
source: mathworks_toolbox
library_root: Communications Toolbox
category_path: Signal processing
block_count: 4
---

# Signal processing

Use these blocks for signal processing.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Comm Filters | commlibv2/Comm Filters | R2023a+ | Apply communications-specific filters such as raised cosine, Gaussian, and matched filters — use for pulse shaping at the transmitter or matched filtering at the receiver |
| Equalizers | commlibv2/Equalizers | R2023a+ | Compensate for channel distortion using adaptive equalizers (LMS, RLS, decision feedback) — use to recover data from ISI-corrupted received signals in frequency-selective channels |
| Sequence Operations | commlibv2/Sequence Operations | R2023a+ | Generate and manipulate pseudorandom sequences (Gold, Kasami, PN) and perform spreading/despreading — use for CDMA, scrambling, or synchronization sequence generation |
| Synchronization | commlibv2/Synchronization | R2023a+ | Recover timing, frequency, and frame synchronization from received signals — use to align the receiver clock and carrier with the incoming waveform before demodulation |

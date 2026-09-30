---
type: Simulink Block Category
title: Equalizers
description: Adaptive and OFDM equalizers
tags: [equalizers, equalizer, decision feedback]
status: stable
source: custom_library
library_root: Communications Toolbox
category_path: Equalizers
block_count: 3
---

# Equalizers

Use these blocks for equalizers.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Decision Feedback Equalizer | commeq3/Decision Feedback Equalizer | R2023a+ | Equalize a dispersive channel using feedforward and decision-feedback taps — use to cancel post-cursor inter-symbol interference. |
| Linear Equalizer | commeq3/Linear Equalizer | R2023a+ | Equalize a channel with an adaptive linear FIR filter (LMS/RLS) — use to mitigate inter-symbol interference at the receiver. |
| OFDM Equalizer | commeq3/OFDM Equalizer | R2023a+ | Equalize per-subcarrier channel effects in an OFDM system — use after OFDM demodulation to correct channel distortion. |

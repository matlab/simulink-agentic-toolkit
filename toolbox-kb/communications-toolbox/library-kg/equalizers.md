---
type: Simulink Block Category
title: Equalizers
description: Adaptive and OFDM equalizers (3 blocks)
tags: [toolbox-kb, communications-toolbox, equalizers, equalizer, decision feedback]
status: stable
sources:
  - resource: matlab:commeq3
source: toolbox_kb
managed_by: satk
library: Communications Toolbox
kb_folder: communications-toolbox
category: equalizers
block_count: 3
generated: { by: satk-toolbox-build/1, at: "2026-11-23T18:23:15Z" }
---

# Equalizers

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Decision Feedback Equalizer | commeq3/Decision Feedback Equalizer | R2023a+ | Equalize a dispersive channel using feedforward and decision-feedback taps — use to cancel post-cursor inter-symbol interference. |
| Linear Equalizer | commeq3/Linear Equalizer | R2023a+ | Equalize a channel with an adaptive linear FIR filter (LMS/RLS) — use to mitigate inter-symbol interference at the receiver. |
| OFDM Equalizer | commeq3/OFDM Equalizer | R2023a+ | Equalize per-subcarrier channel effects in an OFDM system — use after OFDM demodulation to correct channel distortion. |

---
type: Simulink Block Category
title: Comm filters
description: Pulse-shaping and conditioning filters for HDL links
tags: [comm filters, raised cosine, dc blocker]
status: stable
source: custom_library
library_root: Communications Toolbox HDL Support
category_path: Comm filters
block_count: 3
---

# Comm filters

Use these blocks for comm filters.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| DC Blocker | commhdlfilt/DC Blocker | R2023a+ | Remove the DC (zero-frequency) component of a signal with a high-pass filter — use to eliminate DC offset before demodulation. |
| Raised Cosine Receive Filter | commhdlfilt/Raised Cosine Receive Filter | R2023a+ | Matched raised-cosine receive filter with optional decimation — use for matched filtering at the receiver to limit inter-symbol interference. |
| Raised Cosine Transmit Filter | commhdlfilt/Raised Cosine Transmit Filter | R2023a+ | Raised-cosine transmit pulse-shaping filter with upsampling — use to band-limit transmitted symbols and control inter-symbol interference. |

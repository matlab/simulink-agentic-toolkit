---
type: Simulink Block Category
title: Comm filters
description: Pulse-shaping and conditioning filters for HDL links (3 blocks)
tags: [toolbox-kb, communications-toolbox-hdl-support, comm filters, raised cosine, dc blocker]
status: stable
sources:
  - resource: matlab:commhdlfilt
source: toolbox_kb
managed_by: satk
library: Communications Toolbox HDL Support
kb_folder: communications-toolbox-hdl-support
category: comm-filters
block_count: 3
generated: { by: satk-toolbox-build/1, at: "2026-11-23T18:23:16Z" }
---

# Comm filters

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| DC Blocker | commhdlfilt/DC Blocker | R2023a+ | Remove the DC (zero-frequency) component of a signal with a high-pass filter — use to eliminate DC offset before demodulation. |
| Raised Cosine Receive Filter | commhdlfilt/Raised Cosine Receive Filter | R2023a+ | Matched raised-cosine receive filter with optional decimation — use for matched filtering at the receiver to limit inter-symbol interference. |
| Raised Cosine Transmit Filter | commhdlfilt/Raised Cosine Transmit Filter | R2023a+ | Raised-cosine transmit pulse-shaping filter with upsampling — use to band-limit transmitted symbols and control inter-symbol interference. |

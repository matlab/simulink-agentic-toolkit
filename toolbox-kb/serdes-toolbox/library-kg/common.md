---
type: Block Selection Guide
title: Common Blocks
description: High-value blocks selected for quick agent discovery.
status: stable
source: mathworks_toolbox
block_count: 3
---

# Common Blocks

Prefer these blocks when their intent matches the user request.

| Intent | Preferred Block | Library |
|---|---|---|
| Extract clock and data from an incoming serial bit stream — use for synchronizing receiver sampling to the optimal eye opening position | Clock Data Recovery | SerDes Toolbox |
| Equalize inter-symbol interference using post-cursor feedback with integrated clock recovery — use for high-speed serial link receivers requiring both ISI cancellation and timing recovery | Decision Feedback Equalizer w/ CDR | SerDes Toolbox |
| Apply linear equalization using a tapped delay line — use for pre-emphasis at the transmitter or linear equalization at the receiver to compensate channel loss | Feed-Forward Equalizer | SerDes Toolbox |

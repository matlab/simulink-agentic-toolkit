---
type: Simulink Block Category
title: Sequence layers
description: Recurrent layers (LSTM, GRU) and reshaping for sequence processing
tags: [lstm, gru, sequence, recurrent, flatten]
status: stable
source: mathworks_toolbox
library_root: Deep Learning Toolbox
category_path: Sequence layers
block_count: 5
---

# Sequence layers

Use these blocks for sequence layers.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Flatten Layer | dlsequencelib/Flatten Layer | R2024b+ | Reshape a multi-dimensional input into a 1-D vector — use to transition from convolutional feature maps to fully connected layers or sequence inputs |
| GRU Layer | dlsequencelib/GRU Layer | R2025a+ | Apply a Gated Recurrent Unit for sequence modeling — use for temporal pattern recognition in time-series data with lower computational cost than LSTM |
| GRU Projected Layer | dlsequencelib/GRU Projected Layer | R2025a+ | Apply a GRU with projection to reduce output dimensionality — use for sequence tasks where a lower-dimensional hidden state reduces computation without losing accuracy |
| LSTM Layer | dlsequencelib/LSTM Layer | R2024b+ | Apply a Long Short-Term Memory layer for sequence modeling — use for temporal dependencies in time-series prediction, speech, or sequential signal processing |
| LSTM Projected Layer | dlsequencelib/LSTM Projected Layer | R2024b+ | Apply an LSTM with projection to reduce hidden state size — use when the full LSTM hidden dimension is larger than needed for the downstream task |

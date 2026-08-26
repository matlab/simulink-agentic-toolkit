---
type: Simulink Block Category
title: Utility layers
description: Dropout, reshape, permute, and other structural utility layers
tags: [dropout, reshape, permute, slice, identity]
status: stable
source: mathworks_toolbox
library_root: Deep Learning Toolbox
category_path: Utility layers
block_count: 4
---

# Utility layers

Use these blocks for utility layers.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Dropout Layer | dlutilitylib/Dropout Layer | R2024b+ | Randomly zero activations during training for regularization — use to prevent overfitting by forcing the network to learn redundant representations |
| Identity Layer | dlutilitylib/Identity Layer | R2026a+ | Pass input through unchanged — use as a placeholder or naming point in complex architectures for clarity or to mark branch points |
| Scaling Layer | dlutilitylib/Scaling Layer | R2026a+ | Multiply input by a constant factor — use to apply fixed gain to activations for calibration or to match output ranges to downstream requirements |
| Spatial Dropout Layer | dlutilitylib/Spatial Dropout Layer | R2026a+ | Drop entire feature channels rather than individual elements during training — use for spatial regularization in convolutional networks where adjacent activations are correlated |

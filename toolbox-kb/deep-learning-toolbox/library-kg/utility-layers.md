---
type: Simulink Block Category
title: Utility layers
description: "Dropout, reshape, permute, and other structural utility layers (4 blocks)"
tags: [toolbox-kb, deep-learning-toolbox, dropout, reshape, permute, slice, identity]
status: stable
sources:
  - resource: matlab:dlutilitylib
source: toolbox_kb
managed_by: satk
library: Deep Learning Toolbox
kb_folder: deep-learning-toolbox
category: utility-layers
block_count: 4
generated: { by: satk-toolbox-build/1, at: "2026-11-23T18:23:18Z" }
---

# Utility layers

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Dropout Layer | dlutilitylib/Dropout Layer | R2024b+ | Randomly zero activations during training for regularization — use to prevent overfitting by forcing the network to learn redundant representations |
| Identity Layer | dlutilitylib/Identity Layer | R2026a+ | Pass input through unchanged — use as a placeholder or naming point in complex architectures for clarity or to mark branch points |
| Scaling Layer | dlutilitylib/Scaling Layer | R2026a+ | Multiply input by a constant factor — use to apply fixed gain to activations for calibration or to match output ranges to downstream requirements |
| Spatial Dropout Layer | dlutilitylib/Spatial Dropout Layer | R2026a+ | Drop entire feature channels rather than individual elements during training — use for spatial regularization in convolutional networks where adjacent activations are correlated |

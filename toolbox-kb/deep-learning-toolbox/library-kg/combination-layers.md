---
type: Simulink Block Category
title: Combination layers
description: Addition, concatenation, and multiplication for merging network branches
tags: [addition, concatenation, multiplication, merge, skip]
status: stable
source: mathworks_toolbox
library_root: Deep Learning Toolbox
category_path: Combination layers
block_count: 4
---

# Combination layers

Use these blocks for combination layers.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Addition Layer | dlcombinationlib/Addition Layer | R2024b+ | Element-wise add multiple input tensors — use for residual (skip) connections that sum the shortcut path with the main path in ResNet-style architectures |
| Concatenation Layer | dlcombinationlib/Concatenation Layer | R2024b+ | Concatenate inputs along a specified dimension — use to merge features from parallel branches or combine multi-scale representations |
| Depth Concatenation Layer | dlcombinationlib/Depth Concatenation Layer | R2024b+ | Concatenate inputs along the channel (depth) dimension — use in inception modules or U-Net skip connections that stack feature maps from different paths |
| Multiplication Layer | dlcombinationlib/Multiplication Layer | R2024b+ | Element-wise multiply input tensors — use for attention mechanisms, feature gating, or multiplicative interactions between network branches |

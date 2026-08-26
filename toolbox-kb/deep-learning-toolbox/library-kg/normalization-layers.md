---
type: Simulink Block Category
title: Normalization layers
description: Batch, instance, and layer normalization for training stability
tags: [normalization, batch, instance, layer, norm]
status: stable
source: mathworks_toolbox
library_root: Deep Learning Toolbox
category_path: Normalization layers
block_count: 3
---

# Normalization layers

Use these blocks for normalization layers.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Batch Normalization Layer | dlnormalizationlib/Batch Normalization Layer | R2024b+ | Normalize activations across the batch using learned scale and offset — use between convolution and activation to stabilize training and accelerate convergence |
| Instance Normalization Layer | dlnormalizationlib/Instance Normalization Layer | R2026a+ | Normalize each sample independently across spatial dimensions — use in style transfer or generative networks where batch statistics are inappropriate |
| Layer Normalization Layer | dlnormalizationlib/Layer Normalization Layer | R2024b+ | Normalize activations across features within each sample — use in transformer architectures or recurrent networks where batch normalization is unsuitable |

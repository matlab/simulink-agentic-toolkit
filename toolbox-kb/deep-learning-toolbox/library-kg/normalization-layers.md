---
type: Simulink Block Category
title: Normalization layers
description: "Batch, instance, and layer normalization for training stability (3 blocks)"
tags: [toolbox-kb, deep-learning-toolbox, normalization, batch, instance, layer, norm]
status: stable
sources:
  - resource: matlab:dlnormalizationlib
source: toolbox_kb
managed_by: satk
library: Deep Learning Toolbox
kb_folder: deep-learning-toolbox
category: normalization-layers
block_count: 3
generated: { by: satk-toolbox-build/1, at: "2026-11-23T18:23:18Z" }
---

# Normalization layers

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Batch Normalization Layer | dlnormalizationlib/Batch Normalization Layer | R2024b+ | Normalize activations across the batch using learned scale and offset — use between convolution and activation to stabilize training and accelerate convergence |
| Instance Normalization Layer | dlnormalizationlib/Instance Normalization Layer | R2026a+ | Normalize each sample independently across spatial dimensions — use in style transfer or generative networks where batch statistics are inappropriate |
| Layer Normalization Layer | dlnormalizationlib/Layer Normalization Layer | R2024b+ | Normalize activations across features within each sample — use in transformer architectures or recurrent networks where batch normalization is unsuitable |

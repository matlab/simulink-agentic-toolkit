---
type: Simulink Block Category
title: Pooling layers
description: Spatial and temporal pooling layers for dimensionality reduction
tags: [pooling, max, average, global, downsample]
status: stable
source: mathworks_toolbox
library_root: Deep Learning Toolbox
category_path: Pooling layers
block_count: 12
---

# Pooling layers

Use these blocks for pooling layers.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Average Pooling 1D Layer | dlpoolinglib/Average Pooling 1D Layer | R2024b+ | Reduce temporal resolution by averaging over sliding windows — use to downsample 1-D feature maps while preserving smooth signal characteristics |
| Average Pooling 2D Layer | dlpoolinglib/Average Pooling 2D Layer | R2024b+ | Reduce spatial resolution by averaging over 2-D sliding windows — use to downsample feature maps while preserving average activation patterns |
| Average Pooling 3D Layer | dlpoolinglib/Average Pooling 3D Layer | R2024b+ | Reduce volumetric resolution by averaging over 3-D sliding windows — use to downsample 3-D feature maps in video or medical imaging networks |
| Global Average Pooling 1D Layer | dlpoolinglib/Global Average Pooling 1D Layer | R2024b+ | Reduce each 1-D feature channel to a single value by global averaging — use before the classification head to make the network input-length invariant |
| Global Average Pooling 2D Layer | dlpoolinglib/Global Average Pooling 2D Layer | R2024b+ | Reduce each 2-D feature map to a single value by global averaging — use before the classification head to replace fully connected layers with spatial invariance |
| Global Average Pooling 3D Layer | dlpoolinglib/Global Average Pooling 3D Layer | R2024b+ | Reduce each 3-D feature volume to a single value by global averaging — use before classification to achieve spatial invariance in volumetric networks |
| Global Max Pooling 1D Layer | dlpoolinglib/Global Max Pooling 1D Layer | R2024b+ | Reduce each 1-D feature channel to its maximum value — use to capture the strongest activation regardless of temporal position |
| Global Max Pooling 2D Layer | dlpoolinglib/Global Max Pooling 2D Layer | R2024b+ | Reduce each 2-D feature map to its maximum value — use to capture the strongest spatial activation for position-invariant feature extraction |
| Global Max Pooling 3D Layer | dlpoolinglib/Global Max Pooling 3D Layer | R2024b+ | Reduce each 3-D feature volume to its maximum value — use for position-invariant feature extraction from volumetric data |
| Max Pooling 1D Layer | dlpoolinglib/Max Pooling 1D Layer | R2024b+ | Reduce temporal resolution by taking the maximum over sliding windows — use to downsample 1-D feature maps while retaining the strongest activations |
| Max Pooling 2D Layer | dlpoolinglib/Max Pooling 2D Layer | R2024b+ | Reduce spatial resolution by taking the maximum over 2-D sliding windows — use to downsample feature maps while preserving dominant features and adding translation invariance |
| Max Pooling 3D Layer | dlpoolinglib/Max Pooling 3D Layer | R2024b+ | Reduce volumetric resolution by taking the maximum over 3-D sliding windows — use to downsample 3-D feature maps in video or medical imaging networks |

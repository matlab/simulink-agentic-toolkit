---
type: Simulink Block Category
title: Input normalization
description: Input data normalization and inverse denormalization for inference
tags: [rescale, zscore, zerocenter, normalize, inverse]
status: stable
source: mathworks_toolbox
library_root: Deep Learning Toolbox
category_path: Input normalization
block_count: 14
---

# Input normalization

Use these blocks for input normalization.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Inverse Zerocenter | dlinputlayernormlib/Inverse Zerocenter | R2026a+ | Reverse zero-centering normalization on network outputs — use to add back the training mean to denormalize predictions |
| Inverse Zscore | dlinputlayernormlib/Inverse Zscore | R2026a+ | Reverse z-score normalization on network outputs — use to convert standardized predictions back to original scale using training mean and standard deviation |
| Rescale-Symmetric 1D | dlinputlayernormlib/Rescale-Symmetric 1D | R2024b+ | Rescale 1-D input data to the symmetric range [-1, 1] — use to normalize time-series or sensor signals before feeding into a trained network |
| Rescale-Symmetric 2D | dlinputlayernormlib/Rescale-Symmetric 2D | R2024b+ | Rescale 2-D input data to the symmetric range [-1, 1] — use to normalize images before feeding into a network trained with symmetric rescaling |
| Rescale-Symmetric 3D | dlinputlayernormlib/Rescale-Symmetric 3D | R2024b+ | Rescale 3-D input data to the symmetric range [-1, 1] — use to normalize volumetric data before network inference |
| Rescale-Zero-One 1D | dlinputlayernormlib/Rescale-Zero-One 1D | R2024b+ | Rescale 1-D input data to the [0, 1] range — use to normalize time-series signals to match the training normalization |
| Rescale-Zero-One 2D | dlinputlayernormlib/Rescale-Zero-One 2D | R2024b+ | Rescale 2-D input data to the [0, 1] range — use to normalize images to match the training normalization |
| Rescale-Zero-One 3D | dlinputlayernormlib/Rescale-Zero-One 3D | R2024b+ | Rescale 3-D input data to the [0, 1] range — use to normalize volumetric inputs to match training normalization |
| Zerocenter 1D | dlinputlayernormlib/Zerocenter 1D | R2024b+ | Subtract the training mean from 1-D input data — use to zero-center time-series signals before network inference using the stored training statistics |
| Zerocenter 2D | dlinputlayernormlib/Zerocenter 2D | R2024b+ | Subtract the training mean from 2-D input data — use to zero-center images before inference using per-channel training means |
| Zerocenter 3D | dlinputlayernormlib/Zerocenter 3D | R2024b+ | Subtract the training mean from 3-D input data — use to zero-center volumetric inputs before inference |
| Zscore 1D | dlinputlayernormlib/Zscore 1D | R2024b+ | Apply z-score normalization to 1-D input data using training statistics — use to standardize time-series signals to zero mean and unit variance before network inference |
| Zscore 2D | dlinputlayernormlib/Zscore 2D | R2024b+ | Apply z-score normalization to 2-D input data using training statistics — use to standardize images to zero mean and unit variance before network inference |
| Zscore 3D | dlinputlayernormlib/Zscore 3D | R2024b+ | Apply z-score normalization to 3-D input data using training statistics — use to standardize volumetric data before network inference |

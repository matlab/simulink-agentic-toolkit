---
type: Simulink Block Category
title: Activation layers
description: Nonlinear activation functions applied between network layers
tags: [relu, sigmoid, tanh, activation, gelu]
status: stable
source: mathworks_toolbox
library_root: Deep Learning Toolbox
category_path: Activation layers
block_count: 9
---

# Activation layers

Use these blocks for activation layers.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Clipped ReLU Layer | dlactivationlib/Clipped ReLU Layer | R2024b+ | Apply clipped rectified linear activation with a configurable ceiling — use to bound layer outputs between 0 and a maximum value for numerically stable deployments |
| GELU Layer | dlactivationlib/GELU Layer | R2024b+ | Apply Gaussian Error Linear Unit activation — use as a smooth alternative to ReLU in transformer architectures and NLP-inspired signal processing networks |
| Leaky ReLU Layer | dlactivationlib/Leaky ReLU Layer | R2024b+ | Apply leaky rectified linear activation with a small negative slope — use to avoid dead neurons by allowing a small gradient for negative inputs |
| PReLU Layer | dlactivationlib/PReLU Layer | R2026a+ | Apply parametric ReLU with a learnable negative slope — use when the optimal negative-region slope varies by channel and should be learned during training |
| ReLU Layer | dlactivationlib/ReLU Layer | R2024b+ | Apply rectified linear unit activation (max of 0 and input) — use as the default nonlinearity in convolutional and fully connected networks for fast training convergence |
| Sigmoid Layer | dlactivationlib/Sigmoid Layer | R2024b+ | Apply sigmoid activation squashing outputs to the 0-1 range — use for binary classification output layers or gating mechanisms in recurrent networks |
| Softmax Layer | dlactivationlib/Softmax Layer | R2024b+ | Apply softmax normalization producing a probability distribution over classes — use as the final activation in multi-class classification networks |
| Swish Layer | dlactivationlib/Swish Layer | R2026a+ | Apply Swish activation (x times sigmoid) — use as a self-gated nonlinearity that often outperforms ReLU in deep architectures with many layers |
| Tanh Layer | dlactivationlib/Tanh Layer | R2024b+ | Apply hyperbolic tangent activation squashing outputs to -1 to 1 — use in recurrent network gates or when centered (zero-mean) activations are beneficial |

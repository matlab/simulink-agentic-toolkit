# Library Reuse Index

## Priority

1. Custom library blocks (highest priority)
2. Toolbox KB blocks

## Policy

- Always use custom library blocks when available.
- Never fall back to built-in primitives if the same block exists in a declared library.
- Only use built-in blocks when NO equivalent exists in any declared library after searching this index.
- Do not invent custom block names.
- If uncertain, inspect the relevant category page or ask the user.

## Libraries

- Deep Learning Toolbox

Common blocks: [common.md](common.md) (13 of 109 blocks)

## Categories

- [Activation layers](activation-layers.md) — 9 blocks; Nonlinear activation functions applied between network layers
- [Combination layers](combination-layers.md) — 4 blocks; Addition, concatenation, and multiplication for merging network branches
- [Convolution layers](convolution-layers.md) — 5 blocks; Convolutional and fully connected layers for feature extraction
- [Input normalization](input-normalization.md) — 16 blocks; Input data normalization and inverse denormalization for inference
- [Normalization layers](normalization-layers.md) — 3 blocks; Batch, instance, and layer normalization for training stability
- [Pooling layers](pooling-layers.md) — 12 blocks; Spatial and temporal pooling layers for dimensionality reduction
- [Sequence layers](sequence-layers.md) — 5 blocks; Recurrent layers (LSTM, GRU) and reshaping for sequence processing
- [Utility layers](utility-layers.md) — 7 blocks; Dropout, reshape, permute, and other structural utility layers
- [Inference](inference.md) — 4 blocks; Top-level network inference blocks for classification and prediction
- [External frameworks](external-frameworks.md) — 4 blocks; Run inference from external frameworks: ONNX, PyTorch, TensorFlow, Python
- [Classic nn controllers](classic-nn-controllers.md) — 3 blocks; Classic neural network controllers for adaptive and predictive control
- [Classic nn preprocessing](classic-nn-preprocessing.md) — 15 blocks; Data preprocessing and postprocessing functions for classic NN workflows
- [Classic nn functions](classic-nn-functions.md) — 22 blocks; Transfer functions, weight functions, and net input functions for classic networks

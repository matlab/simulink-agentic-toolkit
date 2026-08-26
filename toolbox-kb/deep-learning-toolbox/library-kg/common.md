---
type: Block Selection Guide
title: Common Blocks
description: High-value blocks selected for quick agent discovery.
status: stable
source: mathworks_toolbox
block_count: 13
---

# Common Blocks

Prefer these blocks when their intent matches the user request.

| Intent | Preferred Block | Library |
|---|---|---|
| Apply rectified linear unit activation (max of 0 and input) — use as the default nonlinearity in convolutional and fully connected networks for fast training convergence | ReLU Layer | Deep Learning Toolbox |
| Apply softmax normalization producing a probability distribution over classes — use as the final activation in multi-class classification networks | Softmax Layer | Deep Learning Toolbox |
| Element-wise add multiple input tensors — use for residual (skip) connections that sum the shortcut path with the main path in ResNet-style architectures | Addition Layer | Deep Learning Toolbox |
| Concatenate inputs along a specified dimension — use to merge features from parallel branches or combine multi-scale representations | Concatenation Layer | Deep Learning Toolbox |
| Apply learned 2-D convolutional filters to image or spatial data — use as the core feature extraction layer in image classification, detection, and segmentation networks | Convolution 2D Layer | Deep Learning Toolbox |
| Apply a learned linear transformation (matrix multiply plus bias) — use as a dense layer for classification heads or regression outputs after feature extraction | Fully Connected Layer | Deep Learning Toolbox |
| Normalize activations across the batch using learned scale and offset — use between convolution and activation to stabilize training and accelerate convergence | Batch Normalization Layer | Deep Learning Toolbox |
| Reduce spatial resolution by taking the maximum over 2-D sliding windows — use to downsample feature maps while preserving dominant features and adding translation invariance | Max Pooling 2D Layer | Deep Learning Toolbox |
| Apply a Long Short-Term Memory layer for sequence modeling — use for temporal dependencies in time-series prediction, speech, or sequential signal processing | LSTM Layer | Deep Learning Toolbox |
| Run inference on a trained deep learning network and return class labels — use for image classification, signal categorization, or any trained network that outputs discrete categories | Classify | Deep Learning Toolbox |
| Run inference on a trained deep learning network and return numeric outputs — use for regression, feature extraction, or networks that output continuous values rather than class labels | Predict | Deep Learning Toolbox |
| Run inference with internal state on recurrent networks and return numeric outputs — use for time-series prediction where LSTM/GRU hidden states carry temporal context between samples | Stateful Predict | Deep Learning Toolbox |
| Run inference using an imported ONNX model — use to deploy models trained in any ONNX-compatible framework into Simulink without manual reimplementation | ONNX Model Predict | Deep Learning Toolbox |

---
type: Simulink Block Category
title: Inference
description: Top-level network inference blocks for classification and prediction
tags: [predict, classify, inference, stateful, network]
status: stable
source: mathworks_toolbox
library_root: Deep Learning Toolbox
category_path: Inference
block_count: 4
---

# Inference

Use these blocks for inference.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Classify | deeplib/Classify | R2026a+ | Run inference on a trained deep learning network and return class labels — use for image classification, signal categorization, or any trained network that outputs discrete categories |
| Predict | deeplib/Predict | R2023a+ | Run inference on a trained deep learning network and return numeric outputs — use for regression, feature extraction, or networks that output continuous values rather than class labels |
| Stateful Classify | deeplib/Stateful Classify | R2023a+ | Run inference with internal state on recurrent networks and return class labels — use for sequence classification tasks where LSTM/GRU hidden states persist across time steps |
| Stateful Predict | deeplib/Stateful Predict | R2023a+ | Run inference with internal state on recurrent networks and return numeric outputs — use for time-series prediction where LSTM/GRU hidden states carry temporal context between samples |

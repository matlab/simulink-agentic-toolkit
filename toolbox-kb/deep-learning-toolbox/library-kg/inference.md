---
type: Simulink Block Category
title: Inference
description: Top-level network inference blocks for classification and prediction (4 blocks)
tags: [toolbox-kb, deep-learning-toolbox, predict, classify, inference, stateful, network]
status: stable
sources:
  - resource: matlab:deeplib
source: toolbox_kb
managed_by: satk
library: Deep Learning Toolbox
kb_folder: deep-learning-toolbox
category: inference
block_count: 4
generated: { by: satk-toolbox-build/1, at: "2026-11-23T18:23:18Z" }
---

# Inference

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Classify | deeplib/Classify | R2026a+ | Run inference on a trained deep learning network and return class labels — use for image classification, signal categorization, or any trained network that outputs discrete categories |
| Predict | deeplib/Predict | R2023a+ | Run inference on a trained deep learning network and return numeric outputs — use for regression, feature extraction, or networks that output continuous values rather than class labels |
| Stateful Classify | deeplib/Stateful Classify | R2023a+ | Run inference with internal state on recurrent networks and return class labels — use for sequence classification tasks where LSTM/GRU hidden states persist across time steps |
| Stateful Predict | deeplib/Stateful Predict | R2023a+ | Run inference with internal state on recurrent networks and return numeric outputs — use for time-series prediction where LSTM/GRU hidden states carry temporal context between samples |

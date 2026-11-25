---
type: Simulink Block Category
title: External frameworks
description: "Run inference from external frameworks: ONNX, PyTorch, TensorFlow, Python (4 blocks)"
tags: [toolbox-kb, deep-learning-toolbox, onnx, pytorch, tensorflow, python, external]
status: stable
sources:
  - resource: matlab:pycoexlib
source: toolbox_kb
managed_by: satk
library: Deep Learning Toolbox
kb_folder: deep-learning-toolbox
category: external-frameworks
block_count: 4
generated: { by: satk-toolbox-build/1, at: "2026-11-23T18:23:18Z" }
---

# External frameworks

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| ONNX Model Predict | pycoexlib/ONNX Model Predict | R2024a+ | Run inference using an imported ONNX model — use to deploy models trained in any ONNX-compatible framework into Simulink without manual reimplementation |
| PyTorch Model Predict | pycoexlib/PyTorch Model Predict | R2024a+ | Run inference using a PyTorch model via Python co-execution — use to integrate PyTorch-trained networks into Simulink when ONNX export is not available or loses fidelity |
| TensorFlow Model Predict | pycoexlib/TensorFlow Model Predict | R2024a+ | Run inference using a TensorFlow/Keras model via Python co-execution — use to integrate TensorFlow-trained networks into Simulink without manual conversion |
| Custom Python Model Predict | pycoexlib/Custom Python Model Predict | R2024a+ | Run inference using a custom Python function — use to integrate arbitrary Python ML frameworks or custom preprocessing into Simulink inference pipelines |

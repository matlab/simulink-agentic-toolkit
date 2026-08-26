---
type: Simulink Block Category
title: External frameworks
description: Run inference from external frameworks: ONNX, PyTorch, TensorFlow, Python
tags: [onnx, pytorch, tensorflow, python, external]
status: stable
source: mathworks_toolbox
library_root: Deep Learning Toolbox
category_path: External frameworks
block_count: 4
---

# External frameworks

Use these blocks for external frameworks.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| ONNX Model Predict | pycoexlib/ONNX Model Predict | R2024a+ | Run inference using an imported ONNX model — use to deploy models trained in any ONNX-compatible framework into Simulink without manual reimplementation |
| PyTorch Model Predict | pycoexlib/PyTorch Model Predict | R2024a+ | Run inference using a PyTorch model via Python co-execution — use to integrate PyTorch-trained networks into Simulink when ONNX export is not available or loses fidelity |
| TensorFlow Model Predict | pycoexlib/TensorFlow Model Predict | R2024a+ | Run inference using a TensorFlow/Keras model via Python co-execution — use to integrate TensorFlow-trained networks into Simulink without manual conversion |
| Custom Python Model Predict | pycoexlib/Custom Python Model Predict | R2024a+ | Run inference using a custom Python function — use to integrate arbitrary Python ML frameworks or custom preprocessing into Simulink inference pipelines |

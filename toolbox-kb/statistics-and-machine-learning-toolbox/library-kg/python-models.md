---
type: Simulink Block Category
title: Python models
description: Run inference from externally trained Python ML models (2 blocks)
tags: [toolbox-kb, statistics-and-machine-learning-toolbox, python, custom python, onnx]
status: draft
sources:
  - resource: matlab:statsPycoex
source: toolbox_kb
managed_by: satk
library: Statistics and Machine Learning Toolbox
kb_folder: statistics-and-machine-learning-toolbox
category: python-models
block_count: 2
generated: { by: satk-toolbox-build/1, at: "2026-11-23T18:23:33Z" }
---

# Python models

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Custom Python Model Predict | statsPycoex/Custom Python Model Predict | R2024a+ | Run inference from a Python-based machine learning model inside Simulink — use to integrate a model trained in Python (scikit-learn, PyTorch, TensorFlow) into a Simulink prediction pipeline for code-free deployment testing. |
| Scikit-learn Model Predict | statsPycoex/Scikit-learn Model Predict | R2024a+ | Predict responses using a pretrained scikit-learn model running in the MATLAB Python environment. The block supports files saved in .pkl, .joblib and .skops formats. The MATLAB Python environment must have the scikit-learn module installed, and skops if it is used. For more information, click the Help button. |

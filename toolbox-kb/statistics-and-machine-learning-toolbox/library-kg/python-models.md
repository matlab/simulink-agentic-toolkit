---
type: Simulink Block Category
title: Python models
description: Run inference from externally trained Python ML models
tags: [python, custom python, onnx]
status: stable
source: custom_library
library_root: Statistics and Machine Learning Toolbox
category_path: Python models
block_count: 2
---

# Python models

Use these blocks for python models.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Custom Python Model Predict | statsPycoex/Custom Python Model Predict | R2024a+ | Run inference from a Python-based machine learning model inside Simulink — use to integrate a model trained in Python (scikit-learn, PyTorch, TensorFlow) into a Simulink prediction pipeline for code-free deployment testing. |
| Scikit-learn Model Predict | statsPycoex/Scikit-learn Model Predict | R2024a+ | Predict responses using a pretrained scikit-learn model running in the MATLAB Python environment. The block supports files saved in .pkl, .joblib and .skops formats. The MATLAB Python environment must have the scikit-learn module installed, and skops if it is used. For more information, click the Help button. |

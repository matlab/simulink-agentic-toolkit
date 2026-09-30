---
type: Block Selection Guide
title: Common Blocks
description: High-value blocks selected for quick agent discovery.
status: stable
source: custom_library
block_count: 17
---

# Common Blocks

Prefer these blocks when their intent matches the user request.

| Intent | Preferred Block | Library |
|---|---|---|
| Find anomalies in data using isolation forest | Isolation Forest Anomaly Detector | Statistics and Machine Learning Toolbox |
| Find anomalies in data using one-class support vector machine (SVM) | One-Class SVM Anomaly Detector | Statistics and Machine Learning Toolbox |
| Run inference from a Python-based machine learning model inside Simulink — use to integrate a model trained in Python (scikit-learn, PyTorch, TensorFlow) into a Simulink prediction pipeline for code-free deployment testing. | Custom Python Model Predict | Statistics and Machine Learning Toolbox |
| Predict labels using discriminant analysis classification model | ClassificationDiscriminant Predict | Statistics and Machine Learning Toolbox |
| Classify observations using error-correcting output codes (ECOC) model | ClassificationECOC Predict | Statistics and Machine Learning Toolbox |
| Classify observations using ensemble of classification models | ClassificationEnsemble Predict | Statistics and Machine Learning Toolbox |
| Predict labels using k-nearest neighbor classification model | ClassificationKNN Predict | Statistics and Machine Learning Toolbox |
| Predict labels for Gaussian kernel classification model | ClassificationKernel Predict | Statistics and Machine Learning Toolbox |
| Update drift detector states and drift status with new data | Detect Drift | Statistics and Machine Learning Toolbox |
| Per observation loss for incremental learning model | Per Observation Loss | Statistics and Machine Learning Toolbox |
| Update performance metrics incremental learning model given new data | Update Metrics | Statistics and Machine Learning Toolbox |
| Predict responses using a pretrained scikit-learn model running in the MATLAB Python environment. The block supports files saved in .pkl, .joblib and .skops formats. The MATLAB Python environment must have the scikit-learn module installed, and skops if it is used. For more information, click the Help button. | Scikit-learn Model Predict | Statistics and Machine Learning Toolbox |
| Train kernel regression model for incremental learning | IncrementalRegressionKernel Fit | Statistics and Machine Learning Toolbox |
| Predict response of kernel incremental regression model | IncrementalRegressionKernel Predict | Statistics and Machine Learning Toolbox |
| Train linear regression model for incremental learning | IncrementalRegressionLinear Fit | Statistics and Machine Learning Toolbox |
| Predict response of linear incremental regression model | IncrementalRegressionLinear Predict | Statistics and Machine Learning Toolbox |
| Fit ensemble of learners for regression | RegressionEnsemble Predict | Statistics and Machine Learning Toolbox |

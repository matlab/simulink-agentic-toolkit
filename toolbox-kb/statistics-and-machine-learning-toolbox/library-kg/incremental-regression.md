---
type: Simulink Block Category
title: Incremental regression
description: Online incremental regression with streaming data fitting and prediction
tags: [incremental, online, streaming, regression, update]
status: stable
source: mathworks_toolbox
library_root: Statistics and Machine Learning Toolbox
category_path: Incremental regression
block_count: 4
---

# Incremental regression

Use these blocks for incremental regression.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| IncrementalRegressionKernel Fit | statsIncremental/Regression/Kernel/IncrementalRegressionKernel Fit | R2024b+ | Use when you need to update a kernel regression model online as new observations stream in |
| IncrementalRegressionKernel Predict | statsIncremental/Regression/Kernel/IncrementalRegressionKernel Predict | R2024b+ | Use when you need continuous value prediction from an incrementally updated kernel regression model |
| IncrementalRegressionLinear Fit | statsIncremental/Regression/Linear/IncrementalRegressionLinear Fit | R2023b+ | Use when you need to update a linear regression model online using SGD with streaming data |
| IncrementalRegressionLinear Predict | statsIncremental/Regression/Linear/IncrementalRegressionLinear Predict | R2023b+ | Use when you need continuous value prediction from an incrementally updated linear regression model |

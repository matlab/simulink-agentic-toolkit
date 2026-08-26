---
type: Simulink Block Category
title: Incremental classification
description: Online incremental classification with streaming data fitting and prediction
tags: [incremental, online, streaming, fit, SGD]
status: stable
source: mathworks_toolbox
library_root: Statistics and Machine Learning Toolbox
category_path: Incremental classification
block_count: 8
---

# Incremental classification

Use these blocks for incremental classification.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| IncrementalClassificationECOC Fit | statsIncremental/Classification/ECOC/IncrementalClassificationECOC Fit | R2024a+ | Use when you need to update a multi-class ECOC classifier online as new labeled data arrives in a streaming scenario |
| IncrementalClassificationECOC Predict | statsIncremental/Classification/ECOC/IncrementalClassificationECOC Predict | R2024a+ | Use when you need to classify streaming data with an incrementally updated ECOC multi-class model |
| IncrementalClassificationKernel Fit | statsIncremental/Classification/Kernel/IncrementalClassificationKernel Fit | R2024b+ | Use when you need to update a kernel classifier online with streaming labeled observations |
| IncrementalClassificationKernel Predict | statsIncremental/Classification/Kernel/IncrementalClassificationKernel Predict | R2024b+ | Use when you need to classify streaming data with an incrementally updated kernel model |
| IncrementalClassificationLinear Fit | statsIncremental/Classification/Linear/IncrementalClassificationLinear Fit | R2023b+ | Use when you need to update a linear classifier online using SGD as new labeled data streams in |
| IncrementalClassificationLinear Predict | statsIncremental/Classification/Linear/IncrementalClassificationLinear Predict | R2023b+ | Use when you need to classify streaming data with an incrementally updated linear model |
| IncrementalClassificationNaiveBayes Fit | statsIncremental/Classification/NaiveBayes/IncrementalClassificationNaiveBayes Fit | R2025a+ | Use when you need to update a Naive Bayes classifier online from streaming labeled observations |
| IncrementalClassificationNaiveBayes Predict | statsIncremental/Classification/NaiveBayes/IncrementalClassificationNaiveBayes Predict | R2025a+ | Use when you need probabilistic classification of streaming data with an incrementally updated Naive Bayes model |

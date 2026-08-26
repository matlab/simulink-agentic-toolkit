---
type: Simulink Block Category
title: Classic nn preprocessing
description: Data preprocessing and postprocessing functions for classic NN workflows
tags: [mapminmax, mapstd, pca, preprocessing, fixunknowns]
status: stable
source: mathworks_toolbox
library_root: Deep Learning Toolbox
category_path: Classic nn preprocessing
block_count: 15
---

# Classic nn preprocessing

Use these blocks for classic nn preprocessing.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| X(2Y)  Graph | neural/Control Systems/X(2Y)  Graph | R2023a+ | Legacy neural network plotting block — internal visualization utility for classic Neural Network Toolbox |
| fixunknowns | neural/Processing Functions/fixunknowns | R2023a+ | Encode unknown or missing values in input data using indicator variables — use as a preprocessing step for networks that must handle incomplete input data |
| fixunknowns_reverse | neural/Processing Functions/fixunknowns_reverse | R2023a+ | Reverse the fixunknowns encoding — use to restore original data format after network processing |
| lvqoutputs | neural/Processing Functions/lvqoutputs | R2023a+ | Transform network outputs for Learning Vector Quantization — use as output processing for LVQ classification networks |
| lvqoutputs_reverse | neural/Processing Functions/lvqoutputs_reverse | R2023a+ | Reverse LVQ output transformation — use to convert LVQ network outputs back to class indices |
| mapminmax | neural/Processing Functions/mapminmax | R2023a+ | Scale inputs to the [-1, 1] range using training min/max statistics — use as input preprocessing for classic neural networks trained with normalized data |
| mapminmax_reverse | neural/Processing Functions/mapminmax_reverse | R2023a+ | Reverse min-max scaling to recover original data range — use to denormalize network outputs back to physical units |
| mapstd | neural/Processing Functions/mapstd | R2023a+ | Standardize inputs to zero mean and unit standard deviation — use as input preprocessing for classic neural networks trained with standardized data |
| mapstd_reverse | neural/Processing Functions/mapstd_reverse | R2023a+ | Reverse standardization to recover original data scale — use to denormalize network outputs back to physical units |
| processpca | neural/Processing Functions/processpca | R2023a+ | Apply PCA dimensionality reduction using training-time principal components — use as input preprocessing to reduce input dimensionality while preserving variance |
| processpca_reverse | neural/Processing Functions/processpca_reverse | R2023a+ | Reverse PCA transformation to reconstruct the full-dimensional signal — use to map reduced outputs back to original feature space |
| removeconstantrows | neural/Processing Functions/removeconstantrows | R2023a+ | Remove rows that were constant in the training data — use to eliminate uninformative input features before network inference |
| removeconstantrows_reverse | neural/Processing Functions/removeconstantrows_reverse | R2023a+ | Reinsert constant rows removed during preprocessing — use to restore original data dimensions after network processing |
| removerows | neural/Processing Functions/removerows | R2023a+ | Remove specified rows from input data — use to exclude unwanted features identified during training data analysis |
| removerows_reverse | neural/Processing Functions/removerows_reverse | R2023a+ | Reinsert removed rows into output data — use to restore original data dimensions after network processing |

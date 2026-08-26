---
type: Simulink Block Category
title: Drift detection
description: Concept drift detection and performance monitoring for deployed models
tags: [drift, monitoring, concept-shift, DDM, retraining]
status: stable
source: mathworks_toolbox
library_root: Statistics and Machine Learning Toolbox
category_path: Drift detection
block_count: 3
---

# Drift detection

Use these blocks for drift detection.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Detect Drift | statsDrift/Detect Drift | R2024b+ | Use when you need to monitor streaming model predictions for concept drift and trigger retraining when data distribution shifts |
| Per Observation Loss | statsDrift/Per Observation Loss | R2025a+ | Use when you need to compute prediction loss for each individual observation to feed into drift detection or performance monitoring |
| Update Metrics | statsIncremental/Update Metrics | R2023b+ | Use when you need to compute and track classification or regression performance metrics incrementally on streaming data |

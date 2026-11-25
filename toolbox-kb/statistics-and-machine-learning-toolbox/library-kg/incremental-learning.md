---
type: Simulink Block Category
title: Incremental learning
description: "Update models online as new data streams in, with drift detection (3 blocks)"
tags: [toolbox-kb, statistics-and-machine-learning-toolbox, incremental, drift, kernel, linear]
status: draft
sources:
  - resource: matlab:statsDrift
source: toolbox_kb
managed_by: satk
library: Statistics and Machine Learning Toolbox
kb_folder: statistics-and-machine-learning-toolbox
category: incremental-learning
block_count: 3
generated: { by: satk-toolbox-build/1, at: "2026-11-23T18:23:33Z" }
---

# Incremental learning

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Detect Drift | statsDrift/Detect Drift | R2024b+ | Update drift detector states and drift status with new data |
| Per Observation Loss | statsDrift/Per Observation Loss | R2025a+ | Per observation loss for incremental learning model |
| Update Metrics | statsIncremental/Update Metrics | R2023b+ | Update performance metrics incremental learning model given new data |

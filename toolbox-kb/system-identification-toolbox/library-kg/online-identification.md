---
type: Simulink Block Category
title: Online identification
description: Recursive parameter estimation algorithms
tags: [recursive, rls, adaptive, online, parameter]
status: stable
source: mathworks_toolbox
library_root: System Identification Toolbox
category_path: Online identification
block_count: 3
---

# Online identification

Use these blocks for online identification.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Model Type Converter | slident/Estimators/Model Type Converter | R2023a+ | Convert between identified model representations — use for transforming idpoly, idss, or idtf models into different formats for simulation |
| Recursive Least Squares Estimator | slident/Estimators/Recursive Least Squares Estimator | R2023a+ | Estimate parameters online using recursive least squares — use for adaptive identification of linear-in-parameters models during simulation |
| Recursive Polynomial Model Estimator | slident/Estimators/Recursive Polynomial Model Estimator | R2023a+ | Estimate polynomial model parameters online — use for adaptive identification of ARX, ARMAX, or Output-Error models in real time |

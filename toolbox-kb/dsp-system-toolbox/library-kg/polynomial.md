---
type: Simulink Block Category
title: Polynomial
description: Polynomial functions
tags: [polynomial, stability]
status: stable
source: custom_library
library_root: DSP System Toolbox
category_path: Polynomial
block_count: 4
---

# Polynomial

Use these blocks for polynomial.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Yule-Walker AR Estimator | dspparest3/Yule-Walker AR Estimator | R2023a+ | Frame-based parametric AR estimation using the Yule-Walker method. The AR model coefficients are given in A (polynomial coefficients) and/or K (reflection coefficients). The square of the model gain is given in G. |
| Polynomial Evaluation | dsppolyfun/Polynomial Evaluation | R2023a+ | Apply specified polynomial function to input. Example: [1 3 5] represents u^2 + 3u + 5. |
| Polynomial Stability Test | dsppolyfun/Polynomial Stability Test | R2023a+ | Test whether a polynomial's roots lie inside the unit circle — use to check discrete filter/system stability. |
| Least Squares Polynomial Fit | dsppolyfun/Least Squares Polynomial Fit | R2023a+ | Find the coefficients of a polynomial P(X) of order N that fits the input data U, such that P(X) best approximates U in a least-squares sense. The input vector U must have the same length as X. |

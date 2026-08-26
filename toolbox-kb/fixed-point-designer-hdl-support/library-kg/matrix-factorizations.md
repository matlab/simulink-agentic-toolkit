---
type: Simulink Block Category
title: Matrix factorizations
description: HDL-optimized matrix factorization blocks
tags: [qr, svd, decomposition, factorization, jacobi]
status: stable
source: mathworks_toolbox
library_root: Fixed-Point Designer HDL Support
category_path: Matrix factorizations
block_count: 17
---

# Matrix factorizations

Use these blocks for matrix factorizations.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Complex Burst Q-less QR Decomposition | embeddedMatrixLib/Matrices and Linear Algebra/Matrix Factorizations/Complex Burst Q-less QR Decomposition | R2023a+ | Factorize complex matrices with burst Q-less QR — use for computing R factor of complex matrices on FPGA |
| Complex Burst Q-less QR Decomposition Whole R Output | embeddedMatrixLib/Matrices and Linear Algebra/Matrix Factorizations/Complex Burst Q-less QR Decomposition Whole R Output | R2023a+ | Factorize complex matrices outputting full R — use for FPGA Q-less QR when the entire R matrix is needed at once |
| Complex Burst Q-less QR Decomposition with Forgetting Factor Whole R Output | embeddedMatrixLib/Matrices and Linear Algebra/Matrix Factorizations/Complex Burst Q-less QR Decomposition with Forgetting Factor Whole R Output | R2023a+ | Factorize with forgetting outputting full R — use for time-weighted complex covariance on FPGA |
| Complex Burst QR Decomposition | embeddedMatrixLib/Matrices and Linear Algebra/Matrix Factorizations/Complex Burst QR Decomposition | R2023a+ | Compute full QR decomposition of complex matrices — use for FPGA-based complex matrix factorization |
| Complex Partial-Systolic Q-less QR Decomposition | embeddedMatrixLib/Matrices and Linear Algebra/Matrix Factorizations/Complex Partial-Systolic Q-less QR Decomposition | R2023a+ | Factorize complex matrices with partial-systolic Q-less QR — use for area-efficient FPGA complex factorization |
| Complex Partial-Systolic Q-less QR with Forgetting Factor | embeddedMatrixLib/Matrices and Linear Algebra/Matrix Factorizations/Complex Partial-Systolic Q-less QR with Forgetting Factor | R2023a+ | Factorize complex matrices with forgetting — use for adaptive covariance estimation on FPGA |
| Complex Partial-Systolic QR Decomposition | embeddedMatrixLib/Matrices and Linear Algebra/Matrix Factorizations/Complex Partial-Systolic QR Decomposition | R2023a+ | Compute full QR of complex matrices with partial-systolic architecture — use for area-efficient FPGA QR |
| Non-Square Jacobi SVD HDL Optimized | embeddedMatrixLib/Matrices and Linear Algebra/Matrix Factorizations/Non-Square Jacobi SVD HDL Optimized | R2023a+ | Compute SVD of non-square matrices for HDL — use for FPGA-based singular value decomposition of rectangular matrices |
| Real Burst Q-less QR Decomposition | embeddedMatrixLib/Matrices and Linear Algebra/Matrix Factorizations/Real Burst Q-less QR Decomposition | R2023a+ | Factorize real matrices with burst Q-less QR — use for computing R factor of real matrices on FPGA |
| Real Burst Q-less QR Decomposition Whole R Output | embeddedMatrixLib/Matrices and Linear Algebra/Matrix Factorizations/Real Burst Q-less QR Decomposition Whole R Output | R2023a+ | Factorize real matrices outputting full R — use for FPGA Q-less QR when the entire R matrix is needed |
| Real Burst Q-less QR Decomposition with Forgetting Factor Whole R Output | embeddedMatrixLib/Matrices and Linear Algebra/Matrix Factorizations/Real Burst Q-less QR Decomposition with Forgetting Factor Whole R Output | R2023b+ | Factorize with forgetting outputting full R — use for time-weighted real covariance on FPGA |
| Real Burst QR Decomposition | embeddedMatrixLib/Matrices and Linear Algebra/Matrix Factorizations/Real Burst QR Decomposition | R2023a+ | Compute full QR decomposition of real matrices — use for FPGA-based real matrix factorization |
| Real Partial-Systolic Q-less QR Decomposition | embeddedMatrixLib/Matrices and Linear Algebra/Matrix Factorizations/Real Partial-Systolic Q-less QR Decomposition | R2023a+ | Factorize real matrices with partial-systolic Q-less QR — use for area-efficient FPGA real factorization |
| Real Partial-Systolic Q-less QR with Forgetting Factor | embeddedMatrixLib/Matrices and Linear Algebra/Matrix Factorizations/Real Partial-Systolic Q-less QR with Forgetting Factor | R2023a+ | Factorize real matrices with forgetting — use for adaptive real covariance estimation on FPGA |
| Real Partial-Systolic QR Decomposition | embeddedMatrixLib/Matrices and Linear Algebra/Matrix Factorizations/Real Partial-Systolic QR Decomposition | R2023a+ | Compute full QR of real matrices with partial-systolic architecture — use for area-efficient FPGA QR |
| Square Jacobi SVD HDL Optimized | embeddedMatrixLib/Matrices and Linear Algebra/Matrix Factorizations/Square Jacobi SVD HDL Optimized | R2023a+ | Compute SVD of square matrices for HDL — use for FPGA-based singular value decomposition |
| Systolic QR Decomposition | embeddedMatrixLib/Matrices and Linear Algebra/Matrix Factorizations/Systolic QR Decomposition | R2024a+ | Compute QR with fully systolic architecture — use for maximum-throughput FPGA matrix factorization |

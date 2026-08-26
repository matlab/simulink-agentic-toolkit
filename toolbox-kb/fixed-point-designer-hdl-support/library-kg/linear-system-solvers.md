---
type: Simulink Block Category
title: Linear system solvers
description: HDL-optimized linear system solvers using QR
tags: [solve, system, burst, partial-systolic, systolic, forgetting]
status: stable
source: mathworks_toolbox
library_root: Fixed-Point Designer HDL Support
category_path: Linear system solvers
block_count: 15
---

# Linear system solvers

Use these blocks for linear system solvers.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Complex Burst Asynchronous Matrix Solve Using Q-less QR Decomposition | embeddedMatrixLib/Matrices and Linear Algebra/Linear System Solvers/Complex Burst Asynchronous Matrix Solve Using Q-less QR Decomposition | R2023a+ | Solve complex linear systems with async burst Q-less QR — use for streaming matrix problems on FPGA with variable latency |
| Complex Burst Matrix Solve Using Q-less QR Decomposition | embeddedMatrixLib/Matrices and Linear Algebra/Linear System Solvers/Complex Burst Matrix Solve Using Q-less QR Decomposition | R2023a+ | Solve complex linear systems with burst Q-less QR — use for FPGA beamforming or channel estimation with complex matrices |
| Complex Burst Matrix Solve Using Q-less QR Decomposition with Forgetting Factor | embeddedMatrixLib/Matrices and Linear Algebra/Linear System Solvers/Complex Burst Matrix Solve Using Q-less QR Decomposition with Forgetting Factor | R2023a+ | Solve complex systems with Q-less QR and forgetting — use for adaptive filtering on FPGA with exponential weighting |
| Complex Burst Matrix Solve Using QR Decomposition | embeddedMatrixLib/Matrices and Linear Algebra/Linear System Solvers/Complex Burst Matrix Solve Using QR Decomposition | R2023a+ | Solve complex linear systems with burst QR — use for FPGA-based complex least-squares problems |
| Complex Partial-Systolic Matrix Solve Using Q-less QR Decomposition | embeddedMatrixLib/Matrices and Linear Algebra/Linear System Solvers/Complex Partial-Systolic Matrix Solve Using Q-less QR Decomposition | R2023a+ | Solve complex systems with partial-systolic Q-less QR — use for area-efficient FPGA matrix solving |
| Complex Partial-Systolic Matrix Solve Using Q-less QR Decomposition with Forgetting Factor | embeddedMatrixLib/Matrices and Linear Algebra/Linear System Solvers/Complex Partial-Systolic Matrix Solve Using Q-less QR Decomposition with Forgetting Factor | R2023a+ | Solve complex systems with partial-systolic Q-less QR and forgetting — use for adaptive FPGA beamforming |
| Complex Partial-Systolic Matrix Solve Using QR Decomposition | embeddedMatrixLib/Matrices and Linear Algebra/Linear System Solvers/Complex Partial-Systolic Matrix Solve Using QR Decomposition | R2023a+ | Solve complex systems with partial-systolic QR — use for area-efficient FPGA least-squares solving |
| Real Burst Asynchronous Matrix Solve Using Q-less QR Decomposition | embeddedMatrixLib/Matrices and Linear Algebra/Linear System Solvers/Real Burst Asynchronous Matrix Solve Using Q-less QR Decomposition | R2023a+ | Solve real linear systems with async burst Q-less QR — use for streaming real matrix problems on FPGA |
| Real Burst Matrix Solve Using Q-less QR Decomposition | embeddedMatrixLib/Matrices and Linear Algebra/Linear System Solvers/Real Burst Matrix Solve Using Q-less QR Decomposition | R2023a+ | Solve real linear systems with burst Q-less QR — use for FPGA-based real least-squares with normal equations |
| Real Burst Matrix Solve Using Q-less QR Decomposition with Forgetting Factor | embeddedMatrixLib/Matrices and Linear Algebra/Linear System Solvers/Real Burst Matrix Solve Using Q-less QR Decomposition with Forgetting Factor | R2023a+ | Solve real systems with Q-less QR and forgetting — use for real adaptive filtering on FPGA |
| Real Burst Matrix Solve Using QR Decomposition | embeddedMatrixLib/Matrices and Linear Algebra/Linear System Solvers/Real Burst Matrix Solve Using QR Decomposition | R2023a+ | Solve real linear systems with burst QR — use for FPGA-based overdetermined system solving |
| Real Partial-Systolic Matrix Solve Using Q-less QR Decomposition | embeddedMatrixLib/Matrices and Linear Algebra/Linear System Solvers/Real Partial-Systolic Matrix Solve Using Q-less QR Decomposition | R2023a+ | Solve real systems with partial-systolic Q-less QR — use for area-efficient FPGA real matrix solving |
| Real Partial-Systolic Matrix Solve Using Q-less QR Decomposition with Forgetting Factor | embeddedMatrixLib/Matrices and Linear Algebra/Linear System Solvers/Real Partial-Systolic Matrix Solve Using Q-less QR Decomposition with Forgetting Factor | R2023a+ | Solve real systems with partial-systolic Q-less QR and forgetting — use for adaptive real filtering on FPGA |
| Real Partial-Systolic Matrix Solve Using QR Decomposition | embeddedMatrixLib/Matrices and Linear Algebra/Linear System Solvers/Real Partial-Systolic Matrix Solve Using QR Decomposition | R2023a+ | Solve real systems with partial-systolic QR — use for area-efficient FPGA real least-squares |
| Systolic Matrix Solve Using QR Decomposition | embeddedMatrixLib/Matrices and Linear Algebra/Linear System Solvers/Systolic Matrix Solve Using QR Decomposition | R2024a+ | Solve linear systems with fully systolic QR — use for maximum-throughput FPGA matrix solving |

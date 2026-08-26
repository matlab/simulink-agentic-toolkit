---
type: Simulink Block Category
title: Math operations
description: HDL-optimized scalar math functions
tags: [exp, log, sqrt, divide, cordic, sigmoid, tanh, power, reciprocal, modulo]
status: stable
source: mathworks_toolbox
library_root: Fixed-Point Designer HDL Support
category_path: Math operations
block_count: 10
---

# Math operations

Use these blocks for math operations.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Euler to NED Transformation HDL Optimized | embeddedMatrixLib/Coordinate Transformations/Euler to NED Transformation HDL Optimized | R2023a+ | Convert Euler angles to NED frame optimized for HDL — use for coordinate rotation in FPGA-based navigation |
| CORDIC Sigmoid HDL Optimized | embeddedMatrixLib/Math Operations/CORDIC Sigmoid HDL Optimized | R2024a+ | Compute sigmoid activation using CORDIC for HDL — use for neural network inference on FPGA with fixed-point |
| CORDIC Square Root HDL Optimized | embeddedMatrixLib/Math Operations/CORDIC Square Root HDL Optimized | R2024a+ | Compute square root using CORDIC for HDL — use for implementing sqrt in FPGA without multipliers |
| Complex Divide HDL Optimized | embeddedMatrixLib/Math Operations/Complex Divide HDL Optimized | R2023a+ | Divide complex numbers optimized for HDL — use for implementing complex division in FPGA signal processing |
| Divide by Constant HDL Optimized | embeddedMatrixLib/Math Operations/Divide by Constant HDL Optimized | R2023a+ | Divide by a compile-time constant optimized for HDL — use for efficient constant division without a divider circuit |
| Hyperbolic Tangent HDL Optimized | embeddedMatrixLib/Math Operations/Hyperbolic Tangent HDL Optimized | R2023a+ | Compute tanh optimized for HDL — use for neural network activation or nonlinear control on FPGA |
| Modulo by Constant HDL Optimized | embeddedMatrixLib/Math Operations/Modulo by Constant HDL Optimized | R2023a+ | Compute modulo by a constant optimized for HDL — use for efficient remainder computation without a divider |
| Normalized Reciprocal HDL Optimized | embeddedMatrixLib/Math Operations/Normalized Reciprocal HDL Optimized | R2023a+ | Compute normalized reciprocal optimized for HDL — use for division by normalizing the dividend first |
| Real Divide HDL Optimized | embeddedMatrixLib/Math Operations/Real Divide HDL Optimized | R2023a+ | Divide real numbers optimized for HDL — use for general-purpose fixed-point division on FPGA |
| Real Reciprocal HDL Optimized | embeddedMatrixLib/Math Operations/Real Reciprocal HDL Optimized | R2023a+ | Compute 1/x optimized for HDL — use for reciprocal computation in FPGA signal processing |

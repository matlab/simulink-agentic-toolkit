---
type: Simulink Block Category
title: Physical signal math
description: Arithmetic operations, nonlinear functions, and logic for physical signals
tags: [math, gain, add, saturation, nonlinear]
status: stable
source: mathworks_toolbox
library_root: Simscape
category_path: Physical signal math
block_count: 24
---

# Physical signal math

Use these blocks for physical signal math.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| PS Add | fl_lib/Physical Signals/Functions/PS Add | R2023a+ | Use when summing two physical signals to combine contributions from multiple sources |
| PS Bias | fl_lib/Physical Signals/Functions/PS Bias | R2023b+ | Use when adding a constant offset to a physical signal |
| PS Concatenate | fl_lib/Physical Signals/Functions/PS Concatenate | R2023b+ | Use when joining multiple scalar physical signals into a single vector signal |
| PS Divide | fl_lib/Physical Signals/Functions/PS Divide | R2023a+ | Use when computing the ratio of two physical signals |
| PS Dot Product | fl_lib/Physical Signals/Functions/PS Dot Product | R2023b+ | Use when computing the inner product of two vector physical signals |
| PS Gain | fl_lib/Physical Signals/Functions/PS Gain | R2023a+ | Use when scaling a physical signal by a constant multiplier |
| PS Math Function | fl_lib/Physical Signals/Functions/PS Math Function | R2023a+ | Use when applying transcendental math functions like exp, log, sqrt, or power to a physical signal |
| PS Product | fl_lib/Physical Signals/Functions/PS Product | R2023a+ | Use when multiplying two physical signals element-wise |
| PS Subtract | fl_lib/Physical Signals/Functions/PS Subtract | R2023a+ | Use when computing the difference between two physical signals |
| PS Sum of Elements | fl_lib/Physical Signals/Functions/PS Sum of Elements | R2023b+ | Use when summing all elements of a vector physical signal into a scalar |
| PS Abs | fl_lib/Physical Signals/Nonlinear Operators/PS Abs | R2023a+ | Use when computing the absolute value of a physical signal to ensure non-negative output |
| PS Ceil | fl_lib/Physical Signals/Nonlinear Operators/PS Ceil | R2023a+ | Use when rounding a physical signal up to the nearest integer |
| PS Dead Zone | fl_lib/Physical Signals/Nonlinear Operators/PS Dead Zone | R2023a+ | Use when suppressing small signal values within a specified band around zero |
| PS Fix | fl_lib/Physical Signals/Nonlinear Operators/PS Fix | R2023a+ | Use when rounding a physical signal toward zero to the nearest integer |
| PS Floor | fl_lib/Physical Signals/Nonlinear Operators/PS Floor | R2023a+ | Use when rounding a physical signal down to the nearest integer |
| PS Max | fl_lib/Physical Signals/Nonlinear Operators/PS Max | R2023a+ | Use when selecting the larger of two physical signals at each time step |
| PS Min | fl_lib/Physical Signals/Nonlinear Operators/PS Min | R2023a+ | Use when selecting the smaller of two physical signals at each time step |
| PS Round | fl_lib/Physical Signals/Nonlinear Operators/PS Round | R2023a+ | Use when rounding a physical signal to the nearest integer |
| PS Saturation | fl_lib/Physical Signals/Nonlinear Operators/PS Saturation | R2023a+ | Use when clamping a physical signal to upper and lower bounds to prevent values outside a valid range |
| PS Selector | fl_lib/Physical Signals/Nonlinear Operators/PS Selector | R2023b+ | Use when extracting specific elements from a vector physical signal by index |
| PS Sign | fl_lib/Physical Signals/Nonlinear Operators/PS Sign | R2023a+ | Use when extracting the sign of a physical signal as +1, 0, or -1 |
| PS Switch | fl_lib/Physical Signals/Nonlinear Operators/PS Switch | R2023a+ | Use when selecting between two physical signals based on a threshold condition |
| PS Three-Element Demux | fl_lib/Physical Signals/Nonlinear Operators/PS Three-Element Demux | R2023a+ | Use when splitting a three-element vector physical signal into three separate scalar signals |
| PS Vector Norm | fl_lib/Physical Signals/Nonlinear Operators/PS Vector Norm | R2023b+ | Use when computing the Euclidean norm of a vector physical signal |

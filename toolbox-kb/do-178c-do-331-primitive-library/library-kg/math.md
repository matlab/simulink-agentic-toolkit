---
type: Simulink Block Category
title: Math
description: Arithmetic and elementwise math functions
tags: [math operations, gain, sum, product, sqrt, trig, abs]
status: stable
source: custom_library
library_root: DO-178C/DO-331 Primitive Library
category_path: Math
block_count: 21
---

# Math

Use these blocks for math.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Abs | do178Lib/Simulink/Math Operations/Abs | R2023a+ | Output the absolute value (magnitude) of the input — use to remove sign or compute magnitude. |
| Add | do178Lib/Simulink/Math Operations/Add | R2023a+ | Sum inputs with configurable signs — use for additive combination of signals. |
| Assignment | do178Lib/Simulink/Math Operations/Assignment | R2023a+ | Write values into selected elements of a signal or array — use to update specific elements of a vector or matrix. |
| Bias | do178Lib/Simulink/Math Operations/Bias | R2023a+ | Add a constant offset to the input — use to shift a signal by a fixed amount. |
| Divide | do178Lib/Simulink/Math Operations/Divide | R2023a+ | Multiply and/or divide inputs — use for ratios, normalization, or scaling by another signal. |
| Dot Product | do178Lib/Simulink/Math Operations/Dot Product | R2023a+ | Compute the dot (inner) product of two vectors — use for projections, weighted sums, or magnitude-squared. |
| Gain | do178Lib/Simulink/Math Operations/Gain | R2023a+ | Scale a signal by a constant factor — use for unit conversion, controller gains, or applying physical constants. |
| Math Function | do178Lib/Simulink/Math Operations/Math Function | R2023a+ | Apply a math function (exp, log, power, mod, reciprocal, …) — use for elementwise nonlinear math. |
| MinMax | do178Lib/Simulink/Math Operations/MinMax | R2023a+ | Output the minimum or maximum across inputs or elements — use to select extremes or clamp between signals. |
| Polynomial | do178Lib/Simulink/Math Operations/Polynomial | R2023a+ | Evaluate a polynomial with given coefficients at the input — use to apply a polynomial fit or characteristic. |
| Product | do178Lib/Simulink/Math Operations/Product | R2023a+ | Multiply inputs elementwise or as matrices — use for scaling, modulation, or products of signals. |
| Reshape | do178Lib/Simulink/Math Operations/Reshape | R2023a+ | Change the dimensions of a signal without changing its data — use to convert between vector and matrix shapes. |
| Rounding Function | do178Lib/Simulink/Math Operations/Rounding Function | R2023a+ | Round a signal (floor, ceil, round, fix) — use to quantize to integers or control rounding behavior. |
| Sign | do178Lib/Simulink/Math Operations/Sign | R2023a+ | Output the sign (-1/0/+1) of the input — use for direction detection or sign extraction. |
| Signed Sqrt | do178Lib/Simulink/Math Operations/Signed Sqrt | R2023a+ | Compute a sign-preserving square root, sign(u)·sqrt(|u|) — use when the input can be negative but root-like scaling is needed. |
| Sqrt | do178Lib/Simulink/Math Operations/Sqrt | R2023a+ | Compute the square root of the input — use for magnitude, RMS, or geometric calculations. |
| Subtract | do178Lib/Simulink/Math Operations/Subtract | R2023a+ | Subtract inputs (a Sum configured for subtraction) — use to compute differences or control errors. |
| Sum | do178Lib/Simulink/Math Operations/Sum | R2023a+ | Add or subtract inputs per the sign list — use to combine signals, form errors, or accumulate. |
| Trigonometric Function | do178Lib/Simulink/Math Operations/Trigonometric Function | R2023a+ | Apply a trig function (sin, cos, tan, atan2, …) — use for angle/phase computation and coordinate transforms. |
| Unary Minus | do178Lib/Simulink/Math Operations/Unary Minus | R2023a+ | Negate the input (multiply by -1) — use to invert a signal's sign. |
| MinMax Running Resettable | do178Lib/Simulink/Math Operations/MinMax Running Resettable | R2023a+ | Output the max or min of all past inputs u. The output is reset to the initial condition when the Reset input signal R is TRUE. This reset action is vectorized and supports scalar expansion. |

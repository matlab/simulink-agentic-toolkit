---
type: Simulink Block Category
title: Math operations
description: Arithmetic, algebraic, and trigonometric computations
tags: [add, gain, multiply, sqrt, math]
status: stable
source: mathworks_toolbox
library_root: DO-178C/DO-331 Primitive Library
category_path: Math operations
block_count: 21
---

# Math operations

Use these blocks for math operations.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| MinMax Running Resettable | do178Lib/Simulink/Math Operations/MinMax Running Resettable | R2023a+ | Track the running minimum or maximum of a signal with a reset input — use for peak detection, envelope tracking, or exceedance monitoring with periodic reset |
| Abs | do178Lib/Simulink/Math Operations/Abs | R2023a+ | Compute absolute value of a signal — use for magnitude calculations, error bounds, or ensuring non-negative values in certified control logic |
| Add | do178Lib/Simulink/Math Operations/Add | R2023a+ | Sum two or more signals element-wise — use for combining feedforward and feedback paths, error computation, or signal aggregation |
| Assignment | do178Lib/Simulink/Math Operations/Assignment | R2023a+ | Assign values to specific elements of a vector or matrix signal — use to update individual channels within a bus or array without affecting other elements |
| Bias | do178Lib/Simulink/Math Operations/Bias | R2023a+ | Add a constant offset to a signal — use for sensor offset correction, coordinate frame shifts, or zero-point calibration adjustments |
| Divide | do178Lib/Simulink/Math Operations/Divide | R2023a+ | Divide one signal by another element-wise — use for normalization, ratio computation, or computing per-unit quantities in flight control |
| Dot Product | do178Lib/Simulink/Math Operations/Dot Product | R2023a+ | Compute inner product of two vectors — use for projection calculations, correlation measures, or computing force/torque components along an axis |
| Gain | do178Lib/Simulink/Math Operations/Gain | R2023a+ | Multiply a signal by a constant factor — use for unit conversion, controller gains, scaling factors, or applying physical constants in certified algorithms |
| Math Function | do178Lib/Simulink/Math Operations/Math Function | R2023a+ | Apply a mathematical function such as exp, log, pow, sqrt, or reciprocal — use for nonlinear transformations in certified airborne computations |
| MinMax | do178Lib/Simulink/Math Operations/MinMax | R2023a+ | Output the minimum or maximum of input signals — use for signal limiting, worst-case selection, or redundancy management voting logic |
| Polynomial | do178Lib/Simulink/Math Operations/Polynomial | R2023a+ | Evaluate a polynomial expression given coefficients and an input — use for curve-fit approximations, sensor correction polynomials, or aerodynamic coefficient models |
| Product | do178Lib/Simulink/Math Operations/Product | R2023a+ | Multiply or divide two or more signals — use for gain scheduling, coordinate transforms, or computing products of physical quantities |
| Reshape | do178Lib/Simulink/Math Operations/Reshape | R2023a+ | Change the dimensions of a signal without altering its data — use to convert between vector and matrix representations for downstream block compatibility |
| Rounding Function | do178Lib/Simulink/Math Operations/Rounding Function | R2023a+ | Round a signal value using floor, ceil, round, or fix — use for quantization, discrete command generation, or integer arithmetic in certified logic |
| Sign | do178Lib/Simulink/Math Operations/Sign | R2023a+ | Output the sign of a signal as +1, 0, or -1 — use for direction detection, polarity logic, or deadband control decisions |
| Signed Sqrt | do178Lib/Simulink/Math Operations/Signed Sqrt | R2023a+ | Compute square root preserving the sign of the input — use when the sign carries physical meaning such as signed flow or signed force magnitude |
| Sqrt | do178Lib/Simulink/Math Operations/Sqrt | R2023a+ | Compute the square root of a signal — use for RMS calculations, distance computations, or converting squared quantities back to physical units |
| Subtract | do178Lib/Simulink/Math Operations/Subtract | R2023a+ | Subtract one signal from another — use for error computation, differential measurements, or computing deviations from reference values |
| Sum | do178Lib/Simulink/Math Operations/Sum | R2023a+ | Add or subtract multiple signals according to a sign list — use for summing junctions in feedback loops, multi-input aggregation, or PID error paths |
| Trigonometric Function | do178Lib/Simulink/Math Operations/Trigonometric Function | R2023a+ | Compute sine, cosine, tangent, or their inverses — use for coordinate transforms, angle computations, or navigation algorithms in certified flight software |
| Unary Minus | do178Lib/Simulink/Math Operations/Unary Minus | R2023a+ | Negate a signal — use to reverse polarity, compute complementary values, or implement sign inversion in feedback paths |

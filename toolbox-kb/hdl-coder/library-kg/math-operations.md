---
type: Simulink Block Category
title: Math operations
description: General arithmetic and mathematical operations for HDL designs
tags: [add, multiply, gain, arithmetic, matrix]
status: stable
source: mathworks_toolbox
library_root: HDL Coder
category_path: Math operations
block_count: 50
---

# Math operations

Use these blocks for math operations.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Multiply-Accumulate | hdlsllib/HDL Operations/Multiply-Accumulate | R2023a+ | Use when you need an efficient multiply-and-accumulate operation targeting DSP slices in hardware |
| Multiply-Add | hdlsllib/HDL Operations/Multiply-Add | R2023a+ | Use when you need a fused multiply-add operation that maps to FPGA DSP resources |
| Decrement Real World | hdlsllib/Math Operations/Decrement Real World | R2023a+ | Use when you need to decrease a fixed-point signal by one unit in real-world value |
| Decrement Stored Integer | hdlsllib/Math Operations/Decrement Stored Integer | R2023a+ | Use when you need to decrease the stored integer value of a fixed-point signal by one |
| Increment Real World | hdlsllib/Math Operations/Increment Real World | R2023a+ | Use when you need to increase a fixed-point signal by one unit in real-world value |
| Increment Stored Integer | hdlsllib/Math Operations/Increment Stored Integer | R2023a+ | Use when you need to increase the stored integer value of a fixed-point signal by one |
| Abs | hdlsllib/HDL Floating Point Operations/Abs | R2023a+ | Use when you need the absolute value of a signal for magnitude-only processing in HDL designs |
| Add | hdlsllib/HDL Floating Point Operations/Add | R2023a+ | Use when you need to sum two or more signals together in an HDL-compatible arithmetic path |
| Bias | hdlsllib/HDL Floating Point Operations/Bias | R2023a+ | Use when you need to add a constant offset to a signal value |
| Divide | hdlsllib/HDL Floating Point Operations/Divide | R2023a+ | Use when you need to perform division of signals in an HDL-compatible design |
| Gain | hdlsllib/HDL Floating Point Operations/Gain | R2023a+ | Use when you need to multiply a signal by a constant scaling factor |
| Magnitude-Angle to Complex | hdlsllib/HDL Floating Point Operations/Magnitude-Angle to Complex | R2023a+ | Use when you need to construct a complex signal from polar magnitude and angle inputs |
| Product | hdlsllib/HDL Floating Point Operations/Product | R2023a+ | Use when you need to multiply two or more signals together in hardware |
| Product of Elements | hdlsllib/HDL Floating Point Operations/Product of Elements | R2023a+ | Use when you need to compute the product across all elements of a vector signal |
| Reciprocal | hdlsllib/HDL Floating Point Operations/Reciprocal | R2023a+ | Use when you need to compute the multiplicative inverse of a signal |
| Reciprocal Sqrt | hdlsllib/HDL Floating Point Operations/Reciprocal Sqrt | R2023a+ | Use when you need to compute one divided by the square root of a signal |
| Sign | hdlsllib/HDL Floating Point Operations/Sign | R2023a+ | Use when you need to determine the sign of a signal as positive, negative, or zero |
| Sqrt | hdlsllib/HDL Floating Point Operations/Sqrt | R2023a+ | Use when you need to compute the square root of a signal for HDL implementation |
| Square | hdlsllib/HDL Floating Point Operations/Square | R2023a+ | Use when you need to compute the square of a signal value |
| Subtract | hdlsllib/HDL Floating Point Operations/Subtract | R2023a+ | Use when you need to compute the difference between two signals |
| Sum of Elements | hdlsllib/HDL Floating Point Operations/Sum of Elements | R2023a+ | Use when you need to sum all elements of a vector input into a single scalar |
| Unary Minus | hdlsllib/HDL Floating Point Operations/Unary Minus | R2023a+ | Use when you need to negate a signal value |
| Abs | hdlsllib/Math Operations/Abs | R2023a+ | Use when you need the absolute value of a signal for magnitude-only processing in HDL designs |
| Add | hdlsllib/Math Operations/Add | R2023a+ | Use when you need to sum two or more signals together in an HDL-compatible arithmetic path |
| Assignment | hdlsllib/Math Operations/Assignment | R2023a+ | Use when you need to assign values to specific elements of a vector or matrix signal |
| Bias | hdlsllib/Math Operations/Bias | R2023a+ | Use when you need to add a constant offset to a signal value |
| Complex to Magnitude-Angle | hdlsllib/Math Operations/Complex to Magnitude-Angle | R2023a+ | Use when you need to convert a complex signal into its polar magnitude and phase components |
| Complex to Real-Imag | hdlsllib/Math Operations/Complex to Real-Imag | R2023a+ | Use when you need to split a complex signal into separate real and imaginary parts |
| Divide | hdlsllib/Math Operations/Divide | R2023a+ | Use when you need to perform division of signals in an HDL-compatible design |
| Dot Product | hdlsllib/Math Operations/Dot Product | R2023a+ | Use when you need to compute the inner product of two vector signals |
| Gain | hdlsllib/Math Operations/Gain | R2023a+ | Use when you need to multiply a signal by a constant scaling factor |
| Magnitude-Angle to Complex | hdlsllib/Math Operations/Magnitude-Angle to Complex | R2023a+ | Use when you need to construct a complex signal from polar magnitude and angle inputs |
| Math Function | hdlsllib/Math Operations/Math Function | R2023a+ | Use when you need general mathematical functions like square, reciprocal, or logarithm in HDL |
| Matrix Concatenate | hdlsllib/Math Operations/Matrix Concatenate | R2023a+ | Use when you need to combine multiple matrix signals into a single larger matrix |
| MatrixMultiply | hdlsllib/Math Operations/MatrixMultiply | R2023a+ | Use when you need to perform matrix multiplication for linear algebra operations in HDL |
| MinMax | hdlsllib/Math Operations/MinMax | R2023a+ | Use when you need to find the minimum or maximum across multiple input signals |
| Product | hdlsllib/Math Operations/Product | R2023a+ | Use when you need to multiply two or more signals together in hardware |
| Product of Elements | hdlsllib/Math Operations/Product of Elements | R2023a+ | Use when you need to compute the product across all elements of a vector signal |
| Real-Imag to Complex | hdlsllib/Math Operations/Real-Imag to Complex | R2023a+ | Use when you need to combine separate real and imaginary components into a complex signal |
| Reciprocal | hdlsllib/Math Operations/Reciprocal | R2023a+ | Use when you need to compute the multiplicative inverse of a signal |
| Reciprocal Sqrt | hdlsllib/Math Operations/Reciprocal Sqrt | R2023a+ | Use when you need to compute one divided by the square root of a signal |
| Reshape | hdlsllib/Math Operations/Reshape | R2023a+ | Use when you need to change the dimensions of a signal without modifying its data |
| Sign | hdlsllib/Math Operations/Sign | R2023a+ | Use when you need to determine the sign of a signal as positive, negative, or zero |
| Sqrt | hdlsllib/Math Operations/Sqrt | R2023a+ | Use when you need to compute the square root of a signal for HDL implementation |
| Subtract | hdlsllib/Math Operations/Subtract | R2023a+ | Use when you need to compute the difference between two signals |
| Sum | hdlsllib/Math Operations/Sum | R2023a+ | Use when you need to add or subtract multiple signals with configurable sign list |
| Sum of Elements | hdlsllib/Math Operations/Sum of Elements | R2023a+ | Use when you need to sum all elements of a vector input into a single scalar |
| Trigonometric Function | hdlsllib/Math Operations/Trigonometric Function | R2023a+ | Use when you need sine, cosine, or other trigonometric computations in HDL |
| Unary Minus | hdlsllib/Math Operations/Unary Minus | R2023a+ | Use when you need to negate a signal value |
| Vector Concatenate | hdlsllib/Math Operations/Vector Concatenate | R2023a+ | Use when you need to join multiple vector signals into a single longer vector |

---
type: Simulink Block Category
title: Floating point operations
description: Floating-point math functions optimized for FPGA hardware implementation
tags: [floating-point, trigonometry, logarithm, rounding, IEEE-754]
status: stable
source: mathworks_toolbox
library_root: HDL Coder
category_path: Floating point operations
block_count: 36
---

# Floating point operations

Use these blocks for floating point operations.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| ACosh | hdlsllib/HDL Floating Point Operations/ACosh | R2023a+ | Use when you need the inverse hyperbolic cosine with HDL floating-point implementation |
| ASinh | hdlsllib/HDL Floating Point Operations/ASinh | R2023a+ | Use when you need the inverse hyperbolic sine with HDL floating-point implementation |
| ATanh | hdlsllib/HDL Floating Point Operations/ATanh | R2023a+ | Use when you need the inverse hyperbolic tangent with HDL floating-point implementation |
| Acos | hdlsllib/HDL Floating Point Operations/Acos | R2023a+ | Use when you need the arccosine function with HDL floating-point hardware mapping |
| Asin | hdlsllib/HDL Floating Point Operations/Asin | R2023a+ | Use when you need the arcsine function with HDL floating-point hardware mapping |
| Atan | hdlsllib/HDL Floating Point Operations/Atan | R2023a+ | Use when you need the arctangent function with HDL floating-point hardware mapping |
| Atan2 | hdlsllib/HDL Floating Point Operations/Atan2 | R2023a+ | Use when you need the four-quadrant arctangent with HDL floating-point support |
| Ceil | hdlsllib/HDL Floating Point Operations/Ceil | R2023a+ | Use when you need to round a floating-point value up to the nearest integer in HDL |
| Conjugate | hdlsllib/HDL Floating Point Operations/Conjugate | R2023a+ | Use when you need to compute the complex conjugate of a floating-point signal |
| Cos | hdlsllib/HDL Floating Point Operations/Cos | R2023a+ | Use when you need the cosine function with HDL floating-point hardware mapping |
| Cosh | hdlsllib/HDL Floating Point Operations/Cosh | R2023a+ | Use when you need the hyperbolic cosine with HDL floating-point implementation |
| Exp | hdlsllib/HDL Floating Point Operations/Exp | R2023a+ | Use when you need the exponential function with HDL floating-point hardware support |
| Fix | hdlsllib/HDL Floating Point Operations/Fix | R2023a+ | Use when you need to round a floating-point value toward zero in HDL |
| Float Typecast | hdlsllib/HDL Floating Point Operations/Float Typecast | R2023a+ | Use when you need to reinterpret the bit pattern of a floating-point signal as a different type |
| Floor | hdlsllib/HDL Floating Point Operations/Floor | R2023a+ | Use when you need to round a floating-point value down to the nearest integer in HDL |
| Hermitian | hdlsllib/HDL Floating Point Operations/Hermitian | R2023a+ | Use when you need the Hermitian transpose of a complex matrix in floating-point HDL |
| Hypot | hdlsllib/HDL Floating Point Operations/Hypot | R2023a+ | Use when you need to compute the hypotenuse length from two sides in floating-point HDL |
| Log | hdlsllib/HDL Floating Point Operations/Log | R2023a+ | Use when you need the natural logarithm with HDL floating-point hardware support |
| Log10 | hdlsllib/HDL Floating Point Operations/Log10 | R2023a+ | Use when you need the base-10 logarithm with HDL floating-point hardware support |
| Magnitude Square | hdlsllib/HDL Floating Point Operations/Magnitude Square | R2023a+ | Use when you need the squared magnitude of a complex signal in floating-point HDL |
| Math Reciprocal | hdlsllib/HDL Floating Point Operations/Math Reciprocal | R2023a+ | Use when you need the reciprocal computed via floating-point math operations in HDL |
| Max | hdlsllib/HDL Floating Point Operations/Max | R2023a+ | Use when you need to find the maximum of floating-point inputs in HDL |
| Min | hdlsllib/HDL Floating Point Operations/Min | R2023a+ | Use when you need to find the minimum of floating-point inputs in HDL |
| Mod | hdlsllib/HDL Floating Point Operations/Mod | R2023a+ | Use when you need the modulus operation on floating-point signals in HDL |
| Pow | hdlsllib/HDL Floating Point Operations/Pow | R2023a+ | Use when you need to raise a floating-point signal to an arbitrary power in HDL |
| Pow10 | hdlsllib/HDL Floating Point Operations/Pow10 | R2023a+ | Use when you need to compute ten raised to a floating-point power in HDL |
| Rem | hdlsllib/HDL Floating Point Operations/Rem | R2023a+ | Use when you need the remainder after division of floating-point signals in HDL |
| Round | hdlsllib/HDL Floating Point Operations/Round | R2023a+ | Use when you need to round a floating-point signal to the nearest integer in HDL |
| SignedSqrt | hdlsllib/HDL Floating Point Operations/SignedSqrt | R2023a+ | Use when you need the signed square root that preserves the sign of the input |
| Sin | hdlsllib/HDL Floating Point Operations/Sin | R2023a+ | Use when you need the sine function with HDL floating-point hardware mapping |
| Sincos | hdlsllib/HDL Floating Point Operations/Sincos | R2023a+ | Use when you need simultaneous sine and cosine outputs from a single angle input in HDL |
| Sinh | hdlsllib/HDL Floating Point Operations/Sinh | R2023a+ | Use when you need the hyperbolic sine with HDL floating-point implementation |
| Tan | hdlsllib/HDL Floating Point Operations/Tan | R2023a+ | Use when you need the tangent function with HDL floating-point hardware mapping |
| Tanh | hdlsllib/HDL Floating Point Operations/Tanh | R2023a+ | Use when you need the hyperbolic tangent with HDL floating-point implementation |
| Transpose | hdlsllib/HDL Floating Point Operations/Transpose | R2023a+ | Use when you need to transpose a matrix signal in floating-point HDL designs |
| cos + jsin | hdlsllib/HDL Floating Point Operations/cos + jsin | R2023a+ | Use when you need to compute complex exponential from an angle as cosine plus j-sine |

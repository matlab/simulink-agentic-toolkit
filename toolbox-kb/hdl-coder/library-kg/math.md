---
type: Simulink Block Category
title: Math
description: Arithmetic, trigonometric, and matrix math operations
tags: [math, arithmetic, trigonometry, gain, product, sum, matrix]
status: stable
source: custom_library
library_root: HDL Coder
category_path: Math
block_count: 90
---

# Math

Use these blocks for math.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Gain | hdlsllib/Commonly
Used Blocks/Gain | R2023a+ | Scale a signal by a constant factor — use for unit conversion, controller gains, or applying physical constants. |
| Product | hdlsllib/Commonly
Used Blocks/Product | R2023a+ | Multiply and optionally divide inputs — use for scaling, products, and element-wise multiplication. |
| Sum | hdlsllib/Commonly
Used Blocks/Sum | R2023a+ | Add or subtract inputs — use for summing signals and forming error terms. |
| ACosh | hdlsllib/HDL Floating Point Operations/ACosh | R2023a+ | Compute the inverse hyperbolic cosine — use in HDL-targeted math needing acosh. |
| ASinh | hdlsllib/HDL Floating Point Operations/ASinh | R2023a+ | Compute the inverse hyperbolic sine — use in HDL-targeted math needing asinh. |
| ATanh | hdlsllib/HDL Floating Point Operations/ATanh | R2023a+ | Compute the inverse hyperbolic tangent — use in HDL-targeted math needing atanh. |
| Abs | hdlsllib/HDL Floating Point Operations/Abs | R2023a+ | Output the absolute value (or complex magnitude) of the input — use to remove sign or get magnitude. |
| Acos | hdlsllib/HDL Floating Point Operations/Acos | R2023a+ | Compute the arccosine of the input — use for inverse-trig angle recovery. |
| Add | hdlsllib/HDL Floating Point Operations/Add | R2023a+ | Add and optionally subtract inputs — use for summing signals with per-port sign control. |
| Asin | hdlsllib/HDL Floating Point Operations/Asin | R2023a+ | Compute the arcsine of the input — use for inverse-trig angle recovery. |
| Atan | hdlsllib/HDL Floating Point Operations/Atan | R2023a+ | Compute the arctangent of the input — use for single-argument angle recovery. |
| Atan2 | hdlsllib/HDL Floating Point Operations/Atan2 | R2023a+ | Compute the four-quadrant arctangent of y and x — use to get a full-range angle from Cartesian components. |
| Bias | hdlsllib/HDL Floating Point Operations/Bias | R2023a+ | Add a constant offset to the input — use to shift a signal by a fixed amount. |
| Ceil | hdlsllib/HDL Floating Point Operations/Ceil | R2023a+ | Round toward positive infinity — use for ceiling rounding. |
| Conjugate | hdlsllib/HDL Floating Point Operations/Conjugate | R2023a+ | Compute the complex conjugate — use in signal-processing math needing conjugation. |
| Cos | hdlsllib/HDL Floating Point Operations/Cos | R2023a+ | Compute the cosine of the input (radians) — use for trig and waveform generation. |
| Cosh | hdlsllib/HDL Floating Point Operations/Cosh | R2023a+ | Compute the hyperbolic cosine of the input. |
| Divide | hdlsllib/HDL Floating Point Operations/Divide | R2023a+ | Multiply and/or divide inputs — use for ratios and element-wise division. |
| Exp | hdlsllib/HDL Floating Point Operations/Exp | R2023a+ | Compute the exponential e^u of the input. |
| Fix | hdlsllib/HDL Floating Point Operations/Fix | R2023a+ | Round toward zero (truncate) — use for truncating rounding. |
| Float Typecast | hdlsllib/HDL Floating Point Operations/Float Typecast | R2023a+ | Reinterpret the bits of a float as an integer or vice versa — use for bit-level float manipulation in HDL. |
| Floor | hdlsllib/HDL Floating Point Operations/Floor | R2023a+ | Round toward negative infinity — use for floor rounding. |
| Gain | hdlsllib/HDL Floating Point Operations/Gain | R2023a+ | Scale a signal by a constant factor — use for unit conversion, controller gains, or applying physical constants. |
| Hermitian | hdlsllib/HDL Floating Point Operations/Hermitian | R2023a+ | Compute the complex-conjugate transpose of a matrix — use in linear-algebra signal processing. |
| Hypot | hdlsllib/HDL Floating Point Operations/Hypot | R2023a+ | Compute sqrt(u1^2 + u2^2) robustly — use for magnitude/hypotenuse without overflow. |
| Log | hdlsllib/HDL Floating Point Operations/Log | R2023a+ | Compute the natural logarithm of the input. |
| Log10 | hdlsllib/HDL Floating Point Operations/Log10 | R2023a+ | Compute the base-10 logarithm of the input. |
| Magnitude Square | hdlsllib/HDL Floating Point Operations/Magnitude Square | R2023a+ | Compute |u|^2 of a possibly complex input — use for power/energy without a square root. |
| Magnitude-Angle to Complex | hdlsllib/HDL Floating Point Operations/Magnitude-Angle to Complex | R2023a+ | Build a complex signal from magnitude and angle — use to convert polar to complex. |
| Math Reciprocal | hdlsllib/HDL Floating Point Operations/Math Reciprocal | R2023a+ | Compute 1/u — use for reciprocal or division-by-input. |
| Max | hdlsllib/HDL Floating Point Operations/Max | R2023a+ | Output the maximum of the inputs — use for element-wise or port-wise max selection. |
| Min | hdlsllib/HDL Floating Point Operations/Min | R2023a+ | Output the minimum of the inputs — use for element-wise or port-wise min selection. |
| Mod | hdlsllib/HDL Floating Point Operations/Mod | R2023a+ | Compute the modulus/remainder after division — use for wrapping or periodic indexing. |
| Pow | hdlsllib/HDL Floating Point Operations/Pow | R2023a+ | Raise the base input to the power of the exponent input — use for u1^u2. |
| Pow10 | hdlsllib/HDL Floating Point Operations/Pow10 | R2023a+ | Compute 10^u — use for decade scaling. |
| Product | hdlsllib/HDL Floating Point Operations/Product | R2023a+ | Multiply and optionally divide inputs — use for scaling, products, and element-wise multiplication. |
| Product of Elements | hdlsllib/HDL Floating Point Operations/Product of Elements | R2023a+ | Multiply all elements of a vector together — use for cumulative products. |
| Reciprocal | hdlsllib/HDL Floating Point Operations/Reciprocal | R2023a+ | Compute 1/u — use for inversion or division-by-input. |
| Reciprocal Sqrt | hdlsllib/HDL Floating Point Operations/Reciprocal Sqrt | R2023a+ | Compute 1/sqrt(u) — use for normalization such as inverse magnitude. |
| Rem | hdlsllib/HDL Floating Point Operations/Rem | R2023a+ | Compute the remainder after division (sign of the dividend) — use for remainder arithmetic. |
| Round | hdlsllib/HDL Floating Point Operations/Round | R2023a+ | Round to the nearest integer — use for standard rounding. |
| Sign | hdlsllib/HDL Floating Point Operations/Sign | R2023a+ | Output the sign (-1, 0, +1) of the input — use for sign extraction or direction. |
| SignedSqrt | hdlsllib/HDL Floating Point Operations/SignedSqrt | R2023a+ | Compute sign(u)*sqrt(|u|) — use for signed square-root scaling. |
| Sin | hdlsllib/HDL Floating Point Operations/Sin | R2023a+ | Compute the sine of the input (radians) — use for trig and waveform generation. |
| Sincos | hdlsllib/HDL Floating Point Operations/Sincos | R2023a+ | Compute sine and cosine of the input together — use for efficient combined trig. |
| Sinh | hdlsllib/HDL Floating Point Operations/Sinh | R2023a+ | Compute the hyperbolic sine of the input. |
| Sqrt | hdlsllib/HDL Floating Point Operations/Sqrt | R2023a+ | Compute the square root of the input — use for magnitude or RMS-type math. |
| Square | hdlsllib/HDL Floating Point Operations/Square | R2023a+ | Compute u^2 — use for squaring or power calculations. |
| Subtract | hdlsllib/HDL Floating Point Operations/Subtract | R2023a+ | Subtract inputs with per-port sign — use for differences and error signals. |
| Sum of Elements | hdlsllib/HDL Floating Point Operations/Sum of Elements | R2023a+ | Add all elements of a vector — use for cumulative sums or totals. |
| Tan | hdlsllib/HDL Floating Point Operations/Tan | R2023a+ | Compute the tangent of the input (radians). |
| Tanh | hdlsllib/HDL Floating Point Operations/Tanh | R2023a+ | Compute the hyperbolic tangent — use for smooth saturating nonlinearities. |
| Transpose | hdlsllib/HDL Floating Point Operations/Transpose | R2023a+ | Transpose a matrix signal — use to swap rows and columns. |
| Unary Minus | hdlsllib/HDL Floating Point Operations/Unary Minus | R2023a+ | Negate the input — use to flip sign. |
| cos + jsin | hdlsllib/HDL Floating Point Operations/cos + jsin | R2023a+ | Generate the complex exponential cos(u)+j·sin(u) — use for complex tone or carrier generation. |
| Multiply-Accumulate | hdlsllib/HDL Operations/Multiply-Accumulate | R2023a+ | Operation Mode: Vector dataOut= sum(a.*b) + c Operation Mode: Streaming- using Start and End ports dataOut(t+1)= dataOut(t) + sum(a(t)*b(t)) + c where c=bias when start and valid=high, else c=0 Operation Mode: Streaming- using number of Samples dataOut(t+1)= dataOut(t) + sum(a(t)*b(t)) + c where c=bias when t=0 else c=0 This block is designed for efficient mapping to DSP slices on FPGAs. |
| Bit Shift | hdlsllib/Logic and Bit Operations/Bit Shift | R2023a+ | Perform a logical or arithmetic shift on the input signal, as specified by the Shift Mode parameter. The Shift Length specifies the number of bits shifted. |
| Abs | hdlsllib/Math Operations/Abs | R2023a+ | Output the absolute value (or complex magnitude) of the input — use to remove sign or get magnitude. |
| Add | hdlsllib/Math Operations/Add | R2023a+ | Add and optionally subtract inputs — use for summing signals with per-port sign control. |
| Assignment | hdlsllib/Math Operations/Assignment | R2023a+ | Write input values into selected elements of a signal or array — use to build or update array elements by index. |
| Bias | hdlsllib/Math Operations/Bias | R2023a+ | Add a constant offset to the input — use to shift a signal by a fixed amount. |
| Complex to Magnitude-Angle | hdlsllib/Math Operations/Complex to Magnitude-Angle | R2026a+ | Split a complex signal into magnitude and phase angle — use for polar analysis. |
| Complex to Real-Imag | hdlsllib/Math Operations/Complex to Real-Imag | R2023a+ | Split a complex signal into real and imaginary parts — use to access rectangular components. |
| Divide | hdlsllib/Math Operations/Divide | R2023a+ | Multiply and/or divide inputs — use for ratios and element-wise division. |
| Dot Product | hdlsllib/Math Operations/Dot Product | R2023a+ | Compute the dot product of two vectors — use for projections and weighted sums. |
| Gain | hdlsllib/Math Operations/Gain | R2023a+ | Scale a signal by a constant factor — use for unit conversion, controller gains, or applying physical constants. |
| Magnitude-Angle to Complex | hdlsllib/Math Operations/Magnitude-Angle to Complex | R2023a+ | Build a complex signal from magnitude and angle — use to convert polar to complex. |
| Math Function | hdlsllib/Math Operations/Math Function | R2023a+ | Apply a selectable math function (exp, log, square, reciprocal, mod, …) — use for common scalar math. |
| Matrix Concatenate | hdlsllib/Math Operations/Matrix Concatenate | R2023a+ | Concatenate inputs into a larger matrix along a dimension — use to assemble matrices. |
| MatrixMultiply | hdlsllib/Math Operations/MatrixMultiply | R2023a+ | Multiply matrices or matrix-vector products — use for linear transforms. |
| MinMax | hdlsllib/Math Operations/MinMax | R2023a+ | Output the minimum or maximum across inputs — use for extreme-value selection. |
| Product | hdlsllib/Math Operations/Product | R2023a+ | Multiply and optionally divide inputs — use for scaling, products, and element-wise multiplication. |
| Product of Elements | hdlsllib/Math Operations/Product of Elements | R2023a+ | Multiply all elements of a vector together — use for cumulative products. |
| Real-Imag to Complex | hdlsllib/Math Operations/Real-Imag to Complex | R2023a+ | Build a complex signal from real and imaginary parts — use to convert rectangular to complex. |
| Reciprocal | hdlsllib/Math Operations/Reciprocal | R2023a+ | Compute 1/u — use for inversion or division-by-input. |
| Reciprocal Sqrt | hdlsllib/Math Operations/Reciprocal Sqrt | R2023a+ | Compute 1/sqrt(u) — use for normalization such as inverse magnitude. |
| Reshape | hdlsllib/Math Operations/Reshape | R2023a+ | Change the dimensions of a signal without changing its data — use to reshape vectors and matrices. |
| Sign | hdlsllib/Math Operations/Sign | R2023a+ | Output the sign (-1, 0, +1) of the input — use for sign extraction or direction. |
| Sqrt | hdlsllib/Math Operations/Sqrt | R2023a+ | Compute the square root of the input — use for magnitude or RMS-type math. |
| Subtract | hdlsllib/Math Operations/Subtract | R2023a+ | Subtract inputs with per-port sign — use for differences and error signals. |
| Sum | hdlsllib/Math Operations/Sum | R2023a+ | Add or subtract inputs — use for summing signals and forming error terms. |
| Sum of Elements | hdlsllib/Math Operations/Sum of Elements | R2023a+ | Add all elements of a vector — use for cumulative sums or totals. |
| Trigonometric Function | hdlsllib/Math Operations/Trigonometric Function | R2023a+ | Apply a selectable trig or hyperbolic function (sin, cos, atan2, …) — use for angle and waveform math. |
| Unary Minus | hdlsllib/Math Operations/Unary Minus | R2023a+ | Negate the input — use to flip sign. |
| Vector Concatenate | hdlsllib/Math Operations/Vector Concatenate | R2023a+ | Concatenate inputs into a single vector — use to combine signals along one dimension. |
| Decrement Real World | hdlsllib/Math Operations/Decrement Real World | R2023a+ | Decrease the Real World Value of Signal by 1.0 Overflows will always wrap. |
| Decrement Stored Integer | hdlsllib/Math Operations/Decrement Stored Integer | R2023a+ | Decrease the Stored Value of Signal by 1 Floating Point signals are decreased by 1.0 Overflows will always wrap. |
| Increment Real World | hdlsllib/Math Operations/Increment Real World | R2023a+ | Increase the Real World Value of Signal by 1.0 Overflows will always wrap. |
| Increment Stored Integer | hdlsllib/Math Operations/Increment Stored Integer | R2023a+ | Increase the Stored Value of Signal by 1 Floating Point signals are increased by 1.0 Overflows will always wrap. |
| Vector
Concatenate | hdlsllib/Signal
Routing/Vector
Concatenate | R2023a+ | Concatenate inputs into a single vector — use to combine signals along one dimension. |

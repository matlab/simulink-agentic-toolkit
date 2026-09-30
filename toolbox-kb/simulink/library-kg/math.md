---
type: Simulink Block Category
title: Math
description: Arithmetic, trigonometric, and scalar math
tags: [math, arithmetic, trigonometry, gain, sum, product, sqrt]
status: stable
source: custom_library
library_root: Simulink
category_path: Math
block_count: 91
---

# Math

Use these blocks for math.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Gain | simulink/Commonly
Used Blocks/Gain | R2023a+ | Scale a signal by a constant factor — use for unit conversion, controller gains, or applying physical constants. |
| Product | simulink/Commonly
Used Blocks/Product | R2023a+ | Multiply and optionally divide inputs — use for scaling, products, and element-wise multiplication. |
| Sum | simulink/Commonly
Used Blocks/Sum | R2023a+ | Add or subtract inputs — use for summing signals and forming error terms. |
| Vector
Concatenate | simulink/Commonly
Used Blocks/Vector
Concatenate | R2023a+ | Concatenate inputs into a single vector — use to combine signals along one dimension. |
| Abs | simulink/Math Operations/Abs | R2023a+ | Output the absolute value (or complex magnitude) of the input — use to remove sign or get magnitude. |
| Add | simulink/Math Operations/Add | R2023a+ | Add and optionally subtract inputs — use for summing signals with per-port sign control. |
| Algebraic Constraint | simulink/Math Operations/Algebraic Constraint | R2023a+ | Force an input expression to zero by solving for a constrained output — use to model implicit algebraic equations. |
| Assignment | simulink/Math Operations/Assignment | R2023a+ | Write input values into selected elements of a signal or array — use to build or update array elements by index. |
| Bias | simulink/Math Operations/Bias | R2023a+ | Add a constant offset to the input — use to shift a signal by a fixed amount. |
| Complex to Magnitude-Angle | simulink/Math Operations/Complex to Magnitude-Angle | R2023a+ | Split a complex signal into magnitude and phase angle — use for polar analysis. |
| Complex to Real-Imag | simulink/Math Operations/Complex to Real-Imag | R2023a+ | Split a complex signal into real and imaginary parts — use to access rectangular components. |
| Divide | simulink/Math Operations/Divide | R2023a+ | Multiply and/or divide inputs — use for ratios and element-wise division. |
| Dot Product | simulink/Math Operations/Dot Product | R2023a+ | Compute the dot product of two vectors — use for projections and weighted sums. |
| Find Nonzero Elements | simulink/Math Operations/Find Nonzero Elements | R2023a+ | Return indices and values of nonzero elements — use to locate active entries in a signal/array. |
| Gain | simulink/Math Operations/Gain | R2023a+ | Scale a signal by a constant factor — use for unit conversion, controller gains, or applying physical constants. |
| Magnitude-Angle to Complex | simulink/Math Operations/Magnitude-Angle to Complex | R2023a+ | Build a complex signal from magnitude and angle — use to convert polar to complex. |
| Math Function | simulink/Math Operations/Math Function | R2023a+ | Apply a selectable math function (exp, log, square, reciprocal, mod, …) — use for common scalar math. |
| Matrix Concatenate | simulink/Math Operations/Matrix Concatenate | R2023a+ | Concatenate inputs into a larger matrix along a dimension — use to assemble matrices. |
| MinMax | simulink/Math Operations/MinMax | R2023a+ | Output the minimum or maximum across inputs — use for extreme-value selection. |
| Permute Dimensions | simulink/Math Operations/Permute Dimensions | R2023a+ | Reorder the dimensions of a multidimensional signal — use to rearrange array axes. |
| Polynomial | simulink/Math Operations/Polynomial | R2023a+ | Evaluate a polynomial with given coefficients at the input — use for polynomial curve evaluation. |
| Product | simulink/Math Operations/Product | R2023a+ | Multiply and optionally divide inputs — use for scaling, products, and element-wise multiplication. |
| Product of Elements | simulink/Math Operations/Product of Elements | R2023a+ | Multiply all elements of a vector together — use for cumulative products. |
| Real-Imag to Complex | simulink/Math Operations/Real-Imag to Complex | R2023a+ | Build a complex signal from real and imaginary parts — use to convert rectangular to complex. |
| Reciprocal Sqrt | simulink/Math Operations/Reciprocal Sqrt | R2023a+ | Compute 1/sqrt(u) — use for normalization such as inverse magnitude. |
| Reshape | simulink/Math Operations/Reshape | R2023a+ | Change the dimensions of a signal without changing its data — use to reshape vectors and matrices. |
| Rounding Function | simulink/Math Operations/Rounding Function | R2023a+ | Apply a selectable rounding function (floor, ceil, round, fix) — use to round to integers. |
| Sign | simulink/Math Operations/Sign | R2023a+ | Output the sign (-1, 0, +1) of the input — use for sign extraction or direction. |
| Signed Sqrt | simulink/Math Operations/Signed Sqrt | R2023a+ | Compute sign(u)*sqrt(|u|) — use for signed square-root scaling. |
| Sine Wave Function | simulink/Math Operations/Sine Wave Function | R2023a+ | Generate a sine of the input signal (function form) — use to compute sin of a time or phase input. |
| Sqrt | simulink/Math Operations/Sqrt | R2023a+ | Compute the square root of the input — use for magnitude or RMS-type math. |
| Squeeze | simulink/Math Operations/Squeeze | R2023a+ | Remove singleton dimensions from a signal — use to drop length-1 array dimensions. |
| Subtract | simulink/Math Operations/Subtract | R2023a+ | Subtract inputs with per-port sign — use for differences and error signals. |
| Sum | simulink/Math Operations/Sum | R2023a+ | Add or subtract inputs — use for summing signals and forming error terms. |
| Sum of Elements | simulink/Math Operations/Sum of Elements | R2023a+ | Add all elements of a vector — use for cumulative sums or totals. |
| Trigonometric Function | simulink/Math Operations/Trigonometric Function | R2023a+ | Apply a selectable trig or hyperbolic function (sin, cos, atan2, …) — use for angle and waveform math. |
| Unary Minus | simulink/Math Operations/Unary Minus | R2023a+ | Negate the input — use to flip sign. |
| Vector Concatenate | simulink/Math Operations/Vector Concatenate | R2023a+ | Concatenate inputs into a single vector — use to combine signals along one dimension. |
| Weighted Sample Time Math | simulink/Math Operations/Weighted Sample Time Math | R2023a+ | Perform arithmetic that scales by the sample time (Ts) — use in discretization math involving the step size. |
| MinMax Running Resettable | simulink/Math Operations/MinMax Running Resettable | R2023a+ | Output the max or min of all past inputs u. The output is reset to the initial condition when the Reset input signal R is TRUE. This reset action is vectorized and supports scalar expansion. |
| Slider Gain | simulink/Math Operations/Slider Gain | R2023a+ | Move the slider to modify the scalar gain. |
| Matrix Concatenate | simulink/Matrix Operations/Matrix Concatenate | R2023a+ | Concatenate inputs into a larger matrix along a dimension — use to assemble matrices. |
| Acos | simulink/Quick Insert/Math Operations/Acos | R2023a+ | Compute the arccosine of the input — use for inverse-trig angle recovery. |
| Acosh | simulink/Quick Insert/Math Operations/Acosh | R2023a+ | Compute the inverse hyperbolic cosine of the input. |
| Add Constant | simulink/Quick Insert/Math Operations/Add Constant | R2023a+ | Add a fixed constant to the input — use to apply a constant offset. |
| Asin | simulink/Quick Insert/Math Operations/Asin | R2023a+ | Compute the arcsine of the input — use for inverse-trig angle recovery. |
| Asinh | simulink/Quick Insert/Math Operations/Asinh | R2023a+ | Compute the inverse hyperbolic sine of the input. |
| Atan | simulink/Quick Insert/Math Operations/Atan | R2023a+ | Compute the arctangent of the input — use for single-argument angle recovery. |
| Atan2 | simulink/Quick Insert/Math Operations/Atan2 | R2023a+ | Compute the four-quadrant arctangent of y and x — use to get a full-range angle from Cartesian components. |
| Atan2 Cordic | simulink/Quick Insert/Math Operations/Atan2 Cordic | R2023a+ | Compute four-quadrant arctangent using a CORDIC algorithm — use for efficient atan2 on fixed-point/embedded targets. |
| Atanh | simulink/Quick Insert/Math Operations/Atanh | R2023a+ | Compute the inverse hyperbolic tangent of the input. |
| Ceil | simulink/Quick Insert/Math Operations/Ceil | R2023a+ | Round toward positive infinity — use for ceiling rounding. |
| Conj | simulink/Quick Insert/Math Operations/Conj | R2023a+ | Compute the complex conjugate of the input — use in complex-signal math. |
| Cos | simulink/Quick Insert/Math Operations/Cos | R2023a+ | Compute the cosine of the input (radians) — use for trig and waveform generation. |
| Cos Cordic | simulink/Quick Insert/Math Operations/Cos Cordic | R2023a+ | Compute cosine using a CORDIC algorithm — use for efficient cos on fixed-point/embedded targets. |
| Cos+jSin | simulink/Quick Insert/Math Operations/Cos+jSin | R2023a+ | Generate the complex exponential cos(u)+j·sin(u) — use for complex tone or carrier generation. |
| Cosh | simulink/Quick Insert/Math Operations/Cosh | R2023a+ | Compute the hyperbolic cosine of the input. |
| Exp | simulink/Quick Insert/Math Operations/Exp | R2023a+ | Compute the exponential e^u of the input. |
| Fix | simulink/Quick Insert/Math Operations/Fix | R2023a+ | Round toward zero (truncate) — use for truncating rounding. |
| Floor | simulink/Quick Insert/Math Operations/Floor | R2023a+ | Round toward negative infinity — use for floor rounding. |
| Hermitian | simulink/Quick Insert/Math Operations/Hermitian | R2023a+ | Compute the complex-conjugate transpose of a matrix — use in linear-algebra signal processing. |
| Hypot | simulink/Quick Insert/Math Operations/Hypot | R2023a+ | Compute sqrt(u1^2 + u2^2) robustly — use for magnitude/hypotenuse without overflow. |
| Log | simulink/Quick Insert/Math Operations/Log | R2023a+ | Compute the natural logarithm of the input. |
| Log10 | simulink/Quick Insert/Math Operations/Log10 | R2023a+ | Compute the base-10 logarithm of the input. |
| Magnitude Squared | simulink/Quick Insert/Math Operations/Magnitude Squared | R2023a+ | Compute |u|^2 of a possibly complex input — use for power/energy without a square root. |
| Matrix Divide | simulink/Quick Insert/Math Operations/Matrix Divide | R2023a+ | Solve a matrix equation (left/right matrix division) — use for linear-system solves. |
| Max | simulink/Quick Insert/Math Operations/Max | R2023a+ | Output the maximum of the inputs — use for element-wise or port-wise max selection. |
| Max of Elements | simulink/Quick Insert/Math Operations/Max of Elements | R2023a+ | Output the maximum element of a vector/array — use to find the largest value in a signal. |
| Min | simulink/Quick Insert/Math Operations/Min | R2023a+ | Output the minimum of the inputs — use for element-wise or port-wise min selection. |
| Min of Elements | simulink/Quick Insert/Math Operations/Min of Elements | R2023a+ | Output the minimum element of a vector/array — use to find the smallest value in a signal. |
| Minus | simulink/Quick Insert/Math Operations/Minus | R2023a+ | Subtract the second input from the first — use for differences. |
| Mod | simulink/Quick Insert/Math Operations/Mod | R2023a+ | Compute the modulus/remainder after division — use for wrapping or periodic indexing. |
| Multiply | simulink/Quick Insert/Math Operations/Multiply | R2023a+ | Multiply the inputs — use for products and scaling. |
| Plus | simulink/Quick Insert/Math Operations/Plus | R2023a+ | Add the inputs — use for summing signals. |
| Power | simulink/Quick Insert/Math Operations/Power | R2023a+ | Raise the base input to a power — use for exponentiation u^n. |
| Power of 10 | simulink/Quick Insert/Math Operations/Power of 10 | R2023a+ | Compute 10^u — use for decade scaling. |
| Reciprocal | simulink/Quick Insert/Math Operations/Reciprocal | R2023a+ | Compute 1/u — use for inversion or division-by-input. |
| Reciprocal Square Root | simulink/Quick Insert/Math Operations/Reciprocal Square Root | R2023a+ | Compute 1/sqrt(u) — use for normalization such as inverse magnitude. |
| Rem | simulink/Quick Insert/Math Operations/Rem | R2023a+ | Compute the remainder after division (sign of the dividend) — use for remainder arithmetic. |
| Round | simulink/Quick Insert/Math Operations/Round | R2023a+ | Round to the nearest integer — use for standard rounding. |
| Signed Square Root | simulink/Quick Insert/Math Operations/Signed Square Root | R2023a+ | Compute sign(u)*sqrt(|u|) — use for signed square-root scaling. |
| Sin | simulink/Quick Insert/Math Operations/Sin | R2023a+ | Compute the sine of the input (radians) — use for trig and waveform generation. |
| Sin Cordic | simulink/Quick Insert/Math Operations/Sin Cordic | R2023a+ | Compute sine using a CORDIC algorithm — use for efficient sin on fixed-point/embedded targets. |
| SinCos | simulink/Quick Insert/Math Operations/SinCos | R2023a+ | Compute sine and cosine of the input together — use for efficient combined trig. |
| SinCos Cordic | simulink/Quick Insert/Math Operations/SinCos Cordic | R2023a+ | Compute sine and cosine using a CORDIC algorithm — use for efficient combined trig on embedded targets. |
| Sinh | simulink/Quick Insert/Math Operations/Sinh | R2023a+ | Compute the hyperbolic sine of the input. |
| Square Root | simulink/Quick Insert/Math Operations/Square Root | R2023a+ | Compute the square root of the input — use for magnitude or RMS-type math. |
| Tan | simulink/Quick Insert/Math Operations/Tan | R2023a+ | Compute the tangent of the input (radians). |
| Tanh | simulink/Quick Insert/Math Operations/Tanh | R2023a+ | Compute the hyperbolic tangent — use for smooth saturating nonlinearities. |
| ln | simulink/Quick Insert/Math Operations/ln | R2023a+ | Compute the natural logarithm of the input. |
| Vector
Concatenate | simulink/Signal
Routing/Vector
Concatenate | R2023a+ | Concatenate inputs into a single vector — use to combine signals along one dimension. |

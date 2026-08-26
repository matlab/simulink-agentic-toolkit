---
type: Simulink Block Category
title: Math operations
description: Arithmetic, algebraic, and elementary math operations for signal computation and transformation
tags: [gain, sum, product, sqrt, absolute value]
status: stable
source: mathworks_toolbox
library_root: Simulink
category_path: Math operations
block_count: 71
---

# Math operations

Use these blocks for math operations.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| MinMax Running Resettable | simulink/Math Operations/MinMax Running Resettable | R2023a+ | Use when tracking the running minimum or maximum of a signal over time with reset ability |
| Slider Gain | simulink/Math Operations/Slider Gain | R2023a+ | Use when interactively adjusting a gain value during simulation via a slider UI for parameter tuning |
| Abs | simulink/Math Operations/Abs | R2023a+ | Use when computing the absolute value of a signal to remove sign information or measure magnitude |
| Add | simulink/Math Operations/Add | R2023a+ | Use when summing two or more signals element-wise to combine contributions from multiple sources |
| Algebraic Constraint | simulink/Math Operations/Algebraic Constraint | R2023a+ | Use when solving implicit algebraic equations where the output must satisfy f(x) = 0 at each time step |
| Assignment | simulink/Math Operations/Assignment | R2023a+ | Use when replacing specific elements of a vector or matrix signal with new values at designated indices |
| Bias | simulink/Math Operations/Bias | R2023a+ | Use when adding a constant offset to a signal for level shifting or operating point adjustment |
| Complex to Magnitude-Angle | simulink/Math Operations/Complex to Magnitude-Angle | R2023a+ | Use when converting a complex signal into its polar representation of magnitude and phase angle |
| Complex to Real-Imag | simulink/Math Operations/Complex to Real-Imag | R2023a+ | Use when splitting a complex signal into separate real and imaginary component outputs |
| Divide | simulink/Math Operations/Divide | R2023a+ | Use when dividing one signal by another element-wise or computing the reciprocal of a signal |
| Dot Product | simulink/Math Operations/Dot Product | R2023a+ | Use when computing the inner product of two vectors to measure projection or correlation |
| Find Nonzero Elements | simulink/Math Operations/Find Nonzero Elements | R2023a+ | Use when locating the indices of nonzero entries in a vector or matrix signal |
| Gain | simulink/Math Operations/Gain | R2023a+ | Use when multiplying a signal by a constant scalar, vector, or matrix to apply scaling or unit conversion |
| Magnitude-Angle to Complex | simulink/Math Operations/Magnitude-Angle to Complex | R2023a+ | Use when constructing a complex signal from separate magnitude and phase angle inputs |
| Math Function | simulink/Math Operations/Math Function | R2023a+ | Use when applying common mathematical functions like exp, log, sqrt, power, or reciprocal to a signal |
| Matrix Concatenate | simulink/Math Operations/Matrix Concatenate | R2023a+ | Use when joining multiple matrix or vector signals along a specified dimension into a larger array |
| MinMax | simulink/Math Operations/MinMax | R2023a+ | Use when selecting the minimum or maximum value among multiple input signals element-wise |
| Permute Dimensions | simulink/Math Operations/Permute Dimensions | R2023a+ | Use when rearranging the dimensions of a multidimensional signal to match downstream requirements |
| Polynomial | simulink/Math Operations/Polynomial | R2023a+ | Use when evaluating a polynomial expression with specified coefficients at each input value |
| Product | simulink/Math Operations/Product | R2023a+ | Use when multiplying or dividing two or more signals element-wise or performing matrix multiplication |
| Product of Elements | simulink/Math Operations/Product of Elements | R2023a+ | Use when computing the product of all elements in a vector to reduce it to a scalar |
| Real-Imag to Complex | simulink/Math Operations/Real-Imag to Complex | R2023a+ | Use when combining separate real and imaginary parts into a single complex-valued signal |
| Reciprocal Sqrt | simulink/Math Operations/Reciprocal Sqrt | R2023a+ | Use when computing 1/sqrt(x) efficiently for normalization or inverse distance calculations |
| Reshape | simulink/Math Operations/Reshape | R2023a+ | Use when changing the dimensions of a signal without altering its data for interface compatibility |
| Rounding Function | simulink/Math Operations/Rounding Function | R2023a+ | Use when rounding a signal to the nearest integer using floor, ceil, round, or fix methods |
| Sign | simulink/Math Operations/Sign | R2023a+ | Use when extracting the sign of a signal as +1, 0, or -1 for direction detection or signum-based control |
| Signed Sqrt | simulink/Math Operations/Signed Sqrt | R2023a+ | Use when computing the square root while preserving the sign of the input |
| Sine Wave Function | simulink/Math Operations/Sine Wave Function | R2023a+ | Use when generating a continuous sinusoidal signal as a math operation rather than a source block |
| Sqrt | simulink/Math Operations/Sqrt | R2023a+ | Use when computing the square root of a signal for distance calculations or RMS computation |
| Squeeze | simulink/Math Operations/Squeeze | R2023a+ | Use when removing singleton dimensions from a multidimensional signal to simplify downstream processing |
| Subtract | simulink/Math Operations/Subtract | R2023a+ | Use when computing the difference between two signals for error calculation or comparison |
| Sum | simulink/Math Operations/Sum | R2023a+ | Use when adding or subtracting multiple signals with configurable sign list to form error or combined outputs |
| Sum of Elements | simulink/Math Operations/Sum of Elements | R2023a+ | Use when summing all elements of a vector signal into a single scalar output |
| Trigonometric Function | simulink/Math Operations/Trigonometric Function | R2023a+ | Use when computing trigonometric functions like sin, cos, tan, or their inverses on a signal |
| Unary Minus | simulink/Math Operations/Unary Minus | R2023a+ | Use when negating a signal to reverse its polarity or compute the additive inverse |
| Vector Concatenate | simulink/Math Operations/Vector Concatenate | R2023a+ | Use when joining multiple scalar or vector signals end-to-end into a single longer vector |
| Weighted Sample Time Math | simulink/Math Operations/Weighted Sample Time Math | R2023a+ | Use when performing arithmetic weighted by the sample time for discrete derivative or integral scaling |
| Cross Product | simulink/Matrix Operations/Cross Product | R2023a+ |  |
| Matrix Concatenate | simulink/Matrix Operations/Matrix Concatenate | R2023a+ | Use when joining multiple matrix or vector signals along a specified dimension into a larger array |
| Matrix Multiply | simulink/Matrix Operations/Matrix Multiply | R2023a+ | Use when performing matrix multiplication of two compatible matrix signals |
| Add Constant | simulink/Quick Insert/Math Operations/Add Constant | R2023a+ | Use when adding a fixed bias value to a signal as a streamlined alternative to Sum plus Constant |
| Ceil | simulink/Quick Insert/Math Operations/Ceil | R2023a+ | Use when rounding a signal upward to the nearest integer for quantization or index computation |
| Conj | simulink/Quick Insert/Math Operations/Conj | R2023a+ | Use when computing the complex conjugate of a signal for correlation or spectral operations |
| Exp | simulink/Quick Insert/Math Operations/Exp | R2023a+ | Use when computing the exponential e^x for growth models or exponential transformations |
| Fix | simulink/Quick Insert/Math Operations/Fix | R2023a+ | Use when rounding toward zero to truncate fractional parts for integer conversion |
| Floor | simulink/Quick Insert/Math Operations/Floor | R2023a+ | Use when rounding a signal downward to the nearest integer for bin assignment or quantization |
| Hermitian | simulink/Quick Insert/Math Operations/Hermitian | R2023a+ | Use when computing the conjugate transpose of a complex matrix signal |
| Hypot | simulink/Quick Insert/Math Operations/Hypot | R2023a+ | Use when computing sqrt(x^2 + y^2) with improved numerical accuracy for Euclidean distance |
| Log | simulink/Quick Insert/Math Operations/Log | R2023a+ | Use when computing the natural logarithm for logarithmic compression or inverse exponential operations |
| Log10 | simulink/Quick Insert/Math Operations/Log10 | R2023a+ | Use when computing the base-10 logarithm for decibel calculations or logarithmic scaling |
| Magnitude Squared | simulink/Quick Insert/Math Operations/Magnitude Squared | R2023a+ | Use when computing |x|^2 for power calculations without the cost of a square root |
| Matrix Divide | simulink/Quick Insert/Math Operations/Matrix Divide | R2023a+ | Use when solving linear systems A*x = B or computing matrix left/right division |
| Matrix Multiply | simulink/Quick Insert/Math Operations/Matrix Multiply | R2023a+ | Use when performing matrix multiplication of two compatible matrix signals |
| Max | simulink/Quick Insert/Math Operations/Max | R2023a+ | Use when selecting the larger of two input signals element-wise for upper-bound enforcement |
| Max of Elements | simulink/Quick Insert/Math Operations/Max of Elements | R2023a+ | Use when finding the maximum element within a single vector or matrix signal |
| Min | simulink/Quick Insert/Math Operations/Min | R2023a+ | Use when selecting the smaller of two input signals element-wise for lower-bound enforcement |
| Min of Elements | simulink/Quick Insert/Math Operations/Min of Elements | R2023a+ | Use when finding the minimum element within a single vector or matrix signal |
| Minus | simulink/Quick Insert/Math Operations/Minus | R2023a+ | Use when subtracting one signal from another as a streamlined difference operation |
| Mod | simulink/Quick Insert/Math Operations/Mod | R2023a+ | Use when computing the modulus after division for wrapping angles or cyclic indexing |
| Multiply | simulink/Quick Insert/Math Operations/Multiply | R2023a+ | Use when multiplying a signal by a constant gain value using an element-wise multiply variant |
| Plus | simulink/Quick Insert/Math Operations/Plus | R2023a+ | Use when adding two signals together as a streamlined summation operation |
| Power | simulink/Quick Insert/Math Operations/Power | R2023a+ | Use when raising a signal to a specified power exponent for nonlinear transformations |
| Power of 10 | simulink/Quick Insert/Math Operations/Power of 10 | R2023a+ | Use when computing 10^x for decibel-to-linear conversions or logarithmic scale transformations |
| Reciprocal | simulink/Quick Insert/Math Operations/Reciprocal | R2023a+ | Use when computing the element-wise inverse 1/x of a signal |
| Reciprocal Square Root | simulink/Quick Insert/Math Operations/Reciprocal Square Root | R2023a+ | Use when computing 1/sqrt(x) as a dedicated block variant for normalization operations |
| Rem | simulink/Quick Insert/Math Operations/Rem | R2023a+ | Use when computing the remainder after division following MATLAB rem semantics |
| Round | simulink/Quick Insert/Math Operations/Round | R2023a+ | Use when rounding to the nearest integer using standard rounding rules |
| Signed Square Root | simulink/Quick Insert/Math Operations/Signed Square Root | R2023a+ | Use when computing sign-preserving square root as a dedicated block variant |
| Square | simulink/Quick Insert/Math Operations/Square | R2023a+ | Use when computing x^2 element-wise for power or energy calculations |
| Square Root | simulink/Quick Insert/Math Operations/Square Root | R2023a+ | Use when computing sqrt(x) as a dedicated block variant for magnitude or distance calculations |
| ln | simulink/Quick Insert/Math Operations/ln | R2023a+ | Use when computing the natural logarithm as a dedicated ln block variant |

---
type: Simulink Block Category
title: Logic math
description: Logic comparison and math operations
tags: [compare, logical, relational, math, gain, add]
status: stable
source: mathworks_toolbox
library_root: Simulink Coder Support Package for ARM Cortex-based VEX Microcontroller
category_path: Logic math
block_count: 25
---

# Logic math

Use these blocks for logic math.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Compare To Constant | vexarmcortexlib/Logical Operations Library/Compare To Constant | R2023a+ | Compare signal to a constant value — use for threshold-based decisions in robot logic |
| Compare To Zero | vexarmcortexlib/Logical Operations Library/Compare To Zero | R2023a+ | Compare signal to zero — use for detecting zero-crossings or sign changes |
| Logical Operator | vexarmcortexlib/Logical Operations Library/Logical Operator | R2023a+ | Perform AND/OR/NOT logic — use for combining boolean conditions in robot decision logic |
| Logical Operator1 | vexarmcortexlib/Logical Operations Library/Logical Operator1 | R2023a+ | Additional logic gate — use for OR operations in robot decision logic |
| Relational Operator | vexarmcortexlib/Logical Operations Library/Relational Operator | R2023a+ | Compare two signals with relational operators — use for condition checking between sensor values |
| Abs | vexarmcortexlib/Math Library/Abs | R2023a+ | Compute absolute value — use for getting magnitude regardless of sign |
| Add | vexarmcortexlib/Math Library/Add | R2023a+ | Add two or more signals — use for summing sensor inputs or control terms |
| Bias | vexarmcortexlib/Math Library/Bias | R2023a+ | Add a constant offset to a signal — use for calibrating sensor zero points |
| Divide | vexarmcortexlib/Math Library/Divide | R2023a+ | Divide two signals — use for ratio computation or normalization |
| Gain | vexarmcortexlib/Math Library/Gain | R2023a+ | Multiply signal by a constant — use for scaling sensor readings or control outputs |
| Math Function | vexarmcortexlib/Math Library/Math Function | R2023a+ | Apply mathematical function — use for exp, log, power, or modulus operations |
| MinMax | vexarmcortexlib/Math Library/MinMax | R2023a+ | Find minimum or maximum of inputs — use for clamping or selecting extreme values |
| MinMax Running Resettable | vexarmcortexlib/Math Library/MinMax Running Resettable | R2023a+ | Track running min/max with reset — use for peak detection over time windows |
| Polynomial | vexarmcortexlib/Math Library/Polynomial | R2023a+ | Evaluate polynomial — use for nonlinear sensor calibration curves |
| Product | vexarmcortexlib/Math Library/Product | R2023a+ | Multiply two or more signals — use for combining gains or computing power |
| Reciprocal Sqrt | vexarmcortexlib/Math Library/Reciprocal Sqrt | R2023a+ | Compute 1/sqrt of signal — use for normalization operations |
| Rounding Function | vexarmcortexlib/Math Library/Rounding Function | R2023a+ | Round signal to nearest integer — use for converting to discrete values |
| Sign | vexarmcortexlib/Math Library/Sign | R2023a+ | Extract sign of signal — use for direction detection in motor control |
| Signed Sqrt | vexarmcortexlib/Math Library/Signed Sqrt | R2023a+ | Compute signed square root — use for sign-preserving root operations |
| Sine Wave Function | vexarmcortexlib/Math Library/Sine Wave Function | R2023a+ | Generate sine wave signal — use for periodic test stimuli |
| Slider Gain | vexarmcortexlib/Math Library/Slider Gain | R2023a+ | Interactive gain adjustment — use for tuning control parameters during simulation |
| Sqrt | vexarmcortexlib/Math Library/Sqrt | R2023a+ | Compute square root — use for distance or magnitude calculations |
| Subtract | vexarmcortexlib/Math Library/Subtract | R2023a+ | Subtract signals — use for computing error signals in control loops |
| Trigonometric Function | vexarmcortexlib/Math Library/Trigonometric Function | R2023a+ | Compute trig functions — use for angle calculations in robot navigation |
| Unary Minus | vexarmcortexlib/Math Library/Unary Minus | R2023a+ | Negate a signal — use for reversing motor direction or sign inversion |

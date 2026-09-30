---
type: Simulink Block Category
title: Logic bit
description: Logical, relational, and bit operations
tags: [logic and bit, logical, relational, combinatorial, shift]
status: stable
source: custom_library
library_root: DO-178C/DO-331 Primitive Library
category_path: Logic bit
block_count: 18
---

# Logic bit

Use these blocks for logic bit.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Bitwise Operator | do178Lib/Simulink/Logic and Bit Operations/Bitwise Operator | R2023a+ | Perform the specified bitwise operation on the inputs. The output data type should represent zero exactly. |
| Combinatorial  Logic | do178Lib/Simulink/Logic and Bit Operations/Combinatorial  Logic | R2023a+ | Map inputs to outputs via a truth table — use to implement combinational logic or state-machine output tables. |
| Logical Operator | do178Lib/Simulink/Logic and Bit Operations/Logical Operator | R2023a+ | Apply a logical operation (AND/OR/NOT/XOR/…) to boolean inputs — use for boolean decision logic. |
| Relational Operator | do178Lib/Simulink/Logic and Bit Operations/Relational Operator | R2023a+ | Compare two inputs (==, <, >, …) and output a boolean — use to build conditions and thresholds. |
| Shift Arithmetic | do178Lib/Simulink/Logic and Bit Operations/Shift Arithmetic | R2023a+ | Shift bits or the binary point of a signal — use for fast multiply/divide by powers of two or fixed-point rescaling. |
| Bit Clear | do178Lib/Simulink/Logic and Bit Operations/Bit Clear | R2023a+ | Clear ith bit of the stored integer to 0. Scaling is ignored. |
| Bit Set | do178Lib/Simulink/Logic and Bit Operations/Bit Set | R2023a+ | Set ith bit of the stored integer to 1. Scaling is ignored. |
| Compare To Constant | do178Lib/Simulink/Logic and Bit Operations/Compare To Constant | R2023a+ | Determine how a signal compares to a constant. |
| Compare To Zero | do178Lib/Simulink/Logic and Bit Operations/Compare To Zero | R2023a+ | Determine how a signal compares to zero. |
| Detect Change | do178Lib/Simulink/Logic and Bit Operations/Detect Change | R2023a+ | If the input does not equal its previous value, then output TRUE, otherwise output FALSE. The initial condition determines the initial value of the previous input U/z. |
| Detect Decrease | do178Lib/Simulink/Logic and Bit Operations/Detect Decrease | R2023a+ | If the input is strictly less than its previous value, then output TRUE, otherwise output FALSE. The initial condition determines the initial value of the previous input U/z. |
| Detect Fall Negative | do178Lib/Simulink/Logic and Bit Operations/Detect Fall Negative | R2023a+ | If the input is strictly negative and its previous value was nonnegative, then output TRUE, otherwise output FALSE. The initial condition determines the initial value of the boolean expression (U/z < 0). |
| Detect Fall Nonpositive | do178Lib/Simulink/Logic and Bit Operations/Detect Fall Nonpositive | R2023a+ | If the input is nonpositive and its previous value was strictly positive, then output TRUE, otherwise output FALSE. The initial condition determines the initial value of the boolean expression (U/z <= 0). |
| Detect Increase | do178Lib/Simulink/Logic and Bit Operations/Detect Increase | R2023a+ | If the input is strictly greater than its previous value, then output TRUE, otherwise output FALSE. The initial condition determines the initial value of the previous input U/z. |
| Detect Rise Nonnegative | do178Lib/Simulink/Logic and Bit Operations/Detect Rise Nonnegative | R2023a+ | If the input is nonnegative and its previous value was strictly negative, then output TRUE, otherwise output FALSE. The initial condition determines the initial value of the boolean expression (U/z >= 0). |
| Detect Rise Positive | do178Lib/Simulink/Logic and Bit Operations/Detect Rise Positive | R2023a+ | If the input is strictly positive and its previous value was nonpositive, then output TRUE, otherwise output FALSE. The initial condition determines the initial value of the boolean expression (U/z > 0). |
| Interval Test | do178Lib/Simulink/Logic and Bit Operations/Interval Test | R2023a+ | If the input is in the interval between the lower limit and the upper limit, then the output is TRUE, otherwise it is FALSE. |
| Interval Test Dynamic | do178Lib/Simulink/Logic and Bit Operations/Interval Test Dynamic | R2023a+ | If the input is in the interval between the lower limit and the upper limit, then the output is TRUE, otherwise it is FALSE. |

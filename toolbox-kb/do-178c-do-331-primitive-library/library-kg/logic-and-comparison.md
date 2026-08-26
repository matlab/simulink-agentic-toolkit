---
type: Simulink Block Category
title: Logic and comparison
description: Boolean logic, relational comparisons, bit operations, and edge detection
tags: [logic, compare, detect, bitwise, relational]
status: stable
source: mathworks_toolbox
library_root: DO-178C/DO-331 Primitive Library
category_path: Logic and comparison
block_count: 18
---

# Logic and comparison

Use these blocks for logic and comparison.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Bit Clear | do178Lib/Simulink/Logic and Bit Operations/Bit Clear | R2023a+ | Clear a specific bit in an integer signal — use for flag manipulation, register programming, or clearing status bits in avionics data words |
| Bit Set | do178Lib/Simulink/Logic and Bit Operations/Bit Set | R2023a+ | Set a specific bit in an integer signal — use for flag activation, register programming, or asserting status bits in avionics data words |
| Compare To Constant | do178Lib/Simulink/Logic and Bit Operations/Compare To Constant | R2023a+ | Test whether a signal is equal to, greater than, or less than a specified constant — use for threshold detection, limit checking, or generating Boolean flags from analog signals |
| Compare To Zero | do178Lib/Simulink/Logic and Bit Operations/Compare To Zero | R2023a+ | Test whether a signal is positive, negative, zero, or nonzero — use for sign detection, zero-crossing logic, or validity checking in certified algorithms |
| Detect Change | do178Lib/Simulink/Logic and Bit Operations/Detect Change | R2023a+ | Output true when the input value differs from its previous sample — use for event detection, state transition triggering, or identifying discrete command updates |
| Detect Decrease | do178Lib/Simulink/Logic and Bit Operations/Detect Decrease | R2023a+ | Output true when the input decreases from its previous sample — use for detecting falling parameters, countdown completion, or decreasing-trend events |
| Detect Fall Negative | do178Lib/Simulink/Logic and Bit Operations/Detect Fall Negative | R2023a+ | Output true when the input transitions from non-negative to negative — use for zero-crossing detection, sign-change events, or detecting entry into a negative regime |
| Detect Fall Nonpositive | do178Lib/Simulink/Logic and Bit Operations/Detect Fall Nonpositive | R2023a+ | Output true when the input transitions from positive to non-positive — use for detecting the moment a signal drops to zero or below |
| Detect Increase | do178Lib/Simulink/Logic and Bit Operations/Detect Increase | R2023a+ | Output true when the input increases from its previous sample — use for detecting rising parameters, ramp-up events, or increasing-trend triggers |
| Detect Rise Nonnegative | do178Lib/Simulink/Logic and Bit Operations/Detect Rise Nonnegative | R2023a+ | Output true when the input transitions from negative to non-negative — use for zero-crossing detection from below or recovery-from-negative events |
| Detect Rise Positive | do178Lib/Simulink/Logic and Bit Operations/Detect Rise Positive | R2023a+ | Output true when the input transitions from non-positive to positive — use for detecting the moment a signal first becomes positive |
| Interval Test | do178Lib/Simulink/Logic and Bit Operations/Interval Test | R2023a+ | Test whether a signal falls within a fixed interval — use for range checking, validity windows, or generating in-band/out-of-band Boolean flags |
| Interval Test Dynamic | do178Lib/Simulink/Logic and Bit Operations/Interval Test Dynamic | R2023a+ | Test whether a signal falls within a dynamically varying interval — use when the valid range changes at runtime based on flight phase or operating mode |
| Bitwise Operator | do178Lib/Simulink/Logic and Bit Operations/Bitwise Operator | R2023a+ | Perform AND, OR, XOR, or NOT operations on integer signals at the bit level — use for masking, packing, or protocol decoding in certified embedded software |
| Combinatorial  Logic | do178Lib/Simulink/Logic and Bit Operations/Combinatorial  Logic | R2023a+ | Implement a truth table mapping input combinations to outputs — use for encoding discrete logic decisions, mode selection tables, or Boolean function lookup |
| Logical Operator | do178Lib/Simulink/Logic and Bit Operations/Logical Operator | R2023a+ | Perform AND, OR, NOT, NAND, NOR, or XOR on Boolean signals — use for combining conditions, implementing enable logic, or voting schemes in certified avionics |
| Relational Operator | do178Lib/Simulink/Logic and Bit Operations/Relational Operator | R2023a+ | Compare two signals using ==, ~=, <, >, <=, >= — use for threshold comparisons, guard conditions, or generating Boolean control signals from continuous quantities |
| Shift Arithmetic | do178Lib/Simulink/Logic and Bit Operations/Shift Arithmetic | R2023a+ | Shift integer bits left or right — use for efficient multiply/divide by powers of two, fixed-point scaling, or protocol bit-field extraction |

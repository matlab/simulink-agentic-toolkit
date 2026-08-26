---
type: Simulink Block Category
title: Logic and bit operations
description: Bit manipulation, boolean logic, comparisons, and edge detection for HDL
tags: [bitwise, logic, comparison, shift, detect]
status: stable
source: mathworks_toolbox
library_root: HDL Coder
category_path: Logic and bit operations
block_count: 29
---

# Logic and bit operations

Use these blocks for logic and bit operations.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Bit Concat | hdlsllib/Logic and Bit Operations/Bit Concat | R2023a+ | Use when you need to concatenate multiple signals at the bit level into a wider word |
| Bit Reduce | hdlsllib/Logic and Bit Operations/Bit Reduce | R2023a+ | Use when you need to reduce all bits of a word using AND, OR, or XOR operations |
| Bit Rotate | hdlsllib/Logic and Bit Operations/Bit Rotate | R2023a+ | Use when you need to circularly shift the bits of a signal left or right |
| Bit Shift | hdlsllib/Logic and Bit Operations/Bit Shift | R2023a+ | Use when you need to shift bits left or right, filling with zeros |
| Bit Slice | hdlsllib/Logic and Bit Operations/Bit Slice | R2023a+ | Use when you need to extract a contiguous range of bits from a wider signal |
| Bits to Word | hdlsllib/Logic and Bit Operations/Bits to Word | R2023a+ | Use when you need to assemble individual bit inputs into a multi-bit word signal |
| Compare To Constant | hdlsllib/Logic and Bit Operations/Compare To Constant | R2023a+ | Use when you need to compare a signal against a fixed constant and output a boolean result |
| Compare To Zero | hdlsllib/Logic and Bit Operations/Compare To Zero | R2023a+ | Use when you need to check if a signal is equal to, greater than, or less than zero |
| Detect Fall Negative | hdlsllib/Logic and Bit Operations/Detect Fall Negative | R2023a+ | Use when you need to detect a signal transition from non-negative to strictly negative |
| Detect Fall Nonpositive | hdlsllib/Logic and Bit Operations/Detect Fall Nonpositive | R2023a+ | Use when you need to detect a signal transition from positive to non-positive |
| Detect Rise Nonnegative | hdlsllib/Logic and Bit Operations/Detect Rise Nonnegative | R2023a+ | Use when you need to detect a signal transition from negative to non-negative |
| Detect Rise Positive | hdlsllib/Logic and Bit Operations/Detect Rise Positive | R2023a+ | Use when you need to detect a signal transition from non-positive to strictly positive |
| Interval Test | hdlsllib/Logic and Bit Operations/Interval Test | R2023a+ | Use when you need to check if a signal falls within a specified constant range |
| Word to Bits | hdlsllib/Logic and Bit Operations/Word to Bits | R2023a+ | Use when you need to decompose a multi-bit word into individual bit outputs |
| Relational Operator | hdlsllib/HDL Floating Point Operations/Relational Operator | R2023a+ | Use when you need to compare two signals and produce a boolean output |
| Bit Clear | hdlsllib/Logic and Bit Operations/Bit Clear | R2023a+ | Use when you need to clear a specific bit position in a fixed-point or integer signal |
| Bit Set | hdlsllib/Logic and Bit Operations/Bit Set | R2023a+ | Use when you need to set a specific bit position to one in a fixed-point or integer signal |
| Bit to Integer Converter | hdlsllib/Logic and Bit Operations/Bit to Integer Converter | R2023a+ | Use when you need to pack a vector of individual bit signals into a single integer word |
| Bitwise Operator | hdlsllib/Logic and Bit Operations/Bitwise Operator | R2023a+ | Use when you need to apply AND, OR, XOR, or NOT across bits of one or more signals |
| Detect Change | hdlsllib/Logic and Bit Operations/Detect Change | R2023a+ | Use when you need to detect any change in signal value between consecutive samples |
| Detect Decrease | hdlsllib/Logic and Bit Operations/Detect Decrease | R2023a+ | Use when you need to identify when a signal value decreases from one sample to the next |
| Detect Increase | hdlsllib/Logic and Bit Operations/Detect Increase | R2023a+ | Use when you need to identify when a signal value increases from one sample to the next |
| Extract Bits | hdlsllib/Logic and Bit Operations/Extract Bits | R2023a+ | Use when you need to select specific bits from an integer or fixed-point signal |
| Integer to Bit Converter | hdlsllib/Logic and Bit Operations/Integer to Bit Converter | R2023a+ | Use when you need to unpack an integer word into a vector of individual bit signals |
| Interval Test Dynamic | hdlsllib/Logic and Bit Operations/Interval Test Dynamic | R2023a+ | Use when you need to check if a signal falls within a dynamically specified range |
| Logical Operator | hdlsllib/Logic and Bit Operations/Logical Operator | R2023a+ | Use when you need boolean AND, OR, NAND, NOR, XOR, or NOT operations on logic signals |
| Relational Operator | hdlsllib/Logic and Bit Operations/Relational Operator | R2023a+ | Use when you need to compare two signals and produce a boolean output |
| Shift Arithmetic | hdlsllib/Logic and Bit Operations/Shift Arithmetic | R2023a+ | Use when you need arithmetic bit shifting that preserves the sign of fixed-point signals |
| HDL Combinatorial Logic | hdlsllib/RCP and HIL/HDL Combinatorial Logic | R2023a+ | Use when you need to implement a truth table as combinational logic for HDL |

---
type: Simulink Block Category
title: Logic and bit operations
description: Boolean logic, relational comparison, bitwise manipulation, and signal change detection blocks
tags: [AND, OR, compare, relational, bitwise]
status: stable
source: mathworks_toolbox
library_root: Simulink
category_path: Logic and bit operations
block_count: 29
---

# Logic and bit operations

Use these blocks for logic and bit operations.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Bit Clear | simulink/Logic and Bit Operations/Bit Clear | R2023a+ | Use when clearing specific bits in an integer signal for masking or flag manipulation |
| Bit Set | simulink/Logic and Bit Operations/Bit Set | R2023a+ | Use when setting specific bits in an integer signal for flag activation or register configuration |
| Compare To Constant | simulink/Logic and Bit Operations/Compare To Constant | R2023a+ | Use when testing whether a signal is greater than, less than, or equal to a fixed threshold |
| Compare To Zero | simulink/Logic and Bit Operations/Compare To Zero | R2023a+ | Use when testing whether a signal is positive, negative, zero, or nonzero for condition detection |
| Detect Change | simulink/Logic and Bit Operations/Detect Change | R2023a+ | Use when detecting any change in a signal value between consecutive time steps for event triggering |
| Detect Decrease | simulink/Logic and Bit Operations/Detect Decrease | R2023a+ | Use when detecting when a signal value decreases from one time step to the next |
| Detect Fall Negative | simulink/Logic and Bit Operations/Detect Fall Negative | R2023a+ | Use when detecting the instant a signal crosses from nonnegative to strictly negative |
| Detect Fall Nonpositive | simulink/Logic and Bit Operations/Detect Fall Nonpositive | R2023a+ | Use when detecting the instant a signal crosses from positive to nonpositive |
| Detect Increase | simulink/Logic and Bit Operations/Detect Increase | R2023a+ | Use when detecting when a signal value increases from one time step to the next |
| Detect Rise Nonnegative | simulink/Logic and Bit Operations/Detect Rise Nonnegative | R2023a+ | Use when detecting the instant a signal crosses from negative to nonnegative |
| Detect Rise Positive | simulink/Logic and Bit Operations/Detect Rise Positive | R2023a+ | Use when detecting the instant a signal crosses from nonpositive to strictly positive |
| Extract Bits | simulink/Logic and Bit Operations/Extract Bits | R2023a+ | Use when extracting a contiguous range of bits from an integer signal for bitfield decoding |
| Interval Test | simulink/Logic and Bit Operations/Interval Test | R2023a+ | Use when checking whether a signal falls within a fixed lower and upper bound range |
| Interval Test Dynamic | simulink/Logic and Bit Operations/Interval Test Dynamic | R2023a+ | Use when checking whether a signal falls within dynamically specified lower and upper bounds |
| Bit to Integer Converter | simulink/Logic and Bit Operations/Bit to Integer Converter | R2023a+ | Use when converting a vector of individual bits into a packed integer word |
| Bitwise Operator | simulink/Logic and Bit Operations/Bitwise Operator | R2023a+ | Use when performing bitwise AND, OR, XOR, or NOT on integer signals |
| Combinatorial  Logic | simulink/Logic and Bit Operations/Combinatorial  Logic | R2023a+ | Use when implementing a truth table that maps binary input combinations to specified outputs |
| Float Extract Bits | simulink/Logic and Bit Operations/Float Extract Bits | R2023a+ | Use when extracting the sign, exponent, or mantissa fields from a floating-point number |
| Integer to Bit Converter | simulink/Logic and Bit Operations/Integer to Bit Converter | R2023a+ | Use when unpacking an integer word into a vector of individual bit signals |
| Logical Operator | simulink/Logic and Bit Operations/Logical Operator | R2023a+ | Use when performing Boolean AND, OR, NOT, NAND, NOR, XOR, or NXOR operations on logical signals |
| Relational Operator | simulink/Logic and Bit Operations/Relational Operator | R2023a+ | Use when comparing two signals with operators like equal, not-equal, greater-than, or less-than |
| Shift Arithmetic | simulink/Logic and Bit Operations/Shift Arithmetic | R2023a+ | Use when shifting integer bits left or right for multiplication/division by powers of two |
| Bitwise AND | simulink/Quick Insert/Logic and Bit Operations/Bitwise AND | R2023a+ |  |
| Bitwise NAND | simulink/Quick Insert/Logic and Bit Operations/Bitwise NAND | R2023a+ |  |
| Bitwise NOR | simulink/Quick Insert/Logic and Bit Operations/Bitwise NOR | R2023a+ |  |
| Bitwise NOT | simulink/Quick Insert/Logic and Bit Operations/Bitwise NOT | R2023a+ |  |
| Bitwise OR | simulink/Quick Insert/Logic and Bit Operations/Bitwise OR | R2023a+ |  |
| Bitwise XOR | simulink/Quick Insert/Logic and Bit Operations/Bitwise XOR | R2023a+ |  |
| String Compare | simulink/String/String Compare | R2023a+ |  |

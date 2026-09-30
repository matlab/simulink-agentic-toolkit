---
type: Simulink Block Category
title: Logic bit
description: Logical, relational, and bit-level operations
tags: [logic, bit, relational, detect, shift, bitwise]
status: stable
source: custom_library
library_root: HDL Coder
category_path: Logic bit
block_count: 31
---

# Logic bit

Use these blocks for logic bit.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Logical
Operator | hdlsllib/Commonly
Used Blocks/Logical
Operator | R2023a+ | Apply a logical operation (AND, OR, NOT, XOR, …) to boolean inputs — use for combining conditions. |
| Relational
Operator | hdlsllib/Commonly
Used Blocks/Relational
Operator | R2023a+ | Compare two inputs (>, <, ==, …) and output a boolean — use for threshold and comparison logic. |
| Relational Operator | hdlsllib/HDL Floating Point Operations/Relational Operator | R2023a+ | Compare two inputs (>, <, ==, …) and output a boolean — use for threshold and comparison logic. |
| Bit Clear | hdlsllib/Logic and Bit Operations/Bit Clear | R2023a+ | Force a specified bit of an integer to 0 — use for bit-level masking or flag clearing. |
| Bit Set | hdlsllib/Logic and Bit Operations/Bit Set | R2023a+ | Force a specified bit of an integer to 1 — use for bit-level flag setting. |
| Bit to Integer Converter | hdlsllib/Logic and Bit Operations/Bit to Integer Converter | R2024b+ | Pack a group of bits into an integer — use to assemble bit streams into words. |
| Bitwise Operator | hdlsllib/Logic and Bit Operations/Bitwise Operator | R2023a+ | Apply a bitwise AND/OR/XOR/NOT with optional mask — use for bit manipulation of integer signals. |
| Detect Change | hdlsllib/Logic and Bit Operations/Detect Change | R2023a+ | Output true when the input value changes between samples — use for change/edge detection. |
| Detect Decrease | hdlsllib/Logic and Bit Operations/Detect Decrease | R2023a+ | Output true when the input decreases from the previous sample — use for falling-value detection. |
| Detect Increase | hdlsllib/Logic and Bit Operations/Detect Increase | R2023a+ | Output true when the input increases from the previous sample — use for rising-value detection. |
| Extract Bits | hdlsllib/Logic and Bit Operations/Extract Bits | R2023a+ | Extract a contiguous range of bits from an integer — use to isolate a bit field. |
| Integer to Bit Converter | hdlsllib/Logic and Bit Operations/Integer to Bit Converter | R2024b+ | Unpack an integer into its constituent bits — use to expand words into bit streams. |
| Interval Test Dynamic | hdlsllib/Logic and Bit Operations/Interval Test Dynamic | R2023a+ | Output true when the input lies within runtime lower/upper limits — use for adjustable range testing. |
| Logical Operator | hdlsllib/Logic and Bit Operations/Logical Operator | R2023a+ | Apply a logical operation (AND, OR, NOT, XOR, …) to boolean inputs — use for combining conditions. |
| Relational Operator | hdlsllib/Logic and Bit Operations/Relational Operator | R2023a+ | Compare two inputs (>, <, ==, …) and output a boolean — use for threshold and comparison logic. |
| Shift Arithmetic | hdlsllib/Logic and Bit Operations/Shift Arithmetic | R2023a+ | Arithmetic/logical shift of bits or the binary point — use for scaling by powers of two or bit shifts. |
| Bit Concat | hdlsllib/Logic and Bit Operations/Bit Concat | R2023a+ | Concatenate the input words. For scalar inputs, two or more input signals should be connected to the block. For vector inputs, at least one input should be connected to the block. The left-right ordering of words in the output follows the ordering of input signals. The L input is the lowest-order word and the H input is the highest order word. |
| Bit Reduce | hdlsllib/Logic and Bit Operations/Bit Reduce | R2023a+ | Perform a bitwise AND, OR, or XOR reduction of the input signal, as specified by the Reduction Mode parameter. |
| Bit Rotate | hdlsllib/Logic and Bit Operations/Bit Rotate | R2023a+ | Rotate the input signal left or right as specified by the Rotate Mode parameter. The Rotate Length specifies the number of bits to be rotated. |
| Bit Slice | hdlsllib/Logic and Bit Operations/Bit Slice | R2023a+ | Return a consecutive field of bits from the input signal. The field is indexed (0-based relative to LSB) by the LSB Position and MSB Position. |
| Bits to Word | hdlsllib/Logic and Bit Operations/Bits to Word | R2023a+ | Convert input vector of N 1-bit values to N-bit integer. |
| Compare To Constant | hdlsllib/Logic and Bit Operations/Compare To Constant | R2023a+ | Determine how a signal compares to a constant. |
| Compare To Zero | hdlsllib/Logic and Bit Operations/Compare To Zero | R2023a+ | Determine how a signal compares to zero. |
| Detect Fall Negative | hdlsllib/Logic and Bit Operations/Detect Fall Negative | R2023a+ | If the input is strictly negative and its previous value was nonnegative, then output TRUE, otherwise output FALSE. The initial condition determines the initial value of the boolean expression (U/z < 0). |
| Detect Fall Nonpositive | hdlsllib/Logic and Bit Operations/Detect Fall Nonpositive | R2023a+ | If the input is nonpositive and its previous value was strictly positive, then output TRUE, otherwise output FALSE. The initial condition determines the initial value of the boolean expression (U/z <= 0). |
| Detect Rise Nonnegative | hdlsllib/Logic and Bit Operations/Detect Rise Nonnegative | R2023a+ | If the input is nonnegative and its previous value was strictly negative, then output TRUE, otherwise output FALSE. The initial condition determines the initial value of the boolean expression (U/z >= 0). |
| Detect Rise Positive | hdlsllib/Logic and Bit Operations/Detect Rise Positive | R2023a+ | If the input is strictly positive and its previous value was nonpositive, then output TRUE, otherwise output FALSE. The initial condition determines the initial value of the boolean expression (U/z > 0). |
| Interval Test | hdlsllib/Logic and Bit Operations/Interval Test | R2023a+ | If the input is in the interval between the lower limit and the upper limit, then the output is TRUE, otherwise it is FALSE. |
| Word to Bits | hdlsllib/Logic and Bit Operations/Word to Bits | R2023a+ | Convert input to vector of N 1-bit values, N is given by the Maximum Word Length mask parameter. |
| Counter
Free-Running | hdlsllib/Sources/Counter
Free-Running | R2023a+ | This block is a free-running counter that overflows back to zero after it has reached the maximum value possible for the specified number of bits. The counter is always initialized to zero. The output is normally an unsigned integer with the specified number of bits. |
| Counter
Limited | hdlsllib/Sources/Counter
Limited | R2023a+ | This block is a counter that wraps back to zero after it has output the specified upper limit. The counter is always initialized to zero. The output is normally an unsigned integer of 8, 16, or 32 bits. The smallest number of bits needed to represent the upper limit is used. |

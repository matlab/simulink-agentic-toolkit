---
type: Simulink Block Category
title: Iqmath
description: TI IQMath fixed-point arithmetic library for efficient control computations
tags: [iqmath, fixed-point, iq, trig, sqrt]
status: stable
source: mathworks_toolbox
library_root: C2000 Microcontroller Blockset
category_path: Iqmath
block_count: 17
---

# Iqmath

Use these blocks for iqmath.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Absolute IQN | tiiqmathlib/Absolute IQN | R2023a+ | Compute the absolute value of a fixed-point IQ number — use in control algorithms that require magnitude without sign for error signals or reference tracking |
| Arctangent IQN | tiiqmathlib/Arctangent IQN | R2023a+ | Compute the arctangent of a fixed-point IQ number — use for phase angle calculation in vector control transforms for motor drive algorithms |
| Float to IQN | tiiqmathlib/Float to IQN | R2023a+ | Convert a floating-point value to IQ fixed-point format — use at the boundary between floating-point design and fixed-point C2000 implementation for algorithm porting |
| Fractional part IQN x int32 | tiiqmathlib/Fractional part IQN x int32 | R2023a+ | Extract the fractional part after multiplying an IQ number by an integer — use for scaled fractional computations in fixed-point signal processing |
| Fractional part IQN | tiiqmathlib/Fractional part IQN | R2023a+ | Extract the fractional part of a fixed-point IQ number — use for modulo-1 operations in phase accumulators or angle wrapping in fixed-point control loops |
| IQN / IQN | tiiqmathlib/IQN / IQN | R2023a+ | Divide two fixed-point IQ numbers — use for ratio computations in fixed-point control algorithms where hardware division support is limited |
| IQN to Float | tiiqmathlib/IQN to Float | R2023a+ | Convert an IQ fixed-point number to floating-point format — use at interfaces where fixed-point C2000 results must be logged or compared with floating-point reference models |
| IQN x IQN | tiiqmathlib/IQN x IQN | R2023a+ | Multiply two fixed-point IQ numbers with proper Q-format alignment — use as the core multiply operation in fixed-point control law implementations |
| IQN x int32 | tiiqmathlib/IQN x int32 | R2023a+ | Multiply a fixed-point IQ number by a 32-bit integer — use for scaling operations where one operand is a pure integer count, index, or gain |
| IQN1 to IQN2 | tiiqmathlib/IQN1 to IQN2 | R2023a+ | Convert between different IQ fixed-point formats — use when signals with different fractional bit allocations must be combined in a computation |
| IQN1 x IQN2 | tiiqmathlib/IQN1 x IQN2 | R2023a+ | Multiply two IQ numbers with different Q-formats and produce a result in a specified Q-format — use when operands have different precision requirements |
| Integer part IQN x int32 | tiiqmathlib/Integer part IQN x int32 | R2023a+ | Extract the integer part after multiplying an IQ number by an integer — use for scaled integer extraction in fixed-point address or index calculations |
| Integer part IQN | tiiqmathlib/Integer part IQN | R2023a+ | Extract the integer part of a fixed-point IQ number — use for floor operations or integer truncation in fixed-point lookup table indexing |
| Magnitude IQN | tiiqmathlib/Magnitude IQN | R2023a+ | Compute the magnitude of a fixed-point IQ vector — use for vector length calculation in field-oriented motor control or signal envelope detection |
| Saturate IQN | tiiqmathlib/Saturate IQN | R2023a+ | Clamp a fixed-point IQ number to a specified range — use to prevent overflow or enforce actuator limits in fixed-point control law outputs |
| Square Root IQN | tiiqmathlib/Square Root IQN | R2023a+ | Compute the square root of a fixed-point IQ number — use for RMS calculation, magnitude computation, or normalization in fixed-point algorithms |
| Trig Fcn IQN | tiiqmathlib/Trig Fcn IQN | R2023a+ | Compute trigonometric functions in fixed-point IQ format including sin, cos, and atan2 — use for Park/Clarke transforms and angle-based computations in fixed-point motor control |

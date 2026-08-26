---
type: Simulink Block Category
title: Discrete operations
description: Delays, integrators, and difference operators for sampled systems
tags: [delay, integrator, difference, discrete, sample]
status: stable
source: mathworks_toolbox
library_root: DO-178C/DO-331 Primitive Library
category_path: Discrete operations
block_count: 6
---

# Discrete operations

Use these blocks for discrete operations.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Decrement Real World | do178Lib/Simulink/Additional Math & Discrete/Additional Math: Increment - Decrement/Decrement Real World | R2023a+ | Subtract one from the real-world value of a fixed-point signal — use for countdown logic or decrement operations that respect fixed-point scaling |
| Increment Real World | do178Lib/Simulink/Additional Math & Discrete/Additional Math: Increment - Decrement/Increment Real World | R2023a+ | Add one to the real-world value of a fixed-point signal — use for counter logic or increment operations that respect fixed-point scaling |
| Difference | do178Lib/Simulink/Discrete/Difference | R2023b+ | Compute the difference between current and previous sample values — use for discrete differentiation, rate-of-change detection, or delta computations in sampled systems |
| Delay | do178Lib/Simulink/Discrete/Delay | R2023b+ | Delay a signal by a configurable number of sample periods — use for pipeline alignment, transport delay modeling, or accessing multiple past samples in discrete algorithms |
| Discrete-Time Integrator | do178Lib/Simulink/Discrete/Discrete-Time Integrator | R2023b+ | Accumulate a signal over discrete time steps with optional reset and saturation — use for PID integral action, position from velocity, or energy accumulation in certified controllers |
| Unit Delay | do178Lib/Simulink/Discrete/Unit Delay | R2023b+ | Delay a signal by exactly one sample period — use for implementing Z-transform transfer functions, state feedback, or breaking algebraic loops in discrete systems |

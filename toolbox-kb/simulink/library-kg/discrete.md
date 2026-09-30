---
type: Simulink Block Category
title: Discrete
description: Discrete-time dynamics, delays, and filters
tags: [discrete, delay, integrator, filter, memory, zero-order hold]
status: stable
source: custom_library
library_root: Simulink
category_path: Discrete
block_count: 38
---

# Discrete

Use these blocks for discrete.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Decrement Real World | simulink/Additional Math & Discrete/Additional Math: Increment - Decrement/Decrement Real World | R2023a+ | Decrease the Real World Value of Signal by 1.0 Overflows will always wrap. |
| Decrement Stored Integer | simulink/Additional Math & Discrete/Additional Math: Increment - Decrement/Decrement Stored Integer | R2023a+ | Decrease the Stored Value of Signal by 1 Floating Point signals are decreased by 1.0 Overflows will always wrap. |
| Decrement Time To Zero | simulink/Additional Math & Discrete/Additional Math: Increment - Decrement/Decrement Time To Zero | R2023a+ | Decrease the Real World Value of Signal by the Sample Time Ts, but never go below zero. This block only works with fixed sample rates, so it will not work inside a triggered subsystem. |
| Decrement To Zero | simulink/Additional Math & Discrete/Additional Math: Increment - Decrement/Decrement To Zero | R2023a+ | Decrease the Real World Value of Signal by 1.0, but never go below zero. |
| Increment Real World | simulink/Additional Math & Discrete/Additional Math: Increment - Decrement/Increment Real World | R2023a+ | Increase the Real World Value of Signal by 1.0 Overflows will always wrap. |
| Increment Stored Integer | simulink/Additional Math & Discrete/Additional Math: Increment - Decrement/Increment Stored Integer | R2023a+ | Increase the Stored Value of Signal by 1 Floating Point signals are increased by 1.0 Overflows will always wrap. |
| Delay | simulink/Commonly
Used Blocks/Delay | R2023a+ | Delay a signal by a specified number of samples — use for timing alignment or algorithmic state. |
| Discrete-Time
Integrator | simulink/Commonly
Used Blocks/Discrete-Time
Integrator | R2023a+ | Accumulate the input over discrete time with reset/limit options — use for discrete integration. |
| Delay | simulink/Discrete/Delay | R2023a+ | Delay a signal by a specified number of samples — use for timing alignment or algorithmic state. |
| Discrete Transfer Fcn | simulink/Discrete/Discrete Transfer Fcn | R2023a+ | Implement a discrete transfer function from numerator/denominator coefficients — use for IIR dynamics. |
| Discrete Zero-Pole | simulink/Discrete/Discrete Zero-Pole | R2023a+ | Implement a discrete transfer function specified by zeros, poles, and gain — use for pole-zero discrete dynamics. |
| Discrete FIR Filter | simulink/Discrete/Discrete FIR Filter | R2023a+ | Apply an FIR filter with given coefficients — use for linear-phase digital filtering. |
| Discrete Filter | simulink/Discrete/Discrete Filter | R2023a+ | Apply an IIR filter given numerator and denominator coefficients — use for general recursive filtering. |
| Discrete PID Controller | simulink/Discrete/Discrete PID Controller | R2023a+ | Discrete-time PID controller with anti-windup and tuning — use for closed-loop feedback control. |
| Discrete PID Controller (2DOF) | simulink/Discrete/Discrete PID Controller (2DOF) | R2023a+ | Discrete two-degree-of-freedom PID with setpoint weighting — use to tune tracking and rejection independently. |
| Discrete State-Space | simulink/Discrete/Discrete State-Space | R2023a+ | Implement a discrete-time state-space model (A, B, C, D) — use for MIMO linear dynamics. |
| Discrete-Time Integrator | simulink/Discrete/Discrete-Time Integrator | R2023a+ | Accumulate the input over discrete time with reset/limit options — use for discrete integration. |
| Enabled Delay | simulink/Discrete/Enabled Delay | R2023a+ | Delay that updates only while enabled — use for gated or state-held delays. |
| Memory | simulink/Discrete/Memory | R2023a+ | Hold the input from the previous major time step — use to break algebraic loops or store one-step state. |
| Propagation Delay | simulink/Discrete/Propagation Delay | R2023a+ | Delay a signal to model propagation latency — use to represent signal travel time. |
| Resettable Delay | simulink/Discrete/Resettable Delay | R2023a+ | Delay that clears its state on a reset signal — use for restartable delays. |
| Unit Delay | simulink/Discrete/Unit Delay | R2023a+ | Delay a signal by one sample period — use to introduce one-step state or break algebraic loops. |
| Variable Integer Delay | simulink/Discrete/Variable Integer Delay | R2023a+ | Delay a signal by a runtime-variable integer number of samples — use for adjustable time alignment. |
| Zero-Order Hold | simulink/Discrete/Zero-Order Hold | R2023a+ | Hold each sample constant over the sample period — use to convert continuous to discrete or set a sample rate. |
| Difference | simulink/Discrete/Difference | R2023a+ | Output the current input value minus the previous input value. |
| Discrete Derivative | simulink/Discrete/Discrete Derivative | R2023a+ | Discrete-time derivative of the input. This block only works with fixed sample rates. Do not use this block in subsystems with a non-periodic trigger. |
| Transfer Fcn Lead or Lag | simulink/Discrete/Transfer Fcn Lead or Lag | R2023a+ | Discrete-time lead or lag compensator. The compensator has a unity instantaneous gain, the DC gain equals (1-Zero)/(1-Pole). Lead compensation is obtained when 0 < Pole < Zero < 1. Lag compensation is obtained when 0 < Zero < Pole < 1. |
| Check Discrete Gradient | simulink/Model Verification/Check Discrete Gradient | R2023a+ | Assert that the absolute value of the difference between successive samples of a discrete signal is less than an upper bound. |
| Accumulator | simulink/Quick Insert/Discrete/Accumulator | R2023a+ | Accumulate (sum) the input across time steps — use for running totals with reset. |
| Delay One Step | simulink/Quick Insert/Discrete/Delay One Step | R2023a+ | Delay a signal by exactly one time step — use as a quick one-step unit delay. |
| Discrete Transfer Fcn | simulink/Quick Insert/Discrete/Discrete Transfer Fcn | R2023a+ | Implement a discrete transfer function from numerator/denominator coefficients — use for IIR dynamics. |
| Discrete Zero-Pole | simulink/Quick Insert/Discrete/Discrete Zero-Pole | R2023a+ | Implement a discrete transfer function specified by zeros, poles, and gain — use for pole-zero discrete dynamics. |
| Discrete Filter | simulink/Quick Insert/Discrete/Discrete Filter | R2023a+ | Apply an IIR filter given numerator and denominator coefficients — use for general recursive filtering. |
| Discrete State-Space | simulink/Quick Insert/Discrete/Discrete State-Space | R2023a+ | Implement a discrete-time state-space model (A, B, C, D) — use for MIMO linear dynamics. |
| Difference | simulink/Quick Insert/Discrete/Difference | R2023a+ | Output the current input value minus the previous input value. |
| Discrete Derivative | simulink/Quick Insert/Discrete/Discrete Derivative | R2023a+ | Discrete-time derivative of the input. This block only works with fixed sample rates. Do not use this block in subsystems with a non-periodic trigger. |
| Repeating
Sequence
Interpolated | simulink/Sources/Repeating
Sequence
Interpolated | R2023a+ | Discrete time sequence is output, then repeated. Between data points, the specified lookup method is used to determine the output. |
| Repeating
Sequence
Stair | simulink/Sources/Repeating
Sequence
Stair | R2023a+ | Discrete time sequence is output, then repeated. |

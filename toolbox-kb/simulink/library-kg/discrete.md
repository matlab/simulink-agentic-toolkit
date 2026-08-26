---
type: Simulink Block Category
title: Discrete
description: Discrete-time processing blocks for delays, digital filters, sample-and-hold, and sampled-data controllers
tags: [delay, sample, discrete filter, zero-order hold, accumulator]
status: stable
source: mathworks_toolbox
library_root: Simulink
category_path: Discrete
block_count: 41
---

# Discrete

Use these blocks for discrete.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Fixed-Point State-Space | simulink/Additional Math & Discrete/Additional Discrete/Fixed-Point State-Space | R2023a+ | Use when implementing a state-space model with fixed-point arithmetic for embedded deployment |
| Transfer Fcn Direct Form II | simulink/Additional Math & Discrete/Additional Discrete/Transfer Fcn Direct Form II | R2023a+ | Use when implementing a discrete transfer function using Direct Form II structure |
| Transfer Fcn Direct Form II Time Varying | simulink/Additional Math & Discrete/Additional Discrete/Transfer Fcn Direct Form II Time Varying | R2023a+ | Use when implementing a discrete transfer function in Direct Form II with time-varying coefficients |
| Decrement Real World | simulink/Additional Math & Discrete/Additional Math: Increment - Decrement/Decrement Real World | R2023a+ | Use when decreasing a fixed-point signal by one real-world unit for countdown logic |
| Decrement Stored Integer | simulink/Additional Math & Discrete/Additional Math: Increment - Decrement/Decrement Stored Integer | R2023a+ | Use when decreasing the stored integer value of a fixed-point signal by one |
| Decrement Time To Zero | simulink/Additional Math & Discrete/Additional Math: Increment - Decrement/Decrement Time To Zero | R2023a+ | Use when decreasing a signal by a time-step-scaled amount until it reaches zero for timer countdown |
| Decrement To Zero | simulink/Additional Math & Discrete/Additional Math: Increment - Decrement/Decrement To Zero | R2023a+ | Use when decreasing a signal by one each step until it reaches zero for down-counter behavior |
| Increment Real World | simulink/Additional Math & Discrete/Additional Math: Increment - Decrement/Increment Real World | R2023a+ | Use when increasing a fixed-point signal by one real-world unit for count-up logic |
| Increment Stored Integer | simulink/Additional Math & Discrete/Additional Math: Increment - Decrement/Increment Stored Integer | R2023a+ | Use when increasing the stored integer value of a fixed-point signal by one |
| Difference | simulink/Discrete/Difference | R2023a+ | Use when computing the change in a signal between consecutive time steps for discrete differentiation |
| Discrete Derivative | simulink/Discrete/Discrete Derivative | R2023a+ | Use when approximating the derivative of a discrete-time signal using backward difference |
| Transfer Fcn First Order | simulink/Discrete/Transfer Fcn First Order | R2023a+ | Use when implementing a first-order discrete low-pass or lag filter with a single pole |
| Transfer Fcn Lead or Lag | simulink/Discrete/Transfer Fcn Lead or Lag | R2023a+ | Use when implementing discrete lead or lag compensation for phase adjustment in control systems |
| Transfer Fcn Real Zero | simulink/Discrete/Transfer Fcn Real Zero | R2023a+ | Use when implementing a discrete transfer function with a single real zero for high-frequency emphasis |
| Difference | simulink/Quick Insert/Discrete/Difference | R2023a+ | Use when computing the change in a signal between consecutive time steps for discrete differentiation |
| Discrete Derivative | simulink/Quick Insert/Discrete/Discrete Derivative | R2023a+ | Use when approximating the derivative of a discrete-time signal using backward difference |
| Delay | simulink/Discrete/Delay | R2023a+ | Use when delaying a signal by a configurable number of sample periods with support for variable delay length |
| Discrete Transfer Fcn | simulink/Discrete/Discrete Transfer Fcn | R2023a+ | Use when implementing a discrete-time transfer function specified by z-domain polynomials |
| Discrete Zero-Pole | simulink/Discrete/Discrete Zero-Pole | R2023a+ | Use when representing a discrete transfer function by its zeros, poles, and gain in factored form |
| Discrete FIR Filter | simulink/Discrete/Discrete FIR Filter | R2023a+ | Use when applying a finite impulse response filter defined by tap coefficients for signal smoothing |
| Discrete Filter | simulink/Discrete/Discrete Filter | R2023a+ | Use when implementing a general IIR or FIR digital filter with specified coefficients |
| Discrete PID Controller | simulink/Discrete/Discrete PID Controller | R2023a+ | Use when implementing a discrete-time PID controller with configurable sample time |
| Discrete PID Controller (2DOF) | simulink/Discrete/Discrete PID Controller (2DOF) | R2023a+ | Use when implementing a discrete two-degree-of-freedom PID for separate tracking and rejection tuning |
| Discrete State-Space | simulink/Discrete/Discrete State-Space | R2023a+ | Use when representing discrete-time dynamics in state-space form with matrices A, B, C, D |
| Discrete-Time Integrator | simulink/Discrete/Discrete-Time Integrator | R2023a+ | Use when accumulating a signal over discrete time steps with optional reset and saturation |
| Enabled Delay | simulink/Discrete/Enabled Delay | R2023a+ | Use when delaying a signal only while an enable condition is active, holding the last value when disabled |
| Memory | simulink/Discrete/Memory | R2023a+ | Use when storing the previous time-step value to break algebraic loops or provide one-step memory |
| Propagation Delay | simulink/Discrete/Propagation Delay | R2023a+ | Use when modeling a fixed number of clock cycles of latency in digital hardware |
| Resettable Delay | simulink/Discrete/Resettable Delay | R2023a+ | Use when delaying a signal with the ability to reset the stored state based on a reset trigger |
| Tapped Delay | simulink/Discrete/Tapped Delay | R2023a+ | Use when generating a vector of multiple consecutive delayed versions of a signal for FIR filtering |
| Unit Delay | simulink/Discrete/Unit Delay | R2023a+ | Use when delaying a signal by exactly one sample period to implement z^-1 operations in discrete control |
| Variable Integer Delay | simulink/Discrete/Variable Integer Delay | R2023a+ | Use when the number of sample periods of delay is determined dynamically by an integer-valued input |
| Zero-Order Hold | simulink/Discrete/Zero-Order Hold | R2023a+ | Use when converting a continuous-time signal to discrete-time by sampling and holding the value constant |
| Accumulator | simulink/Quick Insert/Discrete/Accumulator | R2023a+ | Use when summing input values over discrete time steps to create a running total or digital integrator |
| Delay One Step | simulink/Quick Insert/Discrete/Delay One Step | R2023a+ | Use when a simple single-sample delay is needed without additional configuration options |
| Discrete Transfer Fcn | simulink/Quick Insert/Discrete/Discrete Transfer Fcn | R2023a+ | Use when implementing a discrete-time transfer function specified by z-domain polynomials |
| Discrete Zero-Pole | simulink/Quick Insert/Discrete/Discrete Zero-Pole | R2023a+ | Use when representing a discrete transfer function by its zeros, poles, and gain in factored form |
| Discrete Filter | simulink/Quick Insert/Discrete/Discrete Filter | R2023a+ | Use when implementing a general IIR or FIR digital filter with specified coefficients |
| Discrete State-Space | simulink/Quick Insert/Discrete/Discrete State-Space | R2023a+ | Use when representing discrete-time dynamics in state-space form with matrices A, B, C, D |
| Probe Sample Time | simulink/Quick Insert/Signal Attributes/Probe Sample Time | R2023a+ |  |
| Weighted Sample Time | simulink/Signal Attributes/Weighted Sample Time | R2023a+ |  |

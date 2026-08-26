---
type: Simulink Block Category
title: Discrete elements
description: Delay elements, integrators, and transfer functions for discrete-time HDL logic
tags: [delay, register, integrator, filter, pipeline]
status: stable
source: mathworks_toolbox
library_root: HDL Coder
category_path: Discrete elements
block_count: 23
---

# Discrete elements

Use these blocks for discrete elements.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Tapped Delay Enabled Resettable Synchronous | hdlsllib/Discrete/Tapped Delay Enabled Resettable Synchronous | R2023a+ | Use when you need a tapped delay line with synchronous enable and reset for HDL pipelines |
| Tapped Delay Enabled Synchronous | hdlsllib/Discrete/Tapped Delay Enabled Synchronous | R2023a+ | Use when you need a tapped delay line with synchronous enable control for HDL pipelines |
| Tapped Delay Resettable Synchronous | hdlsllib/Discrete/Tapped Delay Resettable Synchronous | R2023a+ | Use when you need a tapped delay line with synchronous reset for HDL pipelines |
| Unit Delay Enabled Resettable Synchronous | hdlsllib/Discrete/Unit Delay Enabled Resettable Synchronous | R2023a+ | Use when you need a single-sample delay with synchronous enable and reset for HDL |
| Unit Delay Enabled Synchronous | hdlsllib/Discrete/Unit Delay Enabled Synchronous | R2023a+ | Use when you need a single-sample delay with synchronous enable control for HDL |
| Unit Delay Resettable Synchronous | hdlsllib/Discrete/Unit Delay Resettable Synchronous | R2023a+ | Use when you need a single-sample delay with synchronous reset capability for HDL |
| Delay | hdlsllib/Discrete/Delay | R2023a+ | Use when you need a configurable number of sample delays in an HDL pipeline |
| Discrete Transfer Fcn | hdlsllib/Discrete/Discrete Transfer Fcn | R2023a+ | Use when you need to implement a discrete transfer function for digital filter or controller design |
| Discrete FIR Filter | hdlsllib/Discrete/Discrete FIR Filter | R2023a+ | Use when you need a finite impulse response filter optimized for HDL code generation |
| Discrete PID Controller | hdlsllib/Discrete/Discrete PID Controller | R2023a+ | Use when you need a proportional-integral-derivative controller for digital control in HDL |
| Discrete-Time Integrator | hdlsllib/Discrete/Discrete-Time Integrator | R2023a+ | Use when you need discrete-time integration for accumulator or integrator logic in HDL |
| Enabled Delay | hdlsllib/Discrete/Enabled Delay | R2023a+ | Use when you need a delay that only advances when an enable signal is active |
| Enabled Resettable Delay | hdlsllib/Discrete/Enabled Resettable Delay | R2023a+ | Use when you need a delay with both enable control and asynchronous reset capability |
| Resettable Delay | hdlsllib/Discrete/Resettable Delay | R2023a+ | Use when you need a delay element that can be reset to its initial condition |
| Tapped Delay | hdlsllib/Discrete/Tapped Delay | R2023a+ | Use when you need multiple delayed versions of a signal for filter or pipeline structures |
| Unit Delay | hdlsllib/Discrete/Unit Delay | R2023a+ | Use when you need a single sample delay to create registers in HDL designs |
| Zero-Order Hold | hdlsllib/Discrete/Zero-Order Hold | R2023a+ | Use when you need to sample a signal and hold its value at a specific rate for multirate HDL designs |
| Discrete Transfer Fcn | hdlsllib/HDL Floating Point Operations/Discrete Transfer Fcn | R2023a+ | Use when you need to implement a discrete transfer function for digital filter or controller design |
| Discrete FIR Filter | hdlsllib/HDL Floating Point Operations/Discrete FIR Filter | R2023a+ | Use when you need a finite impulse response filter optimized for HDL code generation |
| Discrete PID Controller | hdlsllib/HDL Floating Point Operations/Discrete PID Controller | R2023a+ | Use when you need a proportional-integral-derivative controller for digital control in HDL |
| Discrete-Time Integrator | hdlsllib/HDL Floating Point Operations/Discrete-Time Integrator | R2023a+ | Use when you need discrete-time integration for accumulator or integrator logic in HDL |
| Discrete State-Space | hdlsllib/RCP and HIL/Discrete State-Space | R2024b+ | Use when you need state-space representation of a discrete linear system for HDL generation |
| Fixed-Point State-Space | hdlsllib/RCP and HIL/Fixed-Point State-Space | R2023a+ | Use when you need a fixed-point state-space model optimized for HDL implementation |

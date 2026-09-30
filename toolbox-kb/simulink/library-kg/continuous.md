---
type: Simulink Block Category
title: Continuous
description: Continuous-time dynamics: integrators, transfer functions, delays
tags: [continuous, integrator, transfer function, state-space, delay, pid]
status: stable
source: custom_library
library_root: Simulink
category_path: Continuous
block_count: 26
---

# Continuous

Use these blocks for continuous.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Fixed-Point State-Space | simulink/Additional Math & Discrete/Additional Discrete/Fixed-Point State-Space | R2023a+ | Discrete-time State-Space Realization |
| Transfer Fcn Direct Form II | simulink/Additional Math & Discrete/Additional Discrete/Transfer Fcn Direct Form II | R2023a+ | A Direct Form II realization of the specified transfer function is used. Only single input multiple output transfer functions are supported. The data types and scalings of the output, the coefficients, and any temporary variables are automatically selected. The automatic choices will be acceptable in many situations. In situations where the automatic choices give unacceptable results, manual layout of the filter is necessary. For manual layout, it is suggested that the blocks under this mask be used as a starting point. Note 1: The full denominator should have a leading coefficient of +1.0, but this leading coefficient should be excluded when entering the parameter. For example, if the denominator is den = 1 -1.7 0.72 just enter den(2:end) = -1.7 0.72 Note 2: The numerator must be the same size as the full denominator. |
| Transfer Fcn Direct Form II Time Varying | simulink/Additional Math & Discrete/Additional Discrete/Transfer Fcn Direct Form II Time Varying | R2023a+ | A Direct Form II realization of the specified transfer function is used. Only single input single output transfer functions are supported. The data types and scalings of the output, the coefficients, and any temporary variables are automatically selected. The automatic choices will be acceptable in many situations. In situations where the automatic choices give unacceptable results, manual layout of the filter is necessary. For manual layout, it is suggested that the blocks under this mask be used as a starting point. Note 1: The full denominator should have a leading coefficient of +1.0, but this leading coefficient should be excluded when entering the parameter. For example, if the denominator is den = 1 -1.7 0.72 just enter den(2:end) = -1.7 0.72 Note 2: The numerator must be the same size as the full denominator. |
| Integrator | simulink/Commonly
Used Blocks/Integrator | R2023a+ | Integrate a continuous-time signal (1/s) with optional limits and reset — use for continuous dynamics. |
| Derivative | simulink/Continuous/Derivative | R2023a+ | Approximate the continuous-time derivative (du/dt) of the input — use to estimate rate of change. |
| Descriptor State-Space | simulink/Continuous/Descriptor State-Space | R2023a+ | Model implicit (descriptor) continuous dynamics E·dx/dt = Ax + Bu — use for systems with a mass/descriptor matrix. |
| Entity Transport Delay | simulink/Continuous/Entity Transport Delay | R2023a+ | Delay entities/messages by a transport time — use to model conveyance latency in event-based flows. |
| First Order Hold | simulink/Continuous/First Order Hold | R2023a+ | Reconstruct a continuous signal from samples using first-order (ramp) hold — use for smoother sample reconstruction. |
| Integrator | simulink/Continuous/Integrator | R2023a+ | Integrate a continuous-time signal (1/s) with optional limits and reset — use for continuous dynamics. |
| Integrator Limited | simulink/Continuous/Integrator Limited | R2023a+ | Continuous integrator with saturation limits on the output — use to integrate with bounded state. |
| Integrator, Second-Order | simulink/Continuous/Integrator, Second-Order | R2023a+ | Integrate acceleration to velocity and position in one block — use for second-order mechanical dynamics. |
| Integrator, Second-Order Limited | simulink/Continuous/Integrator, Second-Order Limited | R2023a+ | Second-order integrator with limits on velocity and position states — use for bounded second-order dynamics. |
| PID Controller | simulink/Continuous/PID Controller | R2023a+ | Continuous or discrete PID controller with tuning and anti-windup — use for single-loop feedback control. |
| PID Controller (2DOF) | simulink/Continuous/PID Controller (2DOF) | R2023a+ | Two-degree-of-freedom PID with separate setpoint weighting — use to tune tracking and disturbance rejection independently. |
| State-Space | simulink/Continuous/State-Space | R2023a+ | Model continuous linear dynamics with matrices A, B, C, D — use for MIMO linear systems. |
| Transfer Fcn | simulink/Continuous/Transfer Fcn | R2023a+ | Model a continuous transfer function from numerator/denominator coefficients — use for linear s-domain dynamics. |
| Transport Delay | simulink/Continuous/Transport Delay | R2023a+ | Delay the input by a fixed continuous time — use to model pure transport/dead time. |
| Variable Time Delay | simulink/Continuous/Variable Time Delay | R2023a+ | Delay the input by a runtime-variable time — use for adjustable continuous delay. |
| Variable Transport Delay | simulink/Continuous/Variable Transport Delay | R2023a+ | Delay the input by a runtime-variable transport time — use to model variable dead time such as flow through a pipe. |
| Zero-Pole | simulink/Continuous/Zero-Pole | R2023a+ | Model a continuous transfer function specified by zeros, poles, and gain — use for pole-zero linear dynamics. |
| Tapped Delay | simulink/Discrete/Tapped Delay | R2023a+ | Delay a signal N sample periods and output all the delay versions. |
| Transfer Fcn First Order | simulink/Discrete/Transfer Fcn First Order | R2023a+ | Discrete-time first order transfer function. The transfer function has a unity DC gain. |
| Transfer Fcn Real Zero | simulink/Discrete/Transfer Fcn Real Zero | R2023a+ | Discrete-time transfer function that has a real zero and (effectively) has no pole. |
| C/C++ Code Block | simulink/Quick Insert/User-Defined Functions/C/C++ Code Block | R2023a+ | The S-Function Builder block creates a wrapper C-MEX S-function from your supplied C code with multiple input ports, output ports, and a variable number of scalar, vector, or matrix parameters. The input and output ports can propagate Simulink built-in data types, fixed-point data types, complex, 1-D, and 2-D signals. This block also supports discrete and continuous states of type real. You can optionally have the block generate a TLC file to be used for code generation. |
| Band-Limited
White Noise | simulink/Sources/Band-Limited
White Noise | R2023a+ | The Band-Limited White Noise block generates normally distributed random numbers that are suitable for use in continuous or hybrid systems. |
| S-Function Builder | simulink/User-Defined Functions/S-Function Builder | R2023a+ | The S-Function Builder block creates a wrapper C-MEX S-function from your supplied C code with multiple input ports, output ports, and a variable number of scalar, vector, or matrix parameters. The input and output ports can propagate Simulink built-in data types, fixed-point data types, complex, 1-D, and 2-D signals. This block also supports discrete and continuous states of type real. You can optionally have the block generate a TLC file to be used for code generation. |

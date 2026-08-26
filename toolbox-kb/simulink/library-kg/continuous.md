---
type: Simulink Block Category
title: Continuous
description: Continuous-time dynamic system blocks for integrators, derivatives, transfer functions, and state-space systems
tags: [integrator, transfer function, state-space, derivative, PID]
status: stable
source: mathworks_toolbox
library_root: Simulink
category_path: Continuous
block_count: 16
---

# Continuous

Use these blocks for continuous.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Derivative | simulink/Continuous/Derivative | R2023a+ | Use when you need to compute the time derivative of a signal for rate-of-change analysis |
| Descriptor State-Space | simulink/Continuous/Descriptor State-Space | R2023a+ | Use when modeling systems with algebraic constraints alongside differential equations in descriptor form |
| Entity Transport Delay | simulink/Continuous/Entity Transport Delay | R2023a+ | Use when modeling variable transport delays where the delay depends on entity-based scheduling |
| First Order Hold | simulink/Continuous/First Order Hold | R2023a+ | Use when reconstructing continuous signals from discrete samples with first-order interpolation |
| Integrator | simulink/Continuous/Integrator | R2023a+ | Use when accumulating a signal over continuous time to model dynamics such as position from velocity |
| Integrator Limited | simulink/Continuous/Integrator Limited | R2023a+ | Use when integrating a signal with saturation limits to prevent windup in continuous-time systems |
| Integrator, Second-Order | simulink/Continuous/Integrator, Second-Order | R2023a+ | Use when modeling second-order dynamics like mass-spring-damper systems requiring position and velocity states |
| Integrator, Second-Order Limited | simulink/Continuous/Integrator, Second-Order Limited | R2023a+ | Use when modeling second-order dynamics with output saturation to enforce physical limits |
| PID Controller | simulink/Continuous/PID Controller | R2023a+ | Use when implementing continuous-time PID feedback control for setpoint tracking and disturbance rejection |
| PID Controller (2DOF) | simulink/Continuous/PID Controller (2DOF) | R2023a+ | Use when implementing two-degree-of-freedom PID that independently weights setpoint tracking and disturbance rejection |
| State-Space | simulink/Continuous/State-Space | R2023a+ | Use when representing a linear time-invariant system in state-space form with matrices A, B, C, D |
| Transfer Fcn | simulink/Continuous/Transfer Fcn | R2023a+ | Use when modeling linear continuous-time dynamics specified by numerator and denominator polynomial coefficients |
| Transport Delay | simulink/Continuous/Transport Delay | R2023a+ | Use when a signal must be delayed by a fixed time duration to model physical transport phenomena |
| Variable Time Delay | simulink/Continuous/Variable Time Delay | R2023a+ | Use when the transport delay duration changes over time based on another input signal |
| Variable Transport Delay | simulink/Continuous/Variable Transport Delay | R2023a+ | Use when modeling a transport delay whose duration is determined dynamically by a variable input |
| Zero-Pole | simulink/Continuous/Zero-Pole | R2023a+ | Use when representing a continuous transfer function by its zero, pole, and gain factored form |

---
type: Simulink Block Category
title: Parameter varying dynamics
description: Dynamic system blocks whose state-space or transfer-function data varies with scheduling inputs or time.
tags: [lpv, ltv, varying, state-space, scheduling]
status: stable
source: custom_library
library_root: Control System Toolbox
category_path: Parameter varying dynamics
block_count: 10
---

# Parameter varying dynamics

Use these blocks for parameter varying dynamics.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Discrete Varying Delay | cstblocks/Linear Parameter Varying/Discrete Varying Delay | R2024a+ | Discrete transport delay driven by an input signal. Use to model a lag that changes with operating condition in a fixed-step LPV workflow. |
| Discrete Varying Observer Form | cstblocks/Linear Parameter Varying/Discrete Varying Observer Form | R2023a+ | Discrete observer-canonical state-space with input-driven coefficients. Use for a scheduled estimator whose dynamics vary with operating point on a fixed-step target. |
| Discrete Varying State Space | cstblocks/Linear Parameter Varying/Discrete Varying State Space | R2023a+ | Discrete-time state-space block with A, B, C, D matrices supplied as inputs. Use for scheduled LPV plant or controller dynamics deployed on a fixed-step embedded target. |
| Discrete Varying Transfer Function | cstblocks/Linear Parameter Varying/Discrete Varying Transfer Function | R2023a+ | Discrete transfer function with runtime-driven numerator and denominator coefficients. Use for scheduled varying-pole/zero dynamics in fixed-step embedded models. |
| LPV System | cstblocks/Linear Parameter Varying/LPV System | R2023a+ | Simulates a linear parameter-varying system built from a family of local linear models interpolated over scheduling parameters. Use to capture nonlinear plant or controller behavior across the operating envelope from a bank of trim-point linearizations. |
| LTV System | cstblocks/Linear Parameter Varying/LTV System | R2024a+ | Simulates a linear time-varying system whose state-space data is a function of time. Use when the dynamics follow a known time trajectory (a maneuver, startup profile, or aging schedule) rather than a scheduling variable. |
| Varying Delay | cstblocks/Linear Parameter Varying/Varying Delay | R2024a+ | Continuous transport delay whose length is set by an input signal. Use to model an operating-point-dependent transport or communication lag inside a continuous LPV simulation. |
| Varying Observer Form | cstblocks/Linear Parameter Varying/Varying Observer Form | R2023a+ | Continuous state-space in observer canonical form with coefficients taken from inputs. Use to build a scheduled observer or estimator whose model changes across the operating envelope. |
| Varying State Space | cstblocks/Linear Parameter Varying/Varying State Space | R2023a+ | Continuous state-space block whose A, B, C, D matrices are driven by input ports. Use to simulate an LPV plant or controller that re-linearizes as scheduling variables change. |
| Varying Transfer Function | cstblocks/Linear Parameter Varying/Varying Transfer Function | R2023a+ | Continuous transfer function whose numerator and denominator coefficients are supplied as signals. Use for scheduled dynamics expressed as moving poles and zeros in continuous-time simulation. |

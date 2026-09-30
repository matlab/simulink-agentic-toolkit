---
type: Simulink Block Category
title: Linear parameter varying
description: Gain-scheduled and time-varying linear elements for LPV/LTV modeling
tags: [linear parameter varying, varying, lpv, ltv]
status: stable
source: custom_library
library_root: Control System Toolbox
category_path: Linear parameter varying
block_count: 18
---

# Linear parameter varying

Use these blocks for linear parameter varying.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Discrete Varying 2DOF PID | cstblocks/Linear Parameter Varying/Discrete Varying 2DOF PID | R2023a+ | Discrete-time gain-scheduled two-degree-of-freedom PID whose gains vary with scheduling inputs — use for LPV control with separate setpoint and feedback weighting. |
| Discrete Varying Delay | cstblocks/Linear Parameter Varying/Discrete Varying Delay | R2024a+ | Discrete-time delay whose length varies at runtime from an input — use in gain-scheduled/LPV models with time-varying transport delay. |
| Discrete Varying Lowpass | cstblocks/Linear Parameter Varying/Discrete Varying Lowpass | R2023a+ | Discrete-time lowpass filter whose cutoff varies at runtime — use for adaptive filtering within a gain-scheduled design. |
| Discrete Varying Notch | cstblocks/Linear Parameter Varying/Discrete Varying Notch | R2023a+ | Discrete-time notch filter whose notch frequency varies at runtime — use to reject a time-varying tone in an LPV design. |
| Discrete Varying Observer Form | cstblocks/Linear Parameter Varying/Discrete Varying Observer Form | R2023a+ | Discrete-time observer-canonical state-space block with matrices supplied at runtime — use for LPV estimation/control in observer form. |
| Discrete Varying PID | cstblocks/Linear Parameter Varying/Discrete Varying PID | R2023a+ | Discrete-time gain-scheduled PID whose gains vary with scheduling inputs — use for LPV control of a discrete plant. |
| Discrete Varying State Space | cstblocks/Linear Parameter Varying/Discrete Varying State Space | R2023a+ | Discrete-time state-space block whose A/B/C/D matrices are supplied at runtime — use to implement LPV/LTV plants and controllers in discrete time. |
| Discrete Varying Transfer Function | cstblocks/Linear Parameter Varying/Discrete Varying Transfer Function | R2023a+ | Discrete-time transfer function whose coefficients vary at runtime — use for LPV filtering or control in discrete time. |
| LPV System | cstblocks/Linear Parameter Varying/LPV System | R2023a+ | Simulate a linear parameter-varying model that interpolates among precomputed linearizations by a scheduling parameter — use to represent a nonlinear plant for gain-scheduled control design. |
| LTV System | cstblocks/Linear Parameter Varying/LTV System | R2024a+ | Simulate a linear time-varying model whose matrices change with time — use for trajectory-linearized dynamics. |
| Varying 2DOF PID | cstblocks/Linear Parameter Varying/Varying 2DOF PID | R2023a+ | Continuous-time gain-scheduled two-degree-of-freedom PID with runtime-varying gains — use for LPV control with separate setpoint and feedback weighting. |
| Varying Delay | cstblocks/Linear Parameter Varying/Varying Delay | R2024a+ | Continuous-time delay whose length varies at runtime — use in gain-scheduled/LPV models with time-varying transport delay. |
| Varying Lowpass Filter | cstblocks/Linear Parameter Varying/Varying Lowpass Filter | R2023a+ | Continuous-time lowpass filter whose cutoff varies at runtime — use for adaptive filtering within a gain-scheduled design. |
| Varying Notch Filter | cstblocks/Linear Parameter Varying/Varying Notch Filter | R2023a+ | Continuous-time notch filter whose notch frequency varies at runtime — use to reject a time-varying tone in an LPV design. |
| Varying Observer Form | cstblocks/Linear Parameter Varying/Varying Observer Form | R2023a+ | Continuous-time observer-canonical state-space block with matrices supplied at runtime — use for LPV estimation/control in observer form. |
| Varying PID Controller | cstblocks/Linear Parameter Varying/Varying PID Controller | R2023a+ | Continuous-time gain-scheduled PID with runtime-varying gains — use for LPV control of a continuous plant. |
| Varying State Space | cstblocks/Linear Parameter Varying/Varying State Space | R2023a+ | Continuous-time state-space block whose A/B/C/D matrices are supplied at runtime — use to implement LPV/LTV plants and controllers. |
| Varying Transfer Function | cstblocks/Linear Parameter Varying/Varying Transfer Function | R2023a+ | Continuous-time transfer function whose coefficients vary at runtime — use for LPV filtering or control. |

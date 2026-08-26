---
type: Simulink Block Category
title: Common blocks
description: Standard Simulink utility blocks for Gizmo projects
tags: [gain, constant, switch, scope, math]
status: stable
source: mathworks_toolbox
library_root: Simulink Arduino Libraries for Gizmo Hardware
category_path: Common blocks
block_count: 19
---

# Common blocks

Use these blocks for common blocks.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| MATLAB Function | gizmoLibrary/Gizmo Blocks/MATLAB Function | R2025a+ | Execute custom MATLAB code in the Gizmo model — use for implementing custom algorithms not covered by standard blocks |
| Constant | gizmoLibrary/Common Blocks/Constant | R2025a+ | Output a constant value — use for providing fixed setpoints or parameters in Gizmo models |
| Logical Operator | gizmoLibrary/Common Blocks/Logical Operator | R2023a+ | Perform Boolean logic operations — use for AND, OR, NOT logic in decision-making within Gizmo control |
| Relational Operator | gizmoLibrary/Common Blocks/Relational Operator | R2023a+ | Compare two signals — use for threshold detection or conditional logic in Gizmo control algorithms |
| Slider Gain | gizmoLibrary/Common Blocks/Slider Gain | R2023a+ | Adjustable gain with interactive slider — use for real-time tuning of controller gains during Gizmo operation |
| Abs | gizmoLibrary/Common Blocks/Arithmetic Blocks/Abs | R2025a+ | Compute absolute value of a signal — use for magnitude calculations in Gizmo control or sensing |
| Add | gizmoLibrary/Common Blocks/Arithmetic Blocks/Add | R2025a+ | Sum input signals — use for combining sensor readings or computing error signals in Gizmo control |
| Divide | gizmoLibrary/Common Blocks/Arithmetic Blocks/Divide | R2025a+ | Divide one signal by another — use for ratio calculations or normalization in Gizmo algorithms |
| Gain | gizmoLibrary/Common Blocks/Arithmetic Blocks/Gain | R2025a+ | Multiply signal by a constant — use for scaling sensor values or applying controller gains in Gizmo models |
| MinMax | gizmoLibrary/Common Blocks/Arithmetic Blocks/MinMax | R2025a+ | Output minimum or maximum of inputs — use for signal limiting or selecting extremes in Gizmo control |
| Product | gizmoLibrary/Common Blocks/Arithmetic Blocks/Product | R2025a+ | Multiply input signals element-wise — use for modulation or scaling operations in Gizmo models |
| Saturation | gizmoLibrary/Common Blocks/Arithmetic Blocks/Saturation | R2025a+ | Limit signal to upper and lower bounds — use for clamping actuator commands to safe operating ranges |
| Data Type Conversion | gizmoLibrary/Gizmo Blocks/Data Type Conversion | R2025a+ | Convert signal data type — use for matching data types between blocks in Gizmo Arduino-targeted models |
| Dead Zone | gizmoLibrary/Gizmo Blocks/Dead Zone | R2025a+ | Zero the output within a specified band — use for eliminating joystick deadband or sensor noise near zero |
| Display | gizmoLibrary/Gizmo Blocks/Display | R2025a+ | Show signal value during simulation — use for monitoring variables during Gizmo model development |
| Ground | gizmoLibrary/Gizmo Blocks/Ground | R2025a+ | Provide a zero-valued signal — use for terminating unused input ports cleanly in Gizmo models |
| Scope | gizmoLibrary/Gizmo Blocks/Scope | R2025a+ | Visualize signals over time — use for debugging and monitoring signal behavior in Gizmo models |
| Switch | gizmoLibrary/Gizmo Blocks/Switch | R2025a+ | Select between inputs based on a condition — use for mode switching or conditional routing in Gizmo control |
| Terminator | gizmoLibrary/Gizmo Blocks/Terminator | R2025a+ | Terminate an unconnected output — use for suppressing warnings on unused block outputs in Gizmo models |

---
type: Simulink Block Category
title: Signal attributes
description: Data type conversion, rate transitions, and signal property management
tags: [conversion, type, rate, specification, unit]
status: stable
source: mathworks_toolbox
library_root: DO-178C/DO-331 Primitive Library
category_path: Signal attributes
block_count: 12
---

# Signal attributes

Use these blocks for signal attributes.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Data Type Conversion Inherited | do178Lib/Simulink/Signal Attributes/Data Type Conversion Inherited | R2023a+ | Convert a signal to match the data type inherited from downstream — use to ensure type compatibility without hard-coding the target type |
| IC | do178Lib/Simulink/Ports & Subsystems/While Iterator Subsystem/IC | R2023a+ | Set the initial condition of a signal at simulation start — use to define known starting values for signals that would otherwise be undefined on the first time step |
| Data Type Duplicate | do178Lib/Simulink/Signal Attributes/Data Type Duplicate | R2023a+ | Enforce that connected signals share the same data type — use as a design constraint to catch type mismatches at model update rather than runtime |
| Data Type Conversion | do178Lib/Simulink/Signal Attributes/Data Type Conversion | R2023a+ | Convert a signal from one data type to another — use at boundaries between subsystems with different numeric representations or when interfacing fixed-point and floating-point paths |
| Data Type Propagation | do178Lib/Simulink/Signal Attributes/Data Type Propagation | R2023a+ | Propagate data type information through the model — use to help Simulink resolve ambiguous types during compilation in complex signal paths |
| IC | do178Lib/Simulink/Signal Attributes/IC | R2023a+ | Set the initial condition of a signal at simulation start — use to define known starting values for signals that would otherwise be undefined on the first time step |
| Probe | do178Lib/Simulink/Signal Attributes/Probe | R2023a+ | Detect signal attributes such as width, sample time, or complexity at compile time — use for conditional logic based on signal properties or for documentation |
| Rate Transition | do178Lib/Simulink/Signal Attributes/Rate Transition | R2023a+ | Handle data transfer between subsystems running at different sample rates — use to ensure data integrity across rate boundaries in multirate certified systems |
| Signal Conversion | do178Lib/Simulink/Signal Attributes/Signal Conversion | R2023a+ | Convert between virtual and non-virtual signal types — use to force signal storage allocation or resolve mux/bus compatibility at subsystem boundaries |
| Signal Specification | do178Lib/Simulink/Signal Attributes/Signal Specification | R2023a+ | Assert expected signal dimensions, data type, and sample time — use as a design contract to catch specification violations during model compilation |
| Unit Conversion | do178Lib/Simulink/Signal Attributes/Unit Conversion | R2023a+ | Convert a signal between physical units — use to transform between measurement systems at interface boundaries while maintaining dimensional consistency |
| Width | do178Lib/Simulink/Signal Attributes/Width | R2023a+ | Output the width of the input signal as a constant — use for dynamically sizing downstream operations or verifying expected vector lengths |

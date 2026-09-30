---
type: Simulink Block Category
title: Ports subsystems
description: Ports, subsystems, and control-flow containers
tags: [ports, subsystems, inport, outport, if, switch case, subsystem, iterator]
status: stable
source: custom_library
library_root: DO-178C/DO-331 Primitive Library
category_path: Ports subsystems
block_count: 19
---

# Ports subsystems

Use these blocks for ports subsystems.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| In1 | do178Lib/Simulink/Ports & Subsystems/In1 | R2023a+ | Inport that brings a signal into a subsystem or model — use to define an input interface. |
| Function-Call Generator | do178Lib/Simulink/Ports & Subsystems/Function-Call Generator | R2023a+ | Execute function-call subsystems, models, or Stateflow charts that are connected to this block at a specified rate. To execute multiple function-call blocks in prescribed order, use this block in conjunction with a Function-Call Split block. The 'Sample time' parameter specifies the rate at which this block executes each function-call block connected to it. To iteratively execute each function-call block connected to this block multiple times at each time step, use the 'Number of iterations' parameter. If you check 'Show enable port' checkbox, block outputs function-call signal only when input signal to the enable port has positive scalar value. |
| Function-Call Split | do178Lib/Simulink/Ports & Subsystems/Function-Call Split | R2023a+ | Split one function-call line to trigger multiple subsystems — use to invoke several function-call subsystems from one caller. |
| If | do178Lib/Simulink/Ports & Subsystems/If | R2023a+ | Evaluate if/elseif conditions and issue action outputs — use with If Action Subsystems for conditional execution. |
| Switch Case | do178Lib/Simulink/Ports & Subsystems/Switch Case | R2023a+ | Route control to case actions based on an integer input — use with Case Action Subsystems for multiway branching. |
| Out1 | do178Lib/Simulink/Ports & Subsystems/Out1 | R2023a+ | Outport that sends a signal out of a subsystem or model — use to define an output interface. |
| Atomic Subsystem | do178Lib/Simulink/Ports & Subsystems/Atomic Subsystem | R2023a+ | Group blocks that execute atomically as a single unit — use to enforce single-unit execution and code-generation boundaries. |
| Enabled Subsystem | do178Lib/Simulink/Ports & Subsystems/Enabled Subsystem | R2023a+ | Execute contained blocks only while an enable signal is positive — use for conditionally-run logic. |
| For Each Subsystem | do178Lib/Simulink/Ports & Subsystems/For Each Subsystem | R2023a+ | Run the contained logic independently on each element/slice of an input — use to vectorize per-element processing. |
| For Iterator Subsystem | do178Lib/Simulink/Ports & Subsystems/For Iterator Subsystem | R2023a+ | Execute the contents a fixed number of iterations per step — use for bounded loops. |
| Function-Call Subsystem | do178Lib/Simulink/Ports & Subsystems/Function-Call Subsystem | R2023a+ | Execute the contents when invoked by a function-call — use for event- or scheduler-driven logic. |
| If Action Subsystem | do178Lib/Simulink/Ports & Subsystems/If Action Subsystem | R2023a+ | Contained action executed when driven by an If block branch — use as the body of a conditional branch. |
| Subsystem | do178Lib/Simulink/Ports & Subsystems/Subsystem | R2023a+ | Group blocks into a hierarchical container — use to organize a model into reusable, readable units. |
| Triggered Subsystem | do178Lib/Simulink/Ports & Subsystems/Triggered Subsystem | R2023a+ | Execute the contents on a trigger edge — use for edge-driven, event-based logic. |
| Variant Subsystem | do178Lib/Simulink/Ports & Subsystems/Variant Subsystem | R2023a+ | Contain multiple implementations and activate one by variant condition — use to switch between design alternatives. |
| While Iterator Subsystem | do178Lib/Simulink/Ports & Subsystems/While Iterator Subsystem | R2023a+ | Execute the contents repeatedly while a condition holds — use for condition-controlled loops. |
| Data Type Propagation | do178Lib/Simulink/Signal Attributes/Data Type Propagation | R2023a+ | Set the Data Type and Scaling of the propagated signal based on information from the reference signals. Notes: 1) Items closer to the top of the dialog have higher priority/precedence. a) Reference inputs of type double have priority over all others. b) Singles have priority over integer and fixed point data types. c) Multiplicative adjustments are carried out before additive adjustments. d) Number-of-Bits is determined before the precision or positive-range is inherited from the reference signals. 2) PosRange is one bit higher than the exact maximum positive range of the signal. 3) The computed Number-of-Bits is promoted to the smallest allowable value that is greater than or equal to the computation. If none exists, then the block returns an error. |
| Out1 | do178Lib/Simulink/Sinks/Out1 | R2023a+ | Outport that sends a signal out of a subsystem or model — use to define an output interface. |
| In1 | do178Lib/Simulink/Sources/In1 | R2023a+ | Inport that brings a signal into a subsystem or model — use to define an input interface. |

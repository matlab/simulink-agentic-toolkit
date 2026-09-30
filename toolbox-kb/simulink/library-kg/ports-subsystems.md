---
type: Simulink Block Category
title: Ports subsystems
description: Ports, subsystems, and control-flow blocks
tags: [inport, outport, subsystem, enable, trigger, if, function-call, model]
status: stable
source: custom_library
library_root: Simulink
category_path: Ports subsystems
block_count: 24
---

# Ports subsystems

Use these blocks for ports subsystems.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| In1 | simulink/Commonly
Used Blocks/In1 | R2023a+ | Inport that brings a signal into a subsystem or model — use to define an input interface. |
| Subsystem | simulink/Commonly
Used Blocks/Subsystem | R2023a+ | Group blocks into a hierarchical subsystem — use to encapsulate and reuse logic. |
| Out1 | simulink/Commonly
Used Blocks/Out1 | R2023a+ | Outport that sends a signal out of a subsystem or model — use to define an output interface. |
| In1 | simulink/Ports &
Subsystems/In1 | R2023a+ | Inport that brings a signal into a subsystem or model — use to define an input interface. |
| In Bus Element | simulink/Ports &
Subsystems/In Bus Element | R2023a+ | Subsystem input port that selects a bus element — use for bus-based subsystem interfaces. |
| Function Element Call | simulink/Ports &
Subsystems/Function Element Call | R2023a+ | Invoke a function element defined on a bus interface — use to call a server function. |
| Enable | simulink/Ports &
Subsystems/Enable | R2023a+ | Enable-port block that makes a subsystem run only while its enable signal is true — use for conditional execution. |
| Trigger | simulink/Ports &
Subsystems/Trigger | R2023a+ | Trigger-port block that makes a subsystem run on an edge or function call — use for event-driven execution. |
| Function-Call
Feedback Latch | simulink/Ports &
Subsystems/Function-Call
Feedback Latch | R2023a+ | Latch a signal in a function-call feedback loop to break direct feedthrough — use to resolve function-call loop timing. |
| Function-Call
Generator | simulink/Ports &
Subsystems/Function-Call
Generator | R2023a+ | Generate function-call events at a specified rate — use to invoke function-call subsystems programmatically. |
| Function-Call
Split | simulink/Ports &
Subsystems/Function-Call
Split | R2023a+ | Split one function-call signal to invoke multiple subsystems in order — use to fan out a function call. |
| If | simulink/Ports &
Subsystems/If | R2023a+ | Route execution to If-Action subsystems based on conditions — use for if/else control flow. |
| Model | simulink/Ports &
Subsystems/Model | R2023a+ | Reference another Simulink model as a component — use for modular, reusable model composition. |
| Subsystem | simulink/Ports &
Subsystems/Subsystem | R2023a+ | Group blocks into a hierarchical subsystem — use to encapsulate and reuse logic. |
| Switch Case | simulink/Ports &
Subsystems/Switch Case | R2023a+ | Route execution to Case-Action subsystems based on an input value — use for switch/case control flow. |
| Unit System Configuration | simulink/Ports &
Subsystems/Unit System Configuration | R2023a+ | Restrict a subsystem to an allowed unit system — use to enforce consistent physical units. |
| Out1 | simulink/Ports &
Subsystems/Out1 | R2023a+ | Outport that sends a signal out of a subsystem or model — use to define an output interface. |
| Out Bus Element | simulink/Ports &
Subsystems/Out Bus Element | R2023a+ | Subsystem output port that contributes a bus element — use for bus-based subsystem interfaces. |
| Function Element | simulink/Ports &
Subsystems/Function Element | R2023a+ | Declare a function element on a bus interface — use to define client/server functions in a bus. |
| Out1 | simulink/Sinks/Out1 | R2023a+ | Outport that sends a signal out of a subsystem or model — use to define an output interface. |
| Out Bus Element | simulink/Sinks/Out Bus Element | R2023a+ | Subsystem output port that contributes a bus element — use for bus-based subsystem interfaces. |
| In1 | simulink/Sources/In1 | R2023a+ | Inport that brings a signal into a subsystem or model — use to define an input interface. |
| In Bus Element | simulink/Sources/In Bus Element | R2023a+ | Subsystem input port that selects a bus element — use for bus-based subsystem interfaces. |
| S-Function Examples | simulink/User-Defined Functions/S-Function Examples | R2023a+ | These are examples of how to use the different types of S-Functions. |

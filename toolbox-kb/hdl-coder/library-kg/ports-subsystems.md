---
type: Simulink Block Category
title: Ports subsystems
description: Ports, subsystems, and control-flow blocks
tags: [inport, outport, subsystem, enable, trigger, if, switch case, model]
status: stable
source: custom_library
library_root: HDL Coder
category_path: Ports subsystems
block_count: 27
---

# Ports subsystems

Use these blocks for ports subsystems.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| In1 | hdlsllib/Commonly
Used Blocks/In1 | R2023a+ | Inport that brings a signal into a subsystem or model — use to define an input interface. |
| Out1 | hdlsllib/Commonly
Used Blocks/Out1 | R2023a+ | Outport that sends a signal out of a subsystem or model — use to define an output interface. |
| Wrap To Zero | hdlsllib/Discontinuities/Wrap To Zero | R2023a+ | If the input is above the threshold, the output is zero, otherwise the output equals the input. |
| HDL FIFO | hdlsllib/HDL RAMs/HDL FIFO | R2023a+ | Implements a synchronous "First In,First Out" (FIFO) register. |
| Enabled Synchronous Subsystem | hdlsllib/HDL Subsystems/Enabled Synchronous Subsystem | R2023a+ | A subsystem block template containing an enable port, state control, inport, and outport block. |
| Synchronous Subsystem | hdlsllib/HDL Subsystems/Synchronous Subsystem | R2023a+ | A subsystem block template containing a state control, inport, and outport block. |
| In1 | hdlsllib/Ports &
Subsystems/In1 | R2023a+ | Inport that brings a signal into a subsystem or model — use to define an input interface. |
| In Bus Element | hdlsllib/Ports &
Subsystems/In Bus Element | R2023a+ | Subsystem input port that selects a bus element — use for bus-based subsystem interfaces. |
| Enable | hdlsllib/Ports &
Subsystems/Enable | R2023a+ | Enable-port block that makes a subsystem run only while its enable signal is true — use for conditional execution. |
| Trigger | hdlsllib/Ports &
Subsystems/Trigger | R2023a+ | Trigger-port block that makes a subsystem run on an edge or function call — use for event-driven execution. |
| Atomic Subsystem | hdlsllib/Ports &
Subsystems/Atomic Subsystem | R2023a+ | A subsystem block template containing an inport and outport block. |
| Enabled
Subsystem | hdlsllib/Ports &
Subsystems/Enabled
Subsystem | R2023a+ | A subsystem block template containing an enable port, inport and outport block. |
| For Each
Subsystem | hdlsllib/Ports &
Subsystems/For Each
Subsystem | R2023a+ | A subsystem block template containing a for each, inport and outport block. |
| If | hdlsllib/Ports &
Subsystems/If | R2023a+ | Route execution to If-Action subsystems based on conditions — use for if/else control flow. |
| If Action
Subsystem | hdlsllib/Ports &
Subsystems/If Action
Subsystem | R2023a+ | A subsystem block template containing an action port, inport and outport block. |
| Merge | hdlsllib/Ports &
Subsystems/Merge | R2023a+ | Combine multiple conditionally-executed inputs into one output — use to merge outputs of enabled subsystems. |
| Model | hdlsllib/Ports &
Subsystems/Model | R2023a+ | Reference another Simulink model as a component — use for modular, reusable model composition. |
| Subsystem | hdlsllib/Ports &
Subsystems/Subsystem | R2023a+ | Group blocks into a hierarchical subsystem — use to encapsulate and reuse logic. |
| Switch Case | hdlsllib/Ports &
Subsystems/Switch Case | R2023a+ | Route execution to Case-Action subsystems based on an input value — use for switch/case control flow. |
| Triggered
Subsystem | hdlsllib/Ports &
Subsystems/Triggered
Subsystem | R2023a+ | A subsystem block template containing a trigger port, inport and outport block. |
| Variant Subsystem | hdlsllib/Ports &
Subsystems/Variant Subsystem | R2023a+ | A Variant Subsystem template containing Subsystem blocks as variant choices. |
| Out1 | hdlsllib/Ports &
Subsystems/Out1 | R2023a+ | Outport that sends a signal out of a subsystem or model — use to define an output interface. |
| Out Bus Element | hdlsllib/Ports &
Subsystems/Out Bus Element | R2023a+ | Subsystem output port that contributes a bus element — use for bus-based subsystem interfaces. |
| Out1 | hdlsllib/Sinks/Out1 | R2023a+ | Outport that sends a signal out of a subsystem or model — use to define an output interface. |
| Out Bus Element | hdlsllib/Sinks/Out Bus Element | R2023a+ | Subsystem output port that contributes a bus element — use for bus-based subsystem interfaces. |
| In1 | hdlsllib/Sources/In1 | R2023a+ | Inport that brings a signal into a subsystem or model — use to define an input interface. |
| In Bus Element | hdlsllib/Sources/In Bus Element | R2023a+ | Subsystem input port that selects a bus element — use for bus-based subsystem interfaces. |

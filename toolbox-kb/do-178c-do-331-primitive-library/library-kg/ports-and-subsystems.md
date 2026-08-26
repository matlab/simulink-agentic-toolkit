---
type: Simulink Block Category
title: Ports and subsystems
description: Subsystem interfaces, iterators, conditional execution ports
tags: [subsystem, port, iterator, enable, trigger]
status: stable
source: mathworks_toolbox
library_root: DO-178C/DO-331 Primitive Library
category_path: Ports and subsystems
block_count: 42
---

# Ports and subsystems

Use these blocks for ports and subsystems.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| In1 | do178Lib/Simulink/Ports & Subsystems/In1 | R2023a+ | Define an input port for a subsystem or model — use to declare the subsystem interface and receive signals from the parent level |
| Function-Call Generator | do178Lib/Simulink/Ports & Subsystems/Function-Call Generator | R2023a+ | Generate function-call events to trigger function-call subsystems — use to control execution order or implement scheduled function calls in rate-based designs |
| Function-Call Split | do178Lib/Simulink/Ports & Subsystems/Function-Call Split | R2023a+ | Distribute a single function-call event to multiple function-call subsystems — use when one trigger must activate several subsystems in a defined sequence |
| If | do178Lib/Simulink/Ports & Subsystems/If | R2023a+ | Evaluate conditions and activate corresponding If Action subsystems — use to implement conditional branching with mutually exclusive execution paths |
| Switch Case | do178Lib/Simulink/Ports & Subsystems/Switch Case | R2023a+ | Route execution to one of several Switch Case Action subsystems based on an integer input — use for multi-way branching driven by mode or state variables |
| Out1 | do178Lib/Simulink/Ports & Subsystems/Out1 | R2023a+ | Define an output port for a subsystem or model — use to declare the subsystem interface and pass computed results back to the parent level |
| In1 | do178Lib/Simulink/Ports & Subsystems/Atomic Subsystem/In1 | R2023a+ | Define an input port for a subsystem or model — use to declare the subsystem interface and receive signals from the parent level |
| Out1 | do178Lib/Simulink/Ports & Subsystems/Atomic Subsystem/Out1 | R2023a+ | Define an output port for a subsystem or model — use to declare the subsystem interface and pass computed results back to the parent level |
| In1 | do178Lib/Simulink/Ports & Subsystems/Enabled Subsystem/In1 | R2023a+ | Define an input port for a subsystem or model — use to declare the subsystem interface and receive signals from the parent level |
| Enable | do178Lib/Simulink/Ports & Subsystems/Enabled Subsystem/Enable | R2023a+ | Add an enable port to a subsystem — use to make the subsystem execute only when the enable signal is true, supporting conditional execution patterns |
| Out1 | do178Lib/Simulink/Ports & Subsystems/Enabled Subsystem/Out1 | R2023a+ | Define an output port for a subsystem or model — use to declare the subsystem interface and pass computed results back to the parent level |
| In1 | do178Lib/Simulink/Ports & Subsystems/For Each Subsystem/In1 | R2023a+ | Define an input port for a subsystem or model — use to declare the subsystem interface and receive signals from the parent level |
| For Each | do178Lib/Simulink/Ports & Subsystems/For Each Subsystem/For Each | R2023a+ | Partition input signals and iterate a subsystem over each partition — use for applying identical processing to each element of a vector or array independently |
| Out1 | do178Lib/Simulink/Ports & Subsystems/For Each Subsystem/Out1 | R2023a+ | Define an output port for a subsystem or model — use to declare the subsystem interface and pass computed results back to the parent level |
| In1 | do178Lib/Simulink/Ports & Subsystems/For Iterator Subsystem/In1 | R2023a+ | Define an input port for a subsystem or model — use to declare the subsystem interface and receive signals from the parent level |
| For Iterator | do178Lib/Simulink/Ports & Subsystems/For Iterator Subsystem/For Iterator | R2023a+ | Repeat subsystem execution a fixed number of iterations per time step — use for iterative algorithms, convergence loops, or multi-pass computations within one sample |
| Out1 | do178Lib/Simulink/Ports & Subsystems/For Iterator Subsystem/Out1 | R2023a+ | Define an output port for a subsystem or model — use to declare the subsystem interface and pass computed results back to the parent level |
| In1 | do178Lib/Simulink/Ports & Subsystems/Function-Call Subsystem/In1 | R2023a+ | Define an input port for a subsystem or model — use to declare the subsystem interface and receive signals from the parent level |
| function | do178Lib/Simulink/Ports & Subsystems/Function-Call Subsystem/function | R2023a+ | Trigger port that makes a subsystem callable as a function — use inside Function-Call Subsystems to receive execution events from callers |
| Out1 | do178Lib/Simulink/Ports & Subsystems/Function-Call Subsystem/Out1 | R2023a+ | Define an output port for a subsystem or model — use to declare the subsystem interface and pass computed results back to the parent level |
| In1 | do178Lib/Simulink/Ports & Subsystems/If Action Subsystem/In1 | R2023a+ | Define an input port for a subsystem or model — use to declare the subsystem interface and receive signals from the parent level |
| Action Port | do178Lib/Simulink/Ports & Subsystems/If Action Subsystem/Action Port | R2023a+ | Mark a subsystem as an action subsystem — use inside If Action or Switch Case Action subsystems to receive execution control from an If or Switch Case block |
| Out1 | do178Lib/Simulink/Ports & Subsystems/If Action Subsystem/Out1 | R2023a+ | Define an output port for a subsystem or model — use to declare the subsystem interface and pass computed results back to the parent level |
| In1 | do178Lib/Simulink/Ports & Subsystems/Subsystem/In1 | R2023a+ | Define an input port for a subsystem or model — use to declare the subsystem interface and receive signals from the parent level |
| Out1 | do178Lib/Simulink/Ports & Subsystems/Subsystem/Out1 | R2023a+ | Define an output port for a subsystem or model — use to declare the subsystem interface and pass computed results back to the parent level |
| In1 | do178Lib/Simulink/Ports & Subsystems/Triggered Subsystem/In1 | R2023a+ | Define an input port for a subsystem or model — use to declare the subsystem interface and receive signals from the parent level |
| Trigger | do178Lib/Simulink/Ports & Subsystems/Triggered Subsystem/Trigger | R2023a+ | Add a trigger port to a subsystem — use to make the subsystem execute on rising, falling, or either edge of a trigger signal |
| Out1 | do178Lib/Simulink/Ports & Subsystems/Triggered Subsystem/Out1 | R2023a+ | Define an output port for a subsystem or model — use to declare the subsystem interface and pass computed results back to the parent level |
| In1 | do178Lib/Simulink/Ports & Subsystems/Variant Subsystem/In1 | R2023a+ | Define an input port for a subsystem or model — use to declare the subsystem interface and receive signals from the parent level |
| Out1 | do178Lib/Simulink/Ports & Subsystems/Variant Subsystem/Out1 | R2023a+ | Define an output port for a subsystem or model — use to declare the subsystem interface and pass computed results back to the parent level |
| In1 | do178Lib/Simulink/Ports & Subsystems/Variant Subsystem/Subsystem/In1 | R2023a+ | Define an input port for a subsystem or model — use to declare the subsystem interface and receive signals from the parent level |
| Out1 | do178Lib/Simulink/Ports & Subsystems/Variant Subsystem/Subsystem/Out1 | R2023a+ | Define an output port for a subsystem or model — use to declare the subsystem interface and pass computed results back to the parent level |
| In1 | do178Lib/Simulink/Ports & Subsystems/Variant Subsystem/Subsystem1/In1 | R2023a+ | Define an input port for a subsystem or model — use to declare the subsystem interface and receive signals from the parent level |
| Out1 | do178Lib/Simulink/Ports & Subsystems/Variant Subsystem/Subsystem1/Out1 | R2023a+ | Define an output port for a subsystem or model — use to declare the subsystem interface and pass computed results back to the parent level |
| In1 | do178Lib/Simulink/Ports & Subsystems/While Iterator Subsystem/In1 | R2023a+ | Define an input port for a subsystem or model — use to declare the subsystem interface and receive signals from the parent level |
| While Iterator | do178Lib/Simulink/Ports & Subsystems/While Iterator Subsystem/While Iterator | R2023a+ | Repeat subsystem execution until a condition becomes false — use for convergence algorithms or iterative solvers that need a variable number of passes per step |
| Out1 | do178Lib/Simulink/Ports & Subsystems/While Iterator Subsystem/Out1 | R2023a+ | Define an output port for a subsystem or model — use to declare the subsystem interface and pass computed results back to the parent level |
| Out1 | do178Lib/Simulink/Sinks/Out1 | R2023a+ | Define an output port for a subsystem or model — use to declare the subsystem interface and pass computed results back to the parent level |
| In1 | do178Lib/Simulink/Sources/In1 | R2023a+ | Define an input port for a subsystem or model — use to declare the subsystem interface and receive signals from the parent level |
| u | do178Lib/Stateflow/Simulink Function in Chart/foo/u | R2023a+ | Input port inside a Simulink Function template — receives the function argument passed from Stateflow |
| f | do178Lib/Stateflow/Simulink Function in Chart/foo/f | R2023a+ | Trigger port inside a Simulink Function template — activates the function when called from a Stateflow chart action |
| y | do178Lib/Stateflow/Simulink Function in Chart/foo/y | R2023a+ | Output port inside a Simulink Function template — returns the computed result back to the calling Stateflow chart |

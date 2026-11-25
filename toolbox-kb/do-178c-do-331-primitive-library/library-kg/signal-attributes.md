---
type: Simulink Block Category
title: Signal attributes
description: "Type, rate, and attribute handling (10 blocks)"
tags: [toolbox-kb, do-178c-do-331-primitive-library, signal attributes, data type, rate transition, conversion, initial condition, width, unit]
status: draft
sources:
  - resource: matlab:do178Lib
source: toolbox_kb
managed_by: satk
library: DO-178C/DO-331 Primitive Library
kb_folder: do-178c-do-331-primitive-library
category: signal-attributes
block_count: 10
generated: { by: satk-toolbox-build/1, at: "2026-11-23T18:23:17Z" }
---

# Signal attributes

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Data Type Duplicate | do178Lib/Simulink/Signal Attributes/Data Type Duplicate | R2023a+ | Force multiple signals to share the same data type — use to keep interfaces type-consistent. |
| Data Type Conversion | do178Lib/Simulink/Signal Attributes/Data Type Conversion | R2023a+ | Convert a signal to a specified data type — use to set integer/fixed-point type and scaling. |
| IC | do178Lib/Simulink/Signal Attributes/IC | R2023a+ | Set the initial value of a signal for the first time step — use to seed states or feedback at start-up. |
| Probe | do178Lib/Simulink/Signal Attributes/Probe | R2023a+ | Output signal attributes such as width, sample time, complexity, and dimensions — use to inspect properties at runtime. |
| Rate Transition | do178Lib/Simulink/Signal Attributes/Rate Transition | R2023a+ | Safely transfer data between blocks running at different sample rates — use to handle multirate signal hand-off. |
| Signal Conversion | do178Lib/Simulink/Signal Attributes/Signal Conversion | R2023a+ | Convert a signal's storage form (contiguous copy, bus, virtual) — use to satisfy downstream signal requirements. |
| Signal Specification | do178Lib/Simulink/Signal Attributes/Signal Specification | R2023a+ | Assert and enforce a signal's attributes (type, dimensions, sample time) — use to document and check interfaces. |
| Unit Conversion | do178Lib/Simulink/Signal Attributes/Unit Conversion | R2023a+ | Convert a signal between physical units — use to reconcile unit mismatches between components. |
| Width | do178Lib/Simulink/Signal Attributes/Width | R2023a+ | Output the number of elements in the input signal — use to obtain vector width at runtime. |
| Data Type Conversion Inherited | do178Lib/Simulink/Signal Attributes/Data Type Conversion Inherited | R2023a+ | Convert the second input to the data type and scaling of the first input. The conversion has two possible goals. One goal is to have the Real World Values of the input and the output be equal. The other goal is to have the Stored Integer Values of the input and the output be equal. Overflows and quantization errors can prevent the goal from being fully achieved. |

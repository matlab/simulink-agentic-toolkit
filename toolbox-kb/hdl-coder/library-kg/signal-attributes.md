---
type: Simulink Block Category
title: Signal attributes
description: Data type, rate, and signal attribute handling
tags: [data type, rate transition, signal, probe, conversion]
status: stable
source: custom_library
library_root: HDL Coder
category_path: Signal attributes
block_count: 10
---

# Signal attributes

Use these blocks for signal attributes.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Data Type Conversion | hdlsllib/Commonly
Used Blocks/Data Type Conversion | R2023a+ | Convert a signal to a specified data type — use to set integer/fixed-point type and scaling. |
| Data Type Conversion | hdlsllib/HDL Floating Point Operations/Data Type Conversion | R2023a+ | Convert a signal to a specified data type — use to set integer/fixed-point type and scaling. |
| Bus to Vector | hdlsllib/Signal Attributes/Bus to Vector | R2023a+ | Convert a bus of scalars into a single vector — use when downstream blocks need a vector instead of a bus. |
| Data Type Duplicate | hdlsllib/Signal Attributes/Data Type Duplicate | R2023a+ | Force connected signals to share the same data type — use to enforce type consistency. |
| Data Type Propagation | hdlsllib/Signal Attributes/Data Type Propagation | R2023a+ | Propagate a reference signal's data type to another — use to drive types from a template signal. |
| Data Type Conversion | hdlsllib/Signal Attributes/Data Type Conversion | R2023a+ | Convert a signal to a specified data type — use to set integer/fixed-point type and scaling. |
| Probe | hdlsllib/Signal Attributes/Probe | R2023a+ | Report signal attributes such as width, sample time, and complexity at runtime — use to inspect signal properties. |
| Rate Transition | hdlsllib/Signal Attributes/Rate Transition | R2023a+ | Transfer data safely between blocks running at different sample rates — use to handle multirate boundaries. |
| Signal Conversion | hdlsllib/Signal Attributes/Signal Conversion | R2023a+ | Convert signal storage (contiguous copy, virtual/nonvirtual bus) — use to satisfy downstream signal requirements. |
| Signal Specification | hdlsllib/Signal Attributes/Signal Specification | R2023a+ | Assert or specify a signal's attributes (dimensions, type, sample time) — use to enforce an interface contract. |

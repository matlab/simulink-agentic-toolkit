---
type: Simulink Block Category
title: Sources and sinks
description: Constants, inputs, outputs, grounds, and terminators
tags: [constant, inport, outport, ground, terminator]
status: stable
source: mathworks_toolbox
library_root: DO-178C/DO-331 Primitive Library
category_path: Sources and sinks
block_count: 4
---

# Sources and sinks

Use these blocks for sources and sinks.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Terminator | do178Lib/Simulink/Sinks/Terminator | R2023a+ | Absorb an unconnected output signal — use to explicitly mark unused outputs and satisfy DO-178C unconnected-port requirements without generating warnings |
| Constant | do178Lib/Simulink/Sources/Constant | R2023a+ | Output a constant value — use for fixed parameters, calibration values, Boolean flags, or reference setpoints in certified control algorithms |
| Enumerated Constant | do178Lib/Simulink/Sources/Enumerated Constant | R2023a+ | Output a constant value of an enumerated data type — use for mode identifiers, state labels, or typed command values that must match an enumeration definition |
| Ground | do178Lib/Simulink/Sources/Ground | R2023a+ | Provide a zero-valued signal to unconnected input ports — use to explicitly tie unused inputs to zero and satisfy DO-178C unconnected-port requirements |

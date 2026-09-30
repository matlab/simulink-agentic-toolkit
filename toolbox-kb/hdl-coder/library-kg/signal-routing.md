---
type: Simulink Block Category
title: Signal routing
description: Buses, mux/demux, switches, and tagged routing
tags: [bus, mux, demux, goto, from, selector, switch, concatenate]
status: stable
source: custom_library
library_root: HDL Coder
category_path: Signal routing
block_count: 20
---

# Signal routing

Use these blocks for signal routing.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Demux | hdlsllib/Commonly
Used Blocks/Demux | R2023a+ | Split a vector signal into separate scalar or subvector outputs — use to break out combined signals. |
| Mux | hdlsllib/Commonly
Used Blocks/Mux | R2023a+ | Combine separate signals into a single vector — use to bundle signals for compact routing. |
| Switch | hdlsllib/Commonly
Used Blocks/Switch | R2023a+ | Pass one of two inputs based on a control condition — use for conditional signal selection. |
| Deserializer1D | hdlsllib/HDL Operations/Deserializer1D | R2023a+ | Convert from scalar to vector, or from smaller-size vector to larger-size vector. The output rate is S / (Ratio + Idle Cycles), where S is the input rate. |
| Multiply-Add | hdlsllib/HDL Operations/Multiply-Add | R2023a+ | Multiply first two inputs and add result to third input or subtract result from third input. The function option defines the mode of operation. This block is designed for efficient mapping to DSP slices on FPGAs. |
| Serializer1D | hdlsllib/HDL Operations/Serializer1D | R2023a+ | Convert from vector to scalar, or to smaller-size vector. The output rate is V * (Ratio + Idle Cycles), where V is the input rate. |
| Switch Case Action
Subsystem | hdlsllib/Ports &
Subsystems/Switch Case Action
Subsystem | R2023a+ | A subsystem block template containing an action port, inport and outport block. |
| Bus Element In | hdlsllib/Signal
Routing/Bus Element In | R2023a+ | Inport that receives a selected element of a bus at a subsystem boundary — use for cleaner bus-based interfaces. |
| Bus
Assignment | hdlsllib/Signal
Routing/Bus
Assignment | R2023a+ | Replace selected elements of a bus with new signals — use to update specific bus members. |
| Bus
Creator | hdlsllib/Signal
Routing/Bus
Creator | R2023a+ | Combine multiple signals into a bus — use to bundle related signals for routing. |
| Bus
Selector | hdlsllib/Signal
Routing/Bus
Selector | R2023a+ | Extract selected signals from a bus — use to access individual bus members. |
| Demux | hdlsllib/Signal
Routing/Demux | R2023a+ | Split a vector signal into separate scalar or subvector outputs — use to break out combined signals. |
| From | hdlsllib/Signal
Routing/From | R2023a+ | Receive a signal by tag from a matching Goto — use for wireless signal routing. |
| Goto | hdlsllib/Signal
Routing/Goto | R2023a+ | Send a signal by tag to matching From blocks — use for wireless routing to reduce line clutter. |
| Index
Vector | hdlsllib/Signal
Routing/Index
Vector | R2023a+ | Select one of several inputs using an index signal — use as a data-driven selector. |
| Multiport
Switch | hdlsllib/Signal
Routing/Multiport
Switch | R2023a+ | Select one of several data inputs using a control index — use for index-driven routing. |
| Mux | hdlsllib/Signal
Routing/Mux | R2023a+ | Combine separate signals into a single vector — use to bundle signals for compact routing. |
| Selector | hdlsllib/Signal
Routing/Selector | R2023a+ | Select a subset of elements from a signal by index — use to extract specific channels or samples. |
| Switch | hdlsllib/Signal
Routing/Switch | R2023a+ | Pass one of two inputs based on a control condition — use for conditional signal selection. |
| Bus Element Out | hdlsllib/Signal
Routing/Bus Element Out | R2023a+ | Outport that contributes a signal to a bus at a subsystem boundary — use for cleaner bus-based interfaces. |

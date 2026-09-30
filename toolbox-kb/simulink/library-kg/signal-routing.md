---
type: Simulink Block Category
title: Signal routing
description: Buses, switches, data stores, and variants
tags: [bus, mux, goto, from, data store, variant, switch, selector]
status: stable
source: custom_library
library_root: Simulink
category_path: Signal routing
block_count: 33
---

# Signal routing

Use these blocks for signal routing.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Bus
Creator | simulink/Commonly
Used Blocks/Bus
Creator | R2023a+ | Combine multiple signals into a bus — use to bundle related signals for routing. |
| Bus
Selector | simulink/Commonly
Used Blocks/Bus
Selector | R2023a+ | Extract selected signals from a bus — use to access individual bus members. |
| Demux | simulink/Commonly
Used Blocks/Demux | R2023a+ | Split a vector signal into separate scalar or subvector outputs — use to break out combined signals. |
| Mux | simulink/Commonly
Used Blocks/Mux | R2023a+ | Combine separate signals into a single vector — use to bundle signals for compact routing. |
| Switch | simulink/Commonly
Used Blocks/Switch | R2023a+ | Pass one of two inputs based on a control condition — use for conditional signal selection. |
| Bus Element In | simulink/Signal
Routing/Bus Element In | R2023a+ | Inport that receives a selected element of a bus at a subsystem boundary — use for cleaner bus-based interfaces. |
| Bus
Assignment | simulink/Signal
Routing/Bus
Assignment | R2023a+ | Replace selected elements of a bus with new signals — use to update specific bus members. |
| Bus
Creator | simulink/Signal
Routing/Bus
Creator | R2023a+ | Combine multiple signals into a bus — use to bundle related signals for routing. |
| Bus
Selector | simulink/Signal
Routing/Bus
Selector | R2023a+ | Extract selected signals from a bus — use to access individual bus members. |
| Data Store
Memory | simulink/Signal
Routing/Data Store
Memory | R2023a+ | Define a named data store shared across the model — use for global-like state accessed by Read/Write blocks. |
| Data Store
Read | simulink/Signal
Routing/Data Store
Read | R2023a+ | Read the value of a named data store — use to access shared model state. |
| Data Store
Write | simulink/Signal
Routing/Data Store
Write | R2023a+ | Write a value to a named data store — use to update shared model state. |
| Demux | simulink/Signal
Routing/Demux | R2023a+ | Split a vector signal into separate scalar or subvector outputs — use to break out combined signals. |
| From | simulink/Signal
Routing/From | R2023a+ | Receive a signal by tag from a matching Goto — use for wireless signal routing. |
| Goto | simulink/Signal
Routing/Goto | R2023a+ | Send a signal by tag to matching From blocks — use for wireless routing to reduce line clutter. |
| Goto Tag
Visibility | simulink/Signal
Routing/Goto Tag
Visibility | R2023a+ | Define the visibility scope of a Goto tag — use to control where a tagged signal is accessible. |
| Index
Vector | simulink/Signal
Routing/Index
Vector | R2023a+ | Select one of several inputs using an index signal — use as a data-driven selector. |
| Manual Switch | simulink/Signal
Routing/Manual Switch | R2023a+ | Toggle between two inputs by clicking during simulation — use for interactive signal selection. |
| Merge | simulink/Signal
Routing/Merge | R2023a+ | Combine multiple conditionally-executed inputs into one output — use to merge outputs of enabled subsystems. |
| Multiport
Switch | simulink/Signal
Routing/Multiport
Switch | R2023a+ | Select one of several data inputs using a control index — use for index-driven routing. |
| Mux | simulink/Signal
Routing/Mux | R2023a+ | Combine separate signals into a single vector — use to bundle signals for compact routing. |
| Parameter Writer | simulink/Signal
Routing/Parameter Writer | R2023a+ | Write a value to a block parameter at runtime — use to change parameters programmatically during simulation. |
| Selector | simulink/Signal
Routing/Selector | R2023a+ | Select a subset of elements from a signal by index — use to extract specific channels or samples. |
| State Reader | simulink/Signal
Routing/State Reader | R2023a+ | Read the internal state of another block at runtime — use to observe or reuse block state. |
| State Writer | simulink/Signal
Routing/State Writer | R2023a+ | Write the internal state of another block at runtime — use to reset or set block state. |
| Switch | simulink/Signal
Routing/Switch | R2023a+ | Pass one of two inputs based on a control condition — use for conditional signal selection. |
| Two-Way
Connection | simulink/Signal
Routing/Two-Way
Connection | R2023a+ | Establish a bidirectional connection between components — use for two-way signal/data exchange. |
| Variant End | simulink/Signal
Routing/Variant End | R2024a+ | Mark the end of a variant region in the diagram — use to close a Variant Start region. |
| Variant Sink | simulink/Signal
Routing/Variant Sink | R2023a+ | Select among alternative downstream paths based on variant conditions — use to switch outputs by variant. |
| Variant Source | simulink/Signal
Routing/Variant Source | R2023a+ | Select among alternative upstream sources based on variant conditions — use to switch inputs by variant. |
| Variant Start | simulink/Signal
Routing/Variant Start | R2024a+ | Mark the start of a variant region in the diagram — use to bound a set of variant choices. |
| Connection Port | simulink/Signal
Routing/Connection Port | R2023a+ | Physical (Simscape) connection port on a subsystem boundary — use to expose a physical connection. |
| Bus Element Out | simulink/Signal
Routing/Bus Element Out | R2023a+ | Outport that contributes a signal to a bus at a subsystem boundary — use for cleaner bus-based interfaces. |

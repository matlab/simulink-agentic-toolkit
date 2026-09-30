---
type: Simulink Block Category
title: Signal routing
description: Buses, mux/demux, switches, and data stores
tags: [signal routing, bus, mux, demux, goto, from, switch, merge, selector, data store]
status: stable
source: custom_library
library_root: DO-178C/DO-331 Primitive Library
category_path: Signal routing
block_count: 15
---

# Signal routing

Use these blocks for signal routing.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Bus Assignment | do178Lib/Simulink/Signal Routing/Bus Assignment | R2023a+ | Replace selected elements of a bus with new values — use to update specific bus signals. |
| Bus Creator | do178Lib/Simulink/Signal Routing/Bus Creator | R2023a+ | Bundle multiple signals into a bus — use to group related signals into a single line. |
| Bus Selector | do178Lib/Simulink/Signal Routing/Bus Selector | R2023a+ | Extract selected signals from a bus — use to access individual members of a bus. |
| Data Store Memory | do178Lib/Simulink/Signal Routing/Data Store Memory | R2023a+ | Define a named shared memory region — use for data shared across subsystems without wires. |
| Data Store Read | do178Lib/Simulink/Signal Routing/Data Store Read | R2023a+ | Read the current value of a data store — use to consume shared data. |
| Data Store Write | do178Lib/Simulink/Signal Routing/Data Store Write | R2023a+ | Write a value into a data store — use to publish shared data. |
| Demux | do178Lib/Simulink/Signal Routing/Demux | R2023a+ | Split a vector signal into separate scalar/subvector lines — use to break out combined signals. |
| From | do178Lib/Simulink/Signal Routing/From | R2023a+ | Receive a signal from a matching Goto tag — use for wireless routing to reduce diagram clutter. |
| Goto | do178Lib/Simulink/Signal Routing/Goto | R2023a+ | Send a signal to matching From blocks via a tag — use for wireless routing to reduce diagram clutter. |
| Merge | do178Lib/Simulink/Signal Routing/Merge | R2023a+ | Combine multiple conditionally-executed inputs into one output — use to merge outputs of mutually-exclusive subsystems. |
| Multiport Switch | do178Lib/Simulink/Signal Routing/Multiport Switch | R2023a+ | Route one of several data inputs to the output based on a control index — use for index-selected multiplexing. |
| Mux | do178Lib/Simulink/Signal Routing/Mux | R2023a+ | Combine several signals into a single vector line — use to bundle scalars for compact routing. |
| Selector | do178Lib/Simulink/Signal Routing/Selector | R2023a+ | Select a subset of elements from a signal by index — use to extract specific channels or samples. |
| Switch | do178Lib/Simulink/Signal Routing/Switch | R2023a+ | Pass one of two inputs based on a control threshold — use for conditional signal selection. |
| Vector Concatenate | do178Lib/Simulink/Signal Routing/Vector Concatenate | R2023a+ | Concatenate inputs into a larger vector or matrix — use to assemble composite signals. |

---
type: Simulink Block Category
title: Signal routing
description: Buses, muxing, switching, data stores, and signal routing
tags: [bus, mux, switch, goto, routing]
status: stable
source: mathworks_toolbox
library_root: DO-178C/DO-331 Primitive Library
category_path: Signal routing
block_count: 15
---

# Signal routing

Use these blocks for signal routing.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Bus Assignment | do178Lib/Simulink/Signal Routing/Bus Assignment | R2023a+ | Replace selected elements in a bus signal — use to update specific fields of a structured data bus while preserving all other elements unchanged |
| Bus Creator | do178Lib/Simulink/Signal Routing/Bus Creator | R2023a+ | Bundle multiple signals into a single bus — use to group related signals into a structured interface for cleaner routing and subsystem boundaries |
| Bus Selector | do178Lib/Simulink/Signal Routing/Bus Selector | R2023a+ | Extract selected elements from a bus signal — use to access specific fields from a structured data bus at subsystem inputs or processing stages |
| Data Store Memory | do178Lib/Simulink/Signal Routing/Data Store Memory | R2023a+ | Define a named shared memory region accessible across the model — use for global state variables, mode flags, or inter-subsystem communication without explicit signal wiring |
| Data Store Read | do178Lib/Simulink/Signal Routing/Data Store Read | R2023a+ | Read a value from a named Data Store Memory — use to access shared state from any subsystem without routing a signal wire through the hierarchy |
| Data Store Write | do178Lib/Simulink/Signal Routing/Data Store Write | R2023a+ | Write a value to a named Data Store Memory — use to update shared state from any subsystem, enabling decoupled communication between model components |
| Demux | do178Lib/Simulink/Signal Routing/Demux | R2023a+ | Split a vector signal into individual scalar or sub-vector outputs — use to separate multiplexed channels for individual processing or routing |
| From | do178Lib/Simulink/Signal Routing/From | R2023a+ | Receive a signal from a matching Goto block without a physical wire — use to reduce diagram clutter for signals that must reach distant parts of the model |
| Goto | do178Lib/Simulink/Signal Routing/Goto | R2023a+ | Send a signal to matching From blocks without a physical wire — use to broadcast a signal to multiple destinations while keeping the diagram clean |
| Merge | do178Lib/Simulink/Signal Routing/Merge | R2023a+ | Combine outputs from conditionally executed subsystems into one signal — use when exactly one of several mutually exclusive subsystems writes to a shared output at each step |
| Multiport Switch | do178Lib/Simulink/Signal Routing/Multiport Switch | R2023a+ | Select one of N data inputs based on an integer control signal — use for indexed selection, mode-dependent routing, or state-machine output multiplexing |
| Mux | do178Lib/Simulink/Signal Routing/Mux | R2023a+ | Combine multiple scalar or vector signals into a single vector — use to aggregate parallel channels into one signal line for compact routing or array processing |
| Selector | do178Lib/Simulink/Signal Routing/Selector | R2023a+ | Extract specific elements from a vector, matrix, or multidimensional signal by index — use for channel selection, subarray extraction, or picking specific components |
| Switch | do178Lib/Simulink/Signal Routing/Switch | R2023a+ | Select between two data inputs based on a Boolean or threshold condition — use for if-then-else logic, failover selection, or conditional signal routing |
| Vector Concatenate | do178Lib/Simulink/Signal Routing/Vector Concatenate | R2023a+ | Join multiple signals end-to-end into a longer vector — use for assembling output arrays, building message payloads, or combining separately computed segments |

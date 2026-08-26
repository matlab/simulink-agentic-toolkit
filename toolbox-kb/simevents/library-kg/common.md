---
type: Block Selection Guide
title: Common Blocks
description: High-value blocks selected for quick agent discovery.
status: stable
source: mathworks_toolbox
block_count: 6
---

# Common Blocks

Prefer these blocks when their intent matches the user request.

| Intent | Preferred Block | Library |
|---|---|---|
| Open or close entity flow based on a signal — use for modeling doors, valves, or conditional access points in entity networks | Entity Gate | SimEvents |
| Create entities at specified rates or times — use for modeling arrivals of customers, parts, or packets entering a system | Entity Generator | SimEvents |
| Buffer entities in FIFO, LIFO, or priority order — use for modeling waiting lines, buffers, or inventory storage | Entity Queue | SimEvents |
| Process entities with configurable service time — use for modeling workstations, processors, or service desks that hold entities during processing | Entity Server | SimEvents |
| Remove entities from the simulation — use for modeling system exits where entities leave permanently | Entity Terminator | SimEvents |
| Define a pool of shared resources — use for configuring the total supply of machines, workers, or other limited resources | Resource Pool | SimEvents |

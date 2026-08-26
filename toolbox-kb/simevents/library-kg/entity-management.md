---
type: Simulink Block Category
title: Entity management
description: Entity creation, storage, batching, and termination
tags: [generator, queue, server, store, batch]
status: stable
source: mathworks_toolbox
library_root: SimEvents
category_path: Entity management
block_count: 12
---

# Entity management

Use these blocks for entity management.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Composite Entity Creator | sldelib/Composite Entity Creator | R2023a+ | Bundle multiple entities into a single composite entity — use for modeling assemblies, kits, or grouped items moving together |
| Composite Entity Splitter | sldelib/Composite Entity Splitter | R2023a+ | Split a composite entity back into individual entities — use for disassembly or unpacking operations in manufacturing or logistics |
| Entity Batch Creator | sldelib/Entity Batch Creator | R2023a+ | Collect entities into fixed-size batches — use for modeling palletizing, packaging, or batch processing operations |
| Entity Batch Splitter | sldelib/Entity Batch Splitter | R2023a+ | Split a batch entity into individual entities — use for modeling depalletizing or batch unpacking operations |
| Entity Find | sldelib/Entity Find | R2023a+ | Search for entities matching criteria in a store — use for locating specific items in warehouses or buffers by attribute value |
| Entity Generator | sldelib/Entity Generator | R2023a+ | Create entities at specified rates or times — use for modeling arrivals of customers, parts, or packets entering a system |
| Entity Queue | sldelib/Entity Queue | R2023a+ | Buffer entities in FIFO, LIFO, or priority order — use for modeling waiting lines, buffers, or inventory storage |
| Entity Replicator | sldelib/Entity Replicator | R2023a+ | Create copies of an entity — use for modeling document copying, message broadcasting, or parallel processing splits |
| Entity Selector | sldelib/Entity Selector | R2023a+ | Select specific entities from a set based on criteria — use for cherry-picking items from queues or stores by attribute |
| Entity Server | sldelib/Entity Server | R2023a+ | Process entities with configurable service time — use for modeling workstations, processors, or service desks that hold entities during processing |
| Entity Store | sldelib/Entity Store | R2023a+ | Store entities in an unordered collection — use for modeling warehouses, parking lots, or pools where order does not matter |
| Entity Terminator | sldelib/Entity Terminator | R2023a+ | Remove entities from the simulation — use for modeling system exits where entities leave permanently |

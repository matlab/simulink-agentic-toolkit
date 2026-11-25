---
type: Simulink Block Category
title: Entity flow
description: "Entity routing, switching, and transport (6 blocks)"
tags: [toolbox-kb, simevents, switch, gate, transport, conveyor, route]
status: stable
sources:
  - resource: matlab:sldelib
source: toolbox_kb
managed_by: satk
library: SimEvents
kb_folder: simevents
category: entity-flow
block_count: 6
generated: { by: satk-toolbox-build/1, at: "2026-11-23T18:23:28Z" }
---

# Entity flow

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Conveyor System | sldelib/Conveyor System | R2023a+ | Model a physical conveyor with transport delay — use for simulating material movement on belts or rollers with spatial dynamics |
| Entity Input Switch | sldelib/Entity Input Switch | R2023a+ | Route entities from multiple inputs to a single output — use for merging entity streams from parallel paths |
| Entity Output Switch | sldelib/Entity Output Switch | R2023a+ | Route entities from a single input to multiple outputs — use for splitting entity flow based on conditions or round-robin logic |
| Entity Transport Delay | sldelib/Entity Transport Delay | R2023a+ | Delay entity flow by a specified time — use for modeling transit time through pipes, corridors, or communication channels |
| Entity Gate | sldelib/Entity Gate | R2023a+ | Open or close entity flow based on a signal — use for modeling doors, valves, or conditional access points in entity networks |
| Entity Multicast | sldelib/Entity Multicast | R2023a+ | Send an entity to all connected outputs simultaneously — use for broadcasting events or duplicating items to multiple destinations |

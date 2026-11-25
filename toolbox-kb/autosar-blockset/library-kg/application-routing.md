---
type: Simulink Block Category
title: Application routing
description: Inter-runnable communication and event-driven data exchange between AUTOSAR software components (2 blocks)
tags: [toolbox-kb, autosar-blockset, event, send, receive, routing, communication]
status: stable
sources:
  - resource: matlab:autosarlibaprouting
source: toolbox_kb
managed_by: satk
library: AUTOSAR Blockset
kb_folder: autosar-blockset
category: application-routing
block_count: 2
generated: { by: satk-toolbox-build/1, at: "2026-11-23T18:23:12Z" }
---

# Application routing

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Event Receive | autosarlibaprouting/Event Receive | R2023a+ | Receive asynchronous events from other AUTOSAR software components — use for inter-runnable triggered communication where data arrives on-demand rather than periodically |
| Event Send | autosarlibaprouting/Event Send | R2023a+ | Send asynchronous events to other AUTOSAR software components — use to trigger runnables or notify subscribers of state changes |

---
type: Simulink Block Category
title: Application routing
description: Inter-runnable communication and event-driven data exchange between AUTOSAR software components
tags: [event, send, receive, routing, communication]
status: stable
source: mathworks_toolbox
library_root: AUTOSAR Blockset
category_path: Application routing
block_count: 2
---

# Application routing

Use these blocks for application routing.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Event Receive | autosarlibaprouting/Event Receive | R2023a+ | Receive asynchronous events from other AUTOSAR software components — use for inter-runnable triggered communication where data arrives on-demand rather than periodically |
| Event Send | autosarlibaprouting/Event Send | R2023a+ | Send asynchronous events to other AUTOSAR software components — use to trigger runnables or notify subscribers of state changes |

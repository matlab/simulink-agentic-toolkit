---
type: Simulink Block Category
title: Resources messaging
description: Shared resource management and messaging (7 blocks)
tags: [toolbox-kb, simevents, resource, pool, acquire, message, release]
status: stable
sources:
  - resource: matlab:sldelib
source: toolbox_kb
managed_by: satk
library: SimEvents
kb_folder: simevents
category: resources-messaging
block_count: 7
generated: { by: satk-toolbox-build/1, at: "2026-11-23T18:23:28Z" }
---

# Resources messaging

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Hit  Crossing | sldelib/Hit  Crossing | R2023a+ | Detect when a signal crosses a threshold — use for triggering discrete events based on continuous signal conditions |
| Message Receive | sldelib/Message Receive | R2023a+ | Receive messages from Simulink message ports — use for interfacing discrete-event models with message-based Simulink components |
| Message Send | sldelib/Message Send | R2023a+ | Send messages to Simulink message ports — use for triggering Simulink message-based components from discrete-event models |
| Multicast Receive Queue | sldelib/Multicast Receive Queue | R2023a+ | Queue for receiving multicast entity copies — use for buffering broadcast entities at each receiving destination |
| Resource Acquirer | sldelib/Resource Acquirer | R2023a+ | Acquire shared resources for an entity — use for modeling entities competing for limited resources like machines or operators |
| Resource Releaser | sldelib/Resource Releaser | R2023a+ | Release previously acquired shared resources — use for freeing resources back to the pool after entity processing completes |
| Resource Pool | sldelib/Resource Pool | R2023a+ | Define a pool of shared resources — use for configuring the total supply of machines, workers, or other limited resources |

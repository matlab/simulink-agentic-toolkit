---
type: Simulink Block Category
title: Messages events
description: Message passing, queues, and event scheduling
tags: [message, queue, send, receive, event, hit crossing]
status: stable
source: custom_library
library_root: Simulink
category_path: Messages events
block_count: 7
---

# Messages events

Use these blocks for messages events.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Hit Crossing Probe | simulink/Messages & Events/Hit Crossing Probe | R2023a+ | Report when a signal crosses a value as an event/probe — use to observe zero/level crossings. |
| Hit Scheduler | simulink/Messages & Events/Hit Scheduler | R2023a+ | Schedule solver hits at specified times — use to force sample points for events. |
| Message Merge | simulink/Messages & Events/Message Merge | R2023a+ | Merge multiple message paths into one — use to combine message streams. |
| Queue | simulink/Messages & Events/Queue | R2023a+ | Buffer messages/entities in a FIFO (or priority) queue — use to model waiting lines or decouple producers/consumers. |
| Receive | simulink/Messages & Events/Receive | R2023a+ | Receive a message from a queue/message line — use to consume messages in event-driven models. |
| Send | simulink/Messages & Events/Send | R2023a+ | Send a message onto a message line — use to produce messages in event-driven models. |
| Sequence Viewer | simulink/Messages & Events/Sequence Viewer | R2023a+ | Visualize message/event and function-call activity over time — use to debug event sequencing. |

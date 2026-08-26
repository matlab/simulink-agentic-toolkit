---
type: Simulink Block Category
title: Task scheduling
description: Task management, scheduling, triggering, and interrupt-driven execution
tags: [task, scheduler, trigger, interrupt, priority, manager]
status: stable
source: mathworks_toolbox
library_root: SoC Blockset
category_path: Task scheduling
block_count: 5
---

# Task scheduling

Use these blocks for task scheduling.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Hardware Interrupt | proctasklib/Hardware Interrupt | R2024b+ | Trigger a processor task from a hardware interrupt event |
| Proxy Task | proctasklib/Proxy Task | R2023a+ | Represent an external task that interacts with the modeled SoC tasks |
| Task Manager | proctasklib/Task Manager | R2023a+ | Schedule and manage multiple processor tasks with priorities and timing |
| Task Trigger | proctasklib/Task Trigger | R2023b+ | Trigger execution of a processor task based on a timer or event |
| Task Trigger Merge | proctasklib/Task Trigger Merge | R2023b+ | Combine multiple trigger sources into a single task activation signal |

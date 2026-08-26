---
type: Simulink Block Category
title: Multicore
description: Multi-core scheduling and inter-processor communication
tags: [task, core, interprocess, schedule, multicore]
status: stable
source: mathworks_toolbox
library_root: Embedded Coder Support Package for Infineon AURIX TC4x
category_path: Multicore
block_count: 3
---

# Multicore

Use these blocks for multicore.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Task Manager | aurixtc4xlib/Scheduling/Task Manager | R2024b+ | Configure multi-core task scheduling on AURIX TC4x — use for assigning and managing real-time tasks across multiple CPU cores |
| Interprocess Data Read | aurixtc4xlib/Target Communication/Interprocess Data Read | R2024b+ | Read shared data between CPU cores on AURIX TC4x — use for receiving variables published by tasks running on other cores |
| Interprocess Data Write | aurixtc4xlib/Target Communication/Interprocess Data Write | R2024b+ | Write shared data between CPU cores on AURIX TC4x — use for publishing variables to tasks running on other cores |

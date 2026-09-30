---
type: Simulink Block Category
title: Scheduling
description: Map model rates to OS tasks on the multicore target
tags: [task, scheduling, rate, core]
status: stable
source: custom_library
library_root: Embedded Coder Support Package for AURIX TC4x
category_path: Scheduling
block_count: 1
---

# Scheduling

Use these blocks for scheduling.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Task Manager | aurixtc4xlib/Scheduling/Task Manager | R2024b+ | Define and schedule the tasks (rates, cores, priorities) that generated code runs on the AURIX TC4x multicore target — use to map model rates to OS tasks for deployment. |

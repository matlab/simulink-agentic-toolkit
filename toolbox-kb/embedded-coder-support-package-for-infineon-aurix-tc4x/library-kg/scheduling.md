---
type: Simulink Block Category
title: Scheduling
description: Map model rates to OS tasks on the multicore target (1 blocks)
tags: [toolbox-kb, embedded-coder-support-package-for-infineon-aurix-tc4x, task, scheduling, rate, core]
status: stable
sources:
  - resource: matlab:aurixtc4xlib
source: toolbox_kb
managed_by: satk
library: Embedded Coder Support Package for Infineon AURIX TC4x
kb_folder: embedded-coder-support-package-for-infineon-aurix-tc4x
category: scheduling
block_count: 1
generated: { by: satk-toolbox-build/1, at: "2026-11-23T18:23:21Z" }
---

# Scheduling

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Task Manager | aurixtc4xlib/Scheduling/Task Manager | R2024b+ | Define and schedule the tasks (rates, cores, priorities) that generated code runs on the AURIX TC4x multicore target — use to map model rates to OS tasks for deployment. |

---
type: Simulink Block Category
title: Memory
description: Memory and register access (3 blocks)
tags: [toolbox-kb, c2000-microcontroller-blockset, memory, register, allocate, copy]
status: stable
sources:
  - resource: matlab:c2000lib
source: toolbox_kb
managed_by: satk
library: C2000 Microcontroller Blockset
kb_folder: c2000-microcontroller-blockset
category: memory
block_count: 3
generated: { by: satk-toolbox-build/1, at: "2026-11-23T18:23:15Z" }
---

# Memory

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Memory Allocate | c2000lib/Memory Operations/Memory Allocate | R2023a+ | Allocate a block of memory in the generated code — use to reserve buffers or place data in specific memory. |
| Memory Copy | c2000lib/Memory Operations/Memory Copy | R2023a+ | Copy data between memory locations — use to move buffers or access mapped registers/memory. |
| Register ReadWrite | c2000lib/Memory Operations/Register ReadWrite | R2024a+ | Read from or write to a hardware register directly — use for low-level peripheral register access. |

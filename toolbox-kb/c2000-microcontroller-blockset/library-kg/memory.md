---
type: Simulink Block Category
title: Memory
description: Memory and register access
tags: [memory, register, allocate, copy]
status: stable
source: custom_library
library_root: C2000 Microcontroller Blockset
category_path: Memory
block_count: 3
---

# Memory

Use these blocks for memory.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Memory Allocate | c2000lib/Memory Operations/Memory Allocate | R2023a+ | Allocate a block of memory in the generated code — use to reserve buffers or place data in specific memory. |
| Memory Copy | c2000lib/Memory Operations/Memory Copy | R2023a+ | Copy data between memory locations — use to move buffers or access mapped registers/memory. |
| Register ReadWrite | c2000lib/Memory Operations/Register ReadWrite | R2024a+ | Read from or write to a hardware register directly — use for low-level peripheral register access. |

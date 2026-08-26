---
type: Simulink Block Category
title: Memory register
description: Direct memory and register access for DMA, shared memory, and custom peripheral interfacing
tags: [memory, register, dma, allocate, copy]
status: stable
source: mathworks_toolbox
library_root: C2000 Microcontroller Blockset
category_path: Memory register
block_count: 3
---

# Memory register

Use these blocks for memory register.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Memory Allocate | c2000lib/Memory Operations/Memory Allocate | R2023a+ | Allocate a block of memory at a specified address — use to reserve DMA buffers, shared memory regions, or peripheral-mapped memory for real-time data transfer |
| Memory Copy | c2000lib/Memory Operations/Memory Copy | R2023a+ | Copy data between memory regions using DMA or CPU — use for bulk data transfer between peripheral buffers and processing memory without CPU blocking |
| Register ReadWrite | c2000lib/Memory Operations/Register ReadWrite | R2024a+ | Directly read or write a hardware register at a specified memory-mapped address — use to access peripheral registers not covered by dedicated blockset blocks or for custom hardware interfacing |

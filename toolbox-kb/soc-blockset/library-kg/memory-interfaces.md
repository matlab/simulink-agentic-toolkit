---
type: Simulink Block Category
title: Memory interfaces
description: "Shared memory, DMA, registers, and interrupt channels between FPGA and processor (8 blocks)"
tags: [toolbox-kb, soc-blockset, memory, DDR, DMA, register, interrupt, AXI4]
status: stable
sources:
  - resource: matlab:socmemlib
source: toolbox_kb
managed_by: satk
library: SoC Blockset
kb_folder: soc-blockset
category: memory-interfaces
block_count: 8
generated: { by: satk-toolbox-build/1, at: "2026-11-23T18:23:35Z" }
---

# Memory interfaces

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| AXI4 Random Access Memory | socmemlib/AXI4 Random Access Memory | R2023a+ | Model shared DDR memory accessible by FPGA logic and processor via AXI4 interface |
| AXI4 Video Frame Buffer | socmemlib/AXI4 Video Frame Buffer | R2023a+ | Model a video frame buffer in shared memory for FPGA-to-processor video transfer |
| AXI4-Stream to Software | socmemlib/AXI4-Stream to Software | R2023a+ | Transfer streaming data from FPGA logic to processor software via DMA |
| IP Core Register Read | socmemlib/IP Core Register Read | R2023a+ | Read a memory-mapped register exposed by an FPGA IP core from processor software |
| Interrupt Channel | socmemlib/Interrupt Channel | R2023a+ | Model a hardware interrupt line from FPGA logic to the processor |
| Memory Traffic Generator | socmemlib/Memory Traffic Generator | R2023a+ | Simulate background memory traffic to model realistic DDR bandwidth contention |
| Register Channel | socmemlib/Register Channel | R2023a+ | Model a memory-mapped register channel between FPGA logic and processor software |
| Software to AXI4-Stream | socmemlib/Software to AXI4-Stream | R2023a+ | Transfer data from processor software to FPGA logic via DMA streaming |

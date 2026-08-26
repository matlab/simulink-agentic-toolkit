---
type: Block Selection Guide
title: Common Blocks
description: High-value blocks selected for quick agent discovery.
status: stable
source: mathworks_toolbox
block_count: 11
---

# Common Blocks

Prefer these blocks when their intent matches the user request.

| Intent | Preferred Block | Library |
|---|---|---|
| Connect AXI4-Stream interfaces between FPGA logic and processor subsystems | Stream Connector | SoC Blockset |
| Model shared DDR memory accessible by FPGA logic and processor via AXI4 interface | AXI4 Random Access Memory | SoC Blockset |
| Transfer streaming data from FPGA logic to processor software via DMA | AXI4-Stream to Software | SoC Blockset |
| Model a hardware interrupt line from FPGA logic to the processor | Interrupt Channel | SoC Blockset |
| Transfer data from processor software to FPGA logic via DMA streaming | Software to AXI4-Stream | SoC Blockset |
| Read a value from a memory-mapped hardware register in processor software | Register Read | SoC Blockset |
| Write a value to a memory-mapped hardware register from processor software | Register Write | SoC Blockset |
| Read streaming data from FPGA logic via DMA in processor software | Stream Read | SoC Blockset |
| Write streaming data to FPGA logic via DMA from processor software | Stream Write | SoC Blockset |
| Trigger a processor task from a hardware interrupt event | Hardware Interrupt | SoC Blockset |
| Schedule and manage multiple processor tasks with priorities and timing | Task Manager | SoC Blockset |

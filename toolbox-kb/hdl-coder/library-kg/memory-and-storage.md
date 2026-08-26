---
type: Simulink Block Category
title: Memory and storage
description: RAM blocks and FIFO buffers for on-chip data storage in HDL
tags: [RAM, FIFO, memory, storage, buffer]
status: stable
source: mathworks_toolbox
library_root: HDL Coder
category_path: Memory and storage
block_count: 11
---

# Memory and storage

Use these blocks for memory and storage.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Dual Port RAM | hdlsllib/HDL RAMs/Dual Port RAM | R2023a+ | Use when you need simultaneous read and write access to shared memory in HDL |
| Dual Rate Dual Port RAM | hdlsllib/HDL RAMs/Dual Rate Dual Port RAM | R2023a+ | Use when you need dual-port RAM operating at two different clock rates in HDL |
| HDL FIFO | hdlsllib/HDL RAMs/HDL FIFO | R2023a+ | Use when you need a first-in-first-out buffer for rate matching or data queuing in hardware |
| Simple Dual Port RAM | hdlsllib/HDL RAMs/Simple Dual Port RAM | R2023a+ | Use when you need one write port and one read port accessing separate addresses in HDL |
| Single Port RAM | hdlsllib/HDL RAMs/Single Port RAM | R2023a+ | Use when you need basic read-write memory with a single address port in HDL |
| Memory | hdlsllib/Discrete/Memory | R2023a+ | Use when you need to hold the previous sample value with one time-step delay |
| Dual Port RAM System | hdlsllib/HDL RAMs/Dual Port RAM System | R2023a+ | Use when you need a System object based dual-port RAM with HDL code generation support |
| Simple Dual Port RAM System | hdlsllib/HDL RAMs/Simple Dual Port RAM System | R2023a+ | Use when you need a System object based simple dual-port RAM for HDL code generation |
| Simple Tri Port RAM System | hdlsllib/HDL RAMs/Simple Tri Port RAM System | R2023a+ | Use when you need a System object based triple-port RAM for HDL code generation |
| Single Port RAM System | hdlsllib/HDL RAMs/Single Port RAM System | R2023a+ | Use when you need a System object based single-port RAM for HDL code generation |
| True Dual Port RAM System | hdlsllib/HDL RAMs/True Dual Port RAM System | R2023a+ | Use when you need a System object based true dual-port RAM with independent read-write on both ports |

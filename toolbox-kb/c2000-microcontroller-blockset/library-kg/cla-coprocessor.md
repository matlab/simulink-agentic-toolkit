---
type: Simulink Block Category
title: Cla coprocessor
description: Control Law Accelerator coprocessor for offloading real-time math from the main CPU
tags: [cla, coprocessor, accelerator, offload, parallel]
status: stable
source: mathworks_toolbox
library_root: C2000 Microcontroller Blockset
category_path: Cla coprocessor
block_count: 35
---

# Cla coprocessor

Use these blocks for cla coprocessor.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| CLA Math | c2803xlib/CLA Math | R2023a+ | Perform fixed-point or floating-point math operations on the Control Law Accelerator — use to offload computation-intensive control math from the main CPU for faster loop execution |
| CLA Subsystem | c2803xlib/CLA Subsystem | R2023a+ | Define a subsystem that executes on the Control Law Accelerator coprocessor — use to partition time-critical control algorithms onto the CLA for parallel execution with the main CPU |
| CLA Task | c2803xlib/CLA Task | R2023a+ | Define a single CLA task triggered by a hardware event — use to implement one control law computation that runs on the CLA independently of the main CPU |
| CLA Math | c2805xlib/CLA Math | R2023a+ | Perform fixed-point or floating-point math operations on the Control Law Accelerator — use to offload computation-intensive control math from the main CPU for faster loop execution |
| CLA Subsystem | c2805xlib/CLA Subsystem | R2023a+ | Define a subsystem that executes on the Control Law Accelerator coprocessor — use to partition time-critical control algorithms onto the CLA for parallel execution with the main CPU |
| CLA Task | c2805xlib/CLA Task | R2023a+ | Define a single CLA task triggered by a hardware event — use to implement one control law computation that runs on the CLA independently of the main CPU |
| CLA Subsystem | c2806xlib/CLA Subsystem | R2023a+ | Define a subsystem that executes on the Control Law Accelerator coprocessor — use to partition time-critical control algorithms onto the CLA for parallel execution with the main CPU |
| CLA Math | c2806xlib/CLA Math | R2023a+ | Perform fixed-point or floating-point math operations on the Control Law Accelerator — use to offload computation-intensive control math from the main CPU for faster loop execution |
| CLA Task | c2806xlib/CLA Task | R2023a+ | Define a single CLA task triggered by a hardware event — use to implement one control law computation that runs on the CLA independently of the main CPU |
| CLA Math | c28003xlib/CLA Math | R2023a+ | Perform fixed-point or floating-point math operations on the Control Law Accelerator — use to offload computation-intensive control math from the main CPU for faster loop execution |
| CLA Subsystem | c28003xlib/CLA Subsystem | R2023a+ | Define a subsystem that executes on the Control Law Accelerator coprocessor — use to partition time-critical control algorithms onto the CLA for parallel execution with the main CPU |
| CLA Task | c28003xlib/CLA Task | R2023a+ | Define a single CLA task triggered by a hardware event — use to implement one control law computation that runs on the CLA independently of the main CPU |
| CLA Math | c28004xlib/CLA Math | R2023a+ | Perform fixed-point or floating-point math operations on the Control Law Accelerator — use to offload computation-intensive control math from the main CPU for faster loop execution |
| CLA Subsystem | c28004xlib/CLA Subsystem | R2023a+ | Define a subsystem that executes on the Control Law Accelerator coprocessor — use to partition time-critical control algorithms onto the CLA for parallel execution with the main CPU |
| CLA Task | c28004xlib/CLA Task | R2023a+ | Define a single CLA task triggered by a hardware event — use to implement one control law computation that runs on the CLA independently of the main CPU |
| CLA Math | c2807xlib/CLA Math | R2023a+ | Perform fixed-point or floating-point math operations on the Control Law Accelerator — use to offload computation-intensive control math from the main CPU for faster loop execution |
| CLA Subsystem | c2807xlib/CLA Subsystem | R2023a+ | Define a subsystem that executes on the Control Law Accelerator coprocessor — use to partition time-critical control algorithms onto the CLA for parallel execution with the main CPU |
| CLA Task | c2807xlib/CLA Task | R2023a+ | Define a single CLA task triggered by a hardware event — use to implement one control law computation that runs on the CLA independently of the main CPU |
| CLA Math | c2837xDlib/CLA Math | R2023a+ | Perform fixed-point or floating-point math operations on the Control Law Accelerator — use to offload computation-intensive control math from the main CPU for faster loop execution |
| CLA Subsystem | c2837xDlib/CLA Subsystem | R2023a+ | Define a subsystem that executes on the Control Law Accelerator coprocessor — use to partition time-critical control algorithms onto the CLA for parallel execution with the main CPU |
| CLA Task | c2837xDlib/CLA Task | R2023a+ | Define a single CLA task triggered by a hardware event — use to implement one control law computation that runs on the CLA independently of the main CPU |
| CLA Math | c2837xSlib/CLA Math | R2023a+ | Perform fixed-point or floating-point math operations on the Control Law Accelerator — use to offload computation-intensive control math from the main CPU for faster loop execution |
| CLA Subsystem | c2837xSlib/CLA Subsystem | R2023a+ | Define a subsystem that executes on the Control Law Accelerator coprocessor — use to partition time-critical control algorithms onto the CLA for parallel execution with the main CPU |
| CLA Task | c2837xSlib/CLA Task | R2023a+ | Define a single CLA task triggered by a hardware event — use to implement one control law computation that runs on the CLA independently of the main CPU |
| CLA Math | c2838xlib/CLA Math | R2023a+ | Perform fixed-point or floating-point math operations on the Control Law Accelerator — use to offload computation-intensive control math from the main CPU for faster loop execution |
| CLA Subsystem | c2838xlib/CLA Subsystem | R2023a+ | Define a subsystem that executes on the Control Law Accelerator coprocessor — use to partition time-critical control algorithms onto the CLA for parallel execution with the main CPU |
| CLA Task | c2838xlib/CLA Task | R2023a+ | Define a single CLA task triggered by a hardware event — use to implement one control law computation that runs on the CLA independently of the main CPU |
| CLA Subsystem | c28P55xlib/CLA Subsystem | R2024b+ | Define a subsystem that executes on the Control Law Accelerator coprocessor — use to partition time-critical control algorithms onto the CLA for parallel execution with the main CPU |
| CLA Math | c28P55xlib/CLA Math | R2024b+ | Perform fixed-point or floating-point math operations on the Control Law Accelerator — use to offload computation-intensive control math from the main CPU for faster loop execution |
| CLA Task | c28P55xlib/CLA Task | R2024b+ | Define a single CLA task triggered by a hardware event — use to implement one control law computation that runs on the CLA independently of the main CPU |
| CLA Subsystem | c28P65xlib/CLA Subsystem | R2024a+ | Define a subsystem that executes on the Control Law Accelerator coprocessor — use to partition time-critical control algorithms onto the CLA for parallel execution with the main CPU |
| CLA Math | c28P65xlib/CLA Math | R2024a+ | Perform fixed-point or floating-point math operations on the Control Law Accelerator — use to offload computation-intensive control math from the main CPU for faster loop execution |
| CLA Task | c28P65xlib/CLA Task | R2024a+ | Define a single CLA task triggered by a hardware event — use to implement one control law computation that runs on the CLA independently of the main CPU |
| CLA Task Manager | c2000lib/Scheduling/CLA Task Manager | R2023a+ | Configure CLA task triggering and priority — use to manage which hardware events launch which CLA tasks and control their execution order |
| Software Trigger CPU<->CLA | c2000lib/Scheduling/Software Trigger CPU<->CLA | R2023a+ | Send a software trigger between the CPU and CLA coprocessor — use to synchronize CPU and CLA execution or signal task completion across the two processing cores |

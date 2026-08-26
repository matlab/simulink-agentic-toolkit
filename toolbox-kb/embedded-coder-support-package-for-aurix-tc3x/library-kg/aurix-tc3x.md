---
type: Simulink Block Category
title: Aurix tc3x
description: Infineon AURIX TC3x multicore ECU deployment and test bench blocks
tags: [aurix, tc3x, infineon, multicore, automotive]
status: stable
source: mathworks_toolbox
library_root: Embedded Coder Support Package for AURIX TC3x
category_path: Aurix tc3x
block_count: 10
---

# Aurix tc3x

Use these blocks for aurix tc3x.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| AURIX TC3x | aurixtc3xlib/AURIX TC3x | R2023b+ | Device-specific library container for Infineon AURIX TC3x multicore processors — provides access to TC3x-specific peripherals and scheduling |
| Utilities | aurixtc3xlib/Utilities | R2023b+ | Utility blocks for AURIX TC3x deployment — use for target-specific configuration and diagnostics |
| Task Manager | aurixtc3xlib/Scheduling/Task Manager | R2024b+ | Configure multi-core task scheduling on the AURIX TC3x — use to assign Simulink subsystems to specific cores and manage execution priority |
| Interprocess Data Read | aurixtc3xlib/Target Communication/Interprocess Data Read | R2024b+ | Read shared data from another AURIX TC3x core — use for inter-core communication in multicore automotive ECU deployments |
| Interprocess Data Write | aurixtc3xlib/Target Communication/Interprocess Data Write | R2024b+ | Write shared data visible to other AURIX TC3x cores — use for inter-core data exchange in multicore deployments |
| ADC Interface | aurixtc3xlib/Test Bench Blocks/ADC Interface | R2024b+ | Simulate the ADC peripheral behavior for test bench testing — use in SIL/PIL to provide analog input stimulus without hardware |
| Digital IO Interface | aurixtc3xlib/Test Bench Blocks/Digital IO Interface | R2024b+ | Simulate digital I/O peripheral behavior for test bench testing — use in SIL/PIL to provide GPIO stimulus without hardware |
| Event Source | aurixtc3xlib/Test Bench Blocks/Event Source | R2024b+ | Generate scheduling events for test bench simulation — use to trigger task execution in SIL/PIL without real hardware timer interrupts |
| Interprocess Data Channel | aurixtc3xlib/Test Bench Blocks/Interprocess Data Channel | R2024b+ | Simulate inter-core communication channels for test bench testing — use in SIL/PIL to model data exchange between cores without real shared memory |
| PWM Interface | aurixtc3xlib/Test Bench Blocks/PWM Interface | R2024b+ | Simulate PWM peripheral behavior for test bench testing — use in SIL/PIL to capture PWM duty cycle outputs without hardware |

---
type: Simulink Block Category
title: Aurix tc4x
description: Infineon AURIX TC4x next-gen multicore ECU deployment and test bench blocks
tags: [aurix, tc4x, infineon, multicore, automotive]
status: stable
source: mathworks_toolbox
library_root: Embedded Coder Support Package for AURIX TC4x
category_path: Aurix tc4x
block_count: 13
---

# Aurix tc4x

Use these blocks for aurix tc4x.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| AURIX TC46x | aurixtc4xlib/AURIX TC46x | R2026a+ | Device variant container for AURIX TC46x — access peripherals specific to this cost-optimized TC4x variant |
| AURIX TC48x | aurixtc4xlib/AURIX TC48x | R2026a+ | Device variant container for AURIX TC48x — access peripherals specific to this mid-range TC4x variant |
| AURIX TC49xN | aurixtc4xlib/AURIX TC49xN | R2026a+ | Device variant container for AURIX TC49xN — access peripherals specific to this high-performance TC4x variant |
| AURIX TC4Dx | aurixtc4xlib/AURIX TC4Dx | R2025a+ | Device variant container for AURIX TC4Dx — access peripherals specific to this domain-controller TC4x variant |
| Utilities | aurixtc4xlib/Utilities | R2023b+ | Utility blocks for AURIX TC4x deployment — use for target-specific configuration and diagnostics |
| Task Manager | aurixtc4xlib/Scheduling/Task Manager | R2024b+ | Configure multi-core task scheduling on the AURIX TC4x — use to assign subsystems to specific cores and manage execution timing and priority |
| Interprocess Data Read | aurixtc4xlib/Target Communication/Interprocess Data Read | R2024b+ | Read shared data from another AURIX TC4x core — use for inter-core communication in next-gen multicore automotive ECU deployments |
| Interprocess Data Write | aurixtc4xlib/Target Communication/Interprocess Data Write | R2024b+ | Write shared data visible to other AURIX TC4x cores — use for inter-core data exchange in multicore deployments |
| ADC Interface | aurixtc4xlib/Test Bench Blocks/ADC Interface | R2024b+ | Simulate ADC peripheral behavior for test bench testing on TC4x — use in SIL/PIL to provide analog input stimulus without hardware |
| Digital IO Interface | aurixtc4xlib/Test Bench Blocks/Digital IO Interface | R2024b+ | Simulate digital I/O peripheral behavior for TC4x test bench — use in SIL/PIL to provide GPIO stimulus without hardware |
| Event Source | aurixtc4xlib/Test Bench Blocks/Event Source | R2024b+ | Generate scheduling events for TC4x test bench simulation — use to trigger task execution in SIL/PIL without real hardware |
| Interprocess Data Channel | aurixtc4xlib/Test Bench Blocks/Interprocess Data Channel | R2024b+ | Simulate inter-core communication channels for TC4x test bench — use in SIL/PIL to model data exchange between cores |
| PWM Interface | aurixtc4xlib/Test Bench Blocks/PWM Interface | R2024b+ | Simulate PWM peripheral behavior for TC4x test bench — use in SIL/PIL to capture PWM outputs without hardware |

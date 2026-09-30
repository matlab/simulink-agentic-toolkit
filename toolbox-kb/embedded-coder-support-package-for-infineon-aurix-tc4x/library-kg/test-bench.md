---
type: Simulink Block Category
title: Test bench
description: Harness stand-ins for target peripherals used in SIL/PIL testing
tags: [test bench, interface, event source, harness]
status: stable
source: custom_library
library_root: Embedded Coder Support Package for Infineon AURIX TC4x
category_path: Test bench
block_count: 5
---

# Test bench

Use these blocks for test bench.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| ADC Interface | aurixtc4xlib/Test Bench Blocks/ADC Interface | R2024b+ | Test-bench stand-in for the target ADC — use in a SIL/PIL harness to inject analog readings without the physical peripheral. |
| Digital IO Interface | aurixtc4xlib/Test Bench Blocks/Digital IO Interface | R2024b+ | Test-bench stand-in for target digital I/O — use in a harness to drive and observe digital pins without hardware. |
| Event Source | aurixtc4xlib/Test Bench Blocks/Event Source | R2024b+ | Test-bench block that generates trigger events — use to stimulate event-driven tasks in a harness. |
| Interprocess Data Channel | aurixtc4xlib/Test Bench Blocks/Interprocess Data Channel | R2024b+ | Test-bench model of an interprocess data channel — use to wire Interprocess Data Read/Write pairs together in a harness. |
| PWM Interface | aurixtc4xlib/Test Bench Blocks/PWM Interface | R2024b+ | Test-bench stand-in for the target PWM peripheral — use in a harness to observe PWM commands without hardware. |

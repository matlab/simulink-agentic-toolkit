---
type: Simulink Block Category
title: Test bench
description: Test bench interfaces for processor-in-the-loop testing
tags: [test, bench, interface, adc, pil]
status: stable
source: mathworks_toolbox
library_root: Embedded Coder Support Package for Infineon AURIX TC4x
category_path: Test bench
block_count: 5
---

# Test bench

Use these blocks for test bench.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| ADC Interface | aurixtc4xlib/Test Bench Blocks/ADC Interface | R2024b+ | Test bench ADC interface for AURIX TC4x — use for injecting analog sensor signals into processor-in-the-loop or SIL test environments |
| Digital IO Interface | aurixtc4xlib/Test Bench Blocks/Digital IO Interface | R2024b+ | Test bench digital I/O interface for AURIX TC4x — use for stimulating or monitoring GPIO signals in processor-in-the-loop tests |
| Event Source | aurixtc4xlib/Test Bench Blocks/Event Source | R2024b+ | Test bench event generator for AURIX TC4x — use for triggering interrupts or timed events in processor-in-the-loop test scenarios |
| Interprocess Data Channel | aurixtc4xlib/Test Bench Blocks/Interprocess Data Channel | R2024b+ | Test bench inter-core data channel for AURIX TC4x — use for monitoring or injecting shared data in multi-core test environments |
| PWM Interface | aurixtc4xlib/Test Bench Blocks/PWM Interface | R2024b+ | Test bench PWM interface for AURIX TC4x — use for capturing or injecting PWM signals in processor-in-the-loop tests |

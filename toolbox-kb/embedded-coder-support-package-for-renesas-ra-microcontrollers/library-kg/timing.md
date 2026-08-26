---
type: Simulink Block Category
title: Timing
description: Timer and interrupt management on Renesas RA
tags: [timer, interrupt, pwm, isr, gpt]
status: stable
source: mathworks_toolbox
library_root: Embedded Coder Support Package for Renesas RA Microcontrollers
category_path: Timing
block_count: 3
---

# Timing

Use these blocks for timing.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Hardware Interrupt | ra6basedlib/Hardware Interrupt | R2026a+ | Configure hardware interrupt service routines on Renesas RA MCUs — use for triggering function-call subsystems from peripheral interrupts |
| PWM Output | ra6basedlib/PWM Output | R2026a+ | Generate PWM signals on Renesas RA timer outputs — use for motor control, LED dimming, or servo positioning |
| Three-Phase PWM | ra6basedlib/Three-Phase PWM | R2026a+ | Generate three-phase PWM waveforms on Renesas RA — use for driving BLDC motors or three-phase inverters in motor control applications |

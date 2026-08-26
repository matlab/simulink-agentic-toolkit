---
type: Simulink Block Category
title: Analog digital
description: Analog and digital I/O peripherals on FRDM-K64F
tags: [analog, digital, gpio, pwm, dac]
status: stable
source: mathworks_toolbox
library_root: Simulink Coder Support Package for NXP FRDM-K64F Board
category_path: Analog digital
block_count: 5
---

# Analog digital

Use these blocks for analog digital.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Analog Input | frdmk64flib/Analog Input | R2023a+ | Read analog voltage from ADC channels on NXP FRDM-K64F — use for sampling sensor signals in embedded applications |
| Analog Output | frdmk64flib/Analog Output | R2023a+ | Output analog voltage via DAC on NXP FRDM-K64F — use for generating reference voltages or analog control signals |
| Digital Read | frdmk64flib/Digital Read | R2023a+ | Read digital GPIO pin state on NXP FRDM-K64F — use for reading buttons, switches, or digital sensor inputs |
| Digital Write | frdmk64flib/Digital Write | R2023a+ | Write digital GPIO pin state on NXP FRDM-K64F — use for controlling LEDs, relays, or digital outputs |
| PWM Output | frdmk64flib/PWM Output | R2023a+ | Generate PWM signals on FRDM-K64F timer channels — use for motor control, LED dimming, or servo positioning |

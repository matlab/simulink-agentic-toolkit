---
type: Simulink Block Category
title: Gpio analog
description: Digital and analog I/O peripherals (5 blocks)
tags: [toolbox-kb, embedded-coder-support-package-for-beaglebone-black-hardware, gpio, analog, pwm, led, pin]
status: stable
sources:
  - resource: matlab:beaglebonelib
source: toolbox_kb
managed_by: satk
library: Embedded Coder Support Package for BeagleBone Black Hardware
kb_folder: embedded-coder-support-package-for-beaglebone-black-hardware
category: gpio-analog
block_count: 5
generated: { by: satk-toolbox-build/1, at: "2026-11-23T18:23:20Z" }
---

# Gpio analog

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Analog Input | beaglebonelib/Analog Input | R2023a+ | Read analog voltage from ADC inputs on BeagleBone Black — use for sampling sensor signals like temperature, light, or force |
| GPIO Read | beaglebonelib/GPIO Read | R2023a+ | Read digital GPIO pin state on BeagleBone Black — use for reading buttons, switches, or digital sensor inputs |
| GPIO Write | beaglebonelib/GPIO Write | R2023a+ | Write digital GPIO pin state on BeagleBone Black — use for controlling LEDs, relays, or digital outputs |
| LED | beaglebonelib/LED | R2023a+ | Control onboard user LEDs on BeagleBone Black — use for status indication or visual debugging on the board |
| PWM | beaglebonelib/PWM | R2023a+ | Generate PWM output on BeagleBone Black — use for motor speed control, servo positioning, or LED brightness dimming |

---
type: Simulink Block Category
title: Arduino io
description: Arduino hardware I/O blocks for Gizmo
tags: [analog, digital, pwm, arduino, pin]
status: stable
source: mathworks_toolbox
library_root: Simulink Arduino Libraries for Gizmo Hardware
category_path: Arduino io
block_count: 6
---

# Arduino io

Use these blocks for arduino io.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| AngleToDutyCycle | gizmoLibrary/Arduino Utilities/AngleToDutyCycle | R2025a+ | Convert servo angle to PWM duty cycle — use for translating angular position commands into PWM signals for Gizmo servos |
| Analog Input | gizmoLibrary/Arduino Utilities/Analog Input | R2025a+ | Read analog voltage on Gizmo Arduino pins — use for sampling sensor signals like potentiometers or light sensors |
| Digital Input | gizmoLibrary/Arduino Utilities/Digital Input | R2025a+ | Read digital pin state on Gizmo Arduino — use for reading buttons, limit switches, or digital sensors |
| Digital Output | gizmoLibrary/Arduino Utilities/Digital Output | R2025a+ | Write digital pin state on Gizmo Arduino — use for controlling LEDs, relays, or other digital outputs |
| PWM | gizmoLibrary/Arduino Utilities/PWM | R2025a+ | Generate PWM output on Gizmo Arduino pins — use for motor speed control, LED dimming, or servo positioning |
| Gizmo Initialization | gizmoLibrary/Gizmo Blocks/Gizmo Initialization | R2025a+ | Initialize the Gizmo hardware configuration — use at the start of every Gizmo model to set up board communication |

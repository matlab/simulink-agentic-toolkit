---
type: Block Selection Guide
title: Common Blocks
description: High-value blocks selected for quick agent discovery.
status: stable
source: mathworks_toolbox
block_count: 5
---

# Common Blocks

Prefer these blocks when their intent matches the user request.

| Intent | Preferred Block | Library |
|---|---|---|
| Read analog voltage on Gizmo Arduino pins — use for sampling sensor signals like potentiometers or light sensors | Analog Input | Simulink Arduino Libraries for Gizmo Hardware |
| Write digital pin state on Gizmo Arduino — use for controlling LEDs, relays, or other digital outputs | Digital Output | Simulink Arduino Libraries for Gizmo Hardware |
| Generate PWM output on Gizmo Arduino pins — use for motor speed control, LED dimming, or servo positioning | PWM | Simulink Arduino Libraries for Gizmo Hardware |
| Read all axes and buttons from a connected gamepad — use as the primary input device for teleoperating Gizmo robots | Gizmo Gamepad | Simulink Arduino Libraries for Gizmo Hardware |
| Initialize the Gizmo hardware configuration — use at the start of every Gizmo model to set up board communication | Gizmo Initialization | Simulink Arduino Libraries for Gizmo Hardware |

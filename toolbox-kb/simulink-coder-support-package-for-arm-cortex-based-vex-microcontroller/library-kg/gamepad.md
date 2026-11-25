---
type: Simulink Block Category
title: Gamepad
description: Controller input blocks (6 blocks)
tags: [toolbox-kb, simulink-coder-support-package-for-arm-cortex-based-vex-microcontroller, gamepad, joystick, button, competition, accelerometer]
status: stable
sources:
  - resource: matlab:vexarmcortexlib
source: toolbox_kb
managed_by: satk
library: Simulink Coder Support Package for ARM Cortex-based VEX Microcontroller
kb_folder: simulink-coder-support-package-for-arm-cortex-based-vex-microcontroller
category: gamepad
block_count: 6
generated: { by: satk-toolbox-build/1, at: "2026-11-23T18:23:29Z" }
---

# Gamepad

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Competition Switch | vexarmcortexlib/Gamepad/Competition Switch | R2023a+ | Read VEX competition field state — use for detecting autonomous vs driver-control mode |
| Gamepad Accelerometer | vexarmcortexlib/Gamepad/Gamepad Accelerometer | R2023a+ | Read VEX gamepad accelerometer — use for tilt-based control input from the controller |
| Gamepad Button | vexarmcortexlib/Gamepad/Gamepad Button | R2023a+ | Read VEX gamepad button state — use for detecting button presses on the VEX controller |
| Gamepad Joystick | vexarmcortexlib/Gamepad/Gamepad Joystick | R2023a+ | Read VEX gamepad joystick axis — use for analog joystick input from the VEX controller |
| LCD Button | vexarmcortexlib/LCD/LCD Button | R2023a+ | Read VEX LCD module button — use for user input via the LCD screen buttons |
| LCD Screen | vexarmcortexlib/LCD/LCD Screen | R2023a+ | Write text to VEX LCD module — use for displaying status or debug info on the robot LCD |

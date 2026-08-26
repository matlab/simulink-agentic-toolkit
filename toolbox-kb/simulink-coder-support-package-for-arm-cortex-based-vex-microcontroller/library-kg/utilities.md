---
type: Simulink Block Category
title: Utilities
description: Simulation and utility blocks
tags: [scope, display, clock, switch, simulator, deadband]
status: stable
source: mathworks_toolbox
library_root: Simulink Coder Support Package for ARM Cortex-based VEX Microcontroller
category_path: Utilities
block_count: 20
---

# Utilities

Use these blocks for utilities.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| MATLAB Function | vexarmcortexlib/Utilities/MATLAB Function | R2023a+ | Embed custom MATLAB code on VEX Cortex — use for implementing algorithms not available as blocks |
| Stateflow | vexarmcortexlib/Utilities/Stateflow | R2023a+ | Embed state machine logic on VEX Cortex — use for implementing mode-switching and sequencing logic |
| Variable Input | vexarmcortexlib/Utilities/Variable Input | R2023a+ | Slider-adjustable constant input — use for tuning parameters during VEX robot simulation |
| Arcade Module | vexarmcortexlib/Utilities/Arcade Module | R2023a+ | Map joystick to arcade drive — use for converting single-stick input to differential motor commands |
| Clock | vexarmcortexlib/Utilities/Clock | R2023a+ | Output simulation time — use for time-based sequencing in robot programs |
| Constant | vexarmcortexlib/Utilities/Constant | R2023a+ | Output a constant value — use for fixed parameters like speed setpoints |
| Data Type Conversion | vexarmcortexlib/Utilities/Data Type Conversion | R2023a+ | Convert between data types — use for matching signal types between blocks |
| Deadband | vexarmcortexlib/Utilities/Deadband | R2023a+ | Apply deadzone to signal — use for ignoring small joystick movements near center |
| Display | vexarmcortexlib/Utilities/Display | R2023a+ | Show signal value during simulation — use for debugging robot algorithms |
| Field Simulator | vexarmcortexlib/Utilities/Field Simulator | R2023a+ | Simulate VEX competition field — use for testing autonomous routines without hardware |
| Gamepad Simulator | vexarmcortexlib/Utilities/Gamepad Simulator | R2023a+ | Simulate VEX gamepad inputs — use for testing driver-control code without a physical controller |
| Gear Transmission | vexarmcortexlib/Utilities/Gear Transmission | R2023a+ | Model gear ratio effects — use for converting motor speed/torque through gear train |
| Ground | vexarmcortexlib/Utilities/Ground | R2023a+ | Provide zero-value signal — use for grounding unused input ports |
| Latch | vexarmcortexlib/Utilities/Latch | R2023a+ | Latch a signal value on trigger — use for capturing sensor readings at specific events |
| Limit Switch Control  | vexarmcortexlib/Utilities/Limit Switch Control  | R2023a+ | Limit motor output based on switch state — use for preventing mechanism over-travel using limit switches |
| Manual Switch | vexarmcortexlib/Utilities/Manual Switch | R2023a+ | Toggle between two inputs — use for switching between autonomous and manual modes in simulation |
| Scope | vexarmcortexlib/Utilities/Scope | R2023a+ | Plot signals over time — use for visualizing robot behavior during simulation |
| Switch | vexarmcortexlib/Utilities/Switch | R2023a+ | Conditional signal selection — use for choosing between inputs based on a threshold condition |
| Terminator | vexarmcortexlib/Utilities/Terminator | R2023a+ | Terminate unused output — use for cleanly handling unconnected block outputs |
| Toggle | vexarmcortexlib/Utilities/Toggle | R2023a+ | Toggle constant between values — use for binary mode selection during simulation |

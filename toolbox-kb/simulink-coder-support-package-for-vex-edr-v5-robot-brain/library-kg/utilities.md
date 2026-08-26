---
type: Simulink Block Category
title: Utilities
description: Simulation and utility blocks
tags: [scope, display, clock, switch, simulator, deadband, latch]
status: stable
source: mathworks_toolbox
library_root: Simulink Coder Support Package for VEX EDR V5 Robot Brain
category_path: Utilities
block_count: 20
---

# Utilities

Use these blocks for utilities.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Chart | vexv5lib/Utilities/Chart | R2023a+ | Stateflow chart for V5 — use for implementing state machine logic on V5 Robot Brain |
| MATLAB Function | vexv5lib/Utilities/MATLAB Function | R2023a+ | Custom MATLAB code for V5 — use for implementing algorithms not available as blocks on V5 Robot Brain |
| Variable Input | vexv5lib/Utilities/Variable Input | R2023a+ | Slider-adjustable constant — use for tuning parameters during V5 robot simulation |
| Arcade Module | vexv5lib/Utilities/Arcade Module | R2023a+ | Map joystick to arcade drive — use for single-stick differential motor control on V5 |
| Clock | vexv5lib/Utilities/Clock | R2023a+ | Output simulation time — use for time-based sequencing |
| Constant | vexv5lib/Utilities/Constant | R2023a+ | Constant value output — use for fixed parameters |
| Data Type Conversion | vexv5lib/Utilities/Data Type Conversion | R2023a+ | Convert data types — use for matching signal types between blocks |
| Deadband | vexv5lib/Utilities/Deadband | R2023a+ | Apply deadzone — use for ignoring small joystick movements |
| Display | vexv5lib/Utilities/Display | R2023a+ | Show signal value — use for debugging during simulation |
| Field Simulator | vexv5lib/Utilities/Field Simulator | R2023a+ | Simulate V5 competition field — use for testing autonomous without hardware |
| Gamepad Simulator | vexv5lib/Utilities/Gamepad Simulator | R2023a+ | Simulate V5 gamepad — use for testing driver-control without physical controller |
| Gear Transmission | vexv5lib/Utilities/Gear Transmission | R2023a+ | Model gear ratio — use for speed/torque conversion through gears |
| Ground | vexv5lib/Utilities/Ground | R2023a+ | Zero-value signal — use for grounding unused inputs |
| Latch | vexv5lib/Utilities/Latch | R2023a+ | Latch signal on trigger — use for capturing readings at events |
| Limit Switch Control  | vexv5lib/Utilities/Limit Switch Control  | R2023a+ | Limit motor by switch state — use for preventing over-travel with limit switches on V5 |
| Manual Switch | vexv5lib/Utilities/Manual Switch | R2023a+ | Toggle between inputs — use for mode switching in simulation |
| Scope | vexv5lib/Utilities/Scope | R2023a+ | Plot signals — use for visualizing V5 robot behavior |
| Switch | vexv5lib/Utilities/Switch | R2023a+ | Conditional signal selection — use for threshold-based input switching |
| Terminator | vexv5lib/Utilities/Terminator | R2023a+ | Terminate unused output — use for cleanly handling unconnected ports |
| Toggle | vexv5lib/Utilities/Toggle | R2023a+ | Binary toggle constant — use for mode selection |

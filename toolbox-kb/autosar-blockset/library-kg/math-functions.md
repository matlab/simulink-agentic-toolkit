---
type: Simulink Block Category
title: Math functions
description: AUTOSAR Math Function Library (MFL) building blocks for signal generation
tags: [ramp, math, mfl, signal, generator]
status: stable
source: mathworks_toolbox
library_root: AUTOSAR Blockset
category_path: Math functions
block_count: 6
---

# Math functions

Use these blocks for math functions.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Ramp | autosarlibefxmfl/Ramp | R2023b+ | Generate a ramp signal with configurable slope and initial value — use for rate-limited transitions in actuator commands or soft-start/soft-stop profiles in AUTOSAR MFL functions |
| initialize_subsystem | autosarlibefxmfl/Ramp/InitializeFunction/initialize_subsystem | R2023a+ | Internal initialization subsystem for the Ramp block — executes once at startup to set the initial state of the ramp generator |
| Event Listener | autosarlibefxmfl/Ramp/InitializeFunction/Event Listener | R2023a+ | Internal event listener that triggers the initialization logic — responds to the initialize event to run startup computations |
| input_state | autosarlibefxmfl/Ramp/InitializeFunction/input_state | R2023a+ | Internal constant block providing the initial state value for the Ramp initialization function |
| state_dsr | autosarlibefxmfl/Ramp/InitializeFunction/state_dsr | R2023a+ | Internal data store read for accessing the Ramp persistent state during initialization |
| state_dsw | autosarlibefxmfl/Ramp/InitializeFunction/state_dsw | R2023a+ | Internal data store write for setting the Ramp persistent state during initialization |

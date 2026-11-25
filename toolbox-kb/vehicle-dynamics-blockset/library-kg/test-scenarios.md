---
type: Simulink Block Category
title: Test scenarios
description: Standard vehicle test maneuvers and drive cycle inputs (10 blocks)
tags: [toolbox-kb, vehicle-dynamics-blockset, maneuver, test, drive-cycle, steer, scenario]
status: stable
sources:
  - resource: matlab:vehdynlibscenario
source: toolbox_kb
managed_by: satk
library: Vehicle Dynamics Blockset
kb_folder: vehicle-dynamics-blockset
category: test-scenarios
block_count: 10
generated: { by: satk-toolbox-build/1, at: "2026-11-23T18:23:34Z" }
---

# Test scenarios

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Acceleration and Braking | vehdynlibscenario/Acceleration and Braking | R2024b+ | Generate standardized acceleration-and-braking test maneuver commands for vehicle performance evaluation |
| Constant Radius | vehdynlibscenario/Constant Radius | R2024b+ | Generate steering and speed commands for a constant-radius cornering test |
| Drive Cycle Source | vehdynlibscenario/Drive Cycle Source | R2023a+ | Output standardized drive cycle speed profiles for fuel economy and emissions testing |
| Fishhook | vehdynlibscenario/Fishhook | R2024b+ | Generate a fishhook steering maneuver for rollover propensity evaluation |
| Lane Change | vehdynlibscenario/Lane Change | R2024b+ | Generate steering commands for a single or double lane-change maneuver |
| Reference Path Generator | vehdynlibscenario/Reference Path Generator | R2026a+ | Produce waypoint-based reference path signals for path-following controllers |
| Sine With Dwell | vehdynlibscenario/Sine With Dwell | R2024b+ | Generate a sine-with-dwell steering input for electronic stability control testing per FMVSS 126 |
| Slowly Increasing Steer | vehdynlibscenario/Slowly Increasing Steer | R2024b+ | Generate a slowly increasing steering angle for understeer gradient characterization |
| Swept Sine | vehdynlibscenario/Swept Sine | R2024b+ | Generate a frequency-swept sinusoidal steering input for vehicle frequency response analysis |
| Wide Open Throttle | vehdynlibscenario/Wide Open Throttle | R2024b+ | Generate a wide-open-throttle acceleration command for maximum performance testing |

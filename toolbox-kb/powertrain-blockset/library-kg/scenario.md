---
type: Simulink Block Category
title: Scenario
description: Drive-cycle and driver models for closed-loop runs
tags: [vehicle scenario builder, drive cycle, longitudinal driver]
status: stable
source: custom_library
library_root: Powertrain Blockset
category_path: Scenario
block_count: 2
---

# Scenario

Use these blocks for scenario.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Drive Cycle Source | autolibscenario/Drive Cycle Source | R2023a+ | Output a standard or custom drive-cycle speed reference versus time — use to drive powertrain and fuel-economy simulations. |
| Longitudinal Driver | autolibscenario/Longitudinal Driver | R2023a+ | Model a driver that produces accelerator and brake commands to track a speed reference — use to close the loop on a drive cycle. |

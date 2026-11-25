---
type: Simulink Block Category
title: Scenario
description: Drive-cycle and driver models for closed-loop runs (2 blocks)
tags: [toolbox-kb, powertrain-blockset, vehicle scenario builder, drive cycle, longitudinal driver]
status: stable
sources:
  - resource: matlab:autolibscenario
source: toolbox_kb
managed_by: satk
library: Powertrain Blockset
kb_folder: powertrain-blockset
category: scenario
block_count: 2
generated: { by: satk-toolbox-build/1, at: "2026-11-23T18:23:25Z" }
---

# Scenario

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Drive Cycle Source | autolibscenario/Drive Cycle Source | R2023a+ | Output a standard or custom drive-cycle speed reference versus time — use to drive powertrain and fuel-economy simulations. |
| Longitudinal Driver | autolibscenario/Longitudinal Driver | R2023a+ | Model a driver that produces accelerator and brake commands to track a speed reference — use to close the loop on a drive cycle. |

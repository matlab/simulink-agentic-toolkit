---
type: Simulink Block Category
title: Driver models
description: Driver behavior models for steering and longitudinal control (3 blocks)
tags: [toolbox-kb, vehicle-dynamics-blockset, driver, steering, throttle, path-following, longitudinal]
status: stable
sources:
  - resource: matlab:vehdynlibdriver
source: toolbox_kb
managed_by: satk
library: Vehicle Dynamics Blockset
kb_folder: vehicle-dynamics-blockset
category: driver-models
block_count: 3
generated: { by: satk-toolbox-build/1, at: "2026-11-23T18:23:34Z" }
---

# Driver models

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Lateral Driver | vehdynlibdriver/Lateral Driver | R2023a+ | Model a driver that follows a reference path using preview-point lateral steering control |
| Predictive Driver | vehdynlibdriver/Predictive Driver | R2023a+ | Model a combined longitudinal and lateral driver using predictive path-following control |
| Longitudinal Driver | vehdynlibdriver/Longitudinal Driver | R2023a+ | Model a driver that tracks a target speed profile with throttle and brake commands |

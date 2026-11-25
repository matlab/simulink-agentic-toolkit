---
type: Simulink Block Category
title: Targets clutter
description: Radar target models and environmental clutter (5 blocks)
tags: [toolbox-kb, radar-toolbox, backscatter, clutter, pedestrian, target, rcs]
status: stable
sources:
  - resource: matlab:radarlib
source: toolbox_kb
managed_by: satk
library: Radar Toolbox
kb_folder: radar-toolbox
category: targets-clutter
block_count: 5
generated: { by: satk-toolbox-build/1, at: "2026-11-23T18:23:26Z" }
---

# Targets clutter

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Backscatter Bicyclist | radarlib/Backscatter Bicyclist | R2023a+ | Simulate radar backscatter from a moving bicyclist — use for generating realistic micro-Doppler signatures in automotive radar scenarios |
| Backscatter Pedestrian | radarlib/Backscatter Pedestrian | R2023a+ | Simulate radar backscatter from a walking pedestrian — use for generating realistic micro-Doppler signatures for vulnerable road user detection |
| Constant Gamma Clutter | radarlib/Constant Gamma Clutter | R2023a+ | Generate surface clutter returns with constant gamma reflectivity — use for simulating ground or sea clutter in radar system performance evaluation |
| GPU Constant Gamma Clutter | radarlib/GPU Constant Gamma Clutter | R2023a+ | GPU-accelerated surface clutter generation — use for high-fidelity clutter simulation when processing speed is critical in large radar scenarios |
| Radar Data Generator | radarlib/Radar Data Generator | R2023a+ | Generate synthetic radar detections from scenario objects — use for rapid prototyping of radar processing algorithms without full signal-level simulation |

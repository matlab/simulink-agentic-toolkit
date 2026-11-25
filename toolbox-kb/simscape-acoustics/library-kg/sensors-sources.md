---
type: Simulink Block Category
title: Sensors sources
description: Acoustic measurement and excitation blocks (5 blocks)
tags: [toolbox-kb, simscape-acoustics, sensor, source, pressure, velocity, controlled]
status: stable
sources:
  - resource: matlab:acoustic_lib
source: toolbox_kb
managed_by: satk
library: Simscape Acoustics
kb_folder: simscape-acoustics
category: sensors-sources
block_count: 5
generated: { by: satk-toolbox-build/1, at: "2026-11-23T18:23:28Z" }
---

# Sensors sources

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Far-Field Pressure Sensor | acoustic_lib/Acoustic Sensors/Far-Field Pressure Sensor | R2023a+ | Measure acoustic pressure at a distance from the source — use for predicting sound pressure levels in the far field |
| Volume Velocity Sensor | acoustic_lib/Acoustic Sensors/Volume Velocity Sensor | R2023a+ | Measure acoustic volume velocity through a branch — use for monitoring airflow in acoustic elements |
| Controlled Pressure Source | acoustic_lib/Acoustic Sources/Controlled Pressure Source | R2023a+ | Signal-controlled acoustic pressure source — use for driving acoustic networks with time-varying pressure from Simulink |
| Controlled Volume Velocity Source | acoustic_lib/Acoustic Sources/Controlled Volume Velocity Source | R2023a+ | Signal-controlled volume velocity source — use for injecting time-varying airflow into acoustic networks |
| Volume Velocity Source | acoustic_lib/Acoustic Sources/Volume Velocity Source | R2023a+ | Constant volume velocity source — use for providing fixed airflow excitation in acoustic circuits |

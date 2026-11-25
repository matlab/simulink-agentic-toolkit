---
type: Simulink Block Category
title: Guidance navigation
description: "Guidance, range calculation, and inertial navigation sensors (4 blocks)"
tags: [toolbox-kb, aerospace-blockset, guidance, range, accelerometer, gyroscope, IMU]
status: stable
sources:
  - resource: matlab:aerolibguid
source: toolbox_kb
managed_by: satk
library: Aerospace Blockset
kb_folder: aerospace-blockset
category: guidance-navigation
block_count: 4
generated: { by: satk-toolbox-build/1, at: "2026-11-23T18:23:13Z" }
---

# Guidance navigation

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Calculate Range | aerolibguid/Calculate Range | R2023a+ | Compute great-circle range between two geographic positions — use for waypoint navigation, target distance, or range-to-go calculations |
| Three-axis Accelerometer | aerolibnav/Three-axis Accelerometer | R2023a+ | Simulate a three-axis accelerometer with bias, scale factor error, noise, and quantization for IMU/INS modeling |
| Three-axis Gyroscope | aerolibnav/Three-axis Gyroscope | R2023a+ | Simulate a three-axis rate gyroscope with bias drift, angular random walk, and scale factor error for IMU/INS modeling |
| Three-axis Inertial Measurement Unit | aerolibnav/Three-axis Inertial Measurement Unit | R2023a+ | Simulate a complete IMU (accelerometers + gyroscopes) with configurable error models for navigation system development |

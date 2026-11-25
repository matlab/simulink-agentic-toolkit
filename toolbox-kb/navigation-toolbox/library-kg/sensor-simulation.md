---
type: Simulink Block Category
title: Sensor simulation
description: Simulated navigation sensor models (3 blocks)
tags: [toolbox-kb, navigation-toolbox, gps, imu, ins, sensor, simulate]
status: stable
sources:
  - resource: matlab:mspsensorlib
source: toolbox_kb
managed_by: satk
library: Navigation Toolbox
kb_folder: navigation-toolbox
category: sensor-simulation
block_count: 3
generated: { by: satk-toolbox-build/1, at: "2026-11-23T18:23:24Z" }
---

# Sensor simulation

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| GPS | mspsensorlib/GPS | R2023a+ | Simulate GPS receiver measurements — use for generating realistic position and velocity readings with configurable noise and satellite geometry |
| IMU | mspsensorlib/IMU | R2023a+ | Simulate inertial measurement unit sensor readings — use for generating realistic accelerometer and gyroscope measurements with configurable noise models |
| INS | mspsensorlib/INS | R2023a+ | Simulate integrated navigation system measurements — use for generating fused position, velocity, and orientation data from a combined GPS/IMU system |

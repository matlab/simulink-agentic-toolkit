---
type: Simulink Block Category
title: Sensor fusion
description: Orientation and position estimation from sensor data (5 blocks)
tags: [toolbox-kb, navigation-toolbox, ahrs, filter, orientation, fusion, imu]
status: stable
sources:
  - resource: matlab:mspfiltlib
source: toolbox_kb
managed_by: satk
library: Navigation Toolbox
kb_folder: navigation-toolbox
category: sensor-fusion
block_count: 5
generated: { by: satk-toolbox-build/1, at: "2026-11-23T18:23:24Z" }
---

# Sensor fusion

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| AHRS | mspfiltlib/AHRS | R2023a+ | Estimate orientation using an Attitude and Heading Reference System filter — use for fusing accelerometer, gyroscope, and magnetometer data into robust orientation estimates |
| Complementary Filter | mspfiltlib/Complementary Filter | R2023a+ | Estimate orientation using a complementary filter — use for lightweight sensor fusion of accelerometer and gyroscope with tunable trust between sensors |
| IMU Filter | mspfiltlib/IMU Filter | R2023b+ | Estimate orientation from IMU data using a Kalman-based filter — use for accurate attitude estimation from noisy accelerometer and gyroscope measurements |
| ecompass | mspfiltlib/ecompass | R2024a+ | Compute heading from accelerometer and magnetometer readings — use for determining magnetic north direction in tilt-compensated compass applications |
| Coordinate Transformation Conversion | navlib/Utilities/Coordinate Transformation Conversion | R2023a+ | Convert between rotation representations — use for converting quaternions, Euler angles, rotation matrices, or axis-angle representations |

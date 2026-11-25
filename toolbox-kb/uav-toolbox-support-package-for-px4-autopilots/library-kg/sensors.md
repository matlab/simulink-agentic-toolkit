---
type: Simulink Block Category
title: Sensors
description: Onboard sensor data access (7 blocks)
tags: [toolbox-kb, uav-toolbox-support-package-for-px4-autopilots, accelerometer, gyroscope, gps, magnetometer, battery]
status: stable
sources:
  - resource: matlab:px4Sensorslib
source: toolbox_kb
managed_by: satk
library: UAV Toolbox Support Package for PX4 Autopilots
kb_folder: uav-toolbox-support-package-for-px4-autopilots
category: sensors
block_count: 7
generated: { by: satk-toolbox-build/1, at: "2026-11-23T18:23:33Z" }
---

# Sensors

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Accelerometer | px4Sensorslib/Accelerometer | R2023a+ | Read accelerometer data from PX4 IMU — use for accessing raw acceleration measurements in custom estimation or control |
| Battery | px4Sensorslib/Battery | R2023a+ | Read battery voltage and current from PX4 — use for monitoring power state and remaining flight time |
| GPS | px4Sensorslib/GPS | R2023a+ | Read GPS position and velocity from PX4 — use for accessing navigation data in custom position controllers |
| Gyroscope | px4Sensorslib/Gyroscope | R2023a+ | Read gyroscope data from PX4 IMU — use for accessing raw angular rate measurements in custom controllers |
| Magnetometer | px4Sensorslib/Magnetometer | R2023a+ | Read magnetometer data from PX4 — use for accessing magnetic heading in custom attitude estimation |
| Radio Control Transmitter | px4Sensorslib/Radio Control Transmitter | R2023a+ | Read RC transmitter channel values on PX4 — use for accessing pilot stick inputs for mode switching or manual override |
| Vehicle Attitude | px4Sensorslib/Vehicle Attitude | R2023a+ | Read estimated vehicle attitude from PX4 EKF — use for accessing fused orientation in custom guidance algorithms |

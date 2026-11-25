---
type: Simulink Block Category
title: Sensors
description: "On-device iOS sensors (accelerometer, gyroscope, GPS, magnetometer) (3 blocks)"
tags: [toolbox-kb, simulink-support-package-for-apple-ios-devices, sensor, accelerometer, gyroscope, gps, magnetometer]
status: draft
sources:
  - resource: matlab:iossensorlib
source: toolbox_kb
managed_by: satk
library: Simulink Support Package for Apple iOS Devices
kb_folder: simulink-support-package-for-apple-ios-devices
category: sensors
block_count: 3
generated: { by: satk-toolbox-build/1, at: "2026-11-23T18:23:32Z" }
---

# Sensors

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Accelerometer | iossensorlib/Accelerometer | R2023a+ | Measure linear acceleration along the X, Y and Z axes in m/s^2. The block outputs acceleration as a [1x3] vector of single-precision values. |
| Gyroscope | iossensorlib/Gyroscope | R2023a+ | Measure rotational speed around the X, Y, and Z axes in rad/s. The block outputs rotational speed as a [1x3] vector of single-precision values. |
| Location Sensor | iossensorlib/Location Sensor | R2023a+ | Measure GPS latitude, longitude in decimal degrees and altitude in meters. The block outputs the latitude, longitude and altitude as a [1x3] vector of single-precision values. |

---
type: Simulink Block Category
title: Magnetometer
description: On-board 3-axis magnetometers
tags: [magnetometer, magetometer, lsm303, mag3110]
status: stable
source: custom_library
library_root: Simulink Coder Support Package for BBC micro:bit
category_path: Magnetometer
block_count: 4
---

# Magnetometer

Use these blocks for magnetometer.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| LSM-303 Magetometer X-Y-Z | microbitmagnetlib/LSM-303 Magetometer X-Y-Z | R2023a+ | Read the X/Y/Z magnetic field from the LSM303 magnetometer — use for compass heading or magnetic-field sensing. |
| LSM303 3-Axis Magnetometer | microbitmagnetlib/LSM303 3-Axis Magnetometer | R2023a+ | Read 3-axis magnetic field from the on-board LSM303 magnetometer — use for compass heading or magnetic sensing. |
| MAG3110 3-Axis Magnetometer | microbitmagnetlib/MAG3110 3-Axis Magnetometer | R2023a+ | Read 3-axis magnetic field from the on-board MAG3110 magnetometer — use for compass heading on boards with that part. |
| Magnetometer X-Y-Z | microbitmagnetlib/Magnetometer X-Y-Z | R2023a+ | Measure linear acceleration and magnetic field along the X, Y and Z axes. The block outputs magnetic field as a [1x3] vector of double values in uT. |

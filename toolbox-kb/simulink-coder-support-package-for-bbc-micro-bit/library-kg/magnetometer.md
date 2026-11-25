---
type: Simulink Block Category
title: Magnetometer
description: On-board 3-axis magnetometers (4 blocks)
tags: [toolbox-kb, simulink-coder-support-package-for-bbc-micro-bit, magnetometer, magetometer, lsm303, mag3110]
status: draft
sources:
  - resource: matlab:microbitmagnetlib
source: toolbox_kb
managed_by: satk
library: Simulink Coder Support Package for BBC micro:bit
kb_folder: simulink-coder-support-package-for-bbc-micro-bit
category: magnetometer
block_count: 4
generated: { by: satk-toolbox-build/1, at: "2026-11-23T18:23:30Z" }
---

# Magnetometer

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| LSM-303 Magetometer X-Y-Z | microbitmagnetlib/LSM-303 Magetometer X-Y-Z | R2023a+ | Read the X/Y/Z magnetic field from the LSM303 magnetometer — use for compass heading or magnetic-field sensing. |
| LSM303 3-Axis Magnetometer | microbitmagnetlib/LSM303 3-Axis Magnetometer | R2023a+ | Read 3-axis magnetic field from the on-board LSM303 magnetometer — use for compass heading or magnetic sensing. |
| MAG3110 3-Axis Magnetometer | microbitmagnetlib/MAG3110 3-Axis Magnetometer | R2023a+ | Read 3-axis magnetic field from the on-board MAG3110 magnetometer — use for compass heading on boards with that part. |
| Magnetometer X-Y-Z | microbitmagnetlib/Magnetometer X-Y-Z | R2023a+ | Measure linear acceleration and magnetic field along the X, Y and Z axes. The block outputs magnetic field as a [1x3] vector of double values in uT. |

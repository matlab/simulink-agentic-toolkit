---
type: Simulink Block Category
title: Accelerometer
description: On-board 3-axis accelerometers
tags: [accelerometer, lsm303, mma8652]
status: stable
source: custom_library
library_root: Simulink Coder Support Package for BBC micro:bit
category_path: Accelerometer
block_count: 9
---

# Accelerometer

Use these blocks for accelerometer.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| LSM303 3-Axis Accelerometer | microbitaccellib/LSM303 3-Axis Accelerometer | R2023a+ | Read 3-axis acceleration from the on-board LSM303 sensor — use for motion, tilt, and gesture detection. |
| MMA8652FC 3-Axis Accelerometer | microbitaccellib/MMA8652FC 3-Axis Accelerometer | R2023a+ | Read 3-axis acceleration from the on-board MMA8652FC sensor — use for motion, tilt, and gesture detection on boards with that part. |
| Accelerometer X-Y-Z | microbitaccellib/Accelerometer X-Y-Z | R2023a+ | Output the X, Y and Z value in g (9.8 m/s^2) to different output ports. |
| LSM 303 Accelerometer X-Y-Z | microbitaccellib/LSM 303 Accelerometer X-Y-Z | R2023a+ | Output the X, Y and Z value in g (9.8 m/s^2) to different output ports. |
| Shake detection | microbitaccellib/Shake detection | R2023a+ | Detect shake, return "1" or "true" when it is higher than the value determined by sensitivity in g (9.8 m/s^2). |
| Tilt down | microbitaccellib/Tilt down | R2023a+ | Detect the microbit tilted downward by sensitivity in g (9.8 m/s^2). |
| Tilt left | microbitaccellib/Tilt left | R2023a+ | Detect the microbit tilted to the left by sensitivity in g (9.8 m/s^2). |
| Tilt right | microbitaccellib/Tilt right | R2023a+ | Detect the microbit tilted to the right by sensitivity in g (9.8 m/s^2). |
| Tilt up | microbitaccellib/Tilt up | R2023a+ | Detect the microbit tilted upward by sensitivity in g (9.8 m/s^2). |

---
type: Simulink Block Category
title: Sensors
description: On-device Android sensors
tags: [sensor, magnetometer, orientation, accelerometer, gyroscope]
status: stable
source: custom_library
library_root: Simulink Support Package for Android Devices
category_path: Sensors
block_count: 9
---

# Sensors

Use these blocks for sensors.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Magnetometer | androidsensorlib/Magnetometer | R2023a+ | Read the Android device's magnetometer (magnetic field vector) — use for heading/compass and orientation sensing. |
| Orientation | androidsensorlib/Orientation | R2023a+ | Read the Android device's fused orientation (roll/pitch/yaw) — use for attitude sensing in mobile apps. |
| Accelerometer | androidsensorlib/Accelerometer | R2023a+ | Measure linear acceleration along the X, Y and Z axes in m/s^2. Each X, Y, Z port outputs acceleration as a single-precision scalar. |
| Ambient Temperature Sensor | androidsensorlib/Ambient Temperature Sensor | R2023a+ | Measure ambient temperature in degrees Celsius (C). The block outputs temperature as a single-precision value. |
| Gyroscope | androidsensorlib/Gyroscope | R2023a+ | Measure rate of rotation around the X, Y and Z axes in rad/s. Each X, Y, Z port outputs the rate of rotation as a single-precision scalar. |
| Humidity Sensor | androidsensorlib/Humidity Sensor | R2023a+ | Measure relative ambient humidity in percent (%). The block outputs humidity as a single-precision value. |
| Light Sensor | androidsensorlib/Light Sensor | R2023a+ | Measure ambient light level in lux (lx). The block outputs light level as a single-precision value. |
| Location Sensor | androidsensorlib/Location Sensor | R2023a+ | Measure GPS latitude, longitude in decimal degrees (°) and altitude in meters (m). Each Lat, Lon, Alt port outputs a double-precision scalar. |
| Pressure Sensor | androidsensorlib/Pressure Sensor | R2023a+ | Measure ambient air pressure in hectopascals (hPa). The block outputs pressure as a single-precision value. |

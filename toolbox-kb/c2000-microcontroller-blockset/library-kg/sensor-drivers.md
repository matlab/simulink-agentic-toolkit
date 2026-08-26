---
type: Simulink Block Category
title: Sensor drivers
description: Driver blocks for common external sensors connected via I2C or SPI
tags: [sensor, accelerometer, gyroscope, bme, i2c]
status: stable
source: mathworks_toolbox
library_root: C2000 Microcontroller Blockset
category_path: Sensor drivers
block_count: 7
---

# Sensor drivers

Use these blocks for sensor drivers.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| ADXL34x | c2000sensorslib/ADXL34x | R2023a+ | Interface with the ADXL34x family of 3-axis MEMS accelerometers via I2C/SPI — use to measure acceleration for tilt sensing, vibration monitoring, or inertial navigation |
| BME280 | c2000sensorslib/BME280 | R2023a+ | Interface with the BME280 environmental sensor via I2C/SPI — use to measure temperature, humidity, and barometric pressure for environmental monitoring applications |
| BMI160 | c2000sensorslib/BMI160 | R2023a+ | Interface with the BMI160 6-axis inertial measurement unit via I2C/SPI — use to measure acceleration and angular rate for motion tracking or orientation estimation |
| BMM150 | c2000sensorslib/BMM150 | R2023a+ | Interface with the BMM150 3-axis magnetometer via I2C — use to measure magnetic field for compass heading or proximity detection applications |
| BMP280 | c2000sensorslib/BMP280 | R2023a+ | Interface with the BMP280 barometric pressure and temperature sensor via I2C/SPI — use to measure atmospheric pressure for altitude estimation or weather monitoring |
| LIS3DH | c2000sensorslib/LIS3DH | R2023a+ | Interface with the LIS3DH 3-axis accelerometer via I2C/SPI — use to measure acceleration for motion detection, orientation sensing, or vibration analysis |
| sensors | c2000sensorslib/sensors | R2023a+ | Access the sensor driver library containing blocks for common I2C/SPI sensors — use as a container for accelerometer, gyroscope, magnetometer, and environmental sensor interfaces |

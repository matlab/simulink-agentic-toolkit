---
type: Simulink Block Category
title: Peripherals
description: Communication and I/O peripherals
tags: [serial, i2c, can, pwm, analog]
status: stable
source: mathworks_toolbox
library_root: UAV Toolbox Support Package for PX4 Autopilots
category_path: Peripherals
block_count: 8
---

# Peripherals

Use these blocks for peripherals.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| PX4 Analog Input | px4Peripheralslib/PX4 Analog Input | R2023a+ | Read analog voltage from ADC pins on PX4 hardware — use for sampling external sensor voltages on the autopilot board |
| I2C Controller Read | px4Peripheralslib/I2C Controller Read | R2023a+ | Read from I2C devices connected to PX4 — use for interfacing with external I2C sensors or peripherals on the autopilot |
| I2C Controller Write | px4Peripheralslib/I2C Controller Write | R2023a+ | Write to I2C devices connected to PX4 — use for configuring or commanding external I2C peripherals |
| PX4 CAN Receive | px4Peripheralslib/PX4 CAN Receive | R2023a+ | Receive CAN bus messages on PX4 — use for reading data from UAVCAN sensors or other CAN devices |
| PX4 CAN Transmit | px4Peripheralslib/PX4 CAN Transmit | R2023a+ | Transmit CAN bus messages from PX4 — use for sending commands to UAVCAN actuators or peripherals |
| PX4 PWM Output | px4Peripheralslib/PX4 PWM Output | R2023a+ | Generate PWM signals on PX4 output pins — use for directly driving servos or ESCs bypassing the PX4 mixer |
| Serial Receive | px4Peripheralslib/Serial Receive | R2023a+ | Receive serial data on PX4 UART — use for reading data from external sensors, companion computers, or GPS modules |
| Serial Transmit | px4Peripheralslib/Serial Transmit | R2023a+ | Transmit serial data on PX4 UART — use for sending telemetry or commands to external devices |

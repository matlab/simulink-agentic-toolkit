---
type: Simulink Block Category
title: Io basic
description: Digital/analog pins and serial buses on the micro:bit
tags: [basic, digital, analog, pwm, i2c, spi, sci]
status: stable
source: custom_library
library_root: Simulink Coder Support Package for BBC micro:bit
category_path: Io basic
block_count: 11
---

# Io basic

Use these blocks for io basic.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Analog Input | microbitbasiclib/Analog Input | R2023a+ | Read an analog voltage from a micro:bit pin (ADC) — use to sense analog inputs like light level or a potentiometer. |
| Digital Read | microbitbasiclib/Digital Read | R2023a+ | Read the digital state (0/1) of a micro:bit pin — use to sense buttons or digital sensors. |
| Digital Write | microbitbasiclib/Digital Write | R2023a+ | Set a micro:bit pin high or low — use to drive LEDs, relays, or other digital outputs. |
| I2C Master Read | microbitbasiclib/I2C Master Read | R2023a+ | Read bytes from an I2C peripheral as bus master — use to get data from I2C sensors or devices. |
| I2C Master Write | microbitbasiclib/I2C Master Write | R2023a+ | Write bytes to an I2C peripheral as bus master — use to configure or command I2C devices. |
| PWM Output | microbitbasiclib/PWM Output | R2023a+ | Generate a PWM signal on a micro:bit pin — use for dimming LEDs, driving servos, or tone generation. |
| SCI Read | microbitbasiclib/SCI Read | R2023a+ | Read bytes from the serial (UART) port — use to receive data from a host or serial device. |
| SCI Write | microbitbasiclib/SCI Write | R2023a+ | Write bytes to the serial (UART) port — use to send data or logging to a host or serial device. |
| SPI Master Transfer | microbitbasiclib/SPI Master Transfer | R2023a+ | Exchange bytes with an SPI peripheral as bus master — use for full-duplex SPI communication. |
| SPI Register Read | microbitbasiclib/SPI Register Read | R2023a+ | Read a register from an SPI peripheral — use to query SPI sensor/device registers. |
| SPI Register Write | microbitbasiclib/SPI Register Write | R2023a+ | Write a register on an SPI peripheral — use to configure SPI sensor/device registers. |

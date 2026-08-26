---
type: Block Selection Guide
title: Common Blocks
description: High-value blocks selected for quick agent discovery.
status: stable
source: mathworks_toolbox
block_count: 30
---

# Common Blocks

Prefer these blocks when their intent matches the user request.

| Intent | Preferred Block | Library |
|---|---|---|
| Configure and read the on-chip analog-to-digital converter — use to sample analog sensor signals (voltage, current, temperature) at specified channels and conversion rates for closed-loop control | ADC | C2000 Microcontroller Blockset |
| Read the state of a GPIO pin configured as digital input — use to sample discrete signals like push buttons, limit switches, fault indicators, or communication handshake lines | Digital Input | C2000 Microcontroller Blockset |
| Set the state of a GPIO pin configured as digital output — use to control LEDs, enable signals, relay drivers, or discrete actuator commands | Digital Output | C2000 Microcontroller Blockset |
| Receive data over the I2C bus — use to read registers or data from I2C peripheral devices such as temperature sensors, EEPROMs, or display controllers | I2C Receive | C2000 Microcontroller Blockset |
| Transmit data over the I2C bus — use to write configuration registers or send commands to I2C peripheral devices | I2C Transmit | C2000 Microcontroller Blockset |
| Receive data bytes from the Serial Communication Interface (UART) peripheral — use to read asynchronous serial data from external devices, sensors, or host PCs | SCI Receive | C2000 Microcontroller Blockset |
| Transmit data bytes over the Serial Communication Interface (UART) peripheral — use to send status, telemetry, or command data to external devices or host PCs | SCI Transmit | C2000 Microcontroller Blockset |
| Perform a full-duplex SPI transfer as the bus controller — use to simultaneously send and receive data with SPI peripheral devices like ADCs, DACs, or memory chips | SPI Controller Transfer | C2000 Microcontroller Blockset |
| Configure the hardware watchdog timer — use to automatically reset the processor if the control loop stalls, preventing uncontrolled actuator states in safety-critical systems | Watchdog | C2000 Microcontroller Blockset |
| Configure the Enhanced Capture module to timestamp input signal edges with high resolution — use to measure pulse width, period, or duty cycle of external signals like hall sensors or tachometer pulses | eCAP | C2000 Microcontroller Blockset |
| Configure the Enhanced PWM module with independent time-base, compare, action-qualifier, dead-band, and trip-zone submodules — use as the primary actuator output for motor control, power converter switching, and precision waveform generation | ePWM | C2000 Microcontroller Blockset |
| Configure and read the on-chip analog-to-digital converter — use to sample analog sensor signals (voltage, current, temperature) at specified channels and conversion rates for closed-loop control | ADC | C2000 Microcontroller Blockset |
| Receive CAN messages from the on-chip CAN controller — use to read data frames from a CAN bus in automotive or industrial control networks | CAN Receive | C2000 Microcontroller Blockset |
| Transmit CAN messages through the on-chip CAN controller — use to send data frames onto a CAN bus for inter-ECU communication | CAN Transmit | C2000 Microcontroller Blockset |
| Read the state of a GPIO pin configured as digital input — use to sample discrete signals like push buttons, limit switches, fault indicators, or communication handshake lines | Digital Input | C2000 Microcontroller Blockset |
| Set the state of a GPIO pin configured as digital output — use to control LEDs, enable signals, relay drivers, or discrete actuator commands | Digital Output | C2000 Microcontroller Blockset |
| Receive data over the I2C bus — use to read registers or data from I2C peripheral devices such as temperature sensors, EEPROMs, or display controllers | I2C Receive | C2000 Microcontroller Blockset |
| Transmit data over the I2C bus — use to write configuration registers or send commands to I2C peripheral devices | I2C Transmit | C2000 Microcontroller Blockset |
| Receive data bytes from the Serial Communication Interface (UART) peripheral — use to read asynchronous serial data from external devices, sensors, or host PCs | SCI Receive | C2000 Microcontroller Blockset |
| Transmit data bytes over the Serial Communication Interface (UART) peripheral — use to send status, telemetry, or command data to external devices or host PCs | SCI Transmit | C2000 Microcontroller Blockset |
| Perform a full-duplex SPI transfer as the bus controller — use to simultaneously send and receive data with SPI peripheral devices like ADCs, DACs, or memory chips | SPI Controller Transfer | C2000 Microcontroller Blockset |
| Configure the hardware watchdog timer — use to automatically reset the processor if the control loop stalls, preventing uncontrolled actuator states in safety-critical systems | Watchdog | C2000 Microcontroller Blockset |
| Configure the Enhanced Capture module to timestamp input signal edges with high resolution — use to measure pulse width, period, or duty cycle of external signals like hall sensors or tachometer pulses | eCAP | C2000 Microcontroller Blockset |
| Configure the Enhanced PWM module with independent time-base, compare, action-qualifier, dead-band, and trip-zone submodules — use as the primary actuator output for motor control, power converter switching, and precision waveform generation | ePWM | C2000 Microcontroller Blockset |
| Configure the Enhanced Quadrature Encoder Pulse module — use to decode incremental encoder A/B/Index signals for position and speed measurement in servo motor control | eQEP | C2000 Microcontroller Blockset |
| Configure and read the on-chip analog-to-digital converter — use to sample analog sensor signals (voltage, current, temperature) at specified channels and conversion rates for closed-loop control | ADC | C2000 Microcontroller Blockset |
| Receive CAN messages from the on-chip CAN controller — use to read data frames from a CAN bus in automotive or industrial control networks | CAN Receive | C2000 Microcontroller Blockset |
| Transmit CAN messages through the on-chip CAN controller — use to send data frames onto a CAN bus for inter-ECU communication | CAN Transmit | C2000 Microcontroller Blockset |
| Read the state of a GPIO pin configured as digital input — use to sample discrete signals like push buttons, limit switches, fault indicators, or communication handshake lines | Digital Input | C2000 Microcontroller Blockset |
| Set the state of a GPIO pin configured as digital output — use to control LEDs, enable signals, relay drivers, or discrete actuator commands | Digital Output | C2000 Microcontroller Blockset |

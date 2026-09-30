---
type: Simulink Block Category
title: Serial comm
description: SPI, I2C, SCI/UART, and host serial communication
tags: [spi, i2c, sci, uart, serial]
status: stable
source: custom_library
library_root: C2000 Microcontroller Blockset
category_path: Serial comm
block_count: 164
---

# Serial comm

Use these blocks for serial comm.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| I2C Receive | c2802xlib/I2C Receive | R2023a+ | Read data from a device on the I2C bus — use to acquire data from I2C sensors or peripherals. |
| I2C Transmit | c2802xlib/I2C Transmit | R2023a+ | Write data to a device on the I2C bus — use to configure or send data to I2C peripherals. |
| SCI Receive | c2802xlib/SCI Receive | R2023a+ | Receive serial data over the SCI (UART) port — use to read data from a host or serial device. |
| SCI Transmit | c2802xlib/SCI Transmit | R2023a+ | Send serial data over the SCI (UART) port — use to transmit data to a host or serial device. |
| SPI Controller Transfer | c2802xlib/SPI Controller Transfer | R2023a+ | Perform a full-duplex SPI transfer as controller (master) — use to exchange data with an SPI peripheral in one transaction. |
| SPI Receive | c2802xlib/SPI Receive | R2023a+ | Read data received over the SPI bus — use to acquire data from SPI peripherals. |
| SPI Transmit | c2802xlib/SPI Transmit | R2023a+ | Send data over the SPI bus — use to write to SPI peripherals. |
| I2C Receive | c2803xlib/I2C Receive | R2023a+ | Read data from a device on the I2C bus — use to acquire data from I2C sensors or peripherals. |
| I2C Transmit | c2803xlib/I2C Transmit | R2023a+ | Write data to a device on the I2C bus — use to configure or send data to I2C peripherals. |
| SCI Receive | c2803xlib/SCI Receive | R2023a+ | Receive serial data over the SCI (UART) port — use to read data from a host or serial device. |
| SCI Transmit | c2803xlib/SCI Transmit | R2023a+ | Send serial data over the SCI (UART) port — use to transmit data to a host or serial device. |
| SPI Controller Transfer | c2803xlib/SPI Controller Transfer | R2023a+ | Perform a full-duplex SPI transfer as controller (master) — use to exchange data with an SPI peripheral in one transaction. |
| SPI Receive | c2803xlib/SPI Receive | R2023a+ | Read data received over the SPI bus — use to acquire data from SPI peripherals. |
| SPI Transmit | c2803xlib/SPI Transmit | R2023a+ | Send data over the SPI bus — use to write to SPI peripherals. |
| I2C Receive | c280xlib/I2C Receive | R2023a+ | Read data from a device on the I2C bus — use to acquire data from I2C sensors or peripherals. |
| I2C Transmit | c280xlib/I2C Transmit | R2023a+ | Write data to a device on the I2C bus — use to configure or send data to I2C peripherals. |
| SCI Receive | c280xlib/SCI Receive | R2023a+ | Receive serial data over the SCI (UART) port — use to read data from a host or serial device. |
| SCI Transmit | c280xlib/SCI Transmit | R2023a+ | Send serial data over the SCI (UART) port — use to transmit data to a host or serial device. |
| SPI Controller Transfer | c280xlib/SPI Controller Transfer | R2023a+ | Perform a full-duplex SPI transfer as controller (master) — use to exchange data with an SPI peripheral in one transaction. |
| SPI Receive | c280xlib/SPI Receive | R2023a+ | Read data received over the SPI bus — use to acquire data from SPI peripherals. |
| SPI Transmit | c280xlib/SPI Transmit | R2023a+ | Send data over the SPI bus — use to write to SPI peripherals. |
| SCI Receive | c281xlib/SCI Receive | R2023a+ | Receive serial data over the SCI (UART) port — use to read data from a host or serial device. |
| SCI Transmit | c281xlib/SCI Transmit | R2023a+ | Send serial data over the SCI (UART) port — use to transmit data to a host or serial device. |
| SPI Controller Transfer | c281xlib/SPI Controller Transfer | R2023a+ | Perform a full-duplex SPI transfer as controller (master) — use to exchange data with an SPI peripheral in one transaction. |
| SPI Receive | c281xlib/SPI Receive | R2023a+ | Read data received over the SPI bus — use to acquire data from SPI peripherals. |
| SPI Transmit | c281xlib/SPI Transmit | R2023a+ | Send data over the SPI bus — use to write to SPI peripherals. |
| I2C Receive | c2833xlib/I2C Receive | R2023a+ | Read data from a device on the I2C bus — use to acquire data from I2C sensors or peripherals. |
| I2C Transmit | c2833xlib/I2C Transmit | R2023a+ | Write data to a device on the I2C bus — use to configure or send data to I2C peripherals. |
| SCI Receive | c2833xlib/SCI Receive | R2023a+ | Receive serial data over the SCI (UART) port — use to read data from a host or serial device. |
| SCI Transmit | c2833xlib/SCI Transmit | R2023a+ | Send serial data over the SCI (UART) port — use to transmit data to a host or serial device. |
| SPI Controller Transfer | c2833xlib/SPI Controller Transfer | R2023a+ | Perform a full-duplex SPI transfer as controller (master) — use to exchange data with an SPI peripheral in one transaction. |
| SPI Receive | c2833xlib/SPI Receive | R2023a+ | Read data received over the SPI bus — use to acquire data from SPI peripherals. |
| SPI Transmit | c2833xlib/SPI Transmit | R2023a+ | Send data over the SPI bus — use to write to SPI peripherals. |
| I2C Receive | c2834xlib/I2C Receive | R2023a+ | Read data from a device on the I2C bus — use to acquire data from I2C sensors or peripherals. |
| I2C Transmit | c2834xlib/I2C Transmit | R2023a+ | Write data to a device on the I2C bus — use to configure or send data to I2C peripherals. |
| SCI Receive | c2834xlib/SCI Receive | R2023a+ | Receive serial data over the SCI (UART) port — use to read data from a host or serial device. |
| SCI Transmit | c2834xlib/SCI Transmit | R2023a+ | Send serial data over the SCI (UART) port — use to transmit data to a host or serial device. |
| SPI Controller Transfer | c2834xlib/SPI Controller Transfer | R2023a+ | Perform a full-duplex SPI transfer as controller (master) — use to exchange data with an SPI peripheral in one transaction. |
| SPI Receive | c2834xlib/SPI Receive | R2023a+ | Read data received over the SPI bus — use to acquire data from SPI peripherals. |
| SPI Transmit | c2834xlib/SPI Transmit | R2023a+ | Send data over the SPI bus — use to write to SPI peripherals. |
| I2C Receive | c2805xlib/I2C Receive | R2023a+ | Read data from a device on the I2C bus — use to acquire data from I2C sensors or peripherals. |
| I2C Transmit | c2805xlib/I2C Transmit | R2023a+ | Write data to a device on the I2C bus — use to configure or send data to I2C peripherals. |
| SCI Receive | c2805xlib/SCI Receive | R2023a+ | Receive serial data over the SCI (UART) port — use to read data from a host or serial device. |
| SCI Transmit | c2805xlib/SCI Transmit | R2023a+ | Send serial data over the SCI (UART) port — use to transmit data to a host or serial device. |
| SPI Controller Transfer | c2805xlib/SPI Controller Transfer | R2023a+ | Perform a full-duplex SPI transfer as controller (master) — use to exchange data with an SPI peripheral in one transaction. |
| SPI Receive | c2805xlib/SPI Receive | R2023a+ | Read data received over the SPI bus — use to acquire data from SPI peripherals. |
| SPI Transmit | c2805xlib/SPI Transmit | R2023a+ | Send data over the SPI bus — use to write to SPI peripherals. |
| I2C Receive | c2806xlib/I2C Receive | R2023a+ | Read data from a device on the I2C bus — use to acquire data from I2C sensors or peripherals. |
| I2C Transmit | c2806xlib/I2C Transmit | R2023a+ | Write data to a device on the I2C bus — use to configure or send data to I2C peripherals. |
| SCI Receive | c2806xlib/SCI Receive | R2023a+ | Receive serial data over the SCI (UART) port — use to read data from a host or serial device. |
| SCI Transmit | c2806xlib/SCI Transmit | R2023a+ | Send serial data over the SCI (UART) port — use to transmit data to a host or serial device. |
| SPI Controller Transfer | c2806xlib/SPI Controller Transfer | R2023a+ | Perform a full-duplex SPI transfer as controller (master) — use to exchange data with an SPI peripheral in one transaction. |
| SPI Receive | c2806xlib/SPI Receive | R2023a+ | Read data received over the SPI bus — use to acquire data from SPI peripherals. |
| SPI Transmit | c2806xlib/SPI Transmit | R2023a+ | Send data over the SPI bus — use to write to SPI peripherals. |
| I2C Receive | c280013xlib/I2C Receive | R2023b+ | Read data from a device on the I2C bus — use to acquire data from I2C sensors or peripherals. |
| I2C Transmit | c280013xlib/I2C Transmit | R2023b+ | Write data to a device on the I2C bus — use to configure or send data to I2C peripherals. |
| SCI Receive | c280013xlib/SCI Receive | R2023b+ | Receive serial data over the SCI (UART) port — use to read data from a host or serial device. |
| SCI Transmit | c280013xlib/SCI Transmit | R2023b+ | Send serial data over the SCI (UART) port — use to transmit data to a host or serial device. |
| SPI Controller Transfer | c280013xlib/SPI Controller Transfer | R2023b+ | Perform a full-duplex SPI transfer as controller (master) — use to exchange data with an SPI peripheral in one transaction. |
| SPI Receive | c280013xlib/SPI Receive | R2023b+ | Read data received over the SPI bus — use to acquire data from SPI peripherals. |
| SPI Transmit | c280013xlib/SPI Transmit | R2023b+ | Send data over the SPI bus — use to write to SPI peripherals. |
| I2C Receive | c280015xlib/I2C Receive | R2023b+ | Read data from a device on the I2C bus — use to acquire data from I2C sensors or peripherals. |
| I2C Transmit | c280015xlib/I2C Transmit | R2023b+ | Write data to a device on the I2C bus — use to configure or send data to I2C peripherals. |
| SCI Receive | c280015xlib/SCI Receive | R2023b+ | Receive serial data over the SCI (UART) port — use to read data from a host or serial device. |
| SCI Transmit | c280015xlib/SCI Transmit | R2023b+ | Send serial data over the SCI (UART) port — use to transmit data to a host or serial device. |
| SPI Controller Transfer | c280015xlib/SPI Controller Transfer | R2023b+ | Perform a full-duplex SPI transfer as controller (master) — use to exchange data with an SPI peripheral in one transaction. |
| SPI Receive | c280015xlib/SPI Receive | R2023b+ | Read data received over the SPI bus — use to acquire data from SPI peripherals. |
| SPI Transmit | c280015xlib/SPI Transmit | R2023b+ | Send data over the SPI bus — use to write to SPI peripherals. |
| I2C Receive | c28002xlib/I2C Receive | R2023a+ | Read data from a device on the I2C bus — use to acquire data from I2C sensors or peripherals. |
| I2C Transmit | c28002xlib/I2C Transmit | R2023a+ | Write data to a device on the I2C bus — use to configure or send data to I2C peripherals. |
| SCI Receive | c28002xlib/SCI Receive | R2023a+ | Receive serial data over the SCI (UART) port — use to read data from a host or serial device. |
| SCI Transmit | c28002xlib/SCI Transmit | R2023a+ | Send serial data over the SCI (UART) port — use to transmit data to a host or serial device. |
| SPI Controller Transfer | c28002xlib/SPI Controller Transfer | R2023a+ | Perform a full-duplex SPI transfer as controller (master) — use to exchange data with an SPI peripheral in one transaction. |
| SPI Receive | c28002xlib/SPI Receive | R2023a+ | Read data received over the SPI bus — use to acquire data from SPI peripherals. |
| SPI Transmit | c28002xlib/SPI Transmit | R2023a+ | Send data over the SPI bus — use to write to SPI peripherals. |
| I2C Receive | c28003xlib/I2C Receive | R2023a+ | Read data from a device on the I2C bus — use to acquire data from I2C sensors or peripherals. |
| I2C Transmit | c28003xlib/I2C Transmit | R2023a+ | Write data to a device on the I2C bus — use to configure or send data to I2C peripherals. |
| SCI Receive | c28003xlib/SCI Receive | R2023a+ | Receive serial data over the SCI (UART) port — use to read data from a host or serial device. |
| SCI Transmit | c28003xlib/SCI Transmit | R2023a+ | Send serial data over the SCI (UART) port — use to transmit data to a host or serial device. |
| SPI Controller Transfer | c28003xlib/SPI Controller Transfer | R2023a+ | Perform a full-duplex SPI transfer as controller (master) — use to exchange data with an SPI peripheral in one transaction. |
| SPI Receive | c28003xlib/SPI Receive | R2023a+ | Read data received over the SPI bus — use to acquire data from SPI peripherals. |
| SPI Transmit | c28003xlib/SPI Transmit | R2023a+ | Send data over the SPI bus — use to write to SPI peripherals. |
| I2C Receive | c28004xlib/I2C Receive | R2023a+ | Read data from a device on the I2C bus — use to acquire data from I2C sensors or peripherals. |
| I2C Transmit | c28004xlib/I2C Transmit | R2023a+ | Write data to a device on the I2C bus — use to configure or send data to I2C peripherals. |
| SCI Receive | c28004xlib/SCI Receive | R2023a+ | Receive serial data over the SCI (UART) port — use to read data from a host or serial device. |
| SCI Transmit | c28004xlib/SCI Transmit | R2023a+ | Send serial data over the SCI (UART) port — use to transmit data to a host or serial device. |
| SPI Controller Transfer | c28004xlib/SPI Controller Transfer | R2023a+ | Perform a full-duplex SPI transfer as controller (master) — use to exchange data with an SPI peripheral in one transaction. |
| SPI Receive | c28004xlib/SPI Receive | R2023a+ | Read data received over the SPI bus — use to acquire data from SPI peripherals. |
| SPI Transmit | c28004xlib/SPI Transmit | R2023a+ | Send data over the SPI bus — use to write to SPI peripherals. |
| I2C Receive | c2807xlib/I2C Receive | R2023a+ | Read data from a device on the I2C bus — use to acquire data from I2C sensors or peripherals. |
| I2C Transmit | c2807xlib/I2C Transmit | R2023a+ | Write data to a device on the I2C bus — use to configure or send data to I2C peripherals. |
| SCI Receive | c2807xlib/SCI Receive | R2023a+ | Receive serial data over the SCI (UART) port — use to read data from a host or serial device. |
| SCI Transmit | c2807xlib/SCI Transmit | R2023a+ | Send serial data over the SCI (UART) port — use to transmit data to a host or serial device. |
| SPI Controller Transfer | c2807xlib/SPI Controller Transfer | R2023a+ | Perform a full-duplex SPI transfer as controller (master) — use to exchange data with an SPI peripheral in one transaction. |
| SPI Receive | c2807xlib/SPI Receive | R2023a+ | Read data received over the SPI bus — use to acquire data from SPI peripherals. |
| SPI Transmit | c2807xlib/SPI Transmit | R2023a+ | Send data over the SPI bus — use to write to SPI peripherals. |
| I2C Receive | c2837xDlib/I2C Receive | R2023a+ | Read data from a device on the I2C bus — use to acquire data from I2C sensors or peripherals. |
| I2C Transmit | c2837xDlib/I2C Transmit | R2023a+ | Write data to a device on the I2C bus — use to configure or send data to I2C peripherals. |
| SCI Receive | c2837xDlib/SCI Receive | R2023a+ | Receive serial data over the SCI (UART) port — use to read data from a host or serial device. |
| SCI Transmit | c2837xDlib/SCI Transmit | R2023a+ | Send serial data over the SCI (UART) port — use to transmit data to a host or serial device. |
| SPI Controller Transfer | c2837xDlib/SPI Controller Transfer | R2023a+ | Perform a full-duplex SPI transfer as controller (master) — use to exchange data with an SPI peripheral in one transaction. |
| SPI Receive | c2837xDlib/SPI Receive | R2023a+ | Read data received over the SPI bus — use to acquire data from SPI peripherals. |
| SPI Transmit | c2837xDlib/SPI Transmit | R2023a+ | Send data over the SPI bus — use to write to SPI peripherals. |
| I2C Receive | c2837xSlib/I2C Receive | R2023a+ | Read data from a device on the I2C bus — use to acquire data from I2C sensors or peripherals. |
| I2C Transmit | c2837xSlib/I2C Transmit | R2023a+ | Write data to a device on the I2C bus — use to configure or send data to I2C peripherals. |
| SCI Receive | c2837xSlib/SCI Receive | R2023a+ | Receive serial data over the SCI (UART) port — use to read data from a host or serial device. |
| SCI Transmit | c2837xSlib/SCI Transmit | R2023a+ | Send serial data over the SCI (UART) port — use to transmit data to a host or serial device. |
| SPI Controller Transfer | c2837xSlib/SPI Controller Transfer | R2023a+ | Perform a full-duplex SPI transfer as controller (master) — use to exchange data with an SPI peripheral in one transaction. |
| SPI Receive | c2837xSlib/SPI Receive | R2023a+ | Read data received over the SPI bus — use to acquire data from SPI peripherals. |
| SPI Transmit | c2837xSlib/SPI Transmit | R2023a+ | Send data over the SPI bus — use to write to SPI peripherals. |
| I2C Receive | c2838xlib/I2C Receive | R2023a+ | Read data from a device on the I2C bus — use to acquire data from I2C sensors or peripherals. |
| I2C Transmit | c2838xlib/I2C Transmit | R2023a+ | Write data to a device on the I2C bus — use to configure or send data to I2C peripherals. |
| SCI Receive | c2838xlib/SCI Receive | R2023a+ | Receive serial data over the SCI (UART) port — use to read data from a host or serial device. |
| SCI Transmit | c2838xlib/SCI Transmit | R2023a+ | Send serial data over the SCI (UART) port — use to transmit data to a host or serial device. |
| SPI Controller Transfer | c2838xlib/SPI Controller Transfer | R2023a+ | Perform a full-duplex SPI transfer as controller (master) — use to exchange data with an SPI peripheral in one transaction. |
| SPI Receive | c2838xlib/SPI Receive | R2023a+ | Read data received over the SPI bus — use to acquire data from SPI peripherals. |
| SPI Transmit | c2838xlib/SPI Transmit | R2023a+ | Send data over the SPI bus — use to write to SPI peripherals. |
| UART Receive | c2838x_M4_lib/UART Receive | R2023a+ | Receive serial data over a UART port — use to read data from a serial device. |
| UART Transmit | c2838x_M4_lib/UART Transmit | R2023a+ | Send serial data over a UART port — use to transmit data to a serial device. |
| I2C Receive | f28M35x_C28x_lib/I2C Receive | R2023a+ | Read data from a device on the I2C bus — use to acquire data from I2C sensors or peripherals. |
| I2C Transmit | f28M35x_C28x_lib/I2C Transmit | R2023a+ | Write data to a device on the I2C bus — use to configure or send data to I2C peripherals. |
| SCI Receive | f28M35x_C28x_lib/SCI Receive | R2023a+ | Receive serial data over the SCI (UART) port — use to read data from a host or serial device. |
| SCI Transmit | f28M35x_C28x_lib/SCI Transmit | R2023a+ | Send serial data over the SCI (UART) port — use to transmit data to a host or serial device. |
| SPI Controller Transfer | f28M35x_C28x_lib/SPI Controller Transfer | R2023a+ | Perform a full-duplex SPI transfer as controller (master) — use to exchange data with an SPI peripheral in one transaction. |
| SPI Receive | f28M35x_C28x_lib/SPI Receive | R2023a+ | Read data received over the SPI bus — use to acquire data from SPI peripherals. |
| SPI Transmit | f28M35x_C28x_lib/SPI Transmit | R2023a+ | Send data over the SPI bus — use to write to SPI peripherals. |
| UART Receive | f28M35x_M3_lib/UART Receive | R2023a+ | Receive serial data over a UART port — use to read data from a serial device. |
| UART Transmit | f28M35x_M3_lib/UART Transmit | R2023a+ | Send serial data over a UART port — use to transmit data to a serial device. |
| I2C Receive | f28M36x_C28x_lib/I2C Receive | R2023a+ | Read data from a device on the I2C bus — use to acquire data from I2C sensors or peripherals. |
| I2C Transmit | f28M36x_C28x_lib/I2C Transmit | R2023a+ | Write data to a device on the I2C bus — use to configure or send data to I2C peripherals. |
| SCI Receive | f28M36x_C28x_lib/SCI Receive | R2023a+ | Receive serial data over the SCI (UART) port — use to read data from a host or serial device. |
| SCI Transmit | f28M36x_C28x_lib/SCI Transmit | R2023a+ | Send serial data over the SCI (UART) port — use to transmit data to a host or serial device. |
| SPI Controller Transfer | f28M36x_C28x_lib/SPI Controller Transfer | R2023a+ | Perform a full-duplex SPI transfer as controller (master) — use to exchange data with an SPI peripheral in one transaction. |
| SPI Receive | f28M36x_C28x_lib/SPI Receive | R2023a+ | Read data received over the SPI bus — use to acquire data from SPI peripherals. |
| SPI Transmit | f28M36x_C28x_lib/SPI Transmit | R2023a+ | Send data over the SPI bus — use to write to SPI peripherals. |
| UART Receive | f28M36x_M3_lib/UART Receive | R2023a+ | Receive serial data over a UART port — use to read data from a serial device. |
| UART Transmit | f28M36x_M3_lib/UART Transmit | R2023a+ | Send serial data over a UART port — use to transmit data to a serial device. |
| I2C Receive | c28P55xlib/I2C Receive | R2024b+ | Read data from a device on the I2C bus — use to acquire data from I2C sensors or peripherals. |
| I2C Transmit | c28P55xlib/I2C Transmit | R2024b+ | Write data to a device on the I2C bus — use to configure or send data to I2C peripherals. |
| SCI Receive | c28P55xlib/SCI Receive | R2024b+ | Receive serial data over the SCI (UART) port — use to read data from a host or serial device. |
| SCI Transmit | c28P55xlib/SCI Transmit | R2024b+ | Send serial data over the SCI (UART) port — use to transmit data to a host or serial device. |
| SPI Controller Transfer | c28P55xlib/SPI Controller Transfer | R2024b+ | Perform a full-duplex SPI transfer as controller (master) — use to exchange data with an SPI peripheral in one transaction. |
| SPI Receive | c28P55xlib/SPI Receive | R2024b+ | Read data received over the SPI bus — use to acquire data from SPI peripherals. |
| SPI Transmit | c28P55xlib/SPI Transmit | R2024b+ | Send data over the SPI bus — use to write to SPI peripherals. |
| I2C Receive | c28P65xlib/I2C Receive | R2024a+ | Read data from a device on the I2C bus — use to acquire data from I2C sensors or peripherals. |
| I2C Transmit | c28P65xlib/I2C Transmit | R2024a+ | Write data to a device on the I2C bus — use to configure or send data to I2C peripherals. |
| SCI Receive | c28P65xlib/SCI Receive | R2024a+ | Receive serial data over the SCI (UART) port — use to read data from a host or serial device. |
| SCI Transmit | c28P65xlib/SCI Transmit | R2024a+ | Send serial data over the SCI (UART) port — use to transmit data to a host or serial device. |
| SPI Controller Transfer | c28P65xlib/SPI Controller Transfer | R2024a+ | Perform a full-duplex SPI transfer as controller (master) — use to exchange data with an SPI peripheral in one transaction. |
| SPI Receive | c28P65xlib/SPI Receive | R2024a+ | Read data received over the SPI bus — use to acquire data from SPI peripherals. |
| SPI Transmit | c28P65xlib/SPI Transmit | R2024a+ | Send data over the SPI bus — use to write to SPI peripherals. |
| I2C Receive | c29H85xlib/I2C Receive | R2026a+ | Read data from a device on the I2C bus — use to acquire data from I2C sensors or peripherals. |
| I2C Transmit | c29H85xlib/I2C Transmit | R2026a+ | Write data to a device on the I2C bus — use to configure or send data to I2C peripherals. |
| SPI Controller Transfer | c29H85xlib/SPI Controller Transfer | R2026a+ | Perform a full-duplex SPI transfer as controller (master) — use to exchange data with an SPI peripheral in one transaction. |
| SPI Receive | c29H85xlib/SPI Receive | R2026a+ | Read data received over the SPI bus — use to acquire data from SPI peripherals. |
| SPI Transmit1 | c29H85xlib/SPI Transmit1 | R2026a+ | Send data over an SPI port to a connected device — use to write to SPI peripherals. |
| UART Receive | c29H85xlib/UART Receive | R2025a+ | Receive serial data over a UART port — use to read data from a serial device. |
| UART Transmit | c29H85xlib/UART Transmit | R2025a+ | Send serial data over a UART port — use to transmit data to a serial device. |
| Serial Configuration | c2000lib/Host Communication/Serial Configuration | R2023a+ | Configure serial port settings (baud, parity, data bits) for host communication — use to set up a serial link before send/receive. |
| Serial Receive | c2000lib/Host Communication/Serial Receive | R2023a+ | Receive data over the host serial port — use to read data from the connected host PC. |
| Serial Send | c2000lib/Host Communication/Serial Send | R2023a+ | Send data over the host serial port — use to stream data to the connected host PC. |
| Serial Configuration | c2000lib/Test Bench Blocks/Serial Configuration | R2023a+ | Configure serial port settings (baud, parity, data bits) for host communication — use to set up a serial link before send/receive. |
| Serial Receive | c2000lib/Test Bench Blocks/Serial Receive | R2023a+ | Receive data over the host serial port — use to read data from the connected host PC. |
| Serial Send | c2000lib/Test Bench Blocks/Serial Send | R2023a+ | Send data over the host serial port — use to stream data to the connected host PC. |

---
type: Simulink Block Category
title: Serial communication
description: Serial communication peripherals: SCI/UART, SPI, I2C, and LIN interfaces
tags: [sci, spi, i2c, uart, lin]
status: stable
source: mathworks_toolbox
library_root: C2000 Microcontroller Blockset
category_path: Serial communication
block_count: 165
---

# Serial communication

Use these blocks for serial communication.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| I2C Receive | c2802xlib/I2C Receive | R2023a+ | Receive data over the I2C bus — use to read registers or data from I2C peripheral devices such as temperature sensors, EEPROMs, or display controllers |
| I2C Transmit | c2802xlib/I2C Transmit | R2023a+ | Transmit data over the I2C bus — use to write configuration registers or send commands to I2C peripheral devices |
| SCI Receive | c2802xlib/SCI Receive | R2023a+ | Receive data bytes from the Serial Communication Interface (UART) peripheral — use to read asynchronous serial data from external devices, sensors, or host PCs |
| SCI Transmit | c2802xlib/SCI Transmit | R2023a+ | Transmit data bytes over the Serial Communication Interface (UART) peripheral — use to send status, telemetry, or command data to external devices or host PCs |
| SPI Controller Transfer | c2802xlib/SPI Controller Transfer | R2023a+ | Perform a full-duplex SPI transfer as the bus controller — use to simultaneously send and receive data with SPI peripheral devices like ADCs, DACs, or memory chips |
| SPI Receive | c2802xlib/SPI Receive | R2023a+ | Receive data from the SPI peripheral in peripheral mode — use to read data transferred by an external SPI controller device |
| SPI Transmit | c2802xlib/SPI Transmit | R2023a+ | Transmit data from the SPI peripheral in peripheral mode — use to send data to an external SPI controller device |
| I2C Receive | c2803xlib/I2C Receive | R2023a+ | Receive data over the I2C bus — use to read registers or data from I2C peripheral devices such as temperature sensors, EEPROMs, or display controllers |
| I2C Transmit | c2803xlib/I2C Transmit | R2023a+ | Transmit data over the I2C bus — use to write configuration registers or send commands to I2C peripheral devices |
| LIN Receive | c2803xlib/LIN Receive | R2023a+ | Receive data frames from the LIN bus — use to read sensor data or actuator feedback in automotive body electronics or seat/mirror control systems |
| LIN Transmit | c2803xlib/LIN Transmit | R2023a+ | Transmit data frames on the LIN bus — use to send commands to LIN peripheral nodes in automotive sub-networks |
| SCI Receive | c2803xlib/SCI Receive | R2023a+ | Receive data bytes from the Serial Communication Interface (UART) peripheral — use to read asynchronous serial data from external devices, sensors, or host PCs |
| SCI Transmit | c2803xlib/SCI Transmit | R2023a+ | Transmit data bytes over the Serial Communication Interface (UART) peripheral — use to send status, telemetry, or command data to external devices or host PCs |
| SPI Controller Transfer | c2803xlib/SPI Controller Transfer | R2023a+ | Perform a full-duplex SPI transfer as the bus controller — use to simultaneously send and receive data with SPI peripheral devices like ADCs, DACs, or memory chips |
| SPI Receive | c2803xlib/SPI Receive | R2023a+ | Receive data from the SPI peripheral in peripheral mode — use to read data transferred by an external SPI controller device |
| SPI Transmit | c2803xlib/SPI Transmit | R2023a+ | Transmit data from the SPI peripheral in peripheral mode — use to send data to an external SPI controller device |
| I2C Receive | c2805xlib/I2C Receive | R2023a+ | Receive data over the I2C bus — use to read registers or data from I2C peripheral devices such as temperature sensors, EEPROMs, or display controllers |
| I2C Transmit | c2805xlib/I2C Transmit | R2023a+ | Transmit data over the I2C bus — use to write configuration registers or send commands to I2C peripheral devices |
| SCI Receive | c2805xlib/SCI Receive | R2023a+ | Receive data bytes from the Serial Communication Interface (UART) peripheral — use to read asynchronous serial data from external devices, sensors, or host PCs |
| SCI Transmit | c2805xlib/SCI Transmit | R2023a+ | Transmit data bytes over the Serial Communication Interface (UART) peripheral — use to send status, telemetry, or command data to external devices or host PCs |
| SPI Controller Transfer | c2805xlib/SPI Controller Transfer | R2023a+ | Perform a full-duplex SPI transfer as the bus controller — use to simultaneously send and receive data with SPI peripheral devices like ADCs, DACs, or memory chips |
| SPI Receive | c2805xlib/SPI Receive | R2023a+ | Receive data from the SPI peripheral in peripheral mode — use to read data transferred by an external SPI controller device |
| SPI Transmit | c2805xlib/SPI Transmit | R2023a+ | Transmit data from the SPI peripheral in peripheral mode — use to send data to an external SPI controller device |
| I2C Receive | c2806xlib/I2C Receive | R2023a+ | Receive data over the I2C bus — use to read registers or data from I2C peripheral devices such as temperature sensors, EEPROMs, or display controllers |
| I2C Transmit | c2806xlib/I2C Transmit | R2023a+ | Transmit data over the I2C bus — use to write configuration registers or send commands to I2C peripheral devices |
| SCI Receive | c2806xlib/SCI Receive | R2023a+ | Receive data bytes from the Serial Communication Interface (UART) peripheral — use to read asynchronous serial data from external devices, sensors, or host PCs |
| SCI Transmit | c2806xlib/SCI Transmit | R2023a+ | Transmit data bytes over the Serial Communication Interface (UART) peripheral — use to send status, telemetry, or command data to external devices or host PCs |
| SPI Controller Transfer | c2806xlib/SPI Controller Transfer | R2023a+ | Perform a full-duplex SPI transfer as the bus controller — use to simultaneously send and receive data with SPI peripheral devices like ADCs, DACs, or memory chips |
| SPI Receive | c2806xlib/SPI Receive | R2023a+ | Receive data from the SPI peripheral in peripheral mode — use to read data transferred by an external SPI controller device |
| SPI Transmit | c2806xlib/SPI Transmit | R2023a+ | Transmit data from the SPI peripheral in peripheral mode — use to send data to an external SPI controller device |
| I2C Receive | c280xlib/I2C Receive | R2023a+ | Receive data over the I2C bus — use to read registers or data from I2C peripheral devices such as temperature sensors, EEPROMs, or display controllers |
| I2C Transmit | c280xlib/I2C Transmit | R2023a+ | Transmit data over the I2C bus — use to write configuration registers or send commands to I2C peripheral devices |
| SCI Receive | c280xlib/SCI Receive | R2023a+ | Receive data bytes from the Serial Communication Interface (UART) peripheral — use to read asynchronous serial data from external devices, sensors, or host PCs |
| SCI Transmit | c280xlib/SCI Transmit | R2023a+ | Transmit data bytes over the Serial Communication Interface (UART) peripheral — use to send status, telemetry, or command data to external devices or host PCs |
| SPI Controller Transfer | c280xlib/SPI Controller Transfer | R2023a+ | Perform a full-duplex SPI transfer as the bus controller — use to simultaneously send and receive data with SPI peripheral devices like ADCs, DACs, or memory chips |
| SPI Receive | c280xlib/SPI Receive | R2023a+ | Receive data from the SPI peripheral in peripheral mode — use to read data transferred by an external SPI controller device |
| SPI Transmit | c280xlib/SPI Transmit | R2023a+ | Transmit data from the SPI peripheral in peripheral mode — use to send data to an external SPI controller device |
| SCI Receive | c281xlib/SCI Receive | R2023a+ | Receive data bytes from the Serial Communication Interface (UART) peripheral — use to read asynchronous serial data from external devices, sensors, or host PCs |
| SCI Transmit | c281xlib/SCI Transmit | R2023a+ | Transmit data bytes over the Serial Communication Interface (UART) peripheral — use to send status, telemetry, or command data to external devices or host PCs |
| SPI Controller Transfer | c281xlib/SPI Controller Transfer | R2023a+ | Perform a full-duplex SPI transfer as the bus controller — use to simultaneously send and receive data with SPI peripheral devices like ADCs, DACs, or memory chips |
| SPI Receive | c281xlib/SPI Receive | R2023a+ | Receive data from the SPI peripheral in peripheral mode — use to read data transferred by an external SPI controller device |
| SPI Transmit | c281xlib/SPI Transmit | R2023a+ | Transmit data from the SPI peripheral in peripheral mode — use to send data to an external SPI controller device |
| I2C Receive | c2833xlib/I2C Receive | R2023a+ | Receive data over the I2C bus — use to read registers or data from I2C peripheral devices such as temperature sensors, EEPROMs, or display controllers |
| I2C Transmit | c2833xlib/I2C Transmit | R2023a+ | Transmit data over the I2C bus — use to write configuration registers or send commands to I2C peripheral devices |
| SCI Receive | c2833xlib/SCI Receive | R2023a+ | Receive data bytes from the Serial Communication Interface (UART) peripheral — use to read asynchronous serial data from external devices, sensors, or host PCs |
| SCI Transmit | c2833xlib/SCI Transmit | R2023a+ | Transmit data bytes over the Serial Communication Interface (UART) peripheral — use to send status, telemetry, or command data to external devices or host PCs |
| SPI Controller Transfer | c2833xlib/SPI Controller Transfer | R2023a+ | Perform a full-duplex SPI transfer as the bus controller — use to simultaneously send and receive data with SPI peripheral devices like ADCs, DACs, or memory chips |
| SPI Receive | c2833xlib/SPI Receive | R2023a+ | Receive data from the SPI peripheral in peripheral mode — use to read data transferred by an external SPI controller device |
| SPI Transmit | c2833xlib/SPI Transmit | R2023a+ | Transmit data from the SPI peripheral in peripheral mode — use to send data to an external SPI controller device |
| I2C Receive | c2834xlib/I2C Receive | R2023a+ | Receive data over the I2C bus — use to read registers or data from I2C peripheral devices such as temperature sensors, EEPROMs, or display controllers |
| I2C Transmit | c2834xlib/I2C Transmit | R2023a+ | Transmit data over the I2C bus — use to write configuration registers or send commands to I2C peripheral devices |
| SCI Receive | c2834xlib/SCI Receive | R2023a+ | Receive data bytes from the Serial Communication Interface (UART) peripheral — use to read asynchronous serial data from external devices, sensors, or host PCs |
| SCI Transmit | c2834xlib/SCI Transmit | R2023a+ | Transmit data bytes over the Serial Communication Interface (UART) peripheral — use to send status, telemetry, or command data to external devices or host PCs |
| SPI Controller Transfer | c2834xlib/SPI Controller Transfer | R2023a+ | Perform a full-duplex SPI transfer as the bus controller — use to simultaneously send and receive data with SPI peripheral devices like ADCs, DACs, or memory chips |
| SPI Receive | c2834xlib/SPI Receive | R2023a+ | Receive data from the SPI peripheral in peripheral mode — use to read data transferred by an external SPI controller device |
| SPI Transmit | c2834xlib/SPI Transmit | R2023a+ | Transmit data from the SPI peripheral in peripheral mode — use to send data to an external SPI controller device |
| I2C Receive | c280013xlib/I2C Receive | R2023b+ | Receive data over the I2C bus — use to read registers or data from I2C peripheral devices such as temperature sensors, EEPROMs, or display controllers |
| I2C Transmit | c280013xlib/I2C Transmit | R2023b+ | Transmit data over the I2C bus — use to write configuration registers or send commands to I2C peripheral devices |
| SCI Receive | c280013xlib/SCI Receive | R2023b+ | Receive data bytes from the Serial Communication Interface (UART) peripheral — use to read asynchronous serial data from external devices, sensors, or host PCs |
| SCI Transmit | c280013xlib/SCI Transmit | R2023b+ | Transmit data bytes over the Serial Communication Interface (UART) peripheral — use to send status, telemetry, or command data to external devices or host PCs |
| SPI Controller Transfer | c280013xlib/SPI Controller Transfer | R2023b+ | Perform a full-duplex SPI transfer as the bus controller — use to simultaneously send and receive data with SPI peripheral devices like ADCs, DACs, or memory chips |
| SPI Receive | c280013xlib/SPI Receive | R2023b+ | Receive data from the SPI peripheral in peripheral mode — use to read data transferred by an external SPI controller device |
| SPI Transmit | c280013xlib/SPI Transmit | R2023b+ | Transmit data from the SPI peripheral in peripheral mode — use to send data to an external SPI controller device |
| I2C Receive | c280015xlib/I2C Receive | R2023b+ | Receive data over the I2C bus — use to read registers or data from I2C peripheral devices such as temperature sensors, EEPROMs, or display controllers |
| I2C Transmit | c280015xlib/I2C Transmit | R2023b+ | Transmit data over the I2C bus — use to write configuration registers or send commands to I2C peripheral devices |
| SCI Receive | c280015xlib/SCI Receive | R2023b+ | Receive data bytes from the Serial Communication Interface (UART) peripheral — use to read asynchronous serial data from external devices, sensors, or host PCs |
| SCI Transmit | c280015xlib/SCI Transmit | R2023b+ | Transmit data bytes over the Serial Communication Interface (UART) peripheral — use to send status, telemetry, or command data to external devices or host PCs |
| SPI Controller Transfer | c280015xlib/SPI Controller Transfer | R2023b+ | Perform a full-duplex SPI transfer as the bus controller — use to simultaneously send and receive data with SPI peripheral devices like ADCs, DACs, or memory chips |
| SPI Receive | c280015xlib/SPI Receive | R2023b+ | Receive data from the SPI peripheral in peripheral mode — use to read data transferred by an external SPI controller device |
| SPI Transmit | c280015xlib/SPI Transmit | R2023b+ | Transmit data from the SPI peripheral in peripheral mode — use to send data to an external SPI controller device |
| I2C Receive | c28002xlib/I2C Receive | R2023a+ | Receive data over the I2C bus — use to read registers or data from I2C peripheral devices such as temperature sensors, EEPROMs, or display controllers |
| I2C Transmit | c28002xlib/I2C Transmit | R2023a+ | Transmit data over the I2C bus — use to write configuration registers or send commands to I2C peripheral devices |
| SCI Receive | c28002xlib/SCI Receive | R2023a+ | Receive data bytes from the Serial Communication Interface (UART) peripheral — use to read asynchronous serial data from external devices, sensors, or host PCs |
| SCI Transmit | c28002xlib/SCI Transmit | R2023a+ | Transmit data bytes over the Serial Communication Interface (UART) peripheral — use to send status, telemetry, or command data to external devices or host PCs |
| SPI Controller Transfer | c28002xlib/SPI Controller Transfer | R2023a+ | Perform a full-duplex SPI transfer as the bus controller — use to simultaneously send and receive data with SPI peripheral devices like ADCs, DACs, or memory chips |
| SPI Receive | c28002xlib/SPI Receive | R2023a+ | Receive data from the SPI peripheral in peripheral mode — use to read data transferred by an external SPI controller device |
| SPI Transmit | c28002xlib/SPI Transmit | R2023a+ | Transmit data from the SPI peripheral in peripheral mode — use to send data to an external SPI controller device |
| I2C Receive | c28003xlib/I2C Receive | R2023a+ | Receive data over the I2C bus — use to read registers or data from I2C peripheral devices such as temperature sensors, EEPROMs, or display controllers |
| I2C Transmit | c28003xlib/I2C Transmit | R2023a+ | Transmit data over the I2C bus — use to write configuration registers or send commands to I2C peripheral devices |
| SCI Receive | c28003xlib/SCI Receive | R2023a+ | Receive data bytes from the Serial Communication Interface (UART) peripheral — use to read asynchronous serial data from external devices, sensors, or host PCs |
| SCI Transmit | c28003xlib/SCI Transmit | R2023a+ | Transmit data bytes over the Serial Communication Interface (UART) peripheral — use to send status, telemetry, or command data to external devices or host PCs |
| SPI Controller Transfer | c28003xlib/SPI Controller Transfer | R2023a+ | Perform a full-duplex SPI transfer as the bus controller — use to simultaneously send and receive data with SPI peripheral devices like ADCs, DACs, or memory chips |
| SPI Receive | c28003xlib/SPI Receive | R2023a+ | Receive data from the SPI peripheral in peripheral mode — use to read data transferred by an external SPI controller device |
| SPI Transmit | c28003xlib/SPI Transmit | R2023a+ | Transmit data from the SPI peripheral in peripheral mode — use to send data to an external SPI controller device |
| I2C Receive | c28004xlib/I2C Receive | R2023a+ | Receive data over the I2C bus — use to read registers or data from I2C peripheral devices such as temperature sensors, EEPROMs, or display controllers |
| I2C Transmit | c28004xlib/I2C Transmit | R2023a+ | Transmit data over the I2C bus — use to write configuration registers or send commands to I2C peripheral devices |
| SCI Receive | c28004xlib/SCI Receive | R2023a+ | Receive data bytes from the Serial Communication Interface (UART) peripheral — use to read asynchronous serial data from external devices, sensors, or host PCs |
| SCI Transmit | c28004xlib/SCI Transmit | R2023a+ | Transmit data bytes over the Serial Communication Interface (UART) peripheral — use to send status, telemetry, or command data to external devices or host PCs |
| SPI Controller Transfer | c28004xlib/SPI Controller Transfer | R2023a+ | Perform a full-duplex SPI transfer as the bus controller — use to simultaneously send and receive data with SPI peripheral devices like ADCs, DACs, or memory chips |
| SPI Receive | c28004xlib/SPI Receive | R2023a+ | Receive data from the SPI peripheral in peripheral mode — use to read data transferred by an external SPI controller device |
| SPI Transmit | c28004xlib/SPI Transmit | R2023a+ | Transmit data from the SPI peripheral in peripheral mode — use to send data to an external SPI controller device |
| I2C Receive | c2807xlib/I2C Receive | R2023a+ | Receive data over the I2C bus — use to read registers or data from I2C peripheral devices such as temperature sensors, EEPROMs, or display controllers |
| I2C Transmit | c2807xlib/I2C Transmit | R2023a+ | Transmit data over the I2C bus — use to write configuration registers or send commands to I2C peripheral devices |
| SCI Receive | c2807xlib/SCI Receive | R2023a+ | Receive data bytes from the Serial Communication Interface (UART) peripheral — use to read asynchronous serial data from external devices, sensors, or host PCs |
| SCI Transmit | c2807xlib/SCI Transmit | R2023a+ | Transmit data bytes over the Serial Communication Interface (UART) peripheral — use to send status, telemetry, or command data to external devices or host PCs |
| SPI Controller Transfer | c2807xlib/SPI Controller Transfer | R2023a+ | Perform a full-duplex SPI transfer as the bus controller — use to simultaneously send and receive data with SPI peripheral devices like ADCs, DACs, or memory chips |
| SPI Receive | c2807xlib/SPI Receive | R2023a+ | Receive data from the SPI peripheral in peripheral mode — use to read data transferred by an external SPI controller device |
| SPI Transmit | c2807xlib/SPI Transmit | R2023a+ | Transmit data from the SPI peripheral in peripheral mode — use to send data to an external SPI controller device |
| I2C Receive | c2837xDlib/I2C Receive | R2023a+ | Receive data over the I2C bus — use to read registers or data from I2C peripheral devices such as temperature sensors, EEPROMs, or display controllers |
| I2C Transmit | c2837xDlib/I2C Transmit | R2023a+ | Transmit data over the I2C bus — use to write configuration registers or send commands to I2C peripheral devices |
| SCI Receive | c2837xDlib/SCI Receive | R2023a+ | Receive data bytes from the Serial Communication Interface (UART) peripheral — use to read asynchronous serial data from external devices, sensors, or host PCs |
| SCI Transmit | c2837xDlib/SCI Transmit | R2023a+ | Transmit data bytes over the Serial Communication Interface (UART) peripheral — use to send status, telemetry, or command data to external devices or host PCs |
| SPI Controller Transfer | c2837xDlib/SPI Controller Transfer | R2023a+ | Perform a full-duplex SPI transfer as the bus controller — use to simultaneously send and receive data with SPI peripheral devices like ADCs, DACs, or memory chips |
| SPI Receive | c2837xDlib/SPI Receive | R2023a+ | Receive data from the SPI peripheral in peripheral mode — use to read data transferred by an external SPI controller device |
| SPI Transmit | c2837xDlib/SPI Transmit | R2023a+ | Transmit data from the SPI peripheral in peripheral mode — use to send data to an external SPI controller device |
| I2C Receive | c2837xSlib/I2C Receive | R2023a+ | Receive data over the I2C bus — use to read registers or data from I2C peripheral devices such as temperature sensors, EEPROMs, or display controllers |
| I2C Transmit | c2837xSlib/I2C Transmit | R2023a+ | Transmit data over the I2C bus — use to write configuration registers or send commands to I2C peripheral devices |
| SCI Receive | c2837xSlib/SCI Receive | R2023a+ | Receive data bytes from the Serial Communication Interface (UART) peripheral — use to read asynchronous serial data from external devices, sensors, or host PCs |
| SCI Transmit | c2837xSlib/SCI Transmit | R2023a+ | Transmit data bytes over the Serial Communication Interface (UART) peripheral — use to send status, telemetry, or command data to external devices or host PCs |
| SPI Controller Transfer | c2837xSlib/SPI Controller Transfer | R2023a+ | Perform a full-duplex SPI transfer as the bus controller — use to simultaneously send and receive data with SPI peripheral devices like ADCs, DACs, or memory chips |
| SPI Receive | c2837xSlib/SPI Receive | R2023a+ | Receive data from the SPI peripheral in peripheral mode — use to read data transferred by an external SPI controller device |
| SPI Transmit | c2837xSlib/SPI Transmit | R2023a+ | Transmit data from the SPI peripheral in peripheral mode — use to send data to an external SPI controller device |
| I2C Receive | c2838xlib/I2C Receive | R2023a+ | Receive data over the I2C bus — use to read registers or data from I2C peripheral devices such as temperature sensors, EEPROMs, or display controllers |
| I2C Transmit | c2838xlib/I2C Transmit | R2023a+ | Transmit data over the I2C bus — use to write configuration registers or send commands to I2C peripheral devices |
| SCI Receive | c2838xlib/SCI Receive | R2023a+ | Receive data bytes from the Serial Communication Interface (UART) peripheral — use to read asynchronous serial data from external devices, sensors, or host PCs |
| SCI Transmit | c2838xlib/SCI Transmit | R2023a+ | Transmit data bytes over the Serial Communication Interface (UART) peripheral — use to send status, telemetry, or command data to external devices or host PCs |
| SPI Controller Transfer | c2838xlib/SPI Controller Transfer | R2023a+ | Perform a full-duplex SPI transfer as the bus controller — use to simultaneously send and receive data with SPI peripheral devices like ADCs, DACs, or memory chips |
| SPI Receive | c2838xlib/SPI Receive | R2023a+ | Receive data from the SPI peripheral in peripheral mode — use to read data transferred by an external SPI controller device |
| SPI Transmit | c2838xlib/SPI Transmit | R2023a+ | Transmit data from the SPI peripheral in peripheral mode — use to send data to an external SPI controller device |
| UART Receive | c2838x_M4_lib/UART Receive | R2023a+ | Receive data from the UART peripheral — use for asynchronous serial communication with external devices on newer C2000 devices with dedicated UART modules |
| UART Transmit | c2838x_M4_lib/UART Transmit | R2023a+ | Transmit data through the UART peripheral — use for asynchronous serial communication with external devices on newer C2000 devices with dedicated UART modules |
| I2C Receive | f28M35x_C28x_lib/I2C Receive | R2023a+ | Receive data over the I2C bus — use to read registers or data from I2C peripheral devices such as temperature sensors, EEPROMs, or display controllers |
| I2C Transmit | f28M35x_C28x_lib/I2C Transmit | R2023a+ | Transmit data over the I2C bus — use to write configuration registers or send commands to I2C peripheral devices |
| SCI Receive | f28M35x_C28x_lib/SCI Receive | R2023a+ | Receive data bytes from the Serial Communication Interface (UART) peripheral — use to read asynchronous serial data from external devices, sensors, or host PCs |
| SCI Transmit | f28M35x_C28x_lib/SCI Transmit | R2023a+ | Transmit data bytes over the Serial Communication Interface (UART) peripheral — use to send status, telemetry, or command data to external devices or host PCs |
| SPI Controller Transfer | f28M35x_C28x_lib/SPI Controller Transfer | R2023a+ | Perform a full-duplex SPI transfer as the bus controller — use to simultaneously send and receive data with SPI peripheral devices like ADCs, DACs, or memory chips |
| SPI Receive | f28M35x_C28x_lib/SPI Receive | R2023a+ | Receive data from the SPI peripheral in peripheral mode — use to read data transferred by an external SPI controller device |
| SPI Transmit | f28M35x_C28x_lib/SPI Transmit | R2023a+ | Transmit data from the SPI peripheral in peripheral mode — use to send data to an external SPI controller device |
| UART Receive | f28M35x_M3_lib/UART Receive | R2023a+ | Receive data from the UART peripheral — use for asynchronous serial communication with external devices on newer C2000 devices with dedicated UART modules |
| UART Transmit | f28M35x_M3_lib/UART Transmit | R2023a+ | Transmit data through the UART peripheral — use for asynchronous serial communication with external devices on newer C2000 devices with dedicated UART modules |
| I2C Receive | f28M36x_C28x_lib/I2C Receive | R2023a+ | Receive data over the I2C bus — use to read registers or data from I2C peripheral devices such as temperature sensors, EEPROMs, or display controllers |
| I2C Transmit | f28M36x_C28x_lib/I2C Transmit | R2023a+ | Transmit data over the I2C bus — use to write configuration registers or send commands to I2C peripheral devices |
| SCI Receive | f28M36x_C28x_lib/SCI Receive | R2023a+ | Receive data bytes from the Serial Communication Interface (UART) peripheral — use to read asynchronous serial data from external devices, sensors, or host PCs |
| SCI Transmit | f28M36x_C28x_lib/SCI Transmit | R2023a+ | Transmit data bytes over the Serial Communication Interface (UART) peripheral — use to send status, telemetry, or command data to external devices or host PCs |
| SPI Controller Transfer | f28M36x_C28x_lib/SPI Controller Transfer | R2023a+ | Perform a full-duplex SPI transfer as the bus controller — use to simultaneously send and receive data with SPI peripheral devices like ADCs, DACs, or memory chips |
| SPI Receive | f28M36x_C28x_lib/SPI Receive | R2023a+ | Receive data from the SPI peripheral in peripheral mode — use to read data transferred by an external SPI controller device |
| SPI Transmit | f28M36x_C28x_lib/SPI Transmit | R2023a+ | Transmit data from the SPI peripheral in peripheral mode — use to send data to an external SPI controller device |
| UART Receive | f28M36x_M3_lib/UART Receive | R2023a+ | Receive data from the UART peripheral — use for asynchronous serial communication with external devices on newer C2000 devices with dedicated UART modules |
| UART Transmit | f28M36x_M3_lib/UART Transmit | R2023a+ | Transmit data through the UART peripheral — use for asynchronous serial communication with external devices on newer C2000 devices with dedicated UART modules |
| I2C Receive | c28P55xlib/I2C Receive | R2024b+ | Receive data over the I2C bus — use to read registers or data from I2C peripheral devices such as temperature sensors, EEPROMs, or display controllers |
| I2C Transmit | c28P55xlib/I2C Transmit | R2024b+ | Transmit data over the I2C bus — use to write configuration registers or send commands to I2C peripheral devices |
| SCI Receive | c28P55xlib/SCI Receive | R2024b+ | Receive data bytes from the Serial Communication Interface (UART) peripheral — use to read asynchronous serial data from external devices, sensors, or host PCs |
| SCI Transmit | c28P55xlib/SCI Transmit | R2024b+ | Transmit data bytes over the Serial Communication Interface (UART) peripheral — use to send status, telemetry, or command data to external devices or host PCs |
| SPI Controller Transfer | c28P55xlib/SPI Controller Transfer | R2024b+ | Perform a full-duplex SPI transfer as the bus controller — use to simultaneously send and receive data with SPI peripheral devices like ADCs, DACs, or memory chips |
| SPI Receive | c28P55xlib/SPI Receive | R2024b+ | Receive data from the SPI peripheral in peripheral mode — use to read data transferred by an external SPI controller device |
| SPI Transmit | c28P55xlib/SPI Transmit | R2024b+ | Transmit data from the SPI peripheral in peripheral mode — use to send data to an external SPI controller device |
| I2C Receive | c28P65xlib/I2C Receive | R2024a+ | Receive data over the I2C bus — use to read registers or data from I2C peripheral devices such as temperature sensors, EEPROMs, or display controllers |
| I2C Transmit | c28P65xlib/I2C Transmit | R2024a+ | Transmit data over the I2C bus — use to write configuration registers or send commands to I2C peripheral devices |
| SCI Receive | c28P65xlib/SCI Receive | R2024a+ | Receive data bytes from the Serial Communication Interface (UART) peripheral — use to read asynchronous serial data from external devices, sensors, or host PCs |
| SCI Transmit | c28P65xlib/SCI Transmit | R2024a+ | Transmit data bytes over the Serial Communication Interface (UART) peripheral — use to send status, telemetry, or command data to external devices or host PCs |
| SPI Controller Transfer | c28P65xlib/SPI Controller Transfer | R2024a+ | Perform a full-duplex SPI transfer as the bus controller — use to simultaneously send and receive data with SPI peripheral devices like ADCs, DACs, or memory chips |
| SPI Receive | c28P65xlib/SPI Receive | R2024a+ | Receive data from the SPI peripheral in peripheral mode — use to read data transferred by an external SPI controller device |
| SPI Transmit | c28P65xlib/SPI Transmit | R2024a+ | Transmit data from the SPI peripheral in peripheral mode — use to send data to an external SPI controller device |
| UART Receive | c29H85xlib/UART Receive | R2025a+ | Receive data from the UART peripheral — use for asynchronous serial communication with external devices on newer C2000 devices with dedicated UART modules |
| UART Transmit | c29H85xlib/UART Transmit | R2025a+ | Transmit data through the UART peripheral — use for asynchronous serial communication with external devices on newer C2000 devices with dedicated UART modules |
| I2C Receive | c29H85xlib/I2C Receive | R2026a+ | Receive data over the I2C bus — use to read registers or data from I2C peripheral devices such as temperature sensors, EEPROMs, or display controllers |
| I2C Transmit | c29H85xlib/I2C Transmit | R2026a+ | Transmit data over the I2C bus — use to write configuration registers or send commands to I2C peripheral devices |
| SPI Controller Transfer | c29H85xlib/SPI Controller Transfer | R2026a+ | Perform a full-duplex SPI transfer as the bus controller — use to simultaneously send and receive data with SPI peripheral devices like ADCs, DACs, or memory chips |
| SPI Receive | c29H85xlib/SPI Receive | R2026a+ | Receive data from the SPI peripheral in peripheral mode — use to read data transferred by an external SPI controller device |
| Serial Configuration | c2000lib/Host Communication/Serial Configuration | R2023a+ | Configure serial port parameters including baud rate, data bits, parity, and stop bits — use to initialize serial communication before using Serial Receive/Send blocks |
| Serial Receive | c2000lib/Host Communication/Serial Receive | R2023a+ | Receive data from a configured serial port — use for generic serial communication when device-specific SCI blocks are not appropriate |
| Serial Send | c2000lib/Host Communication/Serial Send | R2023a+ | Send data through a configured serial port — use for generic serial communication when device-specific SCI blocks are not appropriate |
| Serial Configuration | c2000lib/Test Bench Blocks/Serial Configuration | R2023a+ | Configure serial port parameters including baud rate, data bits, parity, and stop bits — use to initialize serial communication before using Serial Receive/Send blocks |
| Serial Receive | c2000lib/Test Bench Blocks/Serial Receive | R2023a+ | Receive data from a configured serial port — use for generic serial communication when device-specific SCI blocks are not appropriate |
| Serial Send | c2000lib/Test Bench Blocks/Serial Send | R2023a+ | Send data through a configured serial port — use for generic serial communication when device-specific SCI blocks are not appropriate |

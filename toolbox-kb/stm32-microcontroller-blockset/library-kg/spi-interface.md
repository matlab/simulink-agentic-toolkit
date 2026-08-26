---
type: Simulink Block Category
title: Spi interface
description: SPI bus peripherals for high-speed synchronous communication with sensors and memory
tags: [SPI, MOSI, MISO, clock, register]
status: stable
source: mathworks_toolbox
library_root: STM32 Microcontroller Blockset
category_path: Spi interface
block_count: 57
---

# Spi interface

Use these blocks for spi interface.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| SPI Controller Transfer | stm32f1xxblockslib/SPI Controller Transfer | R2026a+ | Perform simultaneous read-write data exchange with a peripheral device over the SPI bus |
| SPI Receive | stm32f1xxblockslib/SPI Receive | R2026a+ | Receive data from an SPI peripheral device |
| SPI Transmit | stm32f1xxblockslib/SPI Transmit | R2026a+ | Send data to an SPI peripheral device |
| SPI Controller Transfer | stm32f2xxblockslib/SPI Controller Transfer | R2026a+ | Perform simultaneous read-write data exchange with a peripheral device over the SPI bus |
| SPI Receive | stm32f2xxblockslib/SPI Receive | R2026a+ | Receive data from an SPI peripheral device |
| SPI Transmit | stm32f2xxblockslib/SPI Transmit | R2026a+ | Send data to an SPI peripheral device |
| SPI Controller Transfer | stm32f3xxblockslib/SPI Controller Transfer | R2026a+ | Perform simultaneous read-write data exchange with a peripheral device over the SPI bus |
| SPI Receive | stm32f3xxblockslib/SPI Receive | R2026a+ | Receive data from an SPI peripheral device |
| SPI Transmit | stm32f3xxblockslib/SPI Transmit | R2026a+ | Send data to an SPI peripheral device |
| SPI Controller Transfer | stm32f4xxblockslib/SPI Controller Transfer | R2026a+ | Perform simultaneous read-write data exchange with a peripheral device over the SPI bus |
| SPI Receive | stm32f4xxblockslib/SPI Receive | R2026a+ | Receive data from an SPI peripheral device |
| SPI Transmit | stm32f4xxblockslib/SPI Transmit | R2026a+ | Send data to an SPI peripheral device |
| SPI Controller Transfer | stm32f7xxblockslib/SPI Controller Transfer | R2026a+ | Perform simultaneous read-write data exchange with a peripheral device over the SPI bus |
| SPI Receive | stm32f7xxblockslib/SPI Receive | R2026a+ | Receive data from an SPI peripheral device |
| SPI Transmit | stm32f7xxblockslib/SPI Transmit | R2026a+ | Send data to an SPI peripheral device |
| SPI Controller Transfer | stm32g0xxblockslib/SPI Controller Transfer | R2026a+ | Perform simultaneous read-write data exchange with a peripheral device over the SPI bus |
| SPI Receive | stm32g0xxblockslib/SPI Receive | R2026a+ | Receive data from an SPI peripheral device |
| SPI Transmit | stm32g0xxblockslib/SPI Transmit | R2026a+ | Send data to an SPI peripheral device |
| SPI Controller Transfer | stm32g4xxblockslib/SPI Controller Transfer | R2026a+ | Perform simultaneous read-write data exchange with a peripheral device over the SPI bus |
| SPI Receive | stm32g4xxblockslib/SPI Receive | R2026a+ | Receive data from an SPI peripheral device |
| SPI Transmit | stm32g4xxblockslib/SPI Transmit | R2026a+ | Send data to an SPI peripheral device |
| SPI Controller Transfer | stm32h5xxblockslib/SPI Controller Transfer | R2026a+ | Perform simultaneous read-write data exchange with a peripheral device over the SPI bus |
| SPI Receive | stm32h5xxblockslib/SPI Receive | R2026a+ | Receive data from an SPI peripheral device |
| SPI Transmit | stm32h5xxblockslib/SPI Transmit | R2026a+ | Send data to an SPI peripheral device |
| SPI Controller Transfer | stm32h7xxblockslib/SPI Controller Transfer | R2026a+ | Perform simultaneous read-write data exchange with a peripheral device over the SPI bus |
| SPI Receive | stm32h7xxblockslib/SPI Receive | R2026a+ | Receive data from an SPI peripheral device |
| SPI Transmit | stm32h7xxblockslib/SPI Transmit | R2026a+ | Send data to an SPI peripheral device |
| SPI Controller Transfer | stm32l4xxblockslib/SPI Controller Transfer | R2026a+ | Perform simultaneous read-write data exchange with a peripheral device over the SPI bus |
| SPI Receive | stm32l4xxblockslib/SPI Receive | R2026a+ | Receive data from an SPI peripheral device |
| SPI Transmit | stm32l4xxblockslib/SPI Transmit | R2026a+ | Send data to an SPI peripheral device |
| SPI Controller Transfer | stm32l5xxblockslib/SPI Controller Transfer | R2026a+ | Perform simultaneous read-write data exchange with a peripheral device over the SPI bus |
| SPI Receive | stm32l5xxblockslib/SPI Receive | R2026a+ | Receive data from an SPI peripheral device |
| SPI Transmit | stm32l5xxblockslib/SPI Transmit | R2026a+ | Send data to an SPI peripheral device |
| SPI Controller Transfer | stm32u5xxblockslib/SPI Controller Transfer | R2026a+ | Perform simultaneous read-write data exchange with a peripheral device over the SPI bus |
| SPI Receive | stm32u5xxblockslib/SPI Receive | R2026a+ | Receive data from an SPI peripheral device |
| SPI Transmit | stm32u5xxblockslib/SPI Transmit | R2026a+ | Send data to an SPI peripheral device |
| SPI Controller Transfer | stm32wbxxblockslib/SPI Controller Transfer | R2026a+ | Perform simultaneous read-write data exchange with a peripheral device over the SPI bus |
| SPI Receive | stm32wbxxblockslib/SPI Receive | R2026a+ | Receive data from an SPI peripheral device |
| SPI Transmit | stm32wbxxblockslib/SPI Transmit | R2026a+ | Send data to an SPI peripheral device |
| SPI Controller Transfer | stm32f7lib/SPI Controller Transfer | R2026a+ | Perform simultaneous read-write data exchange with a peripheral device over the SPI bus |
| SPI Register Read | stm32f7lib/SPI Register Read | R2026a+ | Read a specific register address on an SPI peripheral such as a sensor or memory chip |
| SPI Register Write | stm32f7lib/SPI Register Write | R2026a+ | Write to a specific register address on an SPI peripheral for configuration or control |
| SPI Controller Transfer | stm32f769ilib/SPI Controller Transfer | R2026a+ | Perform simultaneous read-write data exchange with a peripheral device over the SPI bus |
| SPI Register Read | stm32f769ilib/SPI Register Read | R2026a+ | Read a specific register address on an SPI peripheral such as a sensor or memory chip |
| SPI Register Write | stm32f769ilib/SPI Register Write | R2026a+ | Write to a specific register address on an SPI peripheral for configuration or control |
| SPI Controller Transfer | stm32nucleodiscoboardslib/Common/SPI Controller Transfer | R2026a+ | Perform simultaneous read-write data exchange with a peripheral device over the SPI bus |
| SPI Register Read | stm32nucleodiscoboardslib/Common/SPI Register Read | R2026a+ | Read a specific register address on an SPI peripheral such as a sensor or memory chip |
| SPI Register Write | stm32nucleodiscoboardslib/Common/SPI Register Write | R2026a+ | Write to a specific register address on an SPI peripheral for configuration or control |
| SPI Master Transfer | stm32nucleodiscoboardslib/MBED Based Sensors/SPI Master Transfer | R2026a+ | Perform full-duplex SPI data exchange on an mbed-based STM32 board |
| SPI Register Read | stm32nucleodiscoboardslib/MBED Based Sensors/SPI Register Read | R2026a+ | Read a specific register address on an SPI peripheral such as a sensor or memory chip |
| SPI Register Write | stm32nucleodiscoboardslib/MBED Based Sensors/SPI Register Write | R2026a+ | Write to a specific register address on an SPI peripheral for configuration or control |
| SPI Master Transfer | stm32nucleodiscoboardslib/STM32F7/SPI Master Transfer | R2026a+ | Perform full-duplex SPI data exchange on an mbed-based STM32 board |
| SPI Register Read | stm32nucleodiscoboardslib/STM32F7/SPI Register Read | R2026a+ | Read a specific register address on an SPI peripheral such as a sensor or memory chip |
| SPI Register Write | stm32nucleodiscoboardslib/STM32F7/SPI Register Write | R2026a+ | Write to a specific register address on an SPI peripheral for configuration or control |
| SPI Master Transfer | stm32nucleodiscoboardslib/STM32H7/SPI Master Transfer | R2026a+ | Perform full-duplex SPI data exchange on an mbed-based STM32 board |
| SPI Register Read | stm32nucleodiscoboardslib/STM32H7/SPI Register Read | R2026a+ | Read a specific register address on an SPI peripheral such as a sensor or memory chip |
| SPI Register Write | stm32nucleodiscoboardslib/STM32H7/SPI Register Write | R2026a+ | Write to a specific register address on an SPI peripheral for configuration or control |

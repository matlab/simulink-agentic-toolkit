---
type: Simulink Block Category
title: Serial communication
description: Asynchronous serial communication interfaces for point-to-point data exchange (48 blocks)
tags: [toolbox-kb, stm32-microcontroller-blockset, UART, USART, serial, SCI, RS232]
status: stable
sources:
  - resource: matlab:stm32c0xxblockslib
source: toolbox_kb
managed_by: satk
library: STM32 Microcontroller Blockset
kb_folder: stm32-microcontroller-blockset
category: serial-communication
block_count: 48
generated: { by: satk-toolbox-build/1, at: "2026-11-23T18:23:27Z" }
---

# Serial communication

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| UART/USART Read | stm32c0xxblockslib/UART/USART Read | R2023a+ | Receive serial data over a UART or USART interface from external devices or host systems |
| UART/USART Write | stm32c0xxblockslib/UART/USART Write | R2023a+ | Transmit serial data over a UART or USART interface to external devices or host systems |
| UART/USART Read | stm32f1xxblockslib/UART/USART Read | R2023a+ | Receive serial data over a UART or USART interface from external devices or host systems |
| UART/USART Write | stm32f1xxblockslib/UART/USART Write | R2023a+ | Transmit serial data over a UART or USART interface to external devices or host systems |
| UART/USART Read | stm32f2xxblockslib/UART/USART Read | R2023a+ | Receive serial data over a UART or USART interface from external devices or host systems |
| UART/USART Write | stm32f2xxblockslib/UART/USART Write | R2023a+ | Transmit serial data over a UART or USART interface to external devices or host systems |
| UART/USART Read | stm32f3xxblockslib/UART/USART Read | R2023a+ | Receive serial data over a UART or USART interface from external devices or host systems |
| UART/USART Write | stm32f3xxblockslib/UART/USART Write | R2023a+ | Transmit serial data over a UART or USART interface to external devices or host systems |
| UART/USART Read | stm32f4xxblockslib/UART/USART Read | R2023a+ | Receive serial data over a UART or USART interface from external devices or host systems |
| UART/USART Write | stm32f4xxblockslib/UART/USART Write | R2023a+ | Transmit serial data over a UART or USART interface to external devices or host systems |
| UART/USART Read | stm32f7xxblockslib/UART/USART Read | R2023a+ | Receive serial data over a UART or USART interface from external devices or host systems |
| UART/USART Write | stm32f7xxblockslib/UART/USART Write | R2023a+ | Transmit serial data over a UART or USART interface to external devices or host systems |
| UART/USART Read | stm32g0xxblockslib/UART/USART Read | R2023a+ | Receive serial data over a UART or USART interface from external devices or host systems |
| UART/USART Write | stm32g0xxblockslib/UART/USART Write | R2023a+ | Transmit serial data over a UART or USART interface to external devices or host systems |
| UART/USART Read | stm32g4xxblockslib/UART/USART Read | R2023a+ | Receive serial data over a UART or USART interface from external devices or host systems |
| UART/USART Write | stm32g4xxblockslib/UART/USART Write | R2023a+ | Transmit serial data over a UART or USART interface to external devices or host systems |
| UART/USART Read | stm32h5xxblockslib/UART/USART Read | R2023a+ | Receive serial data over a UART or USART interface from external devices or host systems |
| UART/USART Write | stm32h5xxblockslib/UART/USART Write | R2023a+ | Transmit serial data over a UART or USART interface to external devices or host systems |
| UART/USART Read | stm32h7rsxxblockslib/UART/USART Read | R2023a+ | Receive serial data over a UART or USART interface from external devices or host systems |
| UART/USART Write | stm32h7rsxxblockslib/UART/USART Write | R2023a+ | Transmit serial data over a UART or USART interface to external devices or host systems |
| UART/USART Read | stm32h7xxblockslib/UART/USART Read | R2023a+ | Receive serial data over a UART or USART interface from external devices or host systems |
| UART/USART Write | stm32h7xxblockslib/UART/USART Write | R2023a+ | Transmit serial data over a UART or USART interface to external devices or host systems |
| UART/USART Read | stm32l4xxblockslib/UART/USART Read | R2023a+ | Receive serial data over a UART or USART interface from external devices or host systems |
| UART/USART Write | stm32l4xxblockslib/UART/USART Write | R2023a+ | Transmit serial data over a UART or USART interface to external devices or host systems |
| UART/USART Read | stm32l5xxblockslib/UART/USART Read | R2023a+ | Receive serial data over a UART or USART interface from external devices or host systems |
| UART/USART Write | stm32l5xxblockslib/UART/USART Write | R2023a+ | Transmit serial data over a UART or USART interface to external devices or host systems |
| UART/USART Read | stm32n6xxblockslib/UART/USART Read | R2023a+ | Receive serial data over a UART or USART interface from external devices or host systems |
| UART/USART Write | stm32n6xxblockslib/UART/USART Write | R2023a+ | Transmit serial data over a UART or USART interface to external devices or host systems |
| UART/USART Read | stm32u0xxblockslib/UART/USART Read | R2023a+ | Receive serial data over a UART or USART interface from external devices or host systems |
| UART/USART Write | stm32u0xxblockslib/UART/USART Write | R2023a+ | Transmit serial data over a UART or USART interface to external devices or host systems |
| UART/USART Read | stm32u3xxblockslib/UART/USART Read | R2023a+ | Receive serial data over a UART or USART interface from external devices or host systems |
| UART/USART Write | stm32u3xxblockslib/UART/USART Write | R2023a+ | Transmit serial data over a UART or USART interface to external devices or host systems |
| UART/USART Read | stm32u5xxblockslib/UART/USART Read | R2023a+ | Receive serial data over a UART or USART interface from external devices or host systems |
| UART/USART Write | stm32u5xxblockslib/UART/USART Write | R2023a+ | Transmit serial data over a UART or USART interface to external devices or host systems |
| UART/USART Read | stm32wbxxblockslib/UART/USART Read | R2023a+ | Receive serial data over a UART or USART interface from external devices or host systems |
| UART/USART Write | stm32wbxxblockslib/UART/USART Write | R2023a+ | Transmit serial data over a UART or USART interface to external devices or host systems |
| SCI Read | stm32f7lib/SCI Read | R2026a+ | Receive serial communication data on an mbed-based STM32 board |
| SCI Write | stm32f7lib/SCI Write | R2026a+ | Transmit serial communication data on an mbed-based STM32 board |
| SCI Read | stm32f769ilib/SCI Read | R2026a+ | Receive serial communication data on an mbed-based STM32 board |
| SCI Write | stm32f769ilib/SCI Write | R2026a+ | Transmit serial communication data on an mbed-based STM32 board |
| SCI Read | stm32nucleodiscoboardslib/Common/SCI Read | R2026a+ | Receive serial communication data on an mbed-based STM32 board |
| SCI Write | stm32nucleodiscoboardslib/Common/SCI Write | R2026a+ | Transmit serial communication data on an mbed-based STM32 board |
| SCI Read | stm32nucleodiscoboardslib/MBED Based Sensors/SCI Read | R2026a+ | Receive serial communication data on an mbed-based STM32 board |
| SCI Write | stm32nucleodiscoboardslib/MBED Based Sensors/SCI Write | R2026a+ | Transmit serial communication data on an mbed-based STM32 board |
| SCI Read | stm32nucleodiscoboardslib/STM32F7/SCI Read | R2026a+ | Receive serial communication data on an mbed-based STM32 board |
| SCI Write | stm32nucleodiscoboardslib/STM32F7/SCI Write | R2026a+ | Transmit serial communication data on an mbed-based STM32 board |
| SCI Read | stm32nucleodiscoboardslib/STM32H7/SCI Read | R2026a+ | Receive serial communication data on an mbed-based STM32 board |
| SCI Write | stm32nucleodiscoboardslib/STM32H7/SCI Write | R2026a+ | Transmit serial communication data on an mbed-based STM32 board |

---
type: Simulink Block Category
title: Analog conversion
description: Analog-to-digital and digital-to-analog conversion peripherals including comparators
tags: [ADC, DAC, comparator, analog, voltage]
status: stable
source: mathworks_toolbox
library_root: STM32 Microcontroller Blockset
category_path: Analog conversion
block_count: 41
---

# Analog conversion

Use these blocks for analog conversion.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Analog to Digital Converter | stm32f1xxblockslib/Analog to Digital Converter | R2026a+ | Sample analog sensor voltages and convert them to digital values for processing on the STM32 |
| Digital to Analog Converter | stm32f1xxblockslib/Digital to Analog Converter | R2026a+ | Output an analog voltage from a computed digital value for driving analog actuators or generating reference signals |
| Analog to Digital Converter | stm32f2xxblockslib/Analog to Digital Converter | R2026a+ | Sample analog sensor voltages and convert them to digital values for processing on the STM32 |
| Digital to Analog Converter | stm32f2xxblockslib/Digital to Analog Converter | R2026a+ | Output an analog voltage from a computed digital value for driving analog actuators or generating reference signals |
| Analog to Digital Converter | stm32f3xxblockslib/Analog to Digital Converter | R2026a+ | Sample analog sensor voltages and convert them to digital values for processing on the STM32 |
| Comparator | stm32f3xxblockslib/Comparator | R2026a+ | Compare an analog input against a threshold voltage and generate a digital output indicating which is larger |
| Digital to Analog Converter | stm32f3xxblockslib/Digital to Analog Converter | R2026a+ | Output an analog voltage from a computed digital value for driving analog actuators or generating reference signals |
| Analog to Digital Converter | stm32f4xxblockslib/Analog to Digital Converter | R2026a+ | Sample analog sensor voltages and convert them to digital values for processing on the STM32 |
| Digital to Analog Converter | stm32f4xxblockslib/Digital to Analog Converter | R2026a+ | Output an analog voltage from a computed digital value for driving analog actuators or generating reference signals |
| Analog to Digital Converter | stm32f7xxblockslib/Analog to Digital Converter | R2026a+ | Sample analog sensor voltages and convert them to digital values for processing on the STM32 |
| Digital to Analog Converter | stm32f7xxblockslib/Digital to Analog Converter | R2026a+ | Output an analog voltage from a computed digital value for driving analog actuators or generating reference signals |
| Analog to Digital Converter | stm32g0xxblockslib/Analog to Digital Converter | R2026a+ | Sample analog sensor voltages and convert them to digital values for processing on the STM32 |
| Comparator | stm32g0xxblockslib/Comparator | R2026a+ | Compare an analog input against a threshold voltage and generate a digital output indicating which is larger |
| Digital to Analog Converter | stm32g0xxblockslib/Digital to Analog Converter | R2026a+ | Output an analog voltage from a computed digital value for driving analog actuators or generating reference signals |
| Analog to Digital Converter | stm32g4xxblockslib/Analog to Digital Converter | R2026a+ | Sample analog sensor voltages and convert them to digital values for processing on the STM32 |
| Comparator | stm32g4xxblockslib/Comparator | R2026a+ | Compare an analog input against a threshold voltage and generate a digital output indicating which is larger |
| Digital to Analog Converter | stm32g4xxblockslib/Digital to Analog Converter | R2026a+ | Output an analog voltage from a computed digital value for driving analog actuators or generating reference signals |
| Analog to Digital Converter | stm32h5xxblockslib/Analog to Digital Converter | R2026a+ | Sample analog sensor voltages and convert them to digital values for processing on the STM32 |
| Comparator | stm32h5xxblockslib/Comparator | R2026a+ | Compare an analog input against a threshold voltage and generate a digital output indicating which is larger |
| Digital to Analog Converter | stm32h5xxblockslib/Digital to Analog Converter | R2026a+ | Output an analog voltage from a computed digital value for driving analog actuators or generating reference signals |
| Analog to Digital Converter | stm32h7xxblockslib/Analog to Digital Converter | R2026a+ | Sample analog sensor voltages and convert them to digital values for processing on the STM32 |
| Comparator | stm32h7xxblockslib/Comparator | R2026a+ | Compare an analog input against a threshold voltage and generate a digital output indicating which is larger |
| Digital to Analog Converter | stm32h7xxblockslib/Digital to Analog Converter | R2026a+ | Output an analog voltage from a computed digital value for driving analog actuators or generating reference signals |
| Analog to Digital Converter | stm32l4xxblockslib/Analog to Digital Converter | R2026a+ | Sample analog sensor voltages and convert them to digital values for processing on the STM32 |
| Comparator | stm32l4xxblockslib/Comparator | R2026a+ | Compare an analog input against a threshold voltage and generate a digital output indicating which is larger |
| Digital to Analog Converter | stm32l4xxblockslib/Digital to Analog Converter | R2026a+ | Output an analog voltage from a computed digital value for driving analog actuators or generating reference signals |
| Analog to Digital Converter | stm32l5xxblockslib/Analog to Digital Converter | R2026a+ | Sample analog sensor voltages and convert them to digital values for processing on the STM32 |
| Comparator | stm32l5xxblockslib/Comparator | R2026a+ | Compare an analog input against a threshold voltage and generate a digital output indicating which is larger |
| Digital to Analog Converter | stm32l5xxblockslib/Digital to Analog Converter | R2026a+ | Output an analog voltage from a computed digital value for driving analog actuators or generating reference signals |
| Analog to Digital Converter | stm32u5xxblockslib/Analog to Digital Converter | R2026a+ | Sample analog sensor voltages and convert them to digital values for processing on the STM32 |
| Comparator | stm32u5xxblockslib/Comparator | R2026a+ | Compare an analog input against a threshold voltage and generate a digital output indicating which is larger |
| Digital to Analog Converter | stm32u5xxblockslib/Digital to Analog Converter | R2026a+ | Output an analog voltage from a computed digital value for driving analog actuators or generating reference signals |
| Analog to Digital Converter | stm32wbxxblockslib/Analog to Digital Converter | R2026a+ | Sample analog sensor voltages and convert them to digital values for processing on the STM32 |
| Comparator | stm32wbxxblockslib/Comparator | R2026a+ | Compare an analog input against a threshold voltage and generate a digital output indicating which is larger |
| Analog Input | stm32f7lib/Analog Input | R2026a+ | Read an analog voltage on a board-level pin using the mbed-based peripheral driver |
| Analog Input | stm32f769ilib/Analog Input | R2026a+ | Read an analog voltage on a board-level pin using the mbed-based peripheral driver |
| Analog Input | stm32nucleodiscoboardslib/Common/Analog Input | R2026a+ | Read an analog voltage on a board-level pin using the mbed-based peripheral driver |
| Analog Output | stm32nucleodiscoboardslib/Common/Analog Output | R2026a+ | Write an analog voltage on a board-level DAC pin using the mbed-based peripheral driver |
| Analog Input | stm32nucleodiscoboardslib/MBED Based Sensors/Analog Input | R2026a+ | Read an analog voltage on a board-level pin using the mbed-based peripheral driver |
| Analog Input | stm32nucleodiscoboardslib/STM32F7/Analog Input | R2026a+ | Read an analog voltage on a board-level pin using the mbed-based peripheral driver |
| Analog Input | stm32nucleodiscoboardslib/STM32H7/Analog Input | R2026a+ | Read an analog voltage on a board-level pin using the mbed-based peripheral driver |

---
type: Simulink Block Category
title: Mcal io
description: AUTOSAR Microcontroller Abstraction Layer drivers for analog and digital I/O
tags: [mcal, abstraction layer, dio, adc, autosar]
status: stable
source: custom_library
library_root: Embedded Coder Support Package for Renesas RH850 Microcontrollers
category_path: Mcal io
block_count: 7
---

# Mcal io

Use these blocks for mcal io.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| MCAL ADC | rh850mcallib/MCAL ADC | R2026a+ | Read analog-to-digital conversion results through the AUTOSAR Microcontroller Abstraction Layer (MCAL) on Renesas RH850 — use for hardware-abstracted analog input in AUTOSAR-compliant software. |
| MCAL DIO Channel Group Read | rh850mcallib/MCAL DIO Channel Group Read | R2026a+ | Read a group of related digital I/O channels in one call via the MCAL DIO driver — use to sample several digital inputs atomically. |
| MCAL DIO Channel Group Write | rh850mcallib/MCAL DIO Channel Group Write | R2026a+ | Write a group of related digital I/O channels in one call via the MCAL DIO driver — use to drive several digital outputs atomically. |
| MCAL DIO Channel Read | rh850mcallib/MCAL DIO Channel Read | R2026a+ | Read a single digital I/O channel via the MCAL DIO driver — use for hardware-abstracted single-bit digital input. |
| MCAL DIO Channel Write | rh850mcallib/MCAL DIO Channel Write | R2026a+ | Write a single digital I/O channel via the MCAL DIO driver — use for hardware-abstracted single-bit digital output. |
| MCAL DIO Port Pins Read | rh850mcallib/MCAL DIO Port Pins Read | R2026a+ | Read all pins of a DIO port via the MCAL driver — use for port-wide digital input. |
| MCAL DIO Port Pins Write | rh850mcallib/MCAL DIO Port Pins Write | R2026a+ | Write all pins of a DIO port via the MCAL driver — use for port-wide digital output. |

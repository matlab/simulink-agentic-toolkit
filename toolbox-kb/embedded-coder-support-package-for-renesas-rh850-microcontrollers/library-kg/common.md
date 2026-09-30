---
type: Block Selection Guide
title: Common Blocks
description: High-value blocks selected for quick agent discovery.
status: stable
source: custom_library
block_count: 9
---

# Common Blocks

Prefer these blocks when their intent matches the user request.

| Intent | Preferred Block | Library |
|---|---|---|
| Read analog-to-digital conversion results through the AUTOSAR Microcontroller Abstraction Layer (MCAL) on Renesas RH850 — use for hardware-abstracted analog input in AUTOSAR-compliant software. | MCAL ADC | Embedded Coder Support Package for Renesas RH850 Microcontrollers |
| Read a single digital I/O channel via the MCAL DIO driver — use for hardware-abstracted single-bit digital input. | MCAL DIO Channel Read | Embedded Coder Support Package for Renesas RH850 Microcontrollers |
| Write a single digital I/O channel via the MCAL DIO driver — use for hardware-abstracted single-bit digital output. | MCAL DIO Channel Write | Embedded Coder Support Package for Renesas RH850 Microcontrollers |
| Read a group of related digital I/O channels in one call via the MCAL DIO driver — use to sample several digital inputs atomically. | MCAL DIO Channel Group Read | Embedded Coder Support Package for Renesas RH850 Microcontrollers |
| Write a group of related digital I/O channels in one call via the MCAL DIO driver — use to drive several digital outputs atomically. | MCAL DIO Channel Group Write | Embedded Coder Support Package for Renesas RH850 Microcontrollers |
| Read all pins of a DIO port via the MCAL driver — use for port-wide digital input. | MCAL DIO Port Pins Read | Embedded Coder Support Package for Renesas RH850 Microcontrollers |
| Write all pins of a DIO port via the MCAL driver — use for port-wide digital output. | MCAL DIO Port Pins Write | Embedded Coder Support Package for Renesas RH850 Microcontrollers |
| Trigger the downstream function-call subsystem from an interrupt service routine. Select the interrupt service routine with the 'Interrupt group' and the 'Interrupt name' parameters. Use the 'Simulink task priority' parameter to set the priority of the downstream function-call subsystem. Enable 'Run interrupt service routine as atomic unit' to block all other interrupts while executing the selected interrupt service routine. | Hardware Interrupt | Embedded Coder Support Package for Renesas RH850 Microcontrollers |
| Drive output through the Renesas RH850 U2A TSG3 signal-generation peripheral — use to produce hardware timing or waveform output from the deployed model. | TSG3 Output | Embedded Coder Support Package for Renesas RH850 Microcontrollers |

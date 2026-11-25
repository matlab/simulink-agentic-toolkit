---
type: Simulink Block Category
title: Peripheral io
description: On-chip RH850 peripheral outputs (2 blocks)
tags: [toolbox-kb, embedded-coder-support-package-for-renesas-rh850-microcontrollers, tsg3, u2a, peripheral, output]
status: draft
sources:
  - resource: matlab:rh850u2axblockslib
source: toolbox_kb
managed_by: satk
library: Embedded Coder Support Package for Renesas RH850 Microcontrollers
kb_folder: embedded-coder-support-package-for-renesas-rh850-microcontrollers
category: peripheral-io
block_count: 2
generated: { by: satk-toolbox-build/1, at: "2026-11-23T18:23:21Z" }
---

# Peripheral io

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| TSG3 Output | rh850u2axblockslib/TSG3 Output | R2026a+ | Drive output through the Renesas RH850 U2A TSG3 signal-generation peripheral — use to produce hardware timing or waveform output from the deployed model. |
| Hardware Interrupt | rh850u2axblockslib/Hardware Interrupt | R2026a+ | Trigger the downstream function-call subsystem from an interrupt service routine. Select the interrupt service routine with the 'Interrupt group' and the 'Interrupt name' parameters. Use the 'Simulink task priority' parameter to set the priority of the downstream function-call subsystem. Enable 'Run interrupt service routine as atomic unit' to block all other interrupts while executing the selected interrupt service routine. |

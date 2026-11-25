---
type: Simulink Block Category
title: Board io
description: "Physical board I/O blocks for switches, buttons, LEDs, and GPIO pins (5 blocks)"
tags: [toolbox-kb, soc-blockset, DIP, switch, LED, button, GPIO, pin]
status: stable
sources:
  - resource: matlab:hwlogiciolib
source: toolbox_kb
managed_by: satk
library: SoC Blockset
kb_folder: soc-blockset
category: board-io
block_count: 5
generated: { by: satk-toolbox-build/1, at: "2026-11-23T18:23:35Z" }
---

# Board io

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| DIP Switch | hwlogiciolib/DIP Switch | R2023a+ | Read DIP switch positions from the development board for configuration input |
| IO Pin | hwlogiciolib/IO Pin | R2026a+ | Access a general-purpose I/O pin on the SoC development board |
| LED | hwlogiciolib/LED | R2023a+ | Drive an LED on the development board for visual status indication |
| Push Button | hwlogiciolib/Push Button | R2023a+ | Read push button state from the development board for user interaction |
| Switch | proctasklib/Task Manager/Core Task Manager/Variant Subsystem/HSBON/Task Manager/Task Manager/Switch | R2023a+ | Route entity inputs to the appropriate processing path |

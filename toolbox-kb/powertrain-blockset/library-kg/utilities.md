---
type: Simulink Block Category
title: Utilities
description: Power accounting and Simscape interface helpers (3 blocks)
tags: [toolbox-kb, powertrain-blockset, utilities, power accounting, simscape, connection port, two-way]
status: stable
sources:
  - resource: matlab:autolibpowerinfoutils
source: toolbox_kb
managed_by: satk
library: Powertrain Blockset
kb_folder: powertrain-blockset
category: utilities
block_count: 3
generated: { by: satk-toolbox-build/1, at: "2026-11-23T18:23:25Z" }
---

# Utilities

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Power Accounting Bus Creator | autolibpowerinfoutils/Power Accounting Bus Creator | R2023a+ | Bundle component power and energy signals into a power-accounting bus — use to track energy flow for efficiency analysis. |
| Two-Way Connection | autolibsimscapeutils/Two-Way Connection | R2023a+ | Bridge a Simscape physical two-way connection into a Powertrain Blockset signal interface — use to link physical and signal domains. |
| Connection Port | autolibsimscapeutils/Connection Port | R2023a+ | Expose a physical connection port on a Powertrain subsystem — use to create a physical pin on a masked subsystem. |

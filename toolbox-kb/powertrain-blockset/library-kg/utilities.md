---
type: Simulink Block Category
title: Utilities
description: Power accounting and Simscape interface helpers
tags: [utilities, power accounting, simscape, connection port, two-way]
status: stable
source: custom_library
library_root: Powertrain Blockset
category_path: Utilities
block_count: 3
---

# Utilities

Use these blocks for utilities.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Power Accounting Bus Creator | autolibpowerinfoutils/Power Accounting Bus Creator | R2023a+ | Bundle component power and energy signals into a power-accounting bus — use to track energy flow for efficiency analysis. |
| Two-Way Connection | autolibsimscapeutils/Two-Way Connection | R2023a+ | Bridge a Simscape physical two-way connection into a Powertrain Blockset signal interface — use to link physical and signal domains. |
| Connection Port | autolibsimscapeutils/Connection Port | R2023a+ | Expose a physical connection port on a Powertrain subsystem — use to create a physical pin on a masked subsystem. |

---
type: Simulink Block Category
title: Fuel cell
description: Fuel cell stack models for hydrogen powertrain simulation (2 blocks)
tags: [toolbox-kb, battery, fuel, cell, hydrogen, stack, pem]
status: stable
sources:
  - resource: matlab:batt_lib
source: toolbox_kb
managed_by: satk
library: Battery
kb_folder: battery
category: fuel-cell
block_count: 2
generated: { by: satk-toolbox-build/1, at: "2026-11-23T18:23:14Z" }
---

# Fuel cell

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Fuel Cell (Table-Based) | batt_lib/Fuel Cell/Fuel Cell (Table-Based) | R2023a+ | Model a fuel cell stack using table-based V-I characteristics in Simscape — use for system-level simulation of hydrogen fuel cell powertrains with electrical and thermal coupling |
| Fuel Cell Equivalent Circuit | batt_lib/Fuel Cell/Fuel Cell Equivalent Circuit | R2023a+ | Model a fuel cell using an equivalent circuit with activation, ohmic, and concentration losses — use for dynamic fuel cell simulation capturing transient voltage response to load steps |

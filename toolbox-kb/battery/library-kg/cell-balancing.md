---
type: Simulink Block Category
title: Cell balancing
description: Cell balancing algorithms for equalizing SOC across series cells (1 blocks)
tags: [toolbox-kb, battery, balancing, passive, cell, equalize, bleed]
status: stable
sources:
  - resource: matlab:batt_sl_lib
source: toolbox_kb
managed_by: satk
library: Battery
kb_folder: battery
category: cell-balancing
block_count: 1
generated: { by: satk-toolbox-build/1, at: "2026-11-23T18:23:14Z" }
---

# Cell balancing

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Passive Cell Balancing | batt_sl_lib/Cell Balancing/Passive Cell Balancing | R2023a+ | Equalize cell voltages in a series-connected pack by dissipating excess energy through bleed resistors — use to implement BMS balancing logic that reduces cell-to-cell SOC variation during charging |

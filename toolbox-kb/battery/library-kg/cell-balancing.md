---
type: Simulink Block Category
title: Cell balancing
description: Cell balancing algorithms for equalizing SOC across series cells
tags: [balancing, passive, cell, equalize, bleed]
status: stable
source: mathworks_toolbox
library_root: Battery
category_path: Cell balancing
block_count: 1
---

# Cell balancing

Use these blocks for cell balancing.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Passive Cell Balancing | batt_sl_lib/Cell Balancing/Passive Cell Balancing | R2023a+ | Equalize cell voltages in a series-connected pack by dissipating excess energy through bleed resistors — use to implement BMS balancing logic that reduces cell-to-cell SOC variation during charging |

---
type: Simulink Block Category
title: Thermal components
description: Simscape thermal components for pack cooling simulation
tags: [cooling, rom, channel, edge, thermal]
status: stable
source: mathworks_toolbox
library_root: Battery
category_path: Thermal components
block_count: 5
---

# Thermal components

Use these blocks for thermal components.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Array of Thermal Nodes Connector | batt_lib/Thermal/Array of Thermal Nodes Connector | R2023a+ | Connect arrays of thermal nodes between battery modules in Simscape — use to wire thermal ports of series/parallel cell configurations for pack-level thermal simulation |
| Edge Cooling | batt_lib/Thermal/Edge Cooling | R2023a+ | Model edge cooling of prismatic or pouch cells in Simscape — use to simulate heat extraction through cell edges via cold plates in pack thermal design |
| Multi-Cell Thermal ROM | batt_lib/Thermal/Multi-Cell Thermal ROM | R2023a+ | Reduced-order thermal model for multiple cells capturing spatial temperature distribution — use for computationally efficient pack thermal simulation that resolves cell-to-cell temperature gradients |
| Parallel Channels | batt_lib/Thermal/Parallel Channels | R2023a+ | Model parallel coolant flow channels for battery thermal management in Simscape — use to simulate flow distribution and thermal performance of manifolded cooling plates |
| U-shaped Channels | batt_lib/Thermal/U-shaped Channels | R2023a+ | Model U-shaped coolant flow channels in Simscape — use to simulate serpentine or U-turn cooling plate geometries and their effect on temperature uniformity |

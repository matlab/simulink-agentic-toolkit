---
type: Simulink Block Category
title: Thermal management
description: Thermal management control algorithms for cooling and heating (2 blocks)
tags: [toolbox-kb, battery, coolant, heater, thermal, temperature, control]
status: stable
sources:
  - resource: matlab:batt_sl_lib
source: toolbox_kb
managed_by: satk
library: Battery
kb_folder: battery
category: thermal-management
block_count: 2
generated: { by: satk-toolbox-build/1, at: "2026-11-23T18:23:14Z" }
---

# Thermal management

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Battery Coolant Control | batt_sl_lib/Thermal Management/Battery Coolant Control | R2023a+ | Control coolant flow rate and pump speed to regulate battery temperature — use to implement thermal management logic that maintains optimal cell temperature during charging and driving |
| Battery Heater Control | batt_sl_lib/Thermal Management/Battery Heater Control | R2023a+ | Control heater activation to bring battery temperature into operating range — use in cold-climate BMS to pre-condition cells before charging or high-power discharge |

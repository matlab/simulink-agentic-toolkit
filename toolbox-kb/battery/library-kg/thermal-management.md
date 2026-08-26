---
type: Simulink Block Category
title: Thermal management
description: Thermal management control algorithms for cooling and heating
tags: [coolant, heater, thermal, temperature, control]
status: stable
source: mathworks_toolbox
library_root: Battery
category_path: Thermal management
block_count: 2
---

# Thermal management

Use these blocks for thermal management.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Battery Coolant Control | batt_sl_lib/Thermal Management/Battery Coolant Control | R2023a+ | Control coolant flow rate and pump speed to regulate battery temperature — use to implement thermal management logic that maintains optimal cell temperature during charging and driving |
| Battery Heater Control | batt_sl_lib/Thermal Management/Battery Heater Control | R2023a+ | Control heater activation to bring battery temperature into operating range — use in cold-climate BMS to pre-condition cells before charging or high-power discharge |

---
type: Simulink Block Category
title: Current management
description: Charging and discharging current control and limiting algorithms
tags: [charging, discharging, current, limit, cc-cv]
status: stable
source: mathworks_toolbox
library_root: Battery
category_path: Current management
block_count: 4
---

# Current management

Use these blocks for current management.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Battery CC-CV | batt_sl_lib/Current Management/Battery CC-CV | R2023a+ | Implement constant-current constant-voltage charging protocol — use to generate charge current commands that transition from CC to CV phase at the voltage setpoint for safe Li-ion charging |
| Battery Charging Current Limit | batt_sl_lib/Current Management/Battery Charging Current Limit | R2023a+ | Compute the maximum allowable charging current based on cell voltage, temperature, and SOC — use in BMS to protect cells from overcharge by dynamically limiting charger current demand |
| Battery Discharging Current Limit | batt_sl_lib/Current Management/Battery Discharging Current Limit | R2023a+ | Compute the maximum allowable discharging current based on cell voltage, temperature, and SOC — use in BMS to prevent over-discharge and protect cells under high-load conditions |
| CC-CV Charging (Proportional Control) | batt_sl_lib/Current Management/CC-CV Charging (Proportional Control) | R2025a+ | Implement CC-CV charging with a proportional controller for smooth phase transition — use when a simple feedback controller is preferred over open-loop current reference generation |

---
type: Simulink Block Category
title: Cyclers
description: Battery test equipment models (chargers, dischargers, cyclers)
tags: [charger, discharger, cycler, test, profile]
status: stable
source: mathworks_toolbox
library_root: Battery
category_path: Cyclers
block_count: 3
---

# Cyclers

Use these blocks for cyclers.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Charger | batt_lib/Cyclers/Charger | R2023a+ | Model a battery charger as a controlled current/voltage source in Simscape — use to simulate charging profiles (CC-CV, pulse, multi-stage) applied to physical battery models |
| Cycler | batt_lib/Cyclers/Cycler | R2023a+ | Model a battery test cycler that applies charge/discharge profiles in Simscape — use to simulate standard test procedures (capacity tests, HPPC, drive cycles) on physical battery models |
| Discharger | batt_lib/Cyclers/Discharger | R2023a+ | Model a battery discharger as a controlled load in Simscape — use to simulate constant-current, constant-power, or profile-based discharge testing on physical battery models |

---
type: Simulink Block Category
title: Cyclers
description: "Battery test equipment models (chargers, dischargers, cyclers) (3 blocks)"
tags: [toolbox-kb, battery, charger, discharger, cycler, test, profile]
status: stable
sources:
  - resource: matlab:batt_lib
source: toolbox_kb
managed_by: satk
library: Battery
kb_folder: battery
category: cyclers
block_count: 3
generated: { by: satk-toolbox-build/1, at: "2026-11-23T18:23:14Z" }
---

# Cyclers

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Charger | batt_lib/Cyclers/Charger | R2023a+ | Model a battery charger as a controlled current/voltage source in Simscape — use to simulate charging profiles (CC-CV, pulse, multi-stage) applied to physical battery models |
| Cycler | batt_lib/Cyclers/Cycler | R2023a+ | Model a battery test cycler that applies charge/discharge profiles in Simscape — use to simulate standard test procedures (capacity tests, HPPC, drive cycles) on physical battery models |
| Discharger | batt_lib/Cyclers/Discharger | R2023a+ | Model a battery discharger as a controlled load in Simscape — use to simulate constant-current, constant-power, or profile-based discharge testing on physical battery models |

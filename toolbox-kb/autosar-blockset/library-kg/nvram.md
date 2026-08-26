---
type: Simulink Block Category
title: Nvram
description: Non-volatile RAM (NvM) services for persistent data storage across power cycles
tags: [nvram, nvm, persistent, storage, eeprom]
status: stable
source: mathworks_toolbox
library_root: AUTOSAR Blockset
category_path: Nvram
block_count: 3
---

# Nvram

Use these blocks for nvram.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| NVRAM Service Component | autosarlibnvm/NVRAM Service Component | R2023a+ | Provide a complete NvM service interface as a single component — use when modeling persistent storage logic that reads/writes calibration or adaptation data across ignition cycles |
| NvMAdminCaller | autosarlibnvm/NvMAdminCaller | R2023a+ | Perform administrative NvM operations (set block protection, invalidate, erase) — use for service routines that manage NVRAM block lifecycle beyond normal read/write |
| NvMServiceCaller | autosarlibnvm/NvMServiceCaller | R2023a+ | Read or write a persistent data block through the NvM service — use to store adaptation values, DTCs, or learned parameters that must survive power cycles |

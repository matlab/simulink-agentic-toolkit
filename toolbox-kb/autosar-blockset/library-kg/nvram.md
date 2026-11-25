---
type: Simulink Block Category
title: Nvram
description: Non-volatile RAM (NvM) services for persistent data storage across power cycles (3 blocks)
tags: [toolbox-kb, autosar-blockset, nvram, nvm, persistent, storage, eeprom]
status: stable
sources:
  - resource: matlab:autosarlibnvm
source: toolbox_kb
managed_by: satk
library: AUTOSAR Blockset
kb_folder: autosar-blockset
category: nvram
block_count: 3
generated: { by: satk-toolbox-build/1, at: "2026-11-23T18:23:12Z" }
---

# Nvram

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| NvMAdminCaller | autosarlibnvm/NvMAdminCaller | R2023a+ | Perform administrative NvM operations (set block protection, invalidate, erase) — use for service routines that manage NVRAM block lifecycle beyond normal read/write |
| NvMServiceCaller | autosarlibnvm/NvMServiceCaller | R2023a+ | Read or write a persistent data block through the NvM service — use to store adaptation values, DTCs, or learned parameters that must survive power cycles |
| NVRAM Service Component | autosarlibnvm/NVRAM Service Component | R2023a+ | Provide a complete NvM service interface as a single component — use when modeling persistent storage logic that reads/writes calibration or adaptation data across ignition cycles |

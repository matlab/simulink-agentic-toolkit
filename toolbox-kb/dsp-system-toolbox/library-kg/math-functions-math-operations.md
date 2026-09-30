---
type: Simulink Block Category
title: Math functions math operations
description: Blocks for math functions math operations.
status: draft
source: custom_library
library_root: DSP System Toolbox
category_path: Math functions math operations
block_count: 3
---

# Math functions math operations

Use these blocks for math functions math operations.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Difference | dspmathops/Difference | R2023a+ | Difference between adjacent input elements. Running difference is always performed along the column dimension. Otherwise the difference is performed along the specified dimension. |
| dB Conversion | dspmathops/dB Conversion | R2023a+ | Convert input of watts or volts to decibels. Voltage inputs are first converted to power relative to the specified load resistance, where P = (V^2)/R. When converting to dB, the reference power is 1 W. When converting to dBm, the reference power is 1 mW. |
| dB Gain | dspmathops/dB Gain | R2023a+ | Apply a gain specified in dB. |

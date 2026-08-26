---
type: Simulink Block Category
title: Cell models
description: Simscape physical battery and supercapacitor cell models
tags: [battery, cell, equivalent, circuit, simscape]
status: stable
source: mathworks_toolbox
library_root: Battery
category_path: Cell models
block_count: 5
---

# Cell models

Use these blocks for cell models.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Battery | batt_lib/Cells/Battery | R2023a+ | Model a battery cell or module as a Simscape physical component with equivalent circuit dynamics — use for system-level electrical simulation with current, voltage, and thermal ports |
| Battery (Table-Based) | batt_lib/Cells/Battery (Table-Based) | R2023a+ | Model a battery cell using table-based parameterization of OCV, resistance, and time constants vs. SOC and temperature — use when cell characterization data is available from HPPC or EIS testing |
| Battery Equivalent Circuit | batt_lib/Cells/Battery Equivalent Circuit | R2023a+ | Model a battery using a configurable equivalent circuit (R, RC, or multi-RC) in Simscape — use for detailed electrical dynamics simulation including transient voltage response under pulsed loads |
| Supercapacitor Equivalent Circuit | batt_lib/Cells/Supercapacitor Equivalent Circuit | R2023a+ | Model a supercapacitor using an equivalent circuit in Simscape — use for hybrid energy storage systems combining batteries with supercapacitors for peak power buffering |
| Battery Single Particle | batt_lib/Cells/Electrochemical/Battery Single Particle | R2023a+ | Model a battery cell using single-particle electrochemical physics — use when equivalent circuits lack fidelity and internal states like lithium concentration gradients are needed for advanced BMS development |

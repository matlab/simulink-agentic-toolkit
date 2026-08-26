---
type: Simulink Block Category
title: Electrical
description: Battery, alternator, and power electronics
tags: [battery, alternator, dc-dc, starter, inverter]
status: stable
source: mathworks_toolbox
library_root: Powertrain Blockset
category_path: Electrical
block_count: 7
---

# Electrical

Use these blocks for electrical.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Reduced Lundell Alternator | autolibalternator/Reduced Lundell Alternator | R2023a+ | Model a vehicle alternator — use for simulating electrical load and charging system interaction |
| Bidirectional DC-DC | autolibdcdc/Bidirectional DC-DC | R2023a+ | Model a bidirectional DC-DC converter — use for simulating voltage conversion between battery and motor in HEVs |
| Datasheet Battery | autolibdatasheetbattery/Datasheet Battery | R2023a+ | Model battery from datasheet parameters — use for quick battery modeling from manufacturer specifications |
| Equivalent Circuit Battery | autolibrcnetworksystem/Equivalent Circuit Battery | R2023a+ | Model battery with RC equivalent circuit — use for simulating voltage, SOC, and thermal dynamics |
| Estimation Equivalent Circuit Battery | autolibrcnetworksystem/Estimation Equivalent Circuit Battery | R2023a+ | Battery model with SOC estimation — use for simulating battery management system state estimation |
| Starter | autolibstarter/Starter | R2023a+ | Model engine starter motor — use for simulating cranking torque during engine start |
| Three-Phase Voltage Source Inverter | autolibemachines/Three-Phase Voltage Source Inverter | R2023a+ | Three-phase inverter model — use for simulating PWM power electronics driving traction motors |

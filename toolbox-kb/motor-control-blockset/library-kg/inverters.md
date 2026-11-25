---
type: Simulink Block Category
title: Inverters
description: Average-value inverter models that convert DC bus voltage and modulation signals into three-phase output for simulation (2 blocks)
tags: [toolbox-kb, motor-control-blockset, inverter, average value, DC bus, three-phase, power stage]
status: stable
sources:
  - resource: matlab:mcblib
source: toolbox_kb
managed_by: satk
library: Motor Control Blockset
kb_folder: motor-control-blockset
category: inverters
block_count: 2
generated: { by: satk-toolbox-build/1, at: "2026-11-23T18:23:35Z" }
---

# Inverters

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Average-Value Inverter | mcblib/Electrical Systems/Inverters/Average-Value Inverter | R2023a+ | Model a three-phase inverter as an ideal voltage source proportional to duty cycle — use for fast, non-switching plant simulations of FOC loops when switching harmonics are not of interest |
| BLDC Average-Value Inverter | mcblib/Electrical Systems/Inverters/BLDC Average-Value Inverter | R2023a+ | Average-value inverter model tailored for six-step BLDC commutation — use in trapezoidal-drive simulations where individual switching events can be abstracted away |

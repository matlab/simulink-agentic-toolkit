---
type: Simulink Block Category
title: Inverters
description: Average-value inverter models that convert DC bus voltage and modulation signals into three-phase output for simulation
tags: [inverter, average value, DC bus, three-phase, power stage]
status: stable
source: mathworks_toolbox
library_root: Motor Control Blockset
category_path: Inverters
block_count: 2
---

# Inverters

Use these blocks for inverters.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Average-Value Inverter | mcblib/Electrical Systems/Inverters/Average-Value Inverter | R2023a+ | Model a three-phase inverter as an ideal voltage source proportional to duty cycle — use for fast, non-switching plant simulations of FOC loops when switching harmonics are not of interest |
| BLDC Average-Value Inverter | mcblib/Electrical Systems/Inverters/BLDC Average-Value Inverter | R2023a+ | Average-value inverter model tailored for six-step BLDC commutation — use in trapezoidal-drive simulations where individual switching events can be abstracted away |

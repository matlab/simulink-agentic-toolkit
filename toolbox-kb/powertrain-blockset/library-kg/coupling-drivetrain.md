---
type: Simulink Block Category
title: Coupling drivetrain
description: Clutches, gears, differentials, and shafts
tags: [clutch, gear, differential, torsional, inertia, chain]
status: stable
source: mathworks_toolbox
library_root: Powertrain Blockset
category_path: Coupling drivetrain
block_count: 12
---

# Coupling drivetrain

Use these blocks for coupling drivetrain.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Disc Clutch | autolibcoupling/Disc Clutch | R2023a+ | Model a friction disc clutch — use for simulating engagement/disengagement and torque transfer in transmissions |
| Planetary Gear | autolibcoupling/Planetary Gear | R2023a+ | Model a planetary gear set — use for simulating automatic transmission gear ratios with sun, ring, and carrier |
| Gearbox | autolibcoupling/Gearbox | R2023a+ | Model a multi-ratio gearbox — use for simulating manual or automated gear selection with efficiency losses |
| Motorcycle Chain | autolibcoupling/Motorcycle Chain | R2023a+ | Model chain drive dynamics — use for simulating sprocket-chain power transmission in motorcycles |
| Rotational Inertia | autolibcoupling/Rotational Inertia | R2023a+ | Model a rotational inertia element — use for representing flywheels and rotating mass in drivetrain |
| Split Torsional Compliance | autolibcoupling/Split Torsional Compliance | R2023a+ | Model split shaft compliance — use for simulating flexible coupling between drivetrain components with branching |
| Torsional Compliance | autolibcoupling/Torsional Compliance | R2023a+ | Model shaft torsional flexibility — use for simulating driveline vibration and compliance between components |
| Limited Slip Differential | autolibdiff/Limited Slip Differential | R2023a+ | Model a limited-slip differential — use for simulating torque biasing between driven wheels |
| Open Differential | autolibdiff/Open Differential | R2023a+ | Model an open differential — use for simulating equal-torque split between driven wheels |
| Transfer Case | autolibdiff/Transfer Case | R2023a+ | Model a transfer case — use for simulating torque distribution between front and rear axles in AWD |
| Two-Way Connection | autolibsimscapeutils/Two-Way Connection | R2023a+ | Bidirectional signal connection — use for interfacing torque-speed signals between powertrain blocks |
| Connection Port | autolibsimscapeutils/Connection Port | R2023a+ | Physical connection port — use for connecting Simscape physical signals at subsystem boundaries |

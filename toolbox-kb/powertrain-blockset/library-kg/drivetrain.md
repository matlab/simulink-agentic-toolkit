---
type: Simulink Block Category
title: Drivetrain
description: Couplings, differentials, transfer cases, and wheels
tags: [drivetrain, gearbox, differential, transfer case, wheel, compliance, inertia, chain]
status: stable
source: custom_library
library_root: Powertrain Blockset
category_path: Drivetrain
block_count: 14
---

# Drivetrain

Use these blocks for drivetrain.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Gearbox | autolibcoupling/Gearbox | R2023a+ | Model a fixed-ratio gearbox with inertia and efficiency losses — use to represent a gear reduction in a driveline. |
| Motorcycle Chain | autolibcoupling/Motorcycle Chain | R2023a+ | Model a motorcycle final-drive chain with ratio and compliance — use to couple the transmission to the rear wheel. |
| Rotational Inertia | autolibcoupling/Rotational Inertia | R2023a+ | Add lumped rotational inertia (with optional damping) to a driveline shaft — use to represent spinning mass. |
| Split Torsional Compliance | autolibcoupling/Split Torsional Compliance | R2023a+ | Model a torsionally-compliant coupling that splits torque between two paths — use for driveline branching with shaft flexibility. |
| Torsional Compliance | autolibcoupling/Torsional Compliance | R2023a+ | Model shaft torsional compliance (spring/damper) between two rotational ports — use to capture driveline flexibility and resonance. |
| Disc Clutch | autolibcoupling/Disc Clutch | R2023a+ | Implements an idealized dry friction clutch. |
| Planetary Gear | autolibcoupling/Planetary Gear | R2023a+ | Implements an ideal planetary gear coupling consisting of a rigidly coupled sun, ring and carrier. Torque inputs are provided in order to produce the corresponding velocity response. |
| Limited Slip Differential | autolibdiff/Limited Slip Differential | R2023a+ | Model a limited-slip differential that biases torque toward the higher-traction wheel — use for driveline traction studies. |
| Open Differential | autolibdiff/Open Differential | R2023a+ | Model an open differential splitting torque equally to two outputs — use as a standard axle differential in a driveline. |
| Transfer Case | autolibdiff/Transfer Case | R2023a+ | Split driveline torque between front and rear axles — use to model 4WD/AWD power distribution. |
| Longitudinal Wheel - Disc Brake | autolibwheelslong/Longitudinal Wheel - Disc Brake | R2024b+ | Model a longitudinal wheel with tire-slip dynamics and a disc brake — use for braking and traction studies with disc braking. |
| Longitudinal Wheel - Drum Brake | autolibwheelslong/Longitudinal Wheel - Drum Brake | R2023a+ | Model a longitudinal wheel with tire-slip dynamics and a drum brake — use for braking and traction studies with drum braking. |
| Longitudinal Wheel - Mapped Brake | autolibwheelslong/Longitudinal Wheel - Mapped Brake | R2023a+ | Model a longitudinal wheel with tire-slip dynamics and a table-mapped brake — use when brake torque is characterized by data. |
| Longitudinal Wheel - No Brake | autolibwheelslong/Longitudinal Wheel - No Brake | R2023a+ | Model a longitudinal wheel with tire-slip dynamics and no brake — use for driven or rolling wheels without braking. |

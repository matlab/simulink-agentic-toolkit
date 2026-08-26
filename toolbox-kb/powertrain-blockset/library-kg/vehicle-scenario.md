---
type: Simulink Block Category
title: Vehicle scenario
description: Vehicle body, driver, and drive cycle
tags: [vehicle, body, driver, drive cycle, motorcycle, road load]
status: stable
source: mathworks_toolbox
library_root: Powertrain Blockset
category_path: Vehicle scenario
block_count: 6
---

# Vehicle scenario

Use these blocks for vehicle scenario.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Motorcycle Body Longitudinal In-Plane | autolibvehdynlong/Motorcycle Body Longitudinal In-Plane | R2023a+ | Motorcycle longitudinal dynamics — use for simulating motorcycle acceleration, braking, and pitch motion |
| Vehicle Body 1DOF Longitudinal | autolibvehdynlong/Vehicle Body 1DOF Longitudinal | R2023a+ | Single-DOF vehicle body — use for basic vehicle speed simulation with road load |
| Vehicle Body 3DOF Longitudinal | autolibvehdynlong/Vehicle Body 3DOF Longitudinal | R2023a+ | Three-DOF vehicle body — use for simulating vehicle longitudinal dynamics with pitch and heave |
| Vehicle Body Total Road Load | autolibvehdynlong/Vehicle Body Total Road Load | R2023a+ | Vehicle road load model — use for computing aerodynamic drag, rolling resistance, and grade force |
| Drive Cycle Source | autolibscenario/Drive Cycle Source | R2023a+ | Provide standard drive cycle profiles — use for feeding velocity targets from regulatory or custom drive cycles |
| Longitudinal Driver | autolibscenario/Longitudinal Driver | R2023a+ | Driver model for speed tracking — use for simulating accelerator and brake pedal inputs to follow a drive cycle |

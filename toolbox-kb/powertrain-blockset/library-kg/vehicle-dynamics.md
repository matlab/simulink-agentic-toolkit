---
type: Simulink Block Category
title: Vehicle dynamics
description: Longitudinal vehicle body and road-load dynamics (4 blocks)
tags: [toolbox-kb, powertrain-blockset, vehicle dynamics, vehicle body, road load, motorcycle body]
status: stable
sources:
  - resource: matlab:autolibvehdynlong
source: toolbox_kb
managed_by: satk
library: Powertrain Blockset
kb_folder: powertrain-blockset
category: vehicle-dynamics
block_count: 4
generated: { by: satk-toolbox-build/1, at: "2026-11-23T18:23:25Z" }
---

# Vehicle dynamics

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Motorcycle Body Longitudinal In-Plane | autolibvehdynlong/Motorcycle Body Longitudinal In-Plane | R2023a+ | Model in-plane longitudinal motorcycle body dynamics — use for motorcycle acceleration and braking studies. |
| Vehicle Body 1DOF Longitudinal | autolibvehdynlong/Vehicle Body 1DOF Longitudinal | R2023a+ | Model longitudinal vehicle motion with a single degree of freedom — use for simple straight-line acceleration/braking studies. |
| Vehicle Body 3DOF Longitudinal | autolibvehdynlong/Vehicle Body 3DOF Longitudinal | R2023a+ | Model vehicle longitudinal, vertical, and pitch dynamics (3 DOF) — use for ride and load-transfer studies in the longitudinal plane. |
| Vehicle Body Total Road Load | autolibvehdynlong/Vehicle Body Total Road Load | R2023a+ | Compute total road load (aerodynamic drag, rolling resistance, grade) opposing motion — use to apply resistive forces in a longitudinal model. |

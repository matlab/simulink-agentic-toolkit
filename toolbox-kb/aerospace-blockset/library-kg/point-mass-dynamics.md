---
type: Simulink Block Category
title: Point mass dynamics
description: Simplified point-mass trajectory equations (5 blocks)
tags: [toolbox-kb, aerospace-blockset, point mass, trajectory, coordinated flight, longitudinal]
status: stable
sources:
  - resource: matlab:aerolibptmass
source: toolbox_kb
managed_by: satk
library: Aerospace Blockset
kb_folder: aerospace-blockset
category: point-mass-dynamics
block_count: 5
generated: { by: satk-toolbox-build/1, at: "2026-11-23T18:23:13Z" }
---

# Point mass dynamics

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| 4th Order Point Mass (Longitudinal) | aerolibptmass/4th Order Point Mass (Longitudinal) | R2023a+ | Integrate 4th-order longitudinal point-mass equations (V, gamma, x, h) for trajectory optimization and performance analysis |
| 4th Order Point Mass Forces (Longitudinal) | aerolibptmass/4th Order Point Mass Forces (Longitudinal) | R2023a+ | Compute forces for 4th-order longitudinal point mass from thrust, weight, lift, and drag coefficients |
| 6th Order Point Mass (Coordinated Flight) | aerolibptmass/6th Order Point Mass (Coordinated Flight) | R2023a+ | Integrate 6th-order coordinated-flight point-mass equations (V, gamma, chi, x, y, h) for 3D trajectory analysis with bank-to-turn |
| 6th Order Point Mass Forces (Coordinated Flight) | aerolibptmass/6th Order Point Mass Forces (Coordinated Flight) | R2023a+ | Compute forces for 6th-order coordinated point mass from aerodynamic coefficients, thrust, and bank angle |
| Fixed-Wing Point Mass | aerolibptmass/Fixed-Wing Point Mass | R2023a+ | Simplified fixed-wing point mass dynamics for quick trajectory studies without full aerodynamic modeling |

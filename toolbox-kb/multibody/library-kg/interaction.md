---
type: Simulink Block Category
title: Interaction
description: "Forces, contacts, and constraint interactions (4 blocks)"
tags: [toolbox-kb, multibody, force, torque, constraint, contact, spring]
status: stable
sources:
  - resource: matlab:sm_lib
source: toolbox_kb
managed_by: satk
library: Multibody
kb_folder: multibody
category: interaction
block_count: 4
generated: { by: satk-toolbox-build/1, at: "2026-11-23T18:23:24Z" }
---

# Interaction

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Constraints | sm_lib/Constraints | R2023a+ | Apply kinematic constraints between bodies — use for locking degrees of freedom, enforcing geometric relationships, or creating closed-loop mechanisms |
| Curves and Surfaces | sm_lib/Curves and Surfaces | R2023a+ | Define contact geometry for collision detection — use for modeling rolling, sliding, or impact interactions between curved surfaces in multibody systems |
| Forces and Torques | sm_lib/Forces and Torques | R2023a+ | Apply external forces and torques to bodies — use for modeling gravity, springs, dampers, actuators, or any applied load in a multibody system |
| Simscape Mechanical Interfaces | sm_lib/Simscape Mechanical Interfaces | R2023a+ | Interface Simscape Multibody with Simscape physical networks — use for connecting 3D mechanical models to 1D driveline or other Simscape domain models |

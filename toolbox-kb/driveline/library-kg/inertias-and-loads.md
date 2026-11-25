---
type: Simulink Block Category
title: Inertias and loads
description: "Variable inertia, variable mass, and unbalanced rotational loads (3 blocks)"
tags: [toolbox-kb, driveline, inertia, mass, load, unbalanced, variable]
status: stable
sources:
  - resource: matlab:sdl_lib
source: toolbox_kb
managed_by: satk
library: Driveline
kb_folder: driveline
category: inertias-and-loads
block_count: 3
generated: { by: satk-toolbox-build/1, at: "2026-11-23T18:23:18Z" }
---

# Inertias and loads

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Unbalanced Load | sdl_lib/Inertias & Loads/Unbalanced Load | R2023a+ | Model a rotating mass with center-of-gravity offset generating cyclic forces — use for vibration analysis of shafts with eccentric loads or unbalanced rotors |
| Variable Inertia | sdl_lib/Inertias & Loads/Variable Inertia | R2023a+ | Model a rotational inertia whose value changes via an external signal — use for systems with varying payload, fuel consumption effects, or deployable mechanisms |
| Variable Mass | sdl_lib/Inertias & Loads/Variable Mass | R2023a+ | Model a translational mass whose value changes via an external signal — use for rocket propulsion, conveyor loading, or systems with mass flow |

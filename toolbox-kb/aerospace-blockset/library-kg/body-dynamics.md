---
type: Simulink Block Category
title: Body dynamics
description: "Mass properties, inertia tensor, and CG estimation (4 blocks)"
tags: [toolbox-kb, aerospace-blockset, inertia, CG, center of gravity, mass, moment]
status: stable
sources:
  - resource: matlab:aerolibbdyn
source: toolbox_kb
managed_by: satk
library: Aerospace Blockset
kb_folder: aerospace-blockset
category: body-dynamics
block_count: 4
generated: { by: satk-toolbox-build/1, at: "2026-11-23T18:23:13Z" }
---

# Body dynamics

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Estimate Center of Gravity | aerolibbdyn/Estimate Center of Gravity | R2023a+ | Estimate combined CG location from multiple component masses and positions — use for mass buildup in vehicle configuration studies |
| Moments about CG  due to Forces | aerolibbdyn/Moments about CG  due to Forces | R2023a+ | Compute moments about the CG caused by off-CG forces using moment arm cross products — use for engine thrust or landing gear force coupling |
| Symmetric Inertia Tensor | aerolibbdyn/Symmetric Inertia Tensor | R2023a+ | Construct a symmetric 3x3 inertia tensor from moments and products of inertia for use in rotational equations of motion |
| Estimate Inertia Tensor | aerolibbdyn/Estimate Inertia Tensor | R2023a+ | Estimate combined inertia tensor from multiple components using parallel axis theorem — use for composite vehicle inertia buildup |

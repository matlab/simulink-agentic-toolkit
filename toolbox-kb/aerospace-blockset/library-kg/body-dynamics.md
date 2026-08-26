---
type: Simulink Block Category
title: Body dynamics
description: Mass properties, inertia tensor, and CG estimation
tags: [inertia, CG, center of gravity, mass, moment]
status: stable
source: mathworks_toolbox
library_root: Aerospace Blockset
category_path: Body dynamics
block_count: 4
---

# Body dynamics

Use these blocks for body dynamics.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Estimate Center of Gravity | aerolibbdyn/Estimate Center of Gravity | R2023a+ | Estimate combined CG location from multiple component masses and positions — use for mass buildup in vehicle configuration studies |
| Moments about CG  due to Forces | aerolibbdyn/Moments about CG  due to Forces | R2023a+ | Compute moments about the CG caused by off-CG forces using moment arm cross products — use for engine thrust or landing gear force coupling |
| Symmetric Inertia Tensor | aerolibbdyn/Symmetric Inertia Tensor | R2023a+ | Construct a symmetric 3x3 inertia tensor from moments and products of inertia for use in rotational equations of motion |
| Estimate Inertia Tensor | aerolibbdyn/Estimate Inertia Tensor | R2023a+ | Estimate combined inertia tensor from multiple components using parallel axis theorem — use for composite vehicle inertia buildup |

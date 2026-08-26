---
type: Simulink Block Category
title: Constraint enforcement
description: Safety constraint and passivity enforcement
tags: [barrier, constraint, lyapunov, passivity, safety]
status: stable
source: mathworks_toolbox
library_root: Simulink Control Design
category_path: Constraint enforcement
block_count: 4
---

# Constraint enforcement

Use these blocks for constraint enforcement.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Constraint Enforcement | slctrl_constraint/Constraint Enforcement | R2023b+ | Modify control actions to satisfy state constraints — use for keeping the system within safe operating bounds |
| Control Barrier Function | slctrl_constraint/Control Barrier Function | R2026a+ | Enforce safety constraints using barrier certificates — use for guaranteeing set invariance in safety-critical systems |
| High-Order Control Barrier Function | slctrl_constraint/High-Order Control Barrier Function | R2026a+ | Enforce safety on systems with relative degree greater than one — use for high-order safety constraints on underactuated systems |
| Passivity Enforcement | slctrl_constraint/Passivity Enforcement | R2023b+ | Enforce passivity on control signals — use for guaranteeing stable interaction with unknown passive environments |

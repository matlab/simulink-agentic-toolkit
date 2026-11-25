---
type: Simulink Block Category
title: Constraint enforcement
description: Safety constraint and passivity enforcement (4 blocks)
tags: [toolbox-kb, simulink-control-design, barrier, constraint, lyapunov, passivity, safety]
status: stable
sources:
  - resource: matlab:slctrl_constraint
source: toolbox_kb
managed_by: satk
library: Simulink Control Design
kb_folder: simulink-control-design
category: constraint-enforcement
block_count: 4
generated: { by: satk-toolbox-build/1, at: "2026-11-23T18:23:30Z" }
---

# Constraint enforcement

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Constraint Enforcement | slctrl_constraint/Constraint Enforcement | R2023b+ | Modify control actions to satisfy state constraints — use for keeping the system within safe operating bounds |
| Control Barrier Function | slctrl_constraint/Control Barrier Function | R2026a+ | Enforce safety constraints using barrier certificates — use for guaranteeing set invariance in safety-critical systems |
| High-Order Control Barrier Function | slctrl_constraint/High-Order Control Barrier Function | R2026a+ | Enforce safety on systems with relative degree greater than one — use for high-order safety constraints on underactuated systems |
| Passivity Enforcement | slctrl_constraint/Passivity Enforcement | R2023b+ | Enforce passivity on control signals — use for guaranteeing stable interaction with unknown passive environments |

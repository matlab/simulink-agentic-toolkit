---
type: Simulink Block Category
title: Linear models
description: Simulate imported LTI/second-order model objects
tags: [lti system, sparse second order]
status: stable
source: custom_library
library_root: Control System Toolbox
category_path: Linear models
block_count: 2
---

# Linear models

Use these blocks for linear models.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| LTI System | cstblocks/LTI System | R2023a+ | Simulate an imported Control System Toolbox LTI model object (tf/ss/zpk) directly as a block — use to drop a designed or identified linear model into a model. |
| Sparse Second Order | cstblocks/Sparse Second Order | R2023a+ | Simulate a large sparse second-order (mechanical/FE-style) model efficiently — use for high-order structural or mechanical dynamics without dense state-space. |

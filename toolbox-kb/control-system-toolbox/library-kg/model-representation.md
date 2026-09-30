---
type: Simulink Block Category
title: Model representation
description: Embed workspace LTI or large-scale linear models directly into a Simulink diagram.
tags: [lti, state-space, transfer-function, plant, linear]
status: stable
source: custom_library
library_root: Control System Toolbox
category_path: Model representation
block_count: 2
---

# Model representation

Use these blocks for model representation.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| LTI System | cstblocks/LTI System | R2023a+ | Drops a linear time-invariant model (ss, tf, zpk, or frd object from the workspace) straight into a diagram. Use to reuse a controller or plant designed at the command line without rebuilding its dynamics from primitive blocks. |
| Sparse Second Order | cstblocks/Sparse Second Order | R2023a+ | Simulates large second-order mechanical or structural models given as sparse mass, damping, and stiffness matrices. Use for high-order finite-element or flexible-body models where a dense state-space would be too large to simulate efficiently. |

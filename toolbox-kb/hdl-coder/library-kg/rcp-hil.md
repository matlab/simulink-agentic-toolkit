---
type: Simulink Block Category
title: Rcp hil
description: "State-space, PWM, and hardware-oriented blocks (5 blocks)"
tags: [toolbox-kb, hdl-coder, state-space, pwm, hil, sparse, combinatorial]
status: stable
sources:
  - resource: matlab:hdlsllib
source: toolbox_kb
managed_by: satk
library: HDL Coder
kb_folder: hdl-coder
category: rcp-hil
block_count: 5
generated: { by: satk-toolbox-build/1, at: "2026-11-23T18:23:23Z" }
---

# Rcp hil

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Discrete State-Space | hdlsllib/RCP and HIL/Discrete State-Space | R2024b+ | Implement a discrete-time state-space model (A, B, C, D) — use for MIMO linear dynamics. |
| Fixed-Point State-Space | hdlsllib/RCP and HIL/Fixed-Point State-Space | R2024b+ | Fixed-point discrete state-space model — use for MIMO dynamics on fixed-point/HDL targets. |
| HDL Combinatorial Logic | hdlsllib/RCP and HIL/HDL Combinatorial Logic | R2024b+ | Implement truth-table-based combinatorial logic for HDL — use for lookup-defined logic. |
| PWM | hdlsllib/RCP and HIL/PWM | R2024b+ | Generate a pulse-width-modulated signal from a duty-cycle input — use to drive motor or power stages on hardware. |
| Sparse Matrix-Vector Product | hdlsllib/RCP and HIL/Sparse Matrix-Vector Product | R2024b+ | Multiply a sparse matrix by a vector — use for efficient large sparse linear operations. |

---
type: Simulink Block Category
title: Fixed point math
description: Optimized fixed-point arithmetic operations for efficient code generation
tags: [fixed-point, divide, modulo, round, constant]
status: stable
source: mathworks_toolbox
library_root: Fixed-Point Designer
category_path: Fixed point math
block_count: 2
---

# Fixed point math

Use these blocks for fixed point math.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Divide by Constant and Round | embeddedMathLib/Divide by Constant and Round | R2023a+ | Divide a signal by a compile-time constant and round the result with configurable rounding mode — use to replace expensive runtime division with efficient multiply-shift operations in fixed-point code generation |
| Modulo by Constant | embeddedMathLib/Modulo by Constant | R2023a+ | Compute modulo of a signal by a compile-time constant — use for efficient remainder operations in fixed-point scheduling, circular buffers, or angle wrapping without runtime division |

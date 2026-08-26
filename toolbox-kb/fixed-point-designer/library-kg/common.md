---
type: Block Selection Guide
title: Common Blocks
description: High-value blocks selected for quick agent discovery.
status: stable
source: mathworks_toolbox
block_count: 2
---

# Common Blocks

Prefer these blocks when their intent matches the user request.

| Intent | Preferred Block | Library |
|---|---|---|
| Divide a signal by a compile-time constant and round the result with configurable rounding mode — use to replace expensive runtime division with efficient multiply-shift operations in fixed-point code generation | Divide by Constant and Round | Fixed-Point Designer |
| Compute modulo of a signal by a compile-time constant — use for efficient remainder operations in fixed-point scheduling, circular buffers, or angle wrapping without runtime division | Modulo by Constant | Fixed-Point Designer |

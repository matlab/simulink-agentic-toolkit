---
type: Simulink Block Category
title: Sources
description: Constant and ground sources
tags: [sources, constant, ground, enumerated, inport]
status: stable
source: custom_library
library_root: DO-178C/DO-331 Primitive Library
category_path: Sources
block_count: 3
---

# Sources

Use these blocks for sources.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Constant | do178Lib/Simulink/Sources/Constant | R2023a+ | Output a constant value — use for fixed parameters, thresholds, or test inputs. |
| Enumerated Constant | do178Lib/Simulink/Sources/Enumerated Constant | R2023a+ | Output a constant enumerated value — use to emit a named mode or state constant. |
| Ground | do178Lib/Simulink/Sources/Ground | R2023a+ | Provide a zero-valued source for an unconnected input — use to safely tie off inputs. |

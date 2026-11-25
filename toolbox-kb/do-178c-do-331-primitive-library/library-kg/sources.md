---
type: Simulink Block Category
title: Sources
description: Constant and ground sources (3 blocks)
tags: [toolbox-kb, do-178c-do-331-primitive-library, sources, constant, ground, enumerated, inport]
status: stable
sources:
  - resource: matlab:do178Lib
source: toolbox_kb
managed_by: satk
library: DO-178C/DO-331 Primitive Library
kb_folder: do-178c-do-331-primitive-library
category: sources
block_count: 3
generated: { by: satk-toolbox-build/1, at: "2026-11-23T18:23:17Z" }
---

# Sources

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Constant | do178Lib/Simulink/Sources/Constant | R2023a+ | Output a constant value — use for fixed parameters, thresholds, or test inputs. |
| Enumerated Constant | do178Lib/Simulink/Sources/Enumerated Constant | R2023a+ | Output a constant enumerated value — use to emit a named mode or state constant. |
| Ground | do178Lib/Simulink/Sources/Ground | R2023a+ | Provide a zero-valued source for an unconnected input — use to safely tie off inputs. |

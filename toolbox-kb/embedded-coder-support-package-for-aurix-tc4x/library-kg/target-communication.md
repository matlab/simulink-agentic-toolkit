---
type: Simulink Block Category
title: Target communication
description: Data exchange between processes and cores (2 blocks)
tags: [toolbox-kb, embedded-coder-support-package-for-aurix-tc4x, interprocess, target communication, shared, channel]
status: stable
sources:
  - resource: matlab:aurixtc4xlib
source: toolbox_kb
managed_by: satk
library: Embedded Coder Support Package for AURIX TC4x
kb_folder: embedded-coder-support-package-for-aurix-tc4x
category: target-communication
block_count: 2
generated: { by: satk-toolbox-build/1, at: "2026-11-23T18:23:20Z" }
---

# Target communication

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Interprocess Data Read | aurixtc4xlib/Target Communication/Interprocess Data Read | R2024b+ | Read data shared between processes or cores on the AURIX TC4x — use to consume values produced by another task or core in a multicore design. |
| Interprocess Data Write | aurixtc4xlib/Target Communication/Interprocess Data Write | R2024b+ | Write data to be shared between processes or cores on the AURIX TC4x — use to publish values for another task or core in a multicore design. |

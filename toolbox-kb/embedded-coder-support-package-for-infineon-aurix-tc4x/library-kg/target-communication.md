---
type: Simulink Block Category
title: Target communication
description: Data exchange between processes and cores
tags: [interprocess, target communication, shared, channel]
status: stable
source: custom_library
library_root: Embedded Coder Support Package for Infineon AURIX TC4x
category_path: Target communication
block_count: 2
---

# Target communication

Use these blocks for target communication.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Interprocess Data Read | aurixtc4xlib/Target Communication/Interprocess Data Read | R2024b+ | Read data shared between processes or cores on the AURIX TC4x — use to consume values produced by another task or core in a multicore design. |
| Interprocess Data Write | aurixtc4xlib/Target Communication/Interprocess Data Write | R2024b+ | Write data to be shared between processes or cores on the AURIX TC4x — use to publish values for another task or core in a multicore design. |

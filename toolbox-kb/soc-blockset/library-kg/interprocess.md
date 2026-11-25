---
type: Simulink Block Category
title: Interprocess
description: Shared data channels for communication between processor tasks at different rates (3 blocks)
tags: [toolbox-kb, soc-blockset, interprocess, shared, channel, IPC, rate-transition]
status: stable
sources:
  - resource: matlab:procinterlib
source: toolbox_kb
managed_by: satk
library: SoC Blockset
kb_folder: soc-blockset
category: interprocess
block_count: 3
generated: { by: satk-toolbox-build/1, at: "2026-11-23T18:23:35Z" }
---

# Interprocess

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Interprocess Data Channel | procinterlib/Interprocess Data Channel | R2023a+ | Model a shared data channel between processor tasks running at different rates |
| Interprocess Data Read | procinterlib/Interprocess Data Read | R2023a+ | Read shared data from another processor task via the interprocess channel |
| Interprocess Data Write | procinterlib/Interprocess Data Write | R2023a+ | Write shared data for another processor task via the interprocess channel |

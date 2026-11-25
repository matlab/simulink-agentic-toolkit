---
type: Simulink Block Category
title: Signal management
description: "Signal quality, invalidation, and communication status handling (1 blocks)"
tags: [toolbox-kb, autosar-blockset, invalidation, signal, quality, status, communication]
status: stable
sources:
  - resource: matlab:autosarlibcprouting
source: toolbox_kb
managed_by: satk
library: AUTOSAR Blockset
kb_folder: autosar-blockset
category: signal-management
block_count: 1
generated: { by: satk-toolbox-build/1, at: "2026-11-23T18:23:12Z" }
---

# Signal management

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Signal Invalidation | autosarlibcprouting/Signal Invalidation | R2023a+ | Mark a signal as invalid to indicate communication failure or data unavailability — use in sender-receiver interfaces to propagate signal quality status to receiving components |

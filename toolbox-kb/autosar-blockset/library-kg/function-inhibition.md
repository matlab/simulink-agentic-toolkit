---
type: Simulink Block Category
title: Function inhibition
description: Function Inhibition Manager (FIM) for controlled degradation and safety interlocks (2 blocks)
tags: [toolbox-kb, autosar-blockset, inhibition, fim, control, available, permission]
status: stable
sources:
  - resource: matlab:autosarlibfim
source: toolbox_kb
managed_by: satk
library: AUTOSAR Blockset
kb_folder: autosar-blockset
category: function-inhibition
block_count: 2
generated: { by: satk-toolbox-build/1, at: "2026-11-23T18:23:12Z" }
---

# Function inhibition

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Control Function Available Caller | autosarlibfim/Control Function Available Caller | R2023a+ | Check whether a control function is currently permitted by the FIM — use before executing safety-relevant actuator commands to respect inhibition conditions |
| Function Inhibition Caller | autosarlibfim/Function Inhibition Caller | R2023a+ | Request inhibition or release of a function through the FIM — use to disable degraded features when prerequisite diagnostic events indicate a fault |

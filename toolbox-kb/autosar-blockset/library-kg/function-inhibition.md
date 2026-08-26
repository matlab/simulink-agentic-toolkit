---
type: Simulink Block Category
title: Function inhibition
description: Function Inhibition Manager (FIM) for controlled degradation and safety interlocks
tags: [inhibition, fim, control, available, permission]
status: stable
source: mathworks_toolbox
library_root: AUTOSAR Blockset
category_path: Function inhibition
block_count: 2
---

# Function inhibition

Use these blocks for function inhibition.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Control Function Available Caller | autosarlibfim/Control Function Available Caller | R2023a+ | Check whether a control function is currently permitted by the FIM — use before executing safety-relevant actuator commands to respect inhibition conditions |
| Function Inhibition Caller | autosarlibfim/Function Inhibition Caller | R2023a+ | Request inhibition or release of a function through the FIM — use to disable degraded features when prerequisite diagnostic events indicate a fault |

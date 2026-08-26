---
type: Simulink Block Category
title: Stateflow
description: Stateflow charts and embedded Simulink functions
tags: [chart, stateflow, state, machine, flow]
status: stable
source: mathworks_toolbox
library_root: DO-178C/DO-331 Primitive Library
category_path: Stateflow
block_count: 2
---

# Stateflow

Use these blocks for stateflow.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Chart | do178Lib/Stateflow/Chart | R2023b+ | Implement state machine or flow chart logic using Stateflow — use for mode management, sequential logic, or complex decision trees requiring DO-178C structural coverage |
| Simulink Function in Chart | do178Lib/Stateflow/Simulink Function in Chart | R2023b+ | Embed a Simulink subsystem as a callable function inside a Stateflow chart — use to reuse Simulink algorithms from within state machine actions |

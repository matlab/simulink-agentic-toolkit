---
type: Simulink Block Category
title: Stateflow
description: State-machine and flow-chart logic
tags: [stateflow, chart, simulink function]
status: stable
source: custom_library
library_root: DO-178C/DO-331 Primitive Library
category_path: Stateflow
block_count: 2
---

# Stateflow

Use these blocks for stateflow.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Chart | do178Lib/Stateflow/Chart | R2023b+ | Model event-driven state-machine and flow-chart logic — use for modal, supervisory, or sequential control logic. |
| Simulink Function in Chart | do178Lib/Stateflow/Simulink Function in Chart | R2023b+ | Define a Simulink Function callable from Stateflow — use to invoke Simulink subsystem logic from chart actions. |

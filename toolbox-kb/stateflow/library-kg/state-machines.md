---
type: Simulink Block Category
title: State machines
description: Hierarchical and parallel finite state machines for event-driven and supervisory logic (2 blocks)
tags: [toolbox-kb, stateflow, state, chart, transition, mode, finite state]
status: stable
sources:
  - resource: matlab:sflib
source: toolbox_kb
managed_by: satk
library: Stateflow
kb_folder: stateflow
category: state-machines
block_count: 2
generated: { by: satk-toolbox-build/1, at: "2026-11-23T18:23:36Z" }
---

# State machines

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Chart | sflib/Chart | R2023a+ | Model event-driven, reactive behavior as a hierarchical, parallel state machine with states, transitions, and flow logic — use for mode logic, supervisory/mission control, fault handling, and any system whose behavior depends on discrete modes and history. |
| State Transition Table | sflib/State Transition Table | R2023a+ | Define a finite state machine in tabular form (states as rows, transitions as columns) instead of a graphical chart — use when the state/transition structure is regular and easier to review, diff, and maintain as a table. |

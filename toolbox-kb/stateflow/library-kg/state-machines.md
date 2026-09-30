---
type: Simulink Block Category
title: State machines
description: Hierarchical and parallel finite state machines for event-driven and supervisory logic
tags: [state, chart, transition, mode, finite state]
status: stable
source: custom_library
library_root: Stateflow
category_path: State machines
block_count: 2
---

# State machines

Use these blocks for state machines.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Chart | sflib/Chart | R2023a+ | Model event-driven, reactive behavior as a hierarchical, parallel state machine with states, transitions, and flow logic — use for mode logic, supervisory/mission control, fault handling, and any system whose behavior depends on discrete modes and history. |
| State Transition Table | sflib/State Transition Table | R2023a+ | Define a finite state machine in tabular form (states as rows, transitions as columns) instead of a graphical chart — use when the state/transition structure is regular and easier to review, diff, and maintain as a table. |

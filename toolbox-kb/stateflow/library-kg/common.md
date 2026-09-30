---
type: Block Selection Guide
title: Common Blocks
description: High-value blocks selected for quick agent discovery.
status: stable
source: custom_library
block_count: 4
---

# Common Blocks

Prefer these blocks when their intent matches the user request.

| Intent | Preferred Block | Library |
|---|---|---|
| Model event-driven, reactive behavior as a hierarchical, parallel state machine with states, transitions, and flow logic — use for mode logic, supervisory/mission control, fault handling, and any system whose behavior depends on discrete modes and history. | Chart | Stateflow |
| Define a finite state machine in tabular form (states as rows, transitions as columns) instead of a graphical chart — use when the state/transition structure is regular and easier to review, diff, and maintain as a table. | State Transition Table | Stateflow |
| Specify combinational decision logic as condition/action rows mapping input combinations to outputs — use for rule-based arbitration and requirements-style boolean tables that are clearer than nested if/else logic. | Truth Table | Stateflow |
| Visualize message, event, and function-call interactions between Stateflow charts and model components over simulation time — use to debug interaction ordering and message passing in event-driven designs. | Sequence Viewer | Stateflow |

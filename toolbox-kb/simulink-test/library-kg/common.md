---
type: Block Selection Guide
title: Common Blocks
description: High-value blocks selected for quick agent discovery.
status: stable
source: custom_library
block_count: 5
---

# Common Blocks

Prefer these blocks when their intent matches the user request.

| Intent | Preferred Block | Library |
|---|---|---|
| Reference a separate observer model to monitor and verify signals inside a system under test without editing the design — use when you want verification logic kept isolated from the model under test and reusable across harnesses. | Observer | Simulink Test |
| Tap a signal from the system under test by its path and bring it into an observer for assessment — use inside an observer to pick exactly which internal signals to watch without adding ports to the design model. | ObserverPort | Simulink Test |
| Visualize the order and timing of messages, events, function calls, and state transitions exchanged during simulation — use to debug interaction and sequencing behavior in message-based, Stateflow, or test-sequence models. | Sequence Viewer | Simulink Test |
| The core S-Function engine inside the Test Sequence and Test Assessment blocks that executes the authored step-and-transition table to drive time- and state-based test stimulus and evaluate verify/assessment statements — use it by adding a Test Sequence or Test Assessment block, not this element directly. |  SFunction  | Simulink Test |
| The core S-Function engine inside the Test Sequence and Test Assessment blocks that executes the authored step-and-transition table to drive time- and state-based test stimulus and evaluate verify/assessment statements — use it by adding a Test Sequence or Test Assessment block, not this element directly. |  SFunction  | Simulink Test |

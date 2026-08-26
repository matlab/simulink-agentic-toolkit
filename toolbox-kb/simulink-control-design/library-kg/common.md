---
type: Block Selection Guide
title: Common Blocks
description: High-value blocks selected for quick agent discovery.
status: stable
source: mathworks_toolbox
block_count: 6
---

# Common Blocks

Prefer these blocks when their intent matches the user request.

| Intent | Preferred Block | Library |
|---|---|---|
| Tune PID gains online without opening the loop — use for safe in-service PID tuning with minimal process disruption | Closed-Loop PID Autotuner | Simulink Control Design |
| Tune PID gains using an open-loop experiment — use for accurate frequency-response-based PID tuning when the loop can be opened | Open-Loop PID Autotuner | Simulink Control Design |
| Interpolate PID gains across operating conditions — use for implementing gain-scheduled PID controllers from stored gain tables | PID Gain Scheduler | Simulink Control Design |
| Modify control actions to satisfy state constraints — use for keeping the system within safe operating bounds | Constraint Enforcement | Simulink Control Design |
| Enforce safety constraints using barrier certificates — use for guaranteeing set invariance in safety-critical systems | Control Barrier Function | Simulink Control Design |
| Estimate frequency response during simulation — use for online Bode measurement of a running system | Frequency Response Estimator | Simulink Control Design |

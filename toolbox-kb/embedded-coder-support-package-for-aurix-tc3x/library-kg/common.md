---
type: Block Selection Guide
title: Common Blocks
description: High-value blocks selected for quick agent discovery.
status: stable
source: mathworks_toolbox
block_count: 5
---

# Common Blocks

Prefer these blocks when their intent matches the user request.

| Intent | Preferred Block | Library |
|---|---|---|
| Configure multi-core task scheduling on the AURIX TC3x — use to assign Simulink subsystems to specific cores and manage execution priority | Task Manager | Embedded Coder Support Package for AURIX TC3x |
| Read shared data from another AURIX TC3x core — use for inter-core communication in multicore automotive ECU deployments | Interprocess Data Read | Embedded Coder Support Package for AURIX TC3x |
| Write shared data visible to other AURIX TC3x cores — use for inter-core data exchange in multicore deployments | Interprocess Data Write | Embedded Coder Support Package for AURIX TC3x |
| Simulate the ADC peripheral behavior for test bench testing — use in SIL/PIL to provide analog input stimulus without hardware | ADC Interface | Embedded Coder Support Package for AURIX TC3x |
| Simulate PWM peripheral behavior for test bench testing — use in SIL/PIL to capture PWM duty cycle outputs without hardware | PWM Interface | Embedded Coder Support Package for AURIX TC3x |

---
type: Block Selection Guide
title: Common Blocks
description: High-value blocks selected for quick agent discovery.
status: stable
source: custom_library
block_count: 13
---

# Common Blocks

Prefer these blocks when their intent matches the user request.

| Intent | Preferred Block | Library |
|---|---|---|
| Define and schedule the tasks (rates, cores, priorities) that generated code runs on the AURIX TC4x multicore target — use to map model rates to OS tasks for deployment. | Task Manager | Embedded Coder Support Package for AURIX TC4x |
| Read data shared between processes or cores on the AURIX TC4x — use to consume values produced by another task or core in a multicore design. | Interprocess Data Read | Embedded Coder Support Package for AURIX TC4x |
| Write data to be shared between processes or cores on the AURIX TC4x — use to publish values for another task or core in a multicore design. | Interprocess Data Write | Embedded Coder Support Package for AURIX TC4x |
| Test-bench stand-in for the target ADC — use in a SIL/PIL harness to inject analog readings without the physical peripheral. | ADC Interface | Embedded Coder Support Package for AURIX TC4x |
| Test-bench stand-in for target digital I/O — use in a harness to drive and observe digital pins without hardware. | Digital IO Interface | Embedded Coder Support Package for AURIX TC4x |
| Test-bench block that generates trigger events — use to stimulate event-driven tasks in a harness. | Event Source | Embedded Coder Support Package for AURIX TC4x |
| Test-bench model of an interprocess data channel — use to wire Interprocess Data Read/Write pairs together in a harness. | Interprocess Data Channel | Embedded Coder Support Package for AURIX TC4x |
| Test-bench stand-in for the target PWM peripheral — use in a harness to observe PWM commands without hardware. | PWM Interface | Embedded Coder Support Package for AURIX TC4x |
| Aurix Utilities Blocks | AURIX TC46x | Embedded Coder Support Package for AURIX TC4x |
| Aurix Utilities Blocks | AURIX TC48x | Embedded Coder Support Package for AURIX TC4x |
| Aurix Utilities Blocks | AURIX TC49x | Embedded Coder Support Package for AURIX TC4x |
| Aurix Utilities Blocks | AURIX TC49xN | Embedded Coder Support Package for AURIX TC4x |
| Aurix Utilities Blocks | AURIX TC4Dx | Embedded Coder Support Package for AURIX TC4x |

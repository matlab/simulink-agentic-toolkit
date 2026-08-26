---
type: Simulink Block Category
title: Data logging
description: File logging and execution profiling on the real-time target
tags: [log, file, profiler, trace, record]
status: stable
source: mathworks_toolbox
library_root: Simulink Real-Time
category_path: Data logging
block_count: 4
---

# Data logging

Use these blocks for data logging.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| File Log | slrealtimeloglib/File Log | R2024a+ | Log signal data to a file on the real-time target for post-run analysis |
| Enable File Log | slrealtimeloglib/Enable File Log | R2024a+ | Programmatically start or stop file logging on the real-time target during execution |
| Enable Profiler | slrealtimeproflib/Enable Profiler | R2024a+ | Start or stop execution profiling on the real-time target for timing analysis |
| Log Event | slrealtimeproflib/Log Event | R2024a+ | Insert a named event marker in the profiling trace for timing instrumentation |

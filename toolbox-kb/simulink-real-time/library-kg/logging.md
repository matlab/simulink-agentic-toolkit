---
type: Simulink Block Category
title: Logging
description: Blocks for Logging (2 blocks)
tags: [toolbox-kb, simulink-real-time]
status: draft
sources:
  - resource: matlab:slrealtimeloglib
source: toolbox_kb
managed_by: satk
library: Simulink Real-Time
kb_folder: simulink-real-time
category: logging
block_count: 2
generated: { by: satk-toolbox-build/1, at: "2026-11-23T18:23:32Z" }
---

# Logging

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Enable File Log | slrealtimeloglib/Enable File Log | R2024a+ | Enable or disable the file logging service. When the input port value is true, the block enables the file logging service on the target computer, and the File Log blocks record data. When the input port value is false, the block disables file logging on the target computer, and the File Log blocks do not record data. |
| File Log | slrealtimeloglib/File Log | R2024a+ | Log signal to file on the target computer. While the logging service is enabled, the block logs the input signal to the target computer file system. The logging service is enabled by default for a model containing this block. After the simulation run ends, the target computer uploads the File Log data to the Simulation Data Inspector on the development computer. If the target computer is not connected to the development computer, you can upload the file log data when the computers are connected. |

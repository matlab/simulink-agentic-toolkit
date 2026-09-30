---
type: Simulink Block Category
title: Logging
description: Blocks for logging.
status: draft
source: custom_library
library_root: Simulink Real-Time
category_path: Logging
block_count: 2
---

# Logging

Use these blocks for logging.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Enable File Log | slrealtimeloglib/Enable File Log | R2024a+ | Enable or disable the file logging service. When the input port value is true, the block enables the file logging service on the target computer, and the File Log blocks record data. When the input port value is false, the block disables file logging on the target computer, and the File Log blocks do not record data. |
| File Log | slrealtimeloglib/File Log | R2024a+ | Log signal to file on the target computer. While the logging service is enabled, the block logs the input signal to the target computer file system. The logging service is enabled by default for a model containing this block. After the simulation run ends, the target computer uploads the File Log data to the Simulation Data Inspector on the development computer. If the target computer is not connected to the development computer, you can upload the file log data when the computers are connected. |

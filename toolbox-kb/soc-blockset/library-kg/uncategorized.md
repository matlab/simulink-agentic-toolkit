---
type: Simulink Block Category
title: Uncategorized
description: Blocks for uncategorized.
status: draft
source: mathworks_toolbox
library_root: SoC Blockset
category_path: Uncategorized
block_count: 40
---

# Uncategorized

Use these blocks for uncategorized.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| MATLAB Function | socmemlib/AXI4 Random Access Memory/SimVariant/Accurate/log/MATLAB Function | R2023a+ | Execute custom MATLAB code within a Simulink model for algorithmic computation |
| MATLAB Function | socmemlib/AXI4 Video Frame Buffer/SimVariant/Accurate/log/MATLAB Function | R2023a+ | Execute custom MATLAB code within a Simulink model for algorithmic computation |
| MATLAB Function | socmemlib/AXI4-Stream to Software/SimVariant/Accurate/log/MATLAB Function | R2023a+ | Execute custom MATLAB code within a Simulink model for algorithmic computation |
| MATLAB Function | socmemlib/Software to AXI4-Stream/SimVariant/Accurate/log/MATLAB Function | R2023a+ | Execute custom MATLAB code within a Simulink model for algorithmic computation |
| ddlogger | socmemlib/AXI4 Random Access Memory/SimVariant/Accurate/log/ddlogger | R2023a+ | Trigger port for data dictionary logging subsystem |
| Constant | socmemlib/AXI4 Random Access Memory/SimVariant/Accurate/log/Constant | R2023a+ | Output a constant value signal |
| Constant1 | socmemlib/AXI4 Random Access Memory/SimVariant/Accurate/log/Constant1 | R2023a+ | Output a constant value signal |
| mid | socmemlib/AXI4 Random Access Memory/SimVariant/Accurate/log/mid | R2023a+ | Input argument for memory identifier in logging functions |
| info | socmemlib/AXI4 Random Access Memory/SimVariant/Accurate/log/info | R2023a+ | Input argument for additional information in logging functions |
| ddlogger | socmemlib/AXI4 Video Frame Buffer/SimVariant/Accurate/log/ddlogger | R2023a+ | Trigger port for data dictionary logging subsystem |
| Constant | socmemlib/AXI4 Video Frame Buffer/SimVariant/Accurate/log/Constant | R2023a+ | Output a constant value signal |
| Constant1 | socmemlib/AXI4 Video Frame Buffer/SimVariant/Accurate/log/Constant1 | R2023a+ | Output a constant value signal |
| mid | socmemlib/AXI4 Video Frame Buffer/SimVariant/Accurate/log/mid | R2023a+ | Input argument for memory identifier in logging functions |
| info | socmemlib/AXI4 Video Frame Buffer/SimVariant/Accurate/log/info | R2023a+ | Input argument for additional information in logging functions |
| ddlogger | socmemlib/AXI4-Stream to Software/SimVariant/Accurate/log/ddlogger | R2023a+ | Trigger port for data dictionary logging subsystem |
| Constant | socmemlib/AXI4-Stream to Software/SimVariant/Accurate/log/Constant | R2023a+ | Output a constant value signal |
| Constant1 | socmemlib/AXI4-Stream to Software/SimVariant/Accurate/log/Constant1 | R2023a+ | Output a constant value signal |
| mid | socmemlib/AXI4-Stream to Software/SimVariant/Accurate/log/mid | R2023a+ | Input argument for memory identifier in logging functions |
| info | socmemlib/AXI4-Stream to Software/SimVariant/Accurate/log/info | R2023a+ | Input argument for additional information in logging functions |
| ddlogger | socmemlib/Software to AXI4-Stream/SimVariant/Accurate/log/ddlogger | R2023a+ | Trigger port for data dictionary logging subsystem |
| Constant | socmemlib/Software to AXI4-Stream/SimVariant/Accurate/log/Constant | R2023a+ | Output a constant value signal |
| Constant1 | socmemlib/Software to AXI4-Stream/SimVariant/Accurate/log/Constant1 | R2023a+ | Output a constant value signal |
| mid | socmemlib/Software to AXI4-Stream/SimVariant/Accurate/log/mid | R2023a+ | Input argument for memory identifier in logging functions |
| info | socmemlib/Software to AXI4-Stream/SimVariant/Accurate/log/info | R2023a+ | Input argument for additional information in logging functions |
| Logger | proctasklib/Task Manager/Core Task Manager/Variant Subsystem/HSBON/Task Manager/Task Manager/Logger | R2023a+ | Log simulation events for debugging and performance analysis |
| ToFcns | proctasklib/Task Manager/Core Task Manager/Variant Subsystem/HSBON/Task Manager/Task Manager/ToFcns | R2023a+ | Route calls to Simulink function implementations within the task manager |
| MATLAB Function | proctasklib/Task Manager/Core Task Manager/Variant Subsystem/HSBON/Task Manager/Task Manager/ToFcns/Simulink Function1/MATLAB Function | R2023a+ | Execute custom MATLAB code within a Simulink model for algorithmic computation |
| MATLAB Function | proctasklib/Task Manager/Core Task Manager/Variant Subsystem/HSBON/Task Manager/Task Manager/ToFcns/Simulink Function2/MATLAB Function | R2023a+ | Execute custom MATLAB code within a Simulink model for algorithmic computation |
| Power ON | proctasklib/Task Manager/Core Task Manager/Variant Subsystem/HSBON/Task Manager/Task Manager/Power ON | R2023a+ | Generate the initial power-on event to start task manager execution |
| RTE | proctasklib/Task Manager/Core Task Manager/Variant Subsystem/HSBON/Task Manager/Task Manager/RTE | R2023a+ | Runtime environment discrete-event engine for task scheduling simulation |
| rteDispatchRunnable | proctasklib/Task Manager/Core Task Manager/Variant Subsystem/HSBON/Task Manager/Task Manager/ToFcns/Simulink Function1/rteDispatchRunnable | R2023a+ | Trigger port for dispatching runnable functions in the runtime environment |
| Assertion | proctasklib/Task Manager/Core Task Manager/Variant Subsystem/HSBON/Task Manager/Task Manager/ToFcns/Simulink Function1/Assertion | R2023a+ | Verify that a signal meets expected conditions during simulation |
| Terminator | proctasklib/Task Manager/Core Task Manager/Variant Subsystem/HSBON/Task Manager/Task Manager/ToFcns/Simulink Function1/Terminator | R2023a+ | Terminate an unconnected output port to avoid warnings |
| isWireless | proctasklib/Task Manager/Core Task Manager/Variant Subsystem/HSBON/Task Manager/Task Manager/ToFcns/Simulink Function1/isWireless | R2023a+ | Input argument indicating wireless communication mode |
| fcnIdx | proctasklib/Task Manager/Core Task Manager/Variant Subsystem/HSBON/Task Manager/Task Manager/ToFcns/Simulink Function1/fcnIdx | R2023a+ | Input argument specifying the function index to dispatch |
| rteDispatchRT | proctasklib/Task Manager/Core Task Manager/Variant Subsystem/HSBON/Task Manager/Task Manager/ToFcns/Simulink Function2/rteDispatchRT | R2023a+ | Trigger port for dispatching real-time tasks in the runtime environment |
| Assertion | proctasklib/Task Manager/Core Task Manager/Variant Subsystem/HSBON/Task Manager/Task Manager/ToFcns/Simulink Function2/Assertion | R2023a+ | Verify that a signal meets expected conditions during simulation |
| Terminator | proctasklib/Task Manager/Core Task Manager/Variant Subsystem/HSBON/Task Manager/Task Manager/ToFcns/Simulink Function2/Terminator | R2023a+ | Terminate an unconnected output port to avoid warnings |
| isWireless | proctasklib/Task Manager/Core Task Manager/Variant Subsystem/HSBON/Task Manager/Task Manager/ToFcns/Simulink Function2/isWireless | R2023a+ | Input argument indicating wireless communication mode |
| fcnIdx | proctasklib/Task Manager/Core Task Manager/Variant Subsystem/HSBON/Task Manager/Task Manager/ToFcns/Simulink Function2/fcnIdx | R2023a+ | Input argument specifying the function index to dispatch |

---
type: Simulink Block Category
title: Signal attributes and utilities
description: Data type conversion, signal routing, and model documentation utilities
tags: [data-type, conversion, routing, documentation, signal]
status: stable
source: mathworks_toolbox
library_root: HDL Coder
category_path: Signal attributes and utilities
block_count: 21
---

# Signal attributes and utilities

Use these blocks for signal attributes and utilities.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Signal Routing | hdlsllib/Signal Routing | R2023a+ |  |
| MATLAB Function | socmemlib/AXI4 Random Access Memory/SimVariant/Accurate/log/MATLAB Function | R2023a+ | Use when you need custom algorithmic logic written in MATLAB for HDL code generation |
| MATLAB Function | socmemlib/AXI4 Video Frame Buffer/SimVariant/Accurate/log/MATLAB Function | R2023a+ | Use when you need custom algorithmic logic written in MATLAB for HDL code generation |
| MATLAB Function | socmemlib/AXI4-Stream to Software/SimVariant/Accurate/log/MATLAB Function | R2023a+ | Use when you need custom algorithmic logic written in MATLAB for HDL code generation |
| MATLAB Function | socmemlib/Software to AXI4-Stream/SimVariant/Accurate/log/MATLAB Function | R2023a+ | Use when you need custom algorithmic logic written in MATLAB for HDL code generation |
| Constant | socmemlib/AXI4 Random Access Memory/SimVariant/Accurate/log/Constant | R2023a+ | Use when you need to provide a fixed constant value as a signal source |
| Constant | socmemlib/AXI4 Video Frame Buffer/SimVariant/Accurate/log/Constant | R2023a+ | Use when you need to provide a fixed constant value as a signal source |
| Constant | socmemlib/AXI4-Stream to Software/SimVariant/Accurate/log/Constant | R2023a+ | Use when you need to provide a fixed constant value as a signal source |
| Constant | socmemlib/Software to AXI4-Stream/SimVariant/Accurate/log/Constant | R2023a+ | Use when you need to provide a fixed constant value as a signal source |
| MATLAB Function | proctasklib/Task Manager/Core Task Manager/Variant Subsystem/HSBON/Task Manager/Task Manager/ToFcns/Simulink Function1/MATLAB Function | R2023a+ | Use when you need custom algorithmic logic written in MATLAB for HDL code generation |
| MATLAB Function | proctasklib/Task Manager/Core Task Manager/Variant Subsystem/HSBON/Task Manager/Task Manager/ToFcns/Simulink Function2/MATLAB Function | R2023a+ | Use when you need custom algorithmic logic written in MATLAB for HDL code generation |
| Terminator | proctasklib/Task Manager/Core Task Manager/Variant Subsystem/HSBON/Task Manager/Task Manager/ToFcns/Simulink Function1/Terminator | R2023a+ | Use when you need to properly terminate an unconnected output port to avoid warnings |
| Terminator | proctasklib/Task Manager/Core Task Manager/Variant Subsystem/HSBON/Task Manager/Task Manager/ToFcns/Simulink Function2/Terminator | R2023a+ | Use when you need to properly terminate an unconnected output port to avoid warnings |
| MATLAB Function | hdlsllib/User-Defined Functions/MATLAB Function | R2023a+ | Use when you need custom algorithmic logic written in MATLAB for HDL code generation |
| Data Type Conversion | hdlsllib/HDL Floating Point Operations/Data Type Conversion | R2023a+ | Use when you need to convert a signal between different numeric data types in HDL |
| Bus to Vector | hdlsllib/Signal Attributes/Bus to Vector | R2023a+ | Use when you need to convert a bus signal into a vector for HDL-compatible processing |
| Data Type Conversion | hdlsllib/Signal Attributes/Data Type Conversion | R2023a+ | Use when you need to convert a signal between different numeric data types in HDL |
| Rate Transition | hdlsllib/Signal Attributes/Rate Transition | R2023a+ | Use when you need to safely transfer data between subsystems running at different clock rates |
| Signal Conversion | hdlsllib/Signal Attributes/Signal Conversion | R2023a+ |  |
| Signal Specification | hdlsllib/Signal Attributes/Signal Specification | R2023a+ | Use when you need to explicitly specify the data type and dimensions of a signal |
| MATLAB System | hdlsllib/User-Defined Functions/MATLAB System | R2023a+ | Use when you need a System object with state and methods for HDL code generation |

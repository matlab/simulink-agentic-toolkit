---
type: Simulink Block Category
title: User defined functions
description: Blocks for embedding custom algorithms written in MATLAB, C, C++, or as S-functions
tags: [MATLAB function, S-function, C code, custom algorithm, Python]
status: stable
source: mathworks_toolbox
library_root: Simulink
category_path: User defined functions
block_count: 12
---

# User defined functions

Use these blocks for user defined functions.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Initialize Function | simulink/User-Defined Functions/Initialize Function | R2023a+ | Use when defining initialization logic that executes once at model startup |
| Simulink Function | simulink/User-Defined Functions/Simulink Function | R2023a+ | Use when defining a callable function within Simulink that can be invoked by Function Caller blocks |
| C Caller | simulink/User-Defined Functions/C Caller | R2023a+ | Use when calling an existing C function from Simulink to integrate legacy C code or external libraries |
| C Function | simulink/User-Defined Functions/C Function | R2023a+ | Use when embedding custom C code directly in a block for low-level algorithm implementation |
| Fcn | simulink/User-Defined Functions/Fcn | R2023a+ | Use when applying a simple mathematical expression to input u for lightweight custom computation |
| Function Caller | simulink/User-Defined Functions/Function Caller | R2023a+ | Use when invoking a Simulink Function defined elsewhere in the model for modular function reuse |
| Interpreted MATLAB Function | simulink/User-Defined Functions/Interpreted MATLAB Function | R2023a+ | Use when calling a MATLAB function during simulation for prototyping custom algorithms |
| Level-2 MATLAB S-Function | simulink/User-Defined Functions/Level-2 MATLAB S-Function | R2023a+ | Use when implementing an advanced custom block with multiple ports using the Level-2 S-function API |
| MATLAB Function | simulink/User-Defined Functions/MATLAB Function | R2023a+ | Use when writing custom algorithms in MATLAB language that support code generation and run within Simulink |
| MATLAB System | simulink/User-Defined Functions/MATLAB System | R2023a+ | Use when integrating a MATLAB System object into Simulink for streaming data processing with state management |
| S-Function | simulink/User-Defined Functions/S-Function | R2023a+ | Use when implementing a custom block using an S-function written in C, C++, or MATLAB for maximum flexibility |
| S-Function Builder | simulink/User-Defined Functions/S-Function Builder | R2023a+ | Use when generating S-function wrapper code from C/C++ source through a graphical interface |

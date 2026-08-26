---
type: Simulink Block Category
title: User defined functions
description: MATLAB Function, C Caller, and expression blocks
tags: [matlab, function, fcn, caller, expression]
status: stable
source: mathworks_toolbox
library_root: DO-178C/DO-331 Primitive Library
category_path: User defined functions
block_count: 4
---

# User defined functions

Use these blocks for user defined functions.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| MATLAB Function | do178Lib/Simulink/User-Defined Functions/MATLAB Function | R2023a+ | Write custom algorithms in MATLAB code with automatic C code generation — use for complex computations not easily expressed with standard blocks while maintaining DO-178C traceability |
| ASCII to String | do178Lib/Simulink/String/ASCII to String | R2023b+ | Convert ASCII integer codes to a string signal — use for constructing text messages, protocol payloads, or display strings from numeric data |
| C Caller | do178Lib/Simulink/User-Defined Functions/C Caller | R2023a+ | Call an external C function directly from the model — use to integrate legacy certified C code or hand-optimized routines into a Simulink model |
| Fcn | do178Lib/Simulink/User-Defined Functions/Fcn | R2023a+ | Evaluate a user-specified expression of the input — use for simple one-line mathematical expressions that do not warrant a full MATLAB Function block |

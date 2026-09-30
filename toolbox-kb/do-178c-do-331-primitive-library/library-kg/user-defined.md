---
type: Simulink Block Category
title: User defined
description: Custom C, MATLAB, and expression blocks
tags: [user-defined, c caller, fcn, matlab function]
status: stable
source: custom_library
library_root: DO-178C/DO-331 Primitive Library
category_path: User defined
block_count: 3
---

# User defined

Use these blocks for user defined.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| C Caller | do178Lib/Simulink/User-Defined Functions/C Caller | R2023a+ | Call external C code as a block — use to integrate legacy or custom C functions into the model. |
| Fcn | do178Lib/Simulink/User-Defined Functions/Fcn | R2023a+ | Evaluate a scalar expression of the inputs — use for simple inline arithmetic or logic expressions. |
| MATLAB Function | do178Lib/Simulink/User-Defined Functions/MATLAB Function | R2023a+ | Run authored MATLAB code as a block — use for custom algorithms not easily built from blocks. |

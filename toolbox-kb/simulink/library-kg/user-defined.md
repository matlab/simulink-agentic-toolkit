---
type: Simulink Block Category
title: User defined
description: "Custom MATLAB, C, Python, and S-function blocks (10 blocks)"
tags: [toolbox-kb, simulink, matlab function, c caller, s-function, python, custom]
status: stable
sources:
  - resource: matlab:simulink
source: toolbox_kb
managed_by: satk
library: Simulink
kb_folder: simulink
category: user-defined
block_count: 10
generated: { by: satk-toolbox-build/1, at: "2026-11-23T18:23:28Z" }
---

# User defined

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| C Caller | simulink/User-Defined Functions/C Caller | R2023a+ | Call external C code (functions) from the model — use to integrate existing C algorithms. |
| C Function | simulink/User-Defined Functions/C Function | R2023a+ | Author and call inline C code within a block — use for custom C logic in the model. |
| Fcn | simulink/User-Defined Functions/Fcn | R2023a+ | Evaluate a scalar arithmetic/logical expression of the input — use for simple inline math formulas. |
| Function Caller | simulink/User-Defined Functions/Function Caller | R2023a+ | Call a Simulink Function defined elsewhere — use to invoke shared function definitions. |
| Interpreted MATLAB Function | simulink/User-Defined Functions/Interpreted MATLAB Function | R2023a+ | Apply an interpreted MATLAB function to the input — use for quick MATLAB math (not for code generation). |
| Level-2 MATLAB S-Function | simulink/User-Defined Functions/Level-2 MATLAB S-Function | R2023a+ | Implement a custom block using a Level-2 MATLAB S-function API — use for advanced custom block behavior in MATLAB. |
| MATLAB Function | simulink/User-Defined Functions/MATLAB Function | R2023a+ | Run custom MATLAB code as a block — use for algorithms not easily built from blocks. |
| MATLAB System | simulink/User-Defined Functions/MATLAB System | R2023a+ | Deploy a System object as a block — use to reuse object-based algorithms in a model. |
| Python Code | simulink/User-Defined Functions/Python Code | R2025a+ | Run Python code within the model — use to integrate Python algorithms. |
| S-Function | simulink/User-Defined Functions/S-Function | R2023a+ | Incorporate a compiled C/C++ or MATLAB S-function as a block — use to add custom or legacy code to the model. |

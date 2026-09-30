---
type: Simulink Block Category
title: Custom code
description: Inject user C code at specific points of the generated code
tags: [custom code, model header, model source, system]
status: stable
source: custom_library
library_root: Simulink Coder
category_path: Custom code
block_count: 11
---

# Custom code

Use these blocks for custom code.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
|   | custcode/  | R2023a+ | Help block for the Custom Code library explaining how to inject user-written C code into generated code. |
| Model Header | custcode/Model Header | R2023a+ | Inject custom C code into the generated model header file (includes, external declarations) — use to make declarations visible to all generated code. |
| Model Source | custcode/Model Source | R2023a+ | Inject custom C code into the generated model source file (definitions, helper functions) — use to add supporting C definitions. |
| System Derivatives | custcode/System Derivatives | R2023a+ | Insert custom C code into the generated continuous-state derivative function — use to hook target code into derivative computation. |
| System Disable | custcode/System Disable | R2023a+ | Insert custom C code into the generated subsystem-disable function — runs when an enabled subsystem is disabled. |
| System Enable | custcode/System Enable | R2023a+ | Insert custom C code into the generated subsystem-enable function — runs when an enabled subsystem becomes active. |
| System Initialize | custcode/System Initialize | R2023a+ | Insert custom C code into the generated initialization function — runs once at model start. |
| System Outputs | custcode/System Outputs | R2023a+ | Insert custom C code into the generated output-computation function — runs every step to compute outputs. |
| System Start | custcode/System Start | R2023a+ | Insert custom C code into the generated start function — runs once when the model begins executing. |
| System Terminate | custcode/System Terminate | R2023a+ | Insert custom C code into the generated terminate function — runs once at shutdown for cleanup. |
| System Update | custcode/System Update | R2023a+ | Insert custom C code into the generated update function — runs every step to update discrete states. |

---
type: Block Selection Guide
title: Common Blocks
description: High-value blocks selected for quick agent discovery.
status: stable
source: custom_library
block_count: 11
---

# Common Blocks

Prefer these blocks when their intent matches the user request.

| Intent | Preferred Block | Library |
|---|---|---|
| Inject custom C code into the generated model header file (includes, external declarations) — use to make declarations visible to all generated code. | Model Header | Simulink Coder |
| Inject custom C code into the generated model source file (definitions, helper functions) — use to add supporting C definitions. | Model Source | Simulink Coder |
| Insert custom C code into the generated initialization function — runs once at model start. | System Initialize | Simulink Coder |
| Insert custom C code into the generated output-computation function — runs every step to compute outputs. | System Outputs | Simulink Coder |
| Build the model or subsystem as an S-function target — use to generate a compiled, reusable (and IP-protectable) S-function from the model. | S-Function Target | Simulink Coder |
| Sublibrary of blocks for modeling asynchronous (interrupt-driven) function-call execution in generated code — open to pick Async Interrupt or Task Sync blocks. | Asynchronous | Simulink Coder |
| Insert custom C code into the generated continuous-state derivative function — use to hook target code into derivative computation. | System Derivatives | Simulink Coder |
| Insert custom C code into the generated subsystem-disable function — runs when an enabled subsystem is disabled. | System Disable | Simulink Coder |
| Insert custom C code into the generated subsystem-enable function — runs when an enabled subsystem becomes active. | System Enable | Simulink Coder |
| Insert custom C code into the generated start function — runs once when the model begins executing. | System Start | Simulink Coder |
| Insert custom C code into the generated terminate function — runs once at shutdown for cleanup. | System Terminate | Simulink Coder |

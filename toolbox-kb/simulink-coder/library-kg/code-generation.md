---
type: Simulink Block Category
title: Code generation
description: Code generation configuration and customization blocks
tags: [code, generation, custom, sfun, async]
status: stable
source: mathworks_toolbox
library_root: Simulink Coder
category_path: Code generation
block_count: 3
---

# Code generation

Use these blocks for code generation.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Asynchronous | rtwlib/Asynchronous | R2023a+ | Configure asynchronous task execution for generated code — use when deploying code with interrupt-driven or event-triggered execution on real-time targets |
| Custom Code | rtwlib/Custom Code | R2023a+ | Insert custom C/C++ code into the generated code — use for integrating legacy code, hardware drivers, or platform-specific routines with Simulink Coder output |
| S-Function Target | rtwlib/S-Function Target | R2023a+ | Generate a standalone S-Function from a subsystem — use for creating reusable simulation components or protecting IP while sharing models |

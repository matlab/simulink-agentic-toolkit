---
type: Simulink Block Category
title: Configuration wizards
description: Code generation configuration wizards for different target types and optimization goals
tags: [ert, grt, configuration, wizard, codegen]
status: stable
source: mathworks_toolbox
library_root: Embedded Coder
category_path: Configuration wizards
block_count: 7
---

# Configuration wizards

Use these blocks for configuration wizards.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| ERT (optimized for fixed-point) | rtweclib/Configuration Wizards/ERT (optimized for fixed-point) | R2023a+ | Configuration wizard that sets model parameters for optimized Embedded Real-Time code generation targeting fixed-point processors — use to quickly configure a model for production-quality fixed-point C code |
| Blockset Name2 | embeddedtargetslib/Blockset Name2 | R2023a+ | Library identification label — internal library element, not used in application models |
| Blockset Name2 | embeddedtargetslib/Host Communication/Blockset Name2 | R2023a+ | Library identification label — internal library element, not used in application models |
| Custom MATLAB file | rtweclib/Configuration Wizards/Custom MATLAB file | R2023a+ | Configuration wizard using a custom MATLAB script to set model parameters — use when standard wizards do not match your target and you need full control over code generation settings |
| ERT (optimized for floating-point) | rtweclib/Configuration Wizards/ERT (optimized for floating-point) | R2023a+ | Configuration wizard that sets model parameters for optimized Embedded Real-Time code generation targeting floating-point processors — use to quickly configure a model for efficient floating-point embedded C code |
| GRT (debug for fixed/floating-point) | rtweclib/Configuration Wizards/GRT (debug for fixed/floating-point) | R2023a+ | Configuration wizard for Generic Real-Time target with debugging enabled — use during development when code traceability and debugging are more important than code size optimization |
| GRT (optimized for fixed/floating-point) | rtweclib/Configuration Wizards/GRT (optimized for fixed/floating-point) | R2023a+ | Configuration wizard for Generic Real-Time target with optimizations enabled — use for rapid prototyping on generic targets with reasonable code efficiency |

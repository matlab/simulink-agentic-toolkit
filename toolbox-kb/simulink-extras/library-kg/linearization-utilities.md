---
type: Simulink Block Category
title: Linearization utilities
description: Blocks for linearization and steady-state detection
tags: [linearization, derivative, transport, steady, fmu]
status: stable
source: mathworks_toolbox
library_root: Simulink Extras
category_path: Linearization utilities
block_count: 3
---

# Linearization utilities

Use these blocks for linearization utilities.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Switched derivative for linearization | simulink_extras/Linearization/Switched derivative for linearization | R2023a+ | Derivative block that switches behavior for linearization — use when standard derivative blocks cause issues during model linearization |
| FMU | simulink_extras/FMU Import/FMU | R2023a+ | Import a Functional Mock-up Unit into Simulink — use for co-simulating models from other tools via the FMI standard |
| Switched transport delay for linearization | simulink_extras/Linearization/Switched transport delay for linearization | R2023a+ | Transport delay that switches for linearization — use when standard transport delay causes issues during trim or linearization |

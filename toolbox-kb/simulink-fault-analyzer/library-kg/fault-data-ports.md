---
type: Simulink Block Category
title: Fault data ports
description: Ports that feed external data or parameters used to drive fault behavior
tags: [fault, data, parameter, inport, injection]
status: stable
source: custom_library
library_root: Simulink Fault Analyzer
category_path: Fault data ports
block_count: 1
---

# Fault data ports

Use these blocks for fault data ports.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Fault Data Inport | mwfaultblocklib/Fault Port Blocks/Fault Data Inport | R2024b+ | Brings external fault data or parameters into a fault subsystem. Use it when fault behavior must depend on recorded data, scenario values, or tunable parameters rather than only on the incoming signal, so the same fault model can be reparameterized across analyses. |

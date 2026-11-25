---
type: Simulink Block Category
title: Fault data ports
description: Ports that feed external data or parameters used to drive fault behavior (1 blocks)
tags: [toolbox-kb, simulink-fault-analyzer, fault, data, parameter, inport, injection]
status: stable
sources:
  - resource: matlab:mwfaultblocklib
source: toolbox_kb
managed_by: satk
library: Simulink Fault Analyzer
kb_folder: simulink-fault-analyzer
category: fault-data-ports
block_count: 1
generated: { by: satk-toolbox-build/1, at: "2026-11-23T18:23:36Z" }
---

# Fault data ports

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Fault Data Inport | mwfaultblocklib/Fault Port Blocks/Fault Data Inport | R2024b+ | Brings external fault data or parameters into a fault subsystem. Use it when fault behavior must depend on recorded data, scenario values, or tunable parameters rather than only on the incoming signal, so the same fault model can be reparameterized across analyses. |

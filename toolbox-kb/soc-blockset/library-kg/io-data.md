---
type: Simulink Block Category
title: Io data
description: I/O data injection and capture for testbench-driven SoC verification
tags: [event, IO, data, inject, capture, boundary]
status: stable
source: mathworks_toolbox
library_root: SoC Blockset
category_path: Io data
block_count: 8
---

# Io data

Use these blocks for io data.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| event | socmemlib/AXI4 Random Access Memory/SimVariant/Accurate/log/event | R2023a+ | Input argument for event type in logging functions |
| event | socmemlib/AXI4 Video Frame Buffer/SimVariant/Accurate/log/event | R2023a+ | Input argument for event type in logging functions |
| event | socmemlib/AXI4-Stream to Software/SimVariant/Accurate/log/event | R2023a+ | Input argument for event type in logging functions |
| event | socmemlib/Software to AXI4-Stream/SimVariant/Accurate/log/event | R2023a+ | Input argument for event type in logging functions |
| Event Source | prociodatalib/Event Source | R2023a+ | Generate timed events for driving testbench scenarios in SoC simulation |
| IO Data Sink | prociodatalib/IO Data Sink | R2023a+ | Capture I/O data at task boundaries for verification in SoC simulation |
| IO Data Source | prociodatalib/IO Data Source | R2023a+ | Inject I/O test data at task boundaries for stimulating SoC simulation |
| Testbench Task | prociodatalib/Testbench Task | R2023a+ | Define a testbench task that runs alongside the design tasks for verification |

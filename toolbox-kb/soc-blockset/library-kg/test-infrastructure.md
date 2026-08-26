---
type: Simulink Block Category
title: Test infrastructure
description: Testbench source and sink blocks for verifying hardware interfaces in simulation
tags: [test, sink, source, verify, testbench, stimulus]
status: stable
source: mathworks_toolbox
library_root: SoC Blockset
category_path: Test infrastructure
block_count: 6
---

# Test infrastructure

Use these blocks for test infrastructure.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| AXI4 Master Sink | hwlogictestlib/AXI4 Master Sink | R2023a+ | Verify AXI4 master write transactions by capturing and checking output data |
| AXI4 Master Source | hwlogictestlib/AXI4 Master Source | R2023a+ | Generate AXI4 master read/write transactions for testing memory-mapped interfaces |
| Stream Data Sink | hwlogictestlib/Stream Data Sink | R2023a+ | Capture and verify AXI4-Stream output data in simulation testbenches |
| Stream Data Source | hwlogictestlib/Stream Data Source | R2023a+ | Generate AXI4-Stream test input data for simulation testbenches |
| Video Test Sink | hwlogictestlib/Video Test Sink | R2023a+ | Capture and verify video stream output in simulation testbenches |
| Video Test Source | hwlogictestlib/Video Test Source | R2023a+ | Generate video stream test patterns for simulation testbenches |

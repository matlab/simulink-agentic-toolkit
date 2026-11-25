---
type: Simulink Block Category
title: Intel soc
description: Processor-FPGA communication and task management on Intel SoC (5 blocks)
tags: [toolbox-kb, embedded-coder-support-package-for-intel-soc-devices, intel, soc, axi4, linux, fpga]
status: stable
sources:
  - resource: matlab:alterasoclib
source: toolbox_kb
managed_by: satk
library: Embedded Coder Support Package for Intel SoC Devices
kb_folder: embedded-coder-support-package-for-intel-soc-devices
category: intel-soc
block_count: 5
generated: { by: satk-toolbox-build/1, at: "2026-11-23T18:23:21Z" }
---

# Intel soc

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| AXI4 Read | alterasoclib/AXI4 Read | R2023a+ | Read data from FPGA fabric via AXI4 interface on Intel SoC — use for processor-to-FPGA data transfer in Intel Cyclone/Arria SoC designs |
| AXI4 Write | alterasoclib/AXI4 Write | R2023a+ | Write data to FPGA fabric via AXI4 interface on Intel SoC — use for processor-to-FPGA command or data passing in Intel SoC designs |
| Linux Task | alterasoclib/Linux Task | R2023a+ | Configure a Linux task for execution on Intel SoC ARM core — use for scheduling generated code as a Linux process on the HPS |
| UDP Receive | alterasoclib/UDP Receive | R2023a+ | Receive UDP packets on Intel SoC Linux — use for network data input to algorithms running on Intel SoC embedded Linux |
| UDP Send | alterasoclib/UDP Send | R2023a+ | Send UDP packets from Intel SoC Linux — use for network data output from algorithms running on Intel SoC embedded Linux |

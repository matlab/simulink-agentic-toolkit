---
type: Simulink Block Category
title: Amd soc
description: AMD/Xilinx SoC blocks for ARM-FPGA partitioning and AXI communication
tags: [zynq, axi, fpga, soc, arm]
status: stable
source: mathworks_toolbox
library_root: Embedded Coder Support Package for AMD SoC Devices
category_path: Amd soc
block_count: 9
---

# Amd soc

Use these blocks for amd soc.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Linux Task | zynqlib/Linux Task | R2023a+ | Execute a subsystem as a Linux process task on the ARM core of an AMD/Xilinx SoC — use to partition algorithms that run on the processor side of a Zynq or Versal device |
| VxWorks Task | zynqlib/VxWorks Task | R2023a+ | Execute a subsystem as a VxWorks task on the processor core — use when the AMD SoC runs VxWorks RTOS instead of Linux |
| AXI4-Interface Read | zynqlib/AXI4-Interface Read | R2023a+ | Read data from the FPGA fabric via an AXI4 memory-mapped interface — use to receive processed results or status registers from HDL IP running on the programmable logic |
| AXI4-Interface Write | zynqlib/AXI4-Interface Write | R2023a+ | Write data to the FPGA fabric via an AXI4 memory-mapped interface — use to send parameters or commands from the processor to HDL IP running on the programmable logic |
| AXI4-Stream IIO Read | zynqlib/AXI4-Stream IIO Read | R2023a+ | Read streaming data from the FPGA fabric via AXI4-Stream with Linux IIO — use for high-throughput continuous data transfer from PL to PS such as ADC sample streams |
| AXI4-Stream IIO Write | zynqlib/AXI4-Stream IIO Write | R2023a+ | Write streaming data to the FPGA fabric via AXI4-Stream with Linux IIO — use for high-throughput continuous data transfer from PS to PL such as DAC output streams |
| Blockset Name2 | zynqlib/Blockset Name2 | R2023a+ | Library identification label — internal library element, not used in application models |
| UDP Receive | zynqlib/UDP Receive | R2023a+ | Receive UDP datagrams on the SoC processor — use for network communication with a host PC or other networked devices |
| UDP Send | zynqlib/UDP Send | R2023a+ | Send UDP datagrams from the SoC processor — use for telemetry or data transfer to a host PC over Ethernet |

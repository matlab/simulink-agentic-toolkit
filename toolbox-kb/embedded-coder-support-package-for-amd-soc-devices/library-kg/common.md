---
type: Block Selection Guide
title: Common Blocks
description: High-value blocks selected for quick agent discovery.
status: stable
source: mathworks_toolbox
block_count: 5
---

# Common Blocks

Prefer these blocks when their intent matches the user request.

| Intent | Preferred Block | Library |
|---|---|---|
| Execute a subsystem as a Linux process task on the ARM core of an AMD/Xilinx SoC — use to partition algorithms that run on the processor side of a Zynq or Versal device | Linux Task | Embedded Coder Support Package for AMD SoC Devices |
| Read data from the FPGA fabric via an AXI4 memory-mapped interface — use to receive processed results or status registers from HDL IP running on the programmable logic | AXI4-Interface Read | Embedded Coder Support Package for AMD SoC Devices |
| Write data to the FPGA fabric via an AXI4 memory-mapped interface — use to send parameters or commands from the processor to HDL IP running on the programmable logic | AXI4-Interface Write | Embedded Coder Support Package for AMD SoC Devices |
| Receive UDP datagrams on the SoC processor — use for network communication with a host PC or other networked devices | UDP Receive | Embedded Coder Support Package for AMD SoC Devices |
| Send UDP datagrams from the SoC processor — use for telemetry or data transfer to a host PC over Ethernet | UDP Send | Embedded Coder Support Package for AMD SoC Devices |

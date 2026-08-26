---
type: Simulink Block Category
title: Fpga connectivity
description: AXI4-Stream and bus connectivity between FPGA and processor domains
tags: [AXI4, stream, bus, FIFO, connector, video-stream]
status: stable
source: mathworks_toolbox
library_root: SoC Blockset
category_path: Fpga connectivity
block_count: 6
---

# Fpga connectivity

Use these blocks for fpga connectivity.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| SoC Bus Creator | hwlogicconnlib/SoC Bus Creator | R2023a+ | Bundle multiple signals into a single SoC bus for hardware-software interface modeling |
| SoC Bus Selector | hwlogicconnlib/SoC Bus Selector | R2023a+ | Extract individual signals from an SoC bus for downstream processing |
| Stream Connector | hwlogicconnlib/Stream Connector | R2023a+ | Connect AXI4-Stream interfaces between FPGA logic and processor subsystems |
| Stream FIFO | hwlogicconnlib/Stream FIFO | R2023a+ | Buffer streaming data between clock domains or processing stages on the SoC |
| Video Stream Connector | hwlogicconnlib/Video Stream Connector | R2023a+ | Connect video streaming interfaces between FPGA logic and processor subsystems |
| Video Stream FIFO | hwlogicconnlib/Video Stream FIFO | R2023a+ | Buffer video stream data between clock domains with frame-aware flow control |

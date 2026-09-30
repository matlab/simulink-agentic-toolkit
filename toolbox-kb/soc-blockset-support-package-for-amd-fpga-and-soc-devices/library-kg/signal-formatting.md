---
type: Simulink Block Category
title: Signal formatting
description: Interleave/deinterleave stream formatting
tags: [interleave, deinterleave]
status: stable
source: custom_library
library_root: SoC Blockset Support Package for AMD FPGA and SoC Devices
category_path: Signal formatting
block_count: 12
---

# Signal formatting

Use these blocks for signal formatting.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Deinterleave | mpsoczcu102lib/Deinterleave | R2023a+ | Split an interleaved sample stream back into separate channels — use to separate I/Q or multi-channel data on the FPGA. |
| Interleave | mpsoczcu102lib/Interleave | R2023a+ | Combine separate channels into a single interleaved sample stream — use to pack I/Q or multi-channel data for transport. |
| Deinterleave | mpsoczcu106lib/Deinterleave | R2023a+ | Split an interleaved sample stream back into separate channels — use to separate I/Q or multi-channel data on the FPGA. |
| Interleave | mpsoczcu106lib/Interleave | R2023a+ | Combine separate channels into a single interleaved sample stream — use to pack I/Q or multi-channel data for transport. |
| Deinterleave | zynq7000picozedlib/Deinterleave | R2023a+ | Split an interleaved sample stream back into separate channels — use to separate I/Q or multi-channel data on the FPGA. |
| Interleave | zynq7000picozedlib/Interleave | R2023a+ | Combine separate channels into a single interleaved sample stream — use to pack I/Q or multi-channel data for transport. |
| Deinterleave | zynq7000zc702lib/Deinterleave | R2023a+ | Split an interleaved sample stream back into separate channels — use to separate I/Q or multi-channel data on the FPGA. |
| Interleave | zynq7000zc702lib/Interleave | R2023a+ | Combine separate channels into a single interleaved sample stream — use to pack I/Q or multi-channel data for transport. |
| Deinterleave | zynq7000zc706lib/Deinterleave | R2023a+ | Split an interleaved sample stream back into separate channels — use to separate I/Q or multi-channel data on the FPGA. |
| Interleave | zynq7000zc706lib/Interleave | R2023a+ | Combine separate channels into a single interleaved sample stream — use to pack I/Q or multi-channel data for transport. |
| Deinterleave | zynq7000zedboardlib/Deinterleave | R2023a+ | Split an interleaved sample stream back into separate channels — use to separate I/Q or multi-channel data on the FPGA. |
| Interleave | zynq7000zedboardlib/Interleave | R2023a+ | Combine separate channels into a single interleaved sample stream — use to pack I/Q or multi-channel data for transport. |

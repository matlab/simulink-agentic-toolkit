---
type: Simulink Block Category
title: Signal formatting
description: Interleave/deinterleave stream formatting (12 blocks)
tags: [toolbox-kb, soc-blockset-support-package-for-amd-fpga-and-soc-devices, interleave, deinterleave]
status: stable
sources:
  - resource: matlab:mpsoczcu102lib
source: toolbox_kb
managed_by: satk
library: SoC Blockset Support Package for AMD FPGA and SoC Devices
kb_folder: soc-blockset-support-package-for-amd-fpga-and-soc-devices
category: signal-formatting
block_count: 12
generated: { by: satk-toolbox-build/1, at: "2026-11-23T18:23:36Z" }
---

# Signal formatting

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

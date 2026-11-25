---
type: Simulink Block Category
title: Instrument io
description: Direct instrument query and command via SCPI/VISA (3 blocks)
tags: [toolbox-kb, instrument-control-toolbox, visa, gpib, scpi, instrument, query]
status: stable
sources:
  - resource: matlab:instrumentlib
source: toolbox_kb
managed_by: satk
library: Instrument Control Toolbox
kb_folder: instrument-control-toolbox
category: instrument-io
block_count: 3
generated: { by: satk-toolbox-build/1, at: "2026-11-23T18:23:23Z" }
---

# Instrument io

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Query Instrument | instrumentlib/Query Instrument | R2023a+ | Send a command and read the response from a SCPI/GPIB instrument — use for interactive measurement acquisition from test equipment |
| To Instrument | instrumentlib/To Instrument | R2023a+ | Send a command string to an instrument without reading a response — use for one-way configuration commands to SCPI/GPIB instruments |
| VISA | instrumentlib/VISA | R2023b+ | Communicate with instruments via the VISA standard — use for vendor-neutral access to GPIB, USB, TCP/IP, or serial instruments |

---
type: Simulink Block Category
title: Instrument io
description: Direct instrument query and command via SCPI/VISA
tags: [visa, gpib, scpi, instrument, query]
status: stable
source: mathworks_toolbox
library_root: Instrument Control Toolbox
category_path: Instrument io
block_count: 3
---

# Instrument io

Use these blocks for instrument io.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Query Instrument | instrumentlib/Query Instrument | R2023a+ | Send a command and read the response from a SCPI/GPIB instrument — use for interactive measurement acquisition from test equipment |
| To Instrument | instrumentlib/To Instrument | R2023a+ | Send a command string to an instrument without reading a response — use for one-way configuration commands to SCPI/GPIB instruments |
| VISA | instrumentlib/VISA | R2023b+ | Communicate with instruments via the VISA standard — use for vendor-neutral access to GPIB, USB, TCP/IP, or serial instruments |

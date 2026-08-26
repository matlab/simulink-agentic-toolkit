---
type: Simulink Block Category
title: Data packing
description: Byte-level data packing, unpacking, and protocol encoding/decoding for communication payloads
tags: [byte, pack, protocol, encode, decode]
status: stable
source: mathworks_toolbox
library_root: C2000 Microcontroller Blockset
category_path: Data packing
block_count: 4
---

# Data packing

Use these blocks for data packing.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Byte Pack | c2000lib/Target Communication/Byte Pack | R2023a+ | Pack multiple signals into a byte array with specified byte order and alignment — use to construct communication payloads for serial, CAN, or network protocols |
| Byte Unpack | c2000lib/Target Communication/Byte Unpack | R2023a+ | Extract signals from a byte array based on specified offsets and data types — use to parse received communication payloads into individual signal values |
| Protocol Decoder | c2000lib/Target Communication/Protocol Decoder | R2023a+ | Decode structured protocol data from a serial byte stream — use to parse custom or standard communication protocols into meaningful signal fields |
| Protocol Encoder | c2000lib/Target Communication/Protocol Encoder | R2023a+ | Encode structured data into a protocol-formatted byte stream — use to construct custom or standard communication protocol frames for serial transmission |

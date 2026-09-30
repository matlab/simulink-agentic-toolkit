---
type: Simulink Block Category
title: Data packing
description: Byte and protocol frame packing/unpacking
tags: [byte, pack, unpack, protocol, encode, decode]
status: stable
source: custom_library
library_root: C2000 Microcontroller Blockset
category_path: Data packing
block_count: 4
---

# Data packing

Use these blocks for data packing.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Byte Pack | c2000lib/Target Communication/Byte Pack | R2023a+ | Pack multiple signals into a single byte vector — use to assemble a message payload for transmission. |
| Byte Unpack | c2000lib/Target Communication/Byte Unpack | R2023a+ | Unpack a byte vector into individual signals — use to parse a received message payload. |
| Protocol Decoder | c2000lib/Target Communication/Protocol Decoder | R2023a+ | Decode a framed communication protocol into signals — use to parse structured serial or network messages. |
| Protocol Encoder | c2000lib/Target Communication/Protocol Encoder | R2023a+ | Encode signals into a framed communication protocol — use to build structured serial or network messages. |

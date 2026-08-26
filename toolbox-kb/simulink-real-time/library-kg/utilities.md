---
type: Simulink Block Category
title: Utilities
description: Byte and bit manipulation utilities for custom protocol framing
tags: [byte, bit, pack, endian, protocol]
status: stable
source: mathworks_toolbox
library_root: Simulink Real-Time
category_path: Utilities
block_count: 7
---

# Utilities

Use these blocks for utilities.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Bit Packing | slrealtimeutilitieslib/Bit Packing | R2024a+ | Pack individual bit fields into a larger integer word for protocol encoding |
| Bit Unpacking | slrealtimeutilitieslib/Bit Unpacking | R2024a+ | Extract individual bit fields from a packed integer word for protocol decoding |
| Byte Packing | slrealtimeutilitieslib/Byte Packing | R2024a+ | Pack typed signals into a raw byte vector for custom protocol framing |
| Byte Reversal | slrealtimeutilitieslib/Byte Reversal | R2024a+ | Reverse byte order of multi-byte data for endianness conversion |
| Byte Unpacking | slrealtimeutilitieslib/Byte Unpacking | R2024a+ | Unpack typed signals from a raw byte vector for custom protocol parsing |
| Protocol Decoder | slrealtimeutilitieslib/Protocol Decoder | R2024a+ | Decode structured data from a byte stream according to a protocol definition |
| Protocol Encoder | slrealtimeutilitieslib/Protocol Encoder | R2024a+ | Encode structured data into a byte stream according to a protocol definition |

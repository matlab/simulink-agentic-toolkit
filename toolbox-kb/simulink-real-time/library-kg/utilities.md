---
type: Simulink Block Category
title: Utilities
description: Data-format and helper blocks
tags: [utilities, byte reversal, endian]
status: stable
source: custom_library
library_root: Simulink Real-Time
category_path: Utilities
block_count: 6
---

# Utilities

Use these blocks for utilities.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Change endianess | slrealtimesharedmemorylib/Change endianess | R2024a+ | Machine word length: |
| Bit Packing | slrealtimeutilitieslib/Bit Packing | R2024a+ | Bit-Packing |
| Bit Unpacking | slrealtimeutilitieslib/Bit Unpacking | R2024a+ | Bit-Unpacking |
| Byte Reversal | slrealtimeutilitieslib/Byte Reversal | R2024a+ | Reverse the byte order (endianness) of a signal — use to match big/little-endian conventions across communication interfaces. |
| Protocol Decoder | slrealtimeutilitieslib/Protocol Decoder | R2024a+ | Decode a uint8 byte stream by specifying the packet structure. The block outputs signals corresponding to specified packet fields, and also allows you to specify packet header and terminator values. IsNew is an additional output (boolean) to check if a new set of decoded fields are available. Select 'Specify logic for checksum validation' to obtain the IsValid output (boolean) to check if the packet is valid or not. |
| Protocol Encoder | slrealtimeutilitieslib/Protocol Encoder | R2024a+ | Encode input data into a uint8 byte stream by specifying the packet structure. The block outputs a byte stream whose size depends on the packet fields and packet header and terminator values. Select 'Specify logic to generate checksum for validation' to include checksum bytes in the output stream. |

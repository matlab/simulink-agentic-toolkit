---
type: Simulink Block Category
title: Utilities
description: Data-format and helper blocks (6 blocks)
tags: [toolbox-kb, simulink-real-time, utilities, byte reversal, endian]
status: draft
sources:
  - resource: matlab:slrealtimesharedmemorylib
source: toolbox_kb
managed_by: satk
library: Simulink Real-Time
kb_folder: simulink-real-time
category: utilities
block_count: 6
generated: { by: satk-toolbox-build/1, at: "2026-11-23T18:23:32Z" }
---

# Utilities

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Change endianess | slrealtimesharedmemorylib/Change endianess | R2024a+ | Machine word length: |
| Bit Packing | slrealtimeutilitieslib/Bit Packing | R2024a+ | Bit-Packing |
| Bit Unpacking | slrealtimeutilitieslib/Bit Unpacking | R2024a+ | Bit-Unpacking |
| Byte Reversal | slrealtimeutilitieslib/Byte Reversal | R2024a+ | Reverse the byte order (endianness) of a signal — use to match big/little-endian conventions across communication interfaces. |
| Protocol Decoder | slrealtimeutilitieslib/Protocol Decoder | R2024a+ | Decode a uint8 byte stream by specifying the packet structure. The block outputs signals corresponding to specified packet fields, and also allows you to specify packet header and terminator values. IsNew is an additional output (boolean) to check if a new set of decoded fields are available. Select 'Specify logic for checksum validation' to obtain the IsValid output (boolean) to check if the packet is valid or not. |
| Protocol Encoder | slrealtimeutilitieslib/Protocol Encoder | R2024a+ | Encode input data into a uint8 byte stream by specifying the packet structure. The block outputs a byte stream whose size depends on the packet fields and packet header and terminator values. Select 'Specify logic to generate checksum for validation' to include checksum bytes in the output stream. |

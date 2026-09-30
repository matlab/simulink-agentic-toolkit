---
type: Simulink Block Category
title: Error correction
description: HDL-optimized forward error correction and error detection
tags: [error detection and correction, rs, crc, convolutional encoder, viterbi]
status: stable
source: custom_library
library_root: Communications Toolbox HDL Support
category_path: Error correction
block_count: 6
---

# Error correction

Use these blocks for error correction.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Integer-Input RS Encoder HDL Optimized | commhdlblkcod/Integer-Input RS Encoder HDL Optimized | R2023a+ | HDL-optimized Reed-Solomon encoder taking integer symbols — use to add RS forward error correction in hardware. |
| Integer-Output RS Decoder HDL Optimized | commhdlblkcod/Integer-Output RS Decoder HDL Optimized | R2023a+ | HDL-optimized Reed-Solomon decoder producing integer symbols — use to correct symbol errors with RS FEC in hardware. |
| General CRC Generator HDL Optimized | commhdlcrc/General CRC Generator HDL Optimized | R2023a+ | HDL-optimized CRC generator that appends a checksum to a frame — use for hardware error detection at the transmitter. |
| General CRC Syndrome Detector HDL Optimized | commhdlcrc/General CRC Syndrome Detector HDL Optimized | R2023a+ | HDL-optimized CRC checker that flags frames failing the checksum — use for hardware error detection at the receiver. |
| Convolutional Encoder | commhdlcnvcod/Convolutional Encoder | R2023a+ | Encode a bit stream with a convolutional code — use ahead of a Viterbi decoder for forward error correction in hardware links. |
| Viterbi Decoder | commhdlcnvcod/Viterbi Decoder | R2023a+ | Decode a convolutionally-encoded stream with the Viterbi algorithm — use to correct errors in hardware receivers. |

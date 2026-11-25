---
type: Simulink Block Category
title: Error correction
description: HDL-optimized forward error correction and error detection (6 blocks)
tags: [toolbox-kb, communications-toolbox-hdl-support, error detection and correction, rs, crc, convolutional encoder, viterbi]
status: stable
sources:
  - resource: matlab:commhdlblkcod
source: toolbox_kb
managed_by: satk
library: Communications Toolbox HDL Support
kb_folder: communications-toolbox-hdl-support
category: error-correction
block_count: 6
generated: { by: satk-toolbox-build/1, at: "2026-11-23T18:23:16Z" }
---

# Error correction

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Integer-Input RS Encoder HDL Optimized | commhdlblkcod/Integer-Input RS Encoder HDL Optimized | R2023a+ | HDL-optimized Reed-Solomon encoder taking integer symbols — use to add RS forward error correction in hardware. |
| Integer-Output RS Decoder HDL Optimized | commhdlblkcod/Integer-Output RS Decoder HDL Optimized | R2023a+ | HDL-optimized Reed-Solomon decoder producing integer symbols — use to correct symbol errors with RS FEC in hardware. |
| General CRC Generator HDL Optimized | commhdlcrc/General CRC Generator HDL Optimized | R2023a+ | HDL-optimized CRC generator that appends a checksum to a frame — use for hardware error detection at the transmitter. |
| General CRC Syndrome Detector HDL Optimized | commhdlcrc/General CRC Syndrome Detector HDL Optimized | R2023a+ | HDL-optimized CRC checker that flags frames failing the checksum — use for hardware error detection at the receiver. |
| Convolutional Encoder | commhdlcnvcod/Convolutional Encoder | R2023a+ | Encode a bit stream with a convolutional code — use ahead of a Viterbi decoder for forward error correction in hardware links. |
| Viterbi Decoder | commhdlcnvcod/Viterbi Decoder | R2023a+ | Decode a convolutionally-encoded stream with the Viterbi algorithm — use to correct errors in hardware receivers. |

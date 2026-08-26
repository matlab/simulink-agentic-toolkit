---
type: Simulink Block Category
title: Modulation coding
description: Modulation, demodulation, error correction, and interleaving
tags: [modulation, qam, ofdm, fec, ldpc]
status: stable
source: mathworks_toolbox
library_root: Communications Toolbox
category_path: Modulation coding
block_count: 5
---

# Modulation coding

Use these blocks for modulation coding.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Error Detection and Correction | commlibv2/Error Detection and Correction | R2023a+ | Encode and decode data with forward error correction codes (convolutional, turbo, LDPC, Reed-Solomon) — use to add redundancy that enables error-free reception at lower SNR |
| Interleaving | commlibv2/Interleaving | R2023a+ | Reorder data bits or symbols to spread burst errors across multiple codewords — use between coding and modulation to convert burst errors into random errors for FEC effectiveness |
| MIMO | commlibv2/MIMO | R2023a+ | Implement multiple-input multiple-output antenna processing (spatial multiplexing, beamforming, space-time coding) — use to increase throughput or reliability in multi-antenna systems |
| Modulation | commlibv2/Modulation | R2023a+ | Map digital data to analog waveforms (QAM, PSK, FSK, OFDM) and demodulate received signals — use as the core physical-layer mapping between bits and transmitted symbols |
| Source Coding | commlibv2/Source Coding | R2023a+ | Compress and decompress data using source coding algorithms (Huffman, arithmetic, quantization) — use to reduce data rate before channel coding in bandwidth-constrained links |

---
type: Simulink Block Category
title: Hdl communications
description: HDL-optimized communications blocks for FPGA and ASIC implementation
tags: [hdl, fpga, hardware, vhdl, verilog]
status: stable
source: mathworks_toolbox
library_root: Communications Toolbox HDL Support
category_path: Hdl communications
block_count: 6
---

# Hdl communications

Use these blocks for hdl communications.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Comm Filters | commhdllib/Comm Filters | R2023a+ | HDL-optimized communications filters (raised cosine, CIC, FIR) for FPGA implementation — use for pulse shaping and matched filtering in hardware-targeted receiver/transmitter designs |
| Comm Sinks | commhdllib/Comm Sinks | R2023a+ | HDL-compatible signal analysis and measurement blocks — use to capture and analyze communications signals within HDL-targeted subsystems |
| Comm Sources | commhdllib/Comm Sources | R2023a+ | HDL-optimized signal generators (NCO, PN sequence, test patterns) for FPGA — use to generate reference signals and test data in hardware-targeted designs |
| Error Detection and Correction | commhdllib/Error Detection and Correction | R2023a+ | HDL-optimized FEC encoders and decoders (Viterbi, RS, LDPC, turbo) for FPGA — use to implement channel coding in hardware with streaming interfaces and fixed latency |
| Interleaving | commhdllib/Interleaving | R2023a+ | HDL-optimized interleavers and deinterleavers for FPGA — use to implement bit/symbol reordering in hardware with deterministic throughput and memory-efficient architectures |
| Modulation | commhdllib/Modulation | R2023a+ | HDL-optimized modulators and demodulators (QAM, PSK, OFDM) for FPGA — use to implement physical-layer modulation in hardware with fixed-point arithmetic and pipeline-friendly architectures |

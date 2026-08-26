---
type: Block Selection Guide
title: Common Blocks
description: High-value blocks selected for quick agent discovery.
status: stable
source: mathworks_toolbox
block_count: 3
---

# Common Blocks

Prefer these blocks when their intent matches the user request.

| Intent | Preferred Block | Library |
|---|---|---|
| HDL-optimized communications filters (raised cosine, CIC, FIR) for FPGA implementation — use for pulse shaping and matched filtering in hardware-targeted receiver/transmitter designs | Comm Filters | Communications Toolbox HDL Support |
| HDL-optimized FEC encoders and decoders (Viterbi, RS, LDPC, turbo) for FPGA — use to implement channel coding in hardware with streaming interfaces and fixed latency | Error Detection and Correction | Communications Toolbox HDL Support |
| HDL-optimized modulators and demodulators (QAM, PSK, OFDM) for FPGA — use to implement physical-layer modulation in hardware with fixed-point arithmetic and pipeline-friendly architectures | Modulation | Communications Toolbox HDL Support |

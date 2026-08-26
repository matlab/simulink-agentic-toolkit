---
type: Simulink Block Category
title: Ad9371 utilities
description: AD9371 digital filter and utility blocks
tags: [filter, decimation, interpolation, lo, signal]
status: stable
source: mathworks_toolbox
library_root: RF Blockset Models for Analog Devices RF Transceivers
category_path: Ad9371 utilities
block_count: 16
---

# Ad9371 utilities

Use these blocks for ad9371 utilities.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| ByPass | ad9371_utilities/ByPass | R2023a+ | Signal bypass utility — use for conditionally routing signals around processing stages |
| CW Signal | ad9371_utilities/CW Signal | R2023a+ | Generate a continuous-wave test signal — use for providing sinusoidal stimulus in RF testbenches |
| DEC4 | ad9371_utilities/DEC4 | R2023a+ | Decimation-by-4 filter — use for digital sample rate reduction in the AD9371 receive path |
| DEC5 | ad9371_utilities/DEC5 | R2023a+ | Decimation-by-5 filter — use for digital sample rate reduction in the AD9371 receive path |
| DEC5HR | ad9371_utilities/DEC5HR | R2023a+ | Decimation-by-5 half-rate filter — use for digital decimation at reduced clock rate |
| External LO1 | ad9371_utilities/External LO1 | R2023a+ | External local oscillator model — use for simulating phase noise and frequency offset from an external LO source |
| Integrated LO | ad9371_utilities/Integrated LO | R2023a+ | Integrated local oscillator model — use for simulating the on-chip LO with synthesizer characteristics |
| LTE signal | ad9371_utilities/LTE signal | R2023a+ | Generate an LTE test waveform — use for stimulating the transceiver with a realistic cellular signal |
| LTE signal1 | ad9371_utilities/LTE signal1 | R2023a+ | Generate a second LTE test waveform — use for multi-carrier testing scenarios |
| Power | ad9371_utilities/Power | R2023a+ | Measure signal power — use for computing average or peak power at any point in the RF chain |
| RHB1 | ad9371_utilities/RHB1 | R2023a+ | Receive half-band filter stage 1 — use for sample rate conversion in the AD9371 digital receive chain |
| THB1 | ad9371_utilities/THB1 | R2023a+ | Transmit half-band filter stage 1 — use for sample rate conversion in the AD9371 digital transmit chain |
| THB2 | ad9371_utilities/THB2 | R2023a+ | Transmit half-band filter stage 2 — use for additional interpolation in the AD9371 transmit path |
| TestSignalTX | ad9371_utilities/TestSignalTX | R2023a+ | Generate a transmit test signal — use for providing configurable stimulus to the TX chain |
| FIR | ad9371_utilities/FIR | R2023a+ | FIR decimation filter — use for programmable receive filtering in the AD9371 digital chain |
| TFIR | ad9371_utilities/TFIR | R2023a+ | FIR interpolation filter — use for programmable transmit filtering in the AD9371 digital chain |

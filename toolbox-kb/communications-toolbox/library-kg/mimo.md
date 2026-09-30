---
type: Simulink Block Category
title: Mimo
description: Multi-antenna detection
tags: [mimo, sphere decoder]
status: stable
source: custom_library
library_root: Communications Toolbox
category_path: Mimo
block_count: 3
---

# Mimo

Use these blocks for mimo.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| OSTBC Combiner | commmimo/OSTBC Combiner | R2023a+ | Combine the received signal and channel estimate inputs in accordance with the structure of the orthogonal space-time block code (OSTBC). The OSTBC can be rate 1 for 2 transmit antennas, rate 1/2 or 3/4 for 3 and 4 transmit antennas. For one receive antenna, the received signal input must be a column vector or a full 2-D matrix. Correspondingly, the channel estimate input must be a full 2-D matrix or 3-D array. For more than one receive antenna, the received signal input must be a full 2-D matrix or 3-D array. Correspondingly, the channel estimate input must be a 3-D or 4-D array. |
| OSTBC Encoder | commmimo/OSTBC Encoder | R2023a+ | Encode the input message using an orthogonal space-time block code (OSTBC). The OSTBC can be rate 1 for 2 transmit antennas, rate 1/2 or 3/4 for 3 and 4 transmit antennas. The input must be a column vector of length N or a full 2-D matrix with N columns. For a full matrix input, the rows are encoded independently by the encoder. N must be a multiple of 2 if the OSTBC is for 2 transmit antennas or has rate 1/2, and a multiple of 3 if the OSTBC has rate 3/4. |
| Sphere Decoder | commmimo/Sphere Decoder | R2023a+ | Perform maximum-likelihood MIMO detection via sphere decoding — use to recover spatially-multiplexed symbols with near-ML performance. |

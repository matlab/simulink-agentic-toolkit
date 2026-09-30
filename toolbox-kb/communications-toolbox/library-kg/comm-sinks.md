---
type: Simulink Block Category
title: Comm sinks
description: Visualization and IQ capture
tags: [comm sinks, constellation, eye diagram, baseband file writer]
status: stable
source: custom_library
library_root: Communications Toolbox
category_path: Comm sinks
block_count: 7
---

# Comm sinks

Use these blocks for comm sinks.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Baseband File Writer | commsink2/Baseband File Writer | R2023a+ | Write complex baseband (IQ) samples with metadata to a file — use to capture recordings for later playback or analysis. |
| Constellation Diagram | commsink2/Constellation Diagram | R2023a+ | Plot received symbols on an IQ constellation — use to visualize modulation quality and channel impairments. |
| Error Rate Calculation | commsink2/Error Rate Calculation | R2023a+ | Compute the error rate of the received data by comparing it to a delayed version of the transmitted data. The block output is a three-element vector consisting of the error rate, followed by the number of errors detected and the total number of symbols compared. This vector can be sent to either the workspace or an output port. The delays are specified in number of samples, regardless of whether the input is a scalar or a vector. The inputs to the 'Tx' and 'Rx' ports must be scalars or column vectors. The 'Stop simulation' option stops the simulation upon detecting a target number of errors or a maximum number of symbols, whichever comes first. |
| Eye Diagram | commsink2/Eye Diagram | R2023a+ | Overlay signal traces into an eye diagram — use to assess inter-symbol interference, jitter, and timing margin. |
| MLSE Equalizer | commeq3/MLSE Equalizer | R2023a+ | Equalize a linearly modulated signal through a dispersive channel using the Viterbi algorithm. The block estimates the transmitted sequence from the received signal and the channel estimates, and then outputs complex constellation points at the symbol rate. |
| General TCM Decoder | commdigbbndtcm2/General TCM Decoder | R2023a+ | Use the Viterbi algorithm to decode trellis-coded modulation data, mapped using the Signal constellation parameter that expects complex constellation points in the set-partitioned order. The Trellis structure parameter must be a valid MATLAB trellis structure. To check if a structure is a valid trellis structure, use the istrellis function in MATLAB. |
| General TCM Encoder | commdigbbndtcm2/General TCM Encoder | R2023a+ | Convolutionally encode binary data and perform signal mapping using the Signal constellation parameter, which expects complex constellation points in the set-partitioned order. The Trellis structure parameter must be a valid MATLAB trellis structure. To check if a structure is a valid trellis structure, use the istrellis function in MATLAB. |

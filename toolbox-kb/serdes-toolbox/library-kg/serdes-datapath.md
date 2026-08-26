---
type: Simulink Block Category
title: Serdes datapath
description: High-speed serial link transmitter and receiver datapath blocks
tags: [serdes, equalizer, cdr, receiver, transmitter]
status: stable
source: mathworks_toolbox
library_root: SerDes Toolbox
category_path: Serdes datapath
block_count: 7
---

# Serdes datapath

Use these blocks for serdes datapath.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Automatic Gain Control | serdesTopLevel/Datapath Blocks/Automatic Gain Control | R2023a+ | Adaptively adjust signal amplitude in a SerDes receiver — use for maintaining consistent signal levels across varying channel loss conditions |
| Clock Data Recovery | serdesTopLevel/Datapath Blocks/Clock Data Recovery | R2023a+ | Extract clock and data from an incoming serial bit stream — use for synchronizing receiver sampling to the optimal eye opening position |
| Decision Feedback Equalizer w/ CDR | serdesTopLevel/Datapath Blocks/Decision Feedback Equalizer w/ CDR | R2023a+ | Equalize inter-symbol interference using post-cursor feedback with integrated clock recovery — use for high-speed serial link receivers requiring both ISI cancellation and timing recovery |
| Feed-Forward Equalizer | serdesTopLevel/Datapath Blocks/Feed-Forward Equalizer | R2023a+ | Apply linear equalization using a tapped delay line — use for pre-emphasis at the transmitter or linear equalization at the receiver to compensate channel loss |
| Saturating Amplifier | serdesTopLevel/Datapath Blocks/Saturating Amplifier | R2023a+ | Amplify a signal with hard saturation limits — use for modeling gain stages that clip at supply rails in SerDes analog front-ends |
| Transparent Pass-Through | serdesTopLevel/Datapath Blocks/Transparent Pass-Through | R2023a+ | Pass the signal without modification — use as a placeholder in SerDes datapath when no processing is needed at a particular stage |
| Variable Gain Amplifier | serdesTopLevel/Datapath Blocks/Variable Gain Amplifier | R2023a+ | Amplify a signal with programmable gain — use for modeling adjustable-gain receiver stages that adapt to different channel loss conditions |

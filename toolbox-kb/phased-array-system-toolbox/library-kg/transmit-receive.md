---
type: Simulink Block Category
title: Transmit receive
description: "Array transmit and receive blocks, steering vectors, and front-end components (8 blocks)"
tags: [toolbox-kb, phased-array-system-toolbox, transmitter, receiver, array, steering, preamp]
status: stable
sources:
  - resource: matlab:phasedtxrxlib
source: toolbox_kb
managed_by: satk
library: Phased Array System Toolbox
kb_folder: phased-array-system-toolbox
category: transmit-receive
block_count: 8
generated: { by: satk-toolbox-build/1, at: "2026-11-23T18:23:25Z" }
---

# Transmit receive

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Narrowband Receive Array | phasedtxrxlib/Narrowband Receive Array | R2023a+ | Collect narrowband signals across array elements with spatial phase shifts from incident direction |
| Narrowband Transmit Array | phasedtxrxlib/Narrowband Transmit Array | R2023a+ | Radiate narrowband signals from array elements with specified steering weights |
| Receiver | phasedtxrxlib/Receiver | R2024a+ | Model a radar or communications receiver with gain and noise figure |
| Receiver Preamp | phasedtxrxlib/Receiver Preamp | R2023a+ | Model a receiver front-end preamplifier with gain, noise figure, and dynamic range limits |
| Steering Vector | phasedtxrxlib/Steering Vector | R2023b+ | Compute the array steering vector for a given direction to use in beamforming or DOA |
| Transmitter | phasedtxrxlib/Transmitter | R2023a+ | Model a radar or communications transmitter with specified peak power and gain |
| Wideband Receive Array | phasedtxrxlib/Wideband Receive Array | R2023a+ | Collect wideband signals across array elements preserving signal bandwidth |
| Wideband Transmit Array | phasedtxrxlib/Wideband Transmit Array | R2023a+ | Radiate wideband signals from array elements with specified beamforming weights |

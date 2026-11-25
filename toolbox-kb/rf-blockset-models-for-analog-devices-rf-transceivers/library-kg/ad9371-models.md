---
type: Simulink Block Category
title: Ad9371 models
description: AD9371 transceiver signal chain models (4 blocks)
tags: [toolbox-kb, rf-blockset-models-for-analog-devices-rf-transceivers, ad9371, rx, tx, orx, snf]
status: stable
sources:
  - resource: matlab:ad9371_models
source: toolbox_kb
managed_by: satk
library: RF Blockset Models for Analog Devices RF Transceivers
kb_folder: rf-blockset-models-for-analog-devices-rf-transceivers
category: ad9371-models
block_count: 4
generated: { by: satk-toolbox-build/1, at: "2026-11-23T18:23:26Z" }
---

# Ad9371 models

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| ad9371_orx | ad9371_models/ad9371_orx | R2023a+ | Model the AD9371 observation receiver — use for simulating the ORx path used in DPD feedback |
| ad9371_rx | ad9371_models/ad9371_rx | R2023a+ | Model the AD9371 receiver chain — use for simulating wideband receive with digital downconversion |
| ad9371_snf | ad9371_models/ad9371_snf | R2023a+ | Model the AD9371 sniffer receiver — use for simulating the low-power monitoring receiver path |
| ad9371_tx | ad9371_models/ad9371_tx | R2023a+ | Model the AD9371 transmitter chain — use for simulating wideband transmit with digital predistortion support |

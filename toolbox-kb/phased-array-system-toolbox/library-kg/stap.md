---
type: Simulink Block Category
title: Stap
description: Space-time adaptive processing for airborne clutter suppression (5 blocks)
tags: [toolbox-kb, phased-array-system-toolbox, STAP, clutter, DPCA, ADPCA, MTI, airborne]
status: stable
sources:
  - resource: matlab:phasedstaplib
source: toolbox_kb
managed_by: satk
library: Phased Array System Toolbox
kb_folder: phased-array-system-toolbox
category: stap
block_count: 5
generated: { by: satk-toolbox-build/1, at: "2026-11-23T18:23:25Z" }
---

# Stap

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| ADPCA Canceller | phasedstaplib/ADPCA Canceller | R2023a+ | Suppress ground clutter using adaptive DPCA for moving target indication from airborne radar |
| Angle Doppler Response | phasedstaplib/Angle Doppler Response | R2023a+ | Compute angle-Doppler map to visualize clutter ridges and target separation |
| Cube Slicer | phasedstaplib/Cube Slicer | R2023a+ | Extract a slice from a space-time data cube for STAP or beamforming processing |
| DPCA Canceller | phasedstaplib/DPCA Canceller | R2023a+ | Suppress ground clutter using displaced phase center antenna cancellation for airborne MTI |
| SMI Beamformer | phasedstaplib/SMI Beamformer | R2023a+ | Apply sample matrix inversion space-time beamforming for joint angle-Doppler filtering |

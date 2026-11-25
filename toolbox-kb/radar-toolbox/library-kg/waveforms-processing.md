---
type: Simulink Block Category
title: Waveforms processing
description: Waveform generation and signal processing (4 blocks)
tags: [toolbox-kb, radar-toolbox, pulse, waveform, compression, detection, clustering]
status: stable
sources:
  - resource: matlab:radarlib
source: toolbox_kb
managed_by: satk
library: Radar Toolbox
kb_folder: radar-toolbox
category: waveforms-processing
block_count: 4
generated: { by: satk-toolbox-build/1, at: "2026-11-23T18:23:26Z" }
---

# Waveforms processing

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| DBSCAN Clustering | radarlib/DBSCAN Clustering | R2023a+ | Cluster radar detections using density-based spatial clustering — use for grouping point detections into distinct objects without knowing object count |
| Detection Concatenation | radarlib/Detection Concatenation | R2023a+ | Merge detection lists from multiple sensors or frames — use for combining radar detections before tracking or fusion processing |
| Pulse Compression Library | radarlib/Pulse Compression Library | R2023a+ | Apply matched filtering to compress radar pulses — use for improving range resolution and SNR in pulsed radar receivers |
| Pulse Waveform Library | radarlib/Pulse Waveform Library | R2023a+ | Generate configurable radar transmit waveforms — use for creating LFM chirps, phase-coded pulses, or custom waveforms for radar transmitters |

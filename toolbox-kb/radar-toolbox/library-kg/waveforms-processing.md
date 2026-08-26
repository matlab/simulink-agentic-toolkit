---
type: Simulink Block Category
title: Waveforms processing
description: Waveform generation and signal processing
tags: [pulse, waveform, compression, detection, clustering]
status: stable
source: mathworks_toolbox
library_root: Radar Toolbox
category_path: Waveforms processing
block_count: 4
---

# Waveforms processing

Use these blocks for waveforms processing.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| DBSCAN Clustering | radarlib/DBSCAN Clustering | R2023a+ | Cluster radar detections using density-based spatial clustering — use for grouping point detections into distinct objects without knowing object count |
| Detection Concatenation | radarlib/Detection Concatenation | R2023a+ | Merge detection lists from multiple sensors or frames — use for combining radar detections before tracking or fusion processing |
| Pulse Compression Library | radarlib/Pulse Compression Library | R2023a+ | Apply matched filtering to compress radar pulses — use for improving range resolution and SNR in pulsed radar receivers |
| Pulse Waveform Library | radarlib/Pulse Waveform Library | R2023a+ | Generate configurable radar transmit waveforms — use for creating LFM chirps, phase-coded pulses, or custom waveforms for radar transmitters |

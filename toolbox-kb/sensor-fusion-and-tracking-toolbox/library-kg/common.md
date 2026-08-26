---
type: Block Selection Guide
title: Common Blocks
description: High-value blocks selected for quick agent discovery.
status: stable
source: mathworks_toolbox
block_count: 5
---

# Common Blocks

Prefer these blocks when their intent matches the user request.

| Intent | Preferred Block | Library |
|---|---|---|
| Track multiple objects using GNN data association — use for simple multi-target tracking when targets are well-separated | Global Nearest Neighbor Multi Object Tracker | Sensor Fusion and Tracking Toolbox |
| Track multiple objects using JPDA soft association — use for cluttered environments where detections may originate from multiple targets | Joint Probabilistic Data Association Multi Object Tracker | Sensor Fusion and Tracking Toolbox |
| Fuse tracks from multiple trackers into a unified track set — use for combining outputs from distributed sensors or tracking nodes | Track-To-Track Fuser | Sensor Fusion and Tracking Toolbox |
| Simulate a radar sensor generating detections from a scenario — use for creating synthetic radar measurements for tracker testing | Fusion Radar Sensor | Sensor Fusion and Tracking Toolbox |
| Read and replay a saved tracking scenario — use for loading pre-configured multi-platform scenarios into Simulink for testing | Tracking Scenario Reader | Sensor Fusion and Tracking Toolbox |

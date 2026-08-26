---
type: Simulink Block Category
title: Scenario utilities
description: Scenario readers, sensors, and data utilities
tags: [scenario, radar, gps, detection, concatenation]
status: stable
source: mathworks_toolbox
library_root: Sensor Fusion and Tracking Toolbox
category_path: Scenario utilities
block_count: 5
---

# Scenario utilities

Use these blocks for scenario utilities.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Fusion Radar Sensor | trackingscenarioandsensormodelslib/Fusion Radar Sensor | R2023a+ | Simulate a radar sensor generating detections from a scenario — use for creating synthetic radar measurements for tracker testing |
| Scenario To Platform | trackingscenarioandsensormodelslib/Scenario To Platform | R2023a+ | Extract platform poses from a tracking scenario — use for feeding ground-truth platform positions into sensor models |
| Tracking Scenario Reader | trackingscenarioandsensormodelslib/Tracking Scenario Reader | R2023a+ | Read and replay a saved tracking scenario — use for loading pre-configured multi-platform scenarios into Simulink for testing |
| Detection Concatenation | trackingutilitieslib/Detection Concatenation | R2023a+ | Merge detection lists from multiple sensors — use for combining detections before feeding into a centralized tracker |
| Track Concatenation | trackingutilitieslib/Track Concatenation | R2023a+ | Merge track lists from multiple trackers — use for combining tracks before feeding into a track-to-track fuser |

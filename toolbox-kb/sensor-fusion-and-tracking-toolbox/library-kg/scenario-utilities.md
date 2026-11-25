---
type: Simulink Block Category
title: Scenario utilities
description: "Scenario readers, sensors, and data utilities (5 blocks)"
tags: [toolbox-kb, sensor-fusion-and-tracking-toolbox, scenario, radar, gps, detection, concatenation]
status: stable
sources:
  - resource: matlab:trackingscenarioandsensormodelslib
source: toolbox_kb
managed_by: satk
library: Sensor Fusion and Tracking Toolbox
kb_folder: sensor-fusion-and-tracking-toolbox
category: scenario-utilities
block_count: 5
generated: { by: satk-toolbox-build/1, at: "2026-11-23T18:23:27Z" }
---

# Scenario utilities

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Fusion Radar Sensor | trackingscenarioandsensormodelslib/Fusion Radar Sensor | R2023a+ | Simulate a radar sensor generating detections from a scenario — use for creating synthetic radar measurements for tracker testing |
| Scenario To Platform | trackingscenarioandsensormodelslib/Scenario To Platform | R2023a+ | Extract platform poses from a tracking scenario — use for feeding ground-truth platform positions into sensor models |
| Tracking Scenario Reader | trackingscenarioandsensormodelslib/Tracking Scenario Reader | R2023a+ | Read and replay a saved tracking scenario — use for loading pre-configured multi-platform scenarios into Simulink for testing |
| Detection Concatenation | trackingutilitieslib/Detection Concatenation | R2023a+ | Merge detection lists from multiple sensors — use for combining detections before feeding into a centralized tracker |
| Track Concatenation | trackingutilitieslib/Track Concatenation | R2023a+ | Merge track lists from multiple trackers — use for combining tracks before feeding into a track-to-track fuser |

---
type: Simulink Block Category
title: Sensor target models
description: Sensor and target specification models
tags: [birth, clutter, measurement, survival, detectability]
status: stable
source: mathworks_toolbox
library_root: Sensor Fusion and Tracking Toolbox
category_path: Sensor target models
block_count: 8
---

# Sensor target models

Use these blocks for sensor target models.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Birth Model | sensorspecslib/Birth Model | R2023a+ | Define where new targets can appear in the surveillance volume — use for configuring target birth distributions in PHD trackers |
| Clutter Model | sensorspecslib/Clutter Model | R2023a+ | Define the false alarm distribution and density — use for characterizing spurious detections in the sensor field of view |
| Detectability Model | sensorspecslib/Detectability Model | R2023a+ | Define sensor detection probability as a function of target state — use for modeling range-dependent or aspect-dependent detection likelihood |
| Measurement Model | sensorspecslib/Measurement Model | R2023a+ | Define the sensor measurement function — use for mapping target state to expected sensor observations in tracking filters |
| Sensor Specification | sensorspecslib/Sensor Specification | R2023a+ | Bundle sensor models into a complete specification — use for combining measurement, clutter, and detectability models for a sensor |
| State Transition Model | targetspecslib/State Transition Model | R2023a+ | Define target dynamics and motion model — use for specifying how targets move between time steps in tracking filters |
| Survival Model | targetspecslib/Survival Model | R2023a+ | Define target survival probability over time — use for modeling how likely targets persist between frames in PHD trackers |
| Target Specification | targetspecslib/Target Specification | R2023a+ | Bundle target models into a complete specification — use for combining state transition, survival, and birth models for targets |

---
type: Simulink Block Category
title: Perception
description: Object detection, tracking, and multi-sensor fusion
tags: [tracker, detection, fusion, concatenation, tracking]
status: stable
source: mathworks_toolbox
library_root: Automated Driving Toolbox
category_path: Perception
block_count: 2
---

# Perception

Use these blocks for perception.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Detection Concatenation | drivinglib/Detection Concatenation | R2023a+ | Merge multiple detection arrays from different sensors into a single detection list — use before feeding multi-sensor detections into a tracker or fusion algorithm |
| Multi-Object Tracker | drivinglib/Multi-Object Tracker | R2023a+ | Track multiple objects over time using detections from one or more sensors — use for persistent object tracking with data association, track management, and state estimation |

---
type: Simulink Block Category
title: Tracking and planning
description: Object tracking and motion-planning algorithms
tags: [tracker, detection concatenation, path smoother, velocity profiler]
status: stable
source: custom_library
library_root: Automated Driving Toolbox
category_path: Tracking and planning
block_count: 4
---

# Tracking and planning

Use these blocks for tracking and planning.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Detection Concatenation | drivinglib/Detection Concatenation | R2023a+ | Concatenate detections from multiple sensors into a single list — use to feed a combined detection stream to a tracker. |
| Multi-Object Tracker | drivinglib/Multi-Object Tracker | R2023a+ | Track multiple objects over time from sensor detections using global nearest-neighbor assignment — use for object tracking in ADAS/autonomous perception. |
| Path Smoother Spline | drivinglib/Path Smoother Spline | R2023a+ | Smooth a reference path into a curvature-continuous spline — use to produce drivable paths from coarse waypoints. |
| Velocity Profiler | drivinglib/Velocity Profiler | R2023a+ | Generate a velocity profile along a path that respects acceleration and curvature limits — use to plan feasible speeds for a planned trajectory. |

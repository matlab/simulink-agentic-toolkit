---
type: Simulink Block Category
title: Path planning
description: Path smoothing, velocity profiling, and trajectory generation
tags: [path, smoother, velocity, profiler, trajectory]
status: stable
source: mathworks_toolbox
library_root: Automated Driving Toolbox
category_path: Path planning
block_count: 2
---

# Path planning

Use these blocks for path planning.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Path Smoother Spline | drivinglib/Path Smoother Spline | R2023a+ | Smooth a coarse waypoint path into a continuous spline trajectory — use to generate drivable paths with bounded curvature from discrete planner outputs |
| Velocity Profiler | drivinglib/Velocity Profiler | R2023a+ | Compute a feasible velocity profile along a planned path considering acceleration and jerk limits — use to generate comfortable and safe speed trajectories for longitudinal control |

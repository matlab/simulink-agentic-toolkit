---
type: Simulink Block Category
title: Path following
description: Path tracking and obstacle avoidance algorithms
tags: [pursuit, path, obstacle, avoidance, steering]
status: stable
source: mathworks_toolbox
library_root: Navigation Toolbox
category_path: Path following
block_count: 3
---

# Path following

Use these blocks for path following.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Pure Pursuit | navlib/Control Algorithms/Pure Pursuit | R2023a+ | Follow a path using the pure pursuit steering algorithm — use for autonomous vehicle or robot lateral control to track waypoint-based reference paths |
| Timed Elastic Band (TEB) | navlib/Control Algorithms/Timed Elastic Band (TEB) | R2025a+ | Plan time-optimal trajectories while avoiding obstacles — use for generating smooth, collision-free paths that respect kinematic constraints in real time |
| Vector Field Histogram | navlib/Control Algorithms/Vector Field Histogram | R2023a+ | Compute obstacle-free steering direction using sensor data — use for reactive obstacle avoidance in mobile robots using range sensor measurements |

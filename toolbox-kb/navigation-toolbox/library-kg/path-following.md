---
type: Simulink Block Category
title: Path following
description: Path tracking and obstacle avoidance algorithms (3 blocks)
tags: [toolbox-kb, navigation-toolbox, pursuit, path, obstacle, avoidance, steering]
status: stable
sources:
  - resource: matlab:navlib
source: toolbox_kb
managed_by: satk
library: Navigation Toolbox
kb_folder: navigation-toolbox
category: path-following
block_count: 3
generated: { by: satk-toolbox-build/1, at: "2026-11-23T18:23:24Z" }
---

# Path following

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Pure Pursuit | navlib/Control Algorithms/Pure Pursuit | R2023a+ | Follow a path using the pure pursuit steering algorithm — use for autonomous vehicle or robot lateral control to track waypoint-based reference paths |
| Timed Elastic Band (TEB) | navlib/Control Algorithms/Timed Elastic Band (TEB) | R2025a+ | Plan time-optimal trajectories while avoiding obstacles — use for generating smooth, collision-free paths that respect kinematic constraints in real time |
| Vector Field Histogram | navlib/Control Algorithms/Vector Field Histogram | R2023a+ | Compute obstacle-free steering direction using sensor data — use for reactive obstacle avoidance in mobile robots using range sensor measurements |

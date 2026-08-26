---
type: Simulink Block Category
title: Guidance navigation
description: Path following, trajectory planning, and obstacle avoidance
tags: [waypoint, orbit, guidance, trajectory, avoidance]
status: stable
source: mathworks_toolbox
library_root: UAV Toolbox
category_path: Guidance navigation
block_count: 9
---

# Guidance navigation

Use these blocks for guidance navigation.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Guidance Model | uavalgslib/Guidance Model | R2023a+ | Execute a UAV guidance model for path following — use for implementing waypoint navigation logic with configurable lookahead and transition criteria |
| Multi-Instance Guidance Model | uavalgslib/Multi-Instance Guidance Model | R2025a+ | Run multiple UAV guidance instances in parallel — use for simulating swarms or multi-vehicle missions with independent guidance |
| Path Manager | uavalgslib/Path Manager | R2023a+ | Manage transitions between mission path segments — use for sequencing waypoints, orbits, and landing patterns in UAV missions |
| Fixed-Wing UAV Point Mass | uavalgslib/Fixed-Wing UAV Point Mass | R2023a+ | Simulate fixed-wing UAV dynamics using point-mass equations — use for fast prototyping of guidance and navigation before full 6-DOF models |
| Minimum Jerk Polynomial Trajectory | uavalgslib/Minimum Jerk Polynomial Trajectory | R2023a+ | Generate smooth trajectories minimizing jerk — use for planning comfortable multirotor paths with continuous acceleration profiles |
| Minimum Snap Polynomial Trajectory | uavalgslib/Minimum Snap Polynomial Trajectory | R2023a+ | Generate smooth trajectories minimizing snap — use for planning aggressive multirotor paths that minimize control effort |
| Obstacle Avoidance | uavalgslib/Obstacle Avoidance | R2023a+ | Compute collision-free steering commands — use for reactive obstacle avoidance using 3D sensor data in UAV navigation |
| Orbit Follower | uavalgslib/Orbit Follower | R2023a+ | Track a circular orbit pattern — use for loitering, surveillance, or inspection missions requiring circular flight paths |
| Waypoint Follower | uavalgslib/Waypoint Follower | R2023a+ | Follow a sequence of 3D waypoints — use for basic point-to-point UAV navigation with smooth transitions between waypoints |

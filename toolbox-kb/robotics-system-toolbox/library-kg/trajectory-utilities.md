---
type: Simulink Block Category
title: Trajectory utilities
description: Trajectory generation and coordinate utilities
tags: [trajectory, jerk, snap, polynomial, rotation, transform]
status: stable
source: mathworks_toolbox
library_root: Robotics System Toolbox
category_path: Trajectory utilities
block_count: 7
---

# Trajectory utilities

Use these blocks for trajectory utilities.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Coordinate Transformation Conversion | robotutilslib/Coordinate Transformation Conversion | R2023a+ | Convert between rotation representations — use for translating quaternions, Euler angles, and rotation matrices |
| Minimum Jerk Polynomial Trajectory | robotutilslib/Minimum Jerk Polynomial Trajectory | R2023a+ | Generate smooth trajectory minimizing jerk — use for planning comfortable robot paths with continuous acceleration |
| Minimum Snap Polynomial Trajectory | robotutilslib/Minimum Snap Polynomial Trajectory | R2023a+ | Generate smooth trajectory minimizing snap — use for planning aggressive robot paths minimizing control effort |
| Polynomial Trajectory | robotutilslib/Polynomial Trajectory | R2023a+ | Generate trajectory from polynomial coefficients — use for executing pre-computed polynomial motion profiles |
| Rotation Trajectory | robotutilslib/Rotation Trajectory | R2023a+ | Interpolate between rotation orientations — use for generating smooth rotational motion between poses |
| Transform Trajectory | robotutilslib/Transform Trajectory | R2023a+ | Interpolate between homogeneous transforms — use for generating smooth 6-DOF motion between poses |
| Trapezoidal Velocity Profile Trajectory | robotutilslib/Trapezoidal Velocity Profile Trajectory | R2023a+ | Generate trajectory with trapezoidal velocity — use for time-optimal point-to-point motion with acceleration limits |

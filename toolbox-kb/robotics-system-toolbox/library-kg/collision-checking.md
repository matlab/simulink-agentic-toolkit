---
type: Simulink Block Category
title: Collision checking
description: Collision geometry and detection
tags: [collision, box, sphere, mesh, capsule, cylinder]
status: stable
source: mathworks_toolbox
library_root: Robotics System Toolbox
category_path: Collision checking
block_count: 8
---

# Collision checking

Use these blocks for collision checking.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Check Collision | robotslcollision/Check Collision | R2025a+ | Detect collisions between geometric primitives — use for verifying robot configurations are collision-free |
| Collision Box | robotslcollision/Collision Box | R2025a+ | Define a box collision geometry — use for representing rectangular obstacles or link bounding volumes |
| Collision Capsule | robotslcollision/Collision Capsule | R2025a+ | Define a capsule collision geometry — use for representing cylindrical shapes with rounded ends |
| Collision Cylinder | robotslcollision/Collision Cylinder | R2025a+ | Define a cylinder collision geometry — use for representing round obstacles or link volumes |
| Collision Mesh | robotslcollision/Collision Mesh | R2025a+ | Define a mesh collision geometry — use for representing complex-shaped obstacles from triangulated surfaces |
| Collision Sphere | robotslcollision/Collision Sphere | R2025a+ | Define a sphere collision geometry — use for representing spherical obstacles or conservative bounding volumes |
| Rigid Body Tree | robotslcollision/Rigid Body Tree | R2026a+ | Create a rigid body tree robot model — use for defining robot kinematics and dynamics from DH or URDF data |
| Rigid Body Tree Check Collision | robotslcollision/Rigid Body Tree Check Collision | R2026a+ | Check collision for all links of a rigid body tree — use for whole-robot collision checking against environment |

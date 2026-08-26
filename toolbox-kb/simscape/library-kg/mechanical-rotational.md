---
type: Simulink Block Category
title: Mechanical rotational
description: Rotational mechanical elements including springs, dampers, inertias, friction, and references
tags: [rotational, inertia, torque, spring, damper]
status: stable
source: mathworks_toolbox
library_root: Simscape
category_path: Mechanical rotational
block_count: 19
---

# Mechanical rotational

Use these blocks for mechanical rotational.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Ideal Rotational Motion Sensor | fl_lib/Mechanical/Mechanical Sensors/Ideal Rotational Motion Sensor | R2023a+ | Use when measuring angular velocity or angle between two rotational nodes without loading the system |
| Ideal Torque Sensor | fl_lib/Mechanical/Mechanical Sensors/Ideal Torque Sensor | R2023a+ | Use when measuring torque between two rotational mechanical nodes without affecting motion |
| Ideal Angular Velocity Source | fl_lib/Mechanical/Mechanical Sources/Ideal Angular Velocity Source | R2023a+ | Use when imposing a prescribed angular velocity between two rotational ports controlled by a physical signal |
| Ideal Torque Source | fl_lib/Mechanical/Mechanical Sources/Ideal Torque Source | R2023a+ | Use when applying a prescribed torque between two rotational ports controlled by a physical signal |
| Inertia | fl_lib/Mechanical/Rotational Elements/Inertia | R2023a+ | Use when modeling rotational kinetic energy storage due to mass moment of inertia of a spinning body |
| Mechanical Rotational Reference | fl_lib/Mechanical/Rotational Elements/Mechanical Rotational Reference | R2023a+ | Use to define a fixed rotational frame as the zero-velocity ground reference for rotational networks |
| Rotational Damper | fl_lib/Mechanical/Rotational Elements/Rotational Damper | R2023a+ | Use when modeling viscous friction that produces torque proportional to angular velocity difference |
| Rotational Free End | fl_lib/Mechanical/Rotational Elements/Rotational Free End | R2023a+ | Use to terminate an unused rotational port with zero torque, representing an unconstrained free end |
| Rotational Friction | fl_lib/Mechanical/Rotational Elements/Rotational Friction | R2023a+ | Use when modeling Coulomb and viscous rotational friction with stick-slip transitions |
| Rotational Hard Stop | fl_lib/Mechanical/Rotational Elements/Rotational Hard Stop | R2023a+ | Use when modeling angular travel limits that produce contact torque at the end of rotational range |
| Rotational Inerter | fl_lib/Mechanical/Rotational Elements/Rotational Inerter | R2023a+ | Use when modeling a two-terminal rotational inertance device that resists relative angular acceleration |
| Rotational Spring | fl_lib/Mechanical/Rotational Elements/Rotational Spring | R2023a+ | Use when modeling a torsional spring that produces torque proportional to angular displacement difference |
| Inertia With Friction (AB) | fl_lib/Rotational/Elements/Inertia With Friction (AB) | R2023a+ |  |
| Rotational Friction (AB) | fl_lib/Rotational/Elements/Rotational Friction (AB) | R2023a+ |  |
| Rotational Hard Stop (AB) | fl_lib/Rotational/Elements/Rotational Hard Stop (AB) | R2023a+ |  |
| Rotational Inerter (AB) | fl_lib/Rotational/Elements/Rotational Inerter (AB) | R2023a+ |  |
| Rotational Spacer (AB) | fl_lib/Rotational/Elements/Rotational Spacer (AB) | R2023a+ |  |
| External Torque Source (AB) | fl_lib/Rotational/Sources/External Torque Source (AB) | R2023a+ |  |
| Torque Actuator (AB) | fl_lib/Rotational/Sources/Torque Actuator (AB) | R2026a+ |  |

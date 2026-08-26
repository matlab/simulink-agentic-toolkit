---
type: Simulink Block Category
title: Manipulator dynamics
description: Rigid body tree kinematics and dynamics
tags: [dynamics, kinematics, jacobian, gravity, mass, inverse]
status: stable
source: mathworks_toolbox
library_root: Robotics System Toolbox
category_path: Manipulator dynamics
block_count: 10
---

# Manipulator dynamics

Use these blocks for manipulator dynamics.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Forward Dynamics | robotmaniplib/Forward Dynamics | R2023a+ | Compute joint accelerations from applied torques — use for simulating robot motion given joint forces |
| Get Jacobian | robotmaniplib/Get Jacobian | R2023a+ | Compute geometric Jacobian of a robot — use for mapping joint velocities to end-effector velocity |
| Get Transform | robotmaniplib/Get Transform | R2023a+ | Compute forward kinematics transform — use for finding end-effector or frame pose given joint angles |
| Gravity Torque | robotmaniplib/Gravity Torque | R2023a+ | Compute gravity compensation torques — use for calculating joint torques needed to counteract gravity |
| Inverse Dynamics | robotmaniplib/Inverse Dynamics | R2023a+ | Compute required joint torques for desired motion — use for feedforward torque computation in robot control |
| Inverse Kinematics | robotmaniplib/Inverse Kinematics | R2023a+ | Solve for joint angles given desired end-effector pose — use for computing joint configurations that achieve a target pose |
| Joint Space Mass Matrix | robotmaniplib/Joint Space Mass Matrix | R2023a+ | Compute the joint-space inertia matrix — use for dynamic control algorithms that require the mass matrix |
| Joint Space Motion Model | robotmaniplib/Joint Space Motion Model | R2023a+ | Simulate robot motion in joint space — use for modeling manipulator dynamics with joint torque inputs |
| Task Space Motion Model | robotmaniplib/Task Space Motion Model | R2023a+ | Simulate robot motion in task space — use for modeling end-effector dynamics with Cartesian force inputs |
| Velocity Product Torque | robotmaniplib/Velocity Product Torque | R2023a+ | Compute Coriolis and centrifugal torques — use for velocity-dependent torque compensation in dynamic control |

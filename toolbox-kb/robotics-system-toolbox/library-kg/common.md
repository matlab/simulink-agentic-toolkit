---
type: Block Selection Guide
title: Common Blocks
description: High-value blocks selected for quick agent discovery.
status: stable
source: mathworks_toolbox
block_count: 6
---

# Common Blocks

Prefer these blocks when their intent matches the user request.

| Intent | Preferred Block | Library |
|---|---|---|
| Compute joint accelerations from applied torques — use for simulating robot motion given joint forces | Forward Dynamics | Robotics System Toolbox |
| Compute forward kinematics transform — use for finding end-effector or frame pose given joint angles | Get Transform | Robotics System Toolbox |
| Solve for joint angles given desired end-effector pose — use for computing joint configurations that achieve a target pose | Inverse Kinematics | Robotics System Toolbox |
| Simulate robot motion in joint space — use for modeling manipulator dynamics with joint torque inputs | Joint Space Motion Model | Robotics System Toolbox |
| Simulate differential-drive robot kinematics — use for two-wheeled robots steered by wheel speed difference | Differential Drive Kinematic Model | Robotics System Toolbox |
| Track a path using pure pursuit — use for steering a mobile robot along a reference path with lookahead | Pure Pursuit | Robotics System Toolbox |

---
type: Simulink Block Category
title: Ur robot control
description: Universal Robots UR series real-time control and monitoring
tags: [robot, manipulator, joint, gripper, ur]
status: stable
source: mathworks_toolbox
library_root: Robotics System Toolbox Support Package for Universal Robots UR Series Manipulators
category_path: Ur robot control
block_count: 6
---

# Ur robot control

Use these blocks for ur robot control.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Actuate Gripper | urRTDElib/Actuate Gripper | R2025a+ | Open or close a gripper attached to a Universal Robots arm — use for pick-and-place operations or object manipulation tasks |
| Follow Joint Waypoints | urRTDElib/Follow Joint Waypoints | R2025a+ | Command a UR robot to move through a sequence of joint configurations — use for executing pre-planned multi-point trajectories |
| Read Controller Output | urRTDElib/Read Controller Output | R2025a+ | Read the current controller output signals from a UR robot — use for monitoring torque commands or control effort in real time |
| Read Joint Configuration | urRTDElib/Read Joint Configuration | R2025a+ | Read current joint angles and velocities from a UR robot — use for feedback in closed-loop control or state monitoring |
| Read Motion Status | urRTDElib/Read Motion Status | R2025a+ | Read the motion state of a UR robot — use for detecting motion completion, checking if the robot is moving, or triggering sequenced operations |
| Send Joint Configuration | urRTDElib/Send Joint Configuration | R2025a+ | Send a target joint configuration to a UR robot — use for commanding the robot to move to a specific joint pose |

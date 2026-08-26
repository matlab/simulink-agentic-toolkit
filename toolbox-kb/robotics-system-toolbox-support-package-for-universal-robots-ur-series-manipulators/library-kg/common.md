---
type: Block Selection Guide
title: Common Blocks
description: High-value blocks selected for quick agent discovery.
status: stable
source: mathworks_toolbox
block_count: 4
---

# Common Blocks

Prefer these blocks when their intent matches the user request.

| Intent | Preferred Block | Library |
|---|---|---|
| Open or close a gripper attached to a Universal Robots arm — use for pick-and-place operations or object manipulation tasks | Actuate Gripper | Robotics System Toolbox Support Package for Universal Robots UR Series Manipulators |
| Command a UR robot to move through a sequence of joint configurations — use for executing pre-planned multi-point trajectories | Follow Joint Waypoints | Robotics System Toolbox Support Package for Universal Robots UR Series Manipulators |
| Read current joint angles and velocities from a UR robot — use for feedback in closed-loop control or state monitoring | Read Joint Configuration | Robotics System Toolbox Support Package for Universal Robots UR Series Manipulators |
| Send a target joint configuration to a UR robot — use for commanding the robot to move to a specific joint pose | Send Joint Configuration | Robotics System Toolbox Support Package for Universal Robots UR Series Manipulators |

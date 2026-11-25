---
type: Simulink Block Category
title: Services actions
description: ROS service calls and action client/server (7 blocks)
tags: [toolbox-kb, ros-toolbox, service, action, goal, cancel, monitor, call]
status: stable
sources:
  - resource: matlab:robotlib
source: toolbox_kb
managed_by: satk
library: ROS Toolbox
kb_folder: ros-toolbox
category: services-actions
block_count: 7
generated: { by: satk-toolbox-build/1, at: "2026-11-23T18:23:26Z" }
---

# Services actions

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Call Service | robotlib/Call Service | R2023a+ | Call a ROS service and receive its response — use for requesting actions from ROS nodes that provide services |
| Call Service | ros2lib/Call Service | R2023a+ | Call a ROS service and receive its response — use for requesting actions from ROS nodes that provide services |
| Cancel Action Goal | ros2lib/Cancel Action Goal | R2024a+ | Cancel a pending ROS 2 action goal — use for aborting long-running action requests |
| Monitor Action Goal | ros2lib/Monitor Action Goal | R2024a+ | Monitor the status of a ROS 2 action goal — use for tracking progress and receiving feedback from action servers |
| Receive Service Request | ros2lib/Receive Service Request | R2024a+ | Receive incoming ROS 2 service requests — use for implementing a service server in Simulink |
| Send Action Goal | ros2lib/Send Action Goal | R2024a+ | Send a goal to a ROS 2 action server — use for initiating long-running tasks on action servers |
| Send Service Response | ros2lib/Send Service Response | R2024a+ | Send a response to a ROS 2 service request — use for completing service handling in a Simulink-based server |

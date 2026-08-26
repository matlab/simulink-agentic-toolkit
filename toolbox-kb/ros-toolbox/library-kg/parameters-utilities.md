---
type: Simulink Block Category
title: Parameters utilities
description: Parameter server access and coordinate utilities
tags: [parameter, transform, time, coordinate, can]
status: stable
source: mathworks_toolbox
library_root: ROS Toolbox
category_path: Parameters utilities
block_count: 12
---

# Parameters utilities

Use these blocks for parameters utilities.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Apply Transform | robotlib/Apply Transform | R2023b+ | Apply a coordinate transform to a message — use for converting sensor data between reference frames via the TF tree |
| Get Transform | robotlib/Get Transform | R2023b+ | Query the TF tree for a transform between frames — use for looking up spatial relationships between coordinate frames |
| Current Time | robotlib/Current Time | R2023a+ | Get the current ROS network time — use for synchronizing Simulink with the ROS time server |
| Get Parameter | robotlib/Get Parameter | R2023a+ | Read a parameter from the ROS parameter server — use for retrieving configuration values shared across nodes |
| Set Parameter | robotlib/Set Parameter | R2023a+ | Write a parameter to the ROS parameter server — use for sharing configuration from Simulink to other nodes |
| Apply Transform | ros2lib/Apply Transform | R2023b+ | Apply a coordinate transform to a message — use for converting sensor data between reference frames via the TF tree |
| Get Transform | ros2lib/Get Transform | R2023b+ | Query the TF tree for a transform between frames — use for looking up spatial relationships between coordinate frames |
| CAN Receive | ros2lib/CAN Receive | R2026a+ | Receive CAN messages via ROS 2 — use for reading vehicle bus data through the ROS 2 CAN interface |
| CAN Transmit | ros2lib/CAN Transmit | R2026a+ | Transmit CAN messages via ROS 2 — use for sending vehicle bus commands through the ROS 2 CAN interface |
| Current Time | ros2lib/Current Time | R2023a+ | Get the current ROS network time — use for synchronizing Simulink with the ROS time server |
| Get Parameter | ros2lib/Get Parameter | R2023a+ | Read a parameter from the ROS parameter server — use for retrieving configuration values shared across nodes |
| Coordinate Transformation Conversion | roslib/Utilities/Coordinate Transformation Conversion | R2023a+ | Convert between rotation representations — use for translating quaternions, Euler angles, and rotation matrices |

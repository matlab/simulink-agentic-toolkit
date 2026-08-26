---
type: Simulink Block Category
title: Sensor data
description: Sensor data encoding and decoding
tags: [image, point cloud, scan, occupancy, write, read]
status: stable
source: mathworks_toolbox
library_root: ROS Toolbox
category_path: Sensor data
block_count: 14
---

# Sensor data

Use these blocks for sensor data.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Read Data | robotlib/Read Data | R2023a+ | Read messages from a ROS bag file — use for replaying recorded sensor data into your model |
| Write Image | robotlib/Write Image | R2023a+ | Convert a Simulink image matrix to a ROS image message — use for publishing camera frames to ROS |
| Write Point Cloud | robotlib/Write Point Cloud | R2023a+ | Convert point cloud data to a ROS message — use for publishing 3D lidar or depth data to ROS |
| Read Image | robotlib/Read Image | R2023a+ | Extract image matrix from a ROS image message — use for processing camera data received from ROS topics |
| Read Occupancy Grid | robotlib/Read Occupancy Grid | R2026a+ | Extract grid data from a ROS occupancy grid message — use for processing map data from SLAM or navigation nodes |
| Read Point Cloud | robotlib/Read Point Cloud | R2023a+ | Extract XYZ data from a ROS point cloud message — use for processing 3D sensor data received from ROS |
| Read Scan | robotlib/Read Scan | R2023a+ | Extract range data from a ROS laser scan message — use for processing 2D lidar data from ROS |
| Read Data | ros2lib/Read Data | R2023a+ | Read messages from a ROS bag file — use for replaying recorded sensor data into your model |
| Write Image | ros2lib/Write Image | R2023a+ | Convert a Simulink image matrix to a ROS image message — use for publishing camera frames to ROS |
| Write Point Cloud | ros2lib/Write Point Cloud | R2023a+ | Convert point cloud data to a ROS message — use for publishing 3D lidar or depth data to ROS |
| Read Image | ros2lib/Read Image | R2023a+ | Extract image matrix from a ROS image message — use for processing camera data received from ROS topics |
| Read Occupancy Grid | ros2lib/Read Occupancy Grid | R2026a+ | Extract grid data from a ROS occupancy grid message — use for processing map data from SLAM or navigation nodes |
| Read Point Cloud | ros2lib/Read Point Cloud | R2023a+ | Extract XYZ data from a ROS point cloud message — use for processing 3D sensor data received from ROS |
| Read Scan | ros2lib/Read Scan | R2023a+ | Extract range data from a ROS laser scan message — use for processing 2D lidar data from ROS |

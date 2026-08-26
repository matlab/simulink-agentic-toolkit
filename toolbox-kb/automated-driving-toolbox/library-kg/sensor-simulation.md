---
type: Simulink Block Category
title: Sensor simulation
description: Synthetic sensor models for lidar, radar, camera, and ultrasonic
tags: [sensor, radar, lidar, camera, detection]
status: stable
source: mathworks_toolbox
library_root: Automated Driving Toolbox
category_path: Sensor simulation
block_count: 7
---

# Sensor simulation

Use these blocks for sensor simulation.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Lidar Point Cloud Generator | drivingscenarioandsensors/Lidar Point Cloud Generator | R2023a+ | Generate synthetic lidar point cloud data from a driving scenario — use to simulate lidar returns including ground plane, obstacles, and ego vehicle occlusion for perception algorithm testing |
| Driving Radar Data Generator | drivingscenarioandsensors/Driving Radar Data Generator | R2023a+ | Generate synthetic radar detections with range, velocity, and angle from a driving scenario — use to produce realistic radar returns including multi-path and clutter for sensor fusion testing |
| INS | drivingscenarioandsensors/INS | R2023a+ | Simulate an inertial navigation system providing position, velocity, and orientation measurements with configurable noise — use for localization algorithm testing with realistic IMU/GPS sensor models |
| Ideal Ground Truth Sensor | drivingscenarioandsensors/Ideal Ground Truth Sensor | R2025a+ | Output perfect actor positions and velocities from the scenario without sensor noise — use as a baseline reference for evaluating perception algorithm accuracy |
| Radar Detection Generator | drivingscenarioandsensors/Radar Detection Generator | R2023a+ | Generate synthetic radar object detections from scenario actors — use to test tracking and fusion algorithms with configurable detection probability, false alarms, and range/angle resolution |
| Ultrasonic Detection Generator | drivingscenarioandsensors/Ultrasonic Detection Generator | R2023a+ | Generate synthetic ultrasonic proximity detections — use to simulate short-range parking sensors for low-speed maneuvering and obstacle avoidance algorithm testing |
| Vision Detection Generator | drivingscenarioandsensors/Vision Detection Generator | R2023a+ | Generate synthetic camera detections of lanes, vehicles, and objects from a driving scenario — use to test vision-based perception pipelines with configurable detection accuracy and camera intrinsics |

---
type: Block Selection Guide
title: Common Blocks
description: High-value blocks selected for quick agent discovery.
status: stable
source: mathworks_toolbox
block_count: 11
---

# Common Blocks

Prefer these blocks when their intent matches the user request.

| Intent | Preferred Block | Library |
|---|---|---|
| Generate synthetic lidar point cloud data from a driving scenario — use to simulate lidar returns including ground plane, obstacles, and ego vehicle occlusion for perception algorithm testing | Lidar Point Cloud Generator | Automated Driving Toolbox |
| Simulate lateral vehicle dynamics using a bicycle model driven by velocity and steering angle — use for path-following controller testing where speed is a known input | Bicycle Model - Velocity Input | Automated Driving Toolbox |
| Generate synthetic radar object detections from scenario actors — use to test tracking and fusion algorithms with configurable detection probability, false alarms, and range/angle resolution | Radar Detection Generator | Automated Driving Toolbox |
| Read and play back a pre-recorded driving scenario at simulation time — use to feed actor trajectories, road boundaries, and lane markings into a Simulink model from a drivingScenario object | Scenario Reader | Automated Driving Toolbox |
| Generate synthetic camera detections of lanes, vehicles, and objects from a driving scenario — use to test vision-based perception pipelines with configurable detection accuracy and camera intrinsics | Vision Detection Generator | Automated Driving Toolbox |
| Capture RGB images from a virtual camera in the 3D simulation environment — use to generate synthetic camera data with configurable intrinsics for perception algorithm validation | Simulation 3D Camera | Automated Driving Toolbox |
| Configure the Unreal Engine 3D simulation scene including weather, lighting, and road surface — use to set up environmental conditions for sensor robustness testing across rain, fog, and night scenarios | Simulation 3D Scene Configuration | Automated Driving Toolbox |
| Compute steering angle using the Stanley lateral control method — use for path-following where the controller minimizes cross-track error and heading error relative to a reference path | Lateral Controller Stanley | Automated Driving Toolbox |
| Compute throttle and brake commands to track a reference speed profile — use with the lateral Stanley controller to achieve combined speed and path tracking for autonomous driving | Longitudinal Controller Stanley | Automated Driving Toolbox |
| Merge multiple detection arrays from different sensors into a single detection list — use before feeding multi-sensor detections into a tracker or fusion algorithm | Detection Concatenation | Automated Driving Toolbox |
| Track multiple objects over time using detections from one or more sensors — use for persistent object tracking with data association, track management, and state estimation | Multi-Object Tracker | Automated Driving Toolbox |

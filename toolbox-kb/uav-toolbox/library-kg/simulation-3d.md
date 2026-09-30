---
type: Simulink Block Category
title: Simulation 3d
description: Photorealistic 3D scene, cameras, and sensors
tags: [simulation 3d, camera, lidar, ultrasonic, scene, video send]
status: stable
source: custom_library
library_root: UAV Toolbox
category_path: Simulation 3d
block_count: 10
---

# Simulation 3d

Use these blocks for simulation 3d.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Simulation 3D Camera | uavsim3dlib/Simulation 3D Camera | R2023a+ | Model a pinhole camera in the 3D simulation environment — use to render synthetic camera imagery for perception testing. |
| Simulation 3D Custom UAV Pack | uavsim3dlib/Simulation 3D Custom UAV Pack | R2026a+ | Spawn a custom UAV mesh/actor in the 3D simulation scene — use to visualize a user-defined vehicle. |
| Simulation 3D Fisheye Camera | uavsim3dlib/Simulation 3D Fisheye Camera | R2023a+ | Model a fisheye camera in the 3D simulation environment — use to generate wide-FOV synthetic imagery. |
| Simulation 3D Lidar | uavsim3dlib/Simulation 3D Lidar | R2023a+ | Model a lidar sensor in the 3D simulation environment — use to generate synthetic point clouds for perception testing. |
| Simulation 3D Scene Configuration | uavsim3dlib/Simulation 3D Scene Configuration | R2023a+ | Configure and connect to the 3D simulation scene (world, weather, sample time) — required once per model to drive the 3D environment. |
| Simulation 3D Ultrasonic Sensor | uavsim3dlib/Simulation 3D Ultrasonic Sensor | R2023a+ | Model an ultrasonic range sensor in the 3D simulation environment — use for synthetic proximity sensing. |
| Video Send | uavsim3dlib/Video Send | R2023a+ | Stream rendered video frames out of the 3D simulation — use to pipe synthetic imagery to a perception algorithm or display. |
| Simulation 3D UAV Vehicle | uavsim3dlib/Simulation 3D UAV Vehicle | R2023a+ | Place a UAV vehicle in the 3D visualization environment. Translation port accepts a [1x3] vector of double-precision values which specifies the position of the UAV body. Rotation port accepts a [1x3] vector of double-precision values which specifies the yaw, pitch, and roll angle of the UAV body in radians. If you set "Type" parameter to "Custom", the Rotation port also accepts a [17x3] matrix of double-precision values where each row specifies the rotation angles of the UAV body and its motors, and the angular velocity of its rotors, in radians and RPM, respectively. Use the Simulation 3D Custom UAV Pack block to generate translation and rotation input for a custom UAV. GeoOrigin port accepts a [1x3] vector of double-precision values. The vector specifies the latitude, longitude, and altitude of the Unreal world origin. When the "Use geospatial coordinates for inputs and initial values" parameter is checked, the translation input specifies the UAV's latitude, longitude, and altitude (in degrees and meters), and the rotation input is relative to the local ENU frame. If unchecked, the translation input specifies the UAV's XYZ position in the Unreal Engine world coordinate frame (in meters), with rotation relative to the Unreal Engine world coordinate frame. |
| UAV Scenario Lidar | uavsimlib/UAV Scenario Lidar | R2023a+ | Simulate lidar measurements based on meshes in the UAV Scenario and UAV motions. Use the Select button to choose the lidar sensor based on the scenario currently loaded in your model. To use this block, ensure that UAV Scenario Configuration block is in your model. Sample time must be a multiple of the sample time specified in the UAV Scenario Configuration block. |
| UAV Scenario Scope | uavsimlib/UAV Scenario Scope | R2023a+ | Visualize UAV scenario and lidar pointclouds. An input port is created for each lidar sensor checked for visualization. The input port expects a point cloud signal as an Nx3 or MxNx3 matrix. Click "Refresh sensor table" to update the sensor names based on the scenario loaded in the model by UAV Scenario Configuration block. Click "Show animation" to bring up the figure that plots the meshes in the scenario and lidar point cloud readings. To use this block, ensure that UAV Scenario Configuration block is in your model. If you set the Sample Time to -1, the block uses the sample time specified in the UAV Scenario Configuration block. |

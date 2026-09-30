---
type: Simulink Block Category
title: Simulation 3d
description: Photorealistic 3D scene actors and sensors
tags: [simulation 3d, camera, lidar, pedestrian, bicyclist, radar, ultrasonic, vehicle with ground]
status: stable
source: custom_library
library_root: Automated Driving Toolbox
category_path: Simulation 3d
block_count: 11
---

# Simulation 3d

Use these blocks for simulation 3d.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Simulation 3D Bicyclist | drivingsim3d/Simulation 3D Bicyclist | R2023a+ | Spawn and animate a bicyclist actor in the 3D simulation scene — use to add a vulnerable road user for perception testing. |
| Simulation 3D Camera | drivingsim3d/Simulation 3D Camera | R2023a+ | Model a pinhole camera in the 3D simulation environment — use to render synthetic camera imagery for perception testing. |
| Simulation 3D Fisheye Camera | drivingsim3d/Simulation 3D Fisheye Camera | R2023a+ | Model a fisheye camera in the 3D simulation environment — use to generate wide-FOV synthetic imagery. |
| Simulation 3D Lidar | drivingsim3d/Simulation 3D Lidar | R2023a+ | Model a lidar sensor in the 3D simulation environment — use to generate synthetic point clouds for perception testing. |
| Simulation 3D Pedestrian | drivingsim3d/Simulation 3D Pedestrian | R2023a+ | Spawn and animate a pedestrian actor in the 3D simulation scene — use to add a vulnerable road user for perception testing. |
| Simulation 3D Probabilistic Radar | drivingsim3d/Simulation 3D Probabilistic Radar | R2023a+ | Model a probabilistic radar sensor in the 3D simulation environment — use to generate statistically-modeled radar detections. |
| Simulation 3D Probabilistic Radar Configuration | drivingsim3d/Simulation 3D Probabilistic Radar Configuration | R2023a+ | Configure the shared settings of the probabilistic radar model in the 3D scene — use once to parameterize 3D radar sensing. |
| Simulation 3D Scene Configuration | drivingsim3d/Simulation 3D Scene Configuration | R2023a+ | Configure and connect to the 3D simulation scene (world, weather, sample time) — required once per model to drive the 3D environment. |
| Simulation 3D Ultrasonic Array | drivingsim3d/Simulation 3D Ultrasonic Array | R2023a+ | Model an array of ultrasonic sensors in the 3D simulation environment — use for synthetic parking/proximity sensing. |
| Simulation 3D Ultrasonic Sensor | drivingsim3d/Simulation 3D Ultrasonic Sensor | R2023a+ | Model an ultrasonic range sensor in the 3D simulation environment — use for synthetic proximity sensing. |
| Simulation 3D Vehicle with Ground Following | drivingsim3d/Simulation 3D Vehicle with Ground Following | R2023a+ | Spawn a vehicle in the 3D scene that follows terrain elevation — use to place a drivable vehicle in the photorealistic world. |

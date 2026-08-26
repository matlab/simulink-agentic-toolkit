---
type: Simulink Block Category
title: X 3d simulation
description: Unreal Engine 3D environment visualization and high-fidelity sensing
tags: [3d, simulation, unreal, scene, rendering]
status: stable
source: mathworks_toolbox
library_root: Automated Driving Toolbox
category_path: X 3d simulation
block_count: 13
---

# X 3d simulation

Use these blocks for x 3d simulation.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Cuboid To 3D Simulation | drivingscenarioandsensors/Cuboid To 3D Simulation | R2023a+ | Convert cuboid actor poses from a driving scenario into 3D simulation coordinates — use to bridge scenario-based testing with Unreal Engine visualization |
| Simulation 3D Vision Detection Generator | drivingsim3d/Simulation 3D Vision Detection Generator | R2023a+ | Generate vision detections from rendered 3D camera images in the Unreal Engine environment — use for high-fidelity vision testing with photorealistic rendering and lighting effects |
| Simulation 3D Bicyclist | drivingsim3d/Simulation 3D Bicyclist | R2023a+ | Place and animate a bicyclist actor in the 3D simulation environment — use to create vulnerable road user scenarios for ADAS testing in the Unreal Engine visualization |
| Simulation 3D Camera | drivingsim3d/Simulation 3D Camera | R2023a+ | Capture RGB images from a virtual camera in the 3D simulation environment — use to generate synthetic camera data with configurable intrinsics for perception algorithm validation |
| Simulation 3D Fisheye Camera | drivingsim3d/Simulation 3D Fisheye Camera | R2023a+ | Capture wide-angle fisheye images from a virtual camera in the 3D environment — use to simulate surround-view or parking camera systems with barrel distortion |
| Simulation 3D Lidar | drivingsim3d/Simulation 3D Lidar | R2023a+ | Generate lidar point clouds from the 3D simulation environment — use for high-fidelity lidar simulation with ray-traced returns from photorealistic scene geometry |
| Simulation 3D Pedestrian | drivingsim3d/Simulation 3D Pedestrian | R2023a+ | Place and animate a pedestrian actor in the 3D simulation environment — use to create pedestrian crossing or jaywalking scenarios for AEB and path planning testing |
| Simulation 3D Probabilistic Radar | drivingsim3d/Simulation 3D Probabilistic Radar | R2023a+ | Generate probabilistic radar detections from the 3D simulation environment — use for realistic radar simulation with detection probability models and multi-target scenarios |
| Simulation 3D Probabilistic Radar Configuration | drivingsim3d/Simulation 3D Probabilistic Radar Configuration | R2023a+ | Configure parameters for the 3D probabilistic radar sensor — use to set detection profiles, false alarm rates, and angular resolution before running 3D radar simulations |
| Simulation 3D Scene Configuration | drivingsim3d/Simulation 3D Scene Configuration | R2023a+ | Configure the Unreal Engine 3D simulation scene including weather, lighting, and road surface — use to set up environmental conditions for sensor robustness testing across rain, fog, and night scenarios |
| Simulation 3D Ultrasonic Array | drivingsim3d/Simulation 3D Ultrasonic Array | R2023a+ | Simulate an array of ultrasonic sensors in the 3D environment — use to model multiple parking sensors simultaneously for surround detection in low-speed scenarios |
| Simulation 3D Ultrasonic Sensor | drivingsim3d/Simulation 3D Ultrasonic Sensor | R2023a+ | Simulate a single ultrasonic proximity sensor in the 3D environment — use to generate range measurements from nearby objects for parking assist algorithm development |
| Simulation 3D Vehicle with Ground Following | drivingsim3d/Simulation 3D Vehicle with Ground Following | R2023a+ | Place and drive a vehicle in the 3D environment with terrain-following suspension — use to visualize ego or traffic vehicles in the Unreal Engine scene with realistic body motion |

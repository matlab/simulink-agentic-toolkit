---
type: Simulink Block Category
title: Sensors
description: Virtual sensor models for perception testing (7 blocks)
tags: [toolbox-kb, simulink-3d-animation, camera, lidar, radar, ultrasonic, sensor]
status: stable
sources:
  - resource: matlab:sl3dlib
source: toolbox_kb
managed_by: satk
library: Simulink 3D Animation
kb_folder: simulink-3d-animation
category: sensors
block_count: 7
generated: { by: satk-toolbox-build/1, at: "2026-11-23T18:23:29Z" }
---

# Sensors

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Simulation 3D Camera | sl3dlib/Simulation 3D/Sensors/Simulation 3D Camera | R2024a+ | Attach a virtual camera to capture images in the 3D scene — use for generating synthetic camera data for perception testing |
| Simulation 3D Fisheye Camera | sl3dlib/Simulation 3D/Sensors/Simulation 3D Fisheye Camera | R2024a+ | Attach a virtual fisheye camera in the 3D scene — use for wide-angle synthetic imagery for surround-view perception testing |
| Simulation 3D Lidar | sl3dlib/Simulation 3D/Sensors/Simulation 3D Lidar | R2024a+ | Attach a virtual lidar sensor in the 3D scene — use for generating synthetic point cloud data for perception algorithm development |
| Simulation 3D Radar Data Generator | sl3dlib/Simulation 3D/Sensors/Simulation 3D Radar Data Generator | R2024a+ | Generate synthetic radar detections from the 3D scene — use for testing radar processing without physical hardware |
| Simulation 3D Ray Tracer | sl3dlib/Simulation 3D/Sensors/Simulation 3D Ray Tracer | R2024a+ | Cast rays into the 3D scene and return hit information — use for custom proximity sensing or line-of-sight checks |
| Simulation 3D Ultrasonic Array | sl3dlib/Simulation 3D/Sensors/Simulation 3D Ultrasonic Array | R2024a+ | Simulate an array of ultrasonic sensors in the 3D scene — use for testing parking assist or close-range detection algorithms |
| Simulation 3D Ultrasonic Sensor | sl3dlib/Simulation 3D/Sensors/Simulation 3D Ultrasonic Sensor | R2024a+ | Simulate a single ultrasonic sensor in the 3D scene — use for testing proximity detection at close range |

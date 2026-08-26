---
type: Simulink Block Category
title: Vehicle models
description: Vehicle dynamics models for lateral and longitudinal motion
tags: [bicycle, vehicle, dynamics, lateral, model]
status: stable
source: mathworks_toolbox
library_root: Automated Driving Toolbox
category_path: Vehicle models
block_count: 2
---

# Vehicle models

Use these blocks for vehicle models.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Bicycle Model - Force Input | drivingscenarioandsensors/Bicycle Model - Force Input | R2023b+ | Simulate lateral vehicle dynamics using a bicycle model driven by tire forces — use for controller development where longitudinal force and steering force are computed externally |
| Bicycle Model - Velocity Input | drivingscenarioandsensors/Bicycle Model - Velocity Input | R2023b+ | Simulate lateral vehicle dynamics using a bicycle model driven by velocity and steering angle — use for path-following controller testing where speed is a known input |

---
type: Simulink Block Category
title: Scenario sensor modeling
description: Cuboid driving scenarios and statistical sensor models
tags: [driving scenario and sensor modeling, detection generator, scenario reader, bicycle model, ins, vehicle to world, world to vehicle, cuboid]
status: stable
source: custom_library
library_root: Automated Driving Toolbox
category_path: Scenario sensor modeling
block_count: 15
---

# Scenario sensor modeling

Use these blocks for scenario sensor modeling.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Bicycle Model - Force Input | drivingscenarioandsensors/Bicycle Model - Force Input | R2023b+ | Simulate lateral vehicle dynamics with a 3-DOF bicycle model driven by tire forces — use for handling and controls studies with force inputs. |
| Bicycle Model - Velocity Input | drivingscenarioandsensors/Bicycle Model - Velocity Input | R2023b+ | Simulate lateral vehicle dynamics with a 3-DOF bicycle model driven by velocity/steering commands — use for kinematic path-tracking studies. |
| Cuboid To 3D Simulation | drivingscenarioandsensors/Cuboid To 3D Simulation | R2023a+ | Convert cuboid driving-scenario actors into 3D-simulation actor poses — use to bridge a cuboid scenario into the photorealistic 3D world. |
| Driving Radar Data Generator | drivingscenarioandsensors/Driving Radar Data Generator | R2023a+ | Generate synthetic radar detections and tracks from scenario ground truth — use to model an automotive radar for perception testing. |
| INS | drivingscenarioandsensors/INS | R2023a+ | Model a fused inertial navigation output (position/orientation/velocity) with error characteristics — use to simulate an INS/GNSS estimate. |
| Ideal Ground Truth Sensor | drivingscenarioandsensors/Ideal Ground Truth Sensor | R2025a+ | Report exact ground-truth actor poses from the scenario — use as a perfect reference for evaluating perception and tracking. |
| Radar Detection Generator | drivingscenarioandsensors/Radar Detection Generator | R2023a+ | Generate synthetic radar detections from scenario ground truth — use to model a radar sensor in cuboid driving scenarios. |
| Scenario Reader | drivingscenarioandsensors/Scenario Reader | R2023a+ | Read actors and roads from a driving-scenario file into the model — use to play back a designed scenario during simulation. |
| Ultrasonic Detection Generator | drivingscenarioandsensors/Ultrasonic Detection Generator | R2023a+ | Generate synthetic ultrasonic range detections from scenario ground truth — use to model parking/proximity sensors. |
| Vehicle To World | drivingscenarioandsensors/Vehicle To World | R2023a+ | Transform poses and positions from the ego-vehicle frame to world coordinates — use to place vehicle-relative data on the map. |
| Vision Detection Generator | drivingscenarioandsensors/Vision Detection Generator | R2023a+ | Generate synthetic camera-based object detections from scenario ground truth — use to model a vision sensor for perception testing. |
| World To Vehicle | drivingscenarioandsensors/World To Vehicle | R2023a+ | Transform poses and positions from world coordinates to the ego-vehicle frame — use to express map data relative to the vehicle. |
| Lidar Point Cloud Generator | drivingscenarioandsensors/Lidar Point Cloud Generator | R2023a+ | Generate a point cloud from simulated roads and actor poses in a driving scenario. The block can simulate added noise at a specified range accuracy using a statistical model. The block also provides parameters to exclude the ego vehicle and roads from the generated point cloud. |
| Simulation 3D Vision Detection Generator | drivingsim3d/Simulation 3D Vision Detection Generator | R2023a+ | Generates object and lane detections for actors and lanes in the 3D visualization environment. If you set the sample time to -1, the block uses the sample time specified in the Simulation 3D Scene Configuration block. To use this sensor, ensure that the Simulation 3D Scene Configuration block is in your model. |
| Lateral Controller Stanley | drivingvehiclecontroller/Lateral Controller Stanley | R2023a+ | Compute the steering angle command in degrees that controls the current pose of the vehicle with respect to the desired reference pose, using the Stanley method. The RefPose port accepts a 1-by-3 vector [x, y, theta] as the position of the reference point on the path and the orientation of the path at the point in degrees. In forward motion, the reference point is the nearest point on the path to the center of the front axle of the vehicle. In reverse motion, the reference point is the nearest point on the path to the center of the rear axle. The CurrPose port accepts a 1-by-3 vector [x, y, theta] as the position of the center of the rear axle and the heading angle of the vehicle in degrees. The CurrVelocity port accepts a scalar as the current longitudinal velocity of the vehicle in meters/second. The Direction port accepts a scalar representing the driving direction: 1 for forward motion and -1 for reverse motion. Setting the Vehicle model parameter to Dynamic bicycle model enables additional input ports. The Curvature port accepts a scalar representing the curvature of the path at the reference point. The CurrYawRate port accepts a scalar as the current yaw rate in degrees/second. The CurrSteer port accepts a scalar representing the current steering angle in degrees. |

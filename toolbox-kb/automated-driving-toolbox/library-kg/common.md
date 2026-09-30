---
type: Block Selection Guide
title: Common Blocks
description: High-value blocks selected for quick agent discovery.
status: stable
source: custom_library
block_count: 25
---

# Common Blocks

Prefer these blocks when their intent matches the user request.

| Intent | Preferred Block | Library |
|---|---|---|
| Track multiple objects over time from sensor detections using global nearest-neighbor assignment — use for object tracking in ADAS/autonomous perception. | Multi-Object Tracker | Automated Driving Toolbox |
| Generate synthetic radar detections and tracks from scenario ground truth — use to model an automotive radar for perception testing. | Driving Radar Data Generator | Automated Driving Toolbox |
| Read actors and roads from a driving-scenario file into the model — use to play back a designed scenario during simulation. | Scenario Reader | Automated Driving Toolbox |
| Generate synthetic camera-based object detections from scenario ground truth — use to model a vision sensor for perception testing. | Vision Detection Generator | Automated Driving Toolbox |
| Model a pinhole camera in the 3D simulation environment — use to render synthetic camera imagery for perception testing. | Simulation 3D Camera | Automated Driving Toolbox |
| Configure and connect to the 3D simulation scene (world, weather, sample time) — required once per model to drive the 3D environment. | Simulation 3D Scene Configuration | Automated Driving Toolbox |
| Spawn a vehicle in the 3D scene that follows terrain elevation — use to place a drivable vehicle in the photorealistic world. | Simulation 3D Vehicle with Ground Following | Automated Driving Toolbox |
| Informational block linking to Automated Driving Toolbox example models — not used in production designs. | Demos | Automated Driving Toolbox |
| Interface block that co-simulates the model with a RoadRunner scenario — use to drive Simulink from RoadRunner actors. | RoadRunner Scenario | Automated Driving Toolbox |
| Read actor and state data from a RoadRunner scenario into the model — use to consume RoadRunner data in Simulink. | RoadRunner Scenario Reader | Automated Driving Toolbox |
| Write actor and state data from the model back to a RoadRunner scenario — use to publish Simulink results into RoadRunner. | RoadRunner Scenario Writer | Automated Driving Toolbox |
| Generate a point cloud from simulated roads and actor poses in a driving scenario. The block can simulate added noise at a specified range accuracy using a statistical model. The block also provides parameters to exclude the ego vehicle and roads from the generated point cloud. | Lidar Point Cloud Generator | Automated Driving Toolbox |
| Generates object and lane detections for actors and lanes in the 3D visualization environment. If you set the sample time to -1, the block uses the sample time specified in the Simulation 3D Scene Configuration block. To use this sensor, ensure that the Simulation 3D Scene Configuration block is in your model. | Simulation 3D Vision Detection Generator | Automated Driving Toolbox |
| Compute the steering angle command in degrees that controls the current pose of the vehicle with respect to the desired reference pose, using the Stanley method. The RefPose port accepts a 1-by-3 vector [x, y, theta] as the position of the reference point on the path and the orientation of the path at the point in degrees. In forward motion, the reference point is the nearest point on the path to the center of the front axle of the vehicle. In reverse motion, the reference point is the nearest point on the path to the center of the rear axle. The CurrPose port accepts a 1-by-3 vector [x, y, theta] as the position of the center of the rear axle and the heading angle of the vehicle in degrees. The CurrVelocity port accepts a scalar as the current longitudinal velocity of the vehicle in meters/second. The Direction port accepts a scalar representing the driving direction: 1 for forward motion and -1 for reverse motion. Setting the Vehicle model parameter to Dynamic bicycle model enables additional input ports. The Curvature port accepts a scalar representing the curvature of the path at the reference point. The CurrYawRate port accepts a scalar as the current yaw rate in degrees/second. The CurrSteer port accepts a scalar representing the current steering angle in degrees. | Lateral Controller Stanley | Automated Driving Toolbox |
| Simulate lateral vehicle dynamics with a 3-DOF bicycle model driven by tire forces — use for handling and controls studies with force inputs. | Bicycle Model - Force Input | Automated Driving Toolbox |
| Simulate lateral vehicle dynamics with a 3-DOF bicycle model driven by velocity/steering commands — use for kinematic path-tracking studies. | Bicycle Model - Velocity Input | Automated Driving Toolbox |
| Spawn and animate a bicyclist actor in the 3D simulation scene — use to add a vulnerable road user for perception testing. | Simulation 3D Bicyclist | Automated Driving Toolbox |
| Model a fisheye camera in the 3D simulation environment — use to generate wide-FOV synthetic imagery. | Simulation 3D Fisheye Camera | Automated Driving Toolbox |
| Model a lidar sensor in the 3D simulation environment — use to generate synthetic point clouds for perception testing. | Simulation 3D Lidar | Automated Driving Toolbox |
| Spawn and animate a pedestrian actor in the 3D simulation scene — use to add a vulnerable road user for perception testing. | Simulation 3D Pedestrian | Automated Driving Toolbox |
| Model a probabilistic radar sensor in the 3D simulation environment — use to generate statistically-modeled radar detections. | Simulation 3D Probabilistic Radar | Automated Driving Toolbox |
| Concatenate detections from multiple sensors into a single list — use to feed a combined detection stream to a tracker. | Detection Concatenation | Automated Driving Toolbox |
| Smooth a reference path into a curvature-continuous spline — use to produce drivable paths from coarse waypoints. | Path Smoother Spline | Automated Driving Toolbox |
| Generate a velocity profile along a path that respects acceleration and curvature limits — use to plan feasible speeds for a planned trajectory. | Velocity Profiler | Automated Driving Toolbox |
| Compute acceleration and deceleration commands that control the velocity of a vehicle given the reference velocity, the current velocity, and the current driving direction. The controller is implemented as a discrete Proportional-Integral (PI) controller with integral anti-windup. To reset the integral of velocity error to zero, pass a nonzero value to the Reset port. The Direction port accepts a scalar representing the driving direction with two possible values: 1 for forward motion and -1 for reverse motion. The outputs AccelCmd and DecelCmd are saturated by the maximum longitudinal acceleration and the maximum longitudinal deceleration parameters. | Longitudinal Controller Stanley | Automated Driving Toolbox |

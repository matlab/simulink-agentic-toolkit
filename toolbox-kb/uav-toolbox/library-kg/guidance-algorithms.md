---
type: Simulink Block Category
title: Guidance algorithms
description: Path following, trajectory generation, and obstacle avoidance
tags: [algorithms, follower, trajectory, obstacle, point mass, polynomial]
status: stable
source: custom_library
library_root: UAV Toolbox
category_path: Guidance algorithms
block_count: 11
---

# Guidance algorithms

Use these blocks for guidance algorithms.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Fixed-Wing UAV Point Mass | uavalgslib/Fixed-Wing UAV Point Mass | R2023a+ | Simulate fixed-wing UAV motion as a point-mass model driven by throttle and attitude commands — use for lightweight guidance and trajectory studies without full 6-DOF dynamics. |
| Minimum Jerk Polynomial Trajectory | uavalgslib/Minimum Jerk Polynomial Trajectory | R2023a+ | Generate a smooth minimum-jerk polynomial trajectory through waypoints — use to plan comfortable, low-acceleration UAV paths. |
| Minimum Snap Polynomial Trajectory | uavalgslib/Minimum Snap Polynomial Trajectory | R2023a+ | Generate a smooth minimum-snap polynomial trajectory through waypoints — use to plan aggressive but dynamically-feasible multirotor paths. |
| Obstacle Avoidance | uavalgslib/Obstacle Avoidance | R2023a+ | Compute a collision-free steering command from occupancy/sensor data — use to reactively avoid obstacles during flight. |
| Orbit Follower | uavalgslib/Orbit Follower | R2023a+ | Command a UAV to orbit a point at a set radius and direction — use for loiter and target-circling behaviors. |
| Waypoint Follower | uavalgslib/Waypoint Follower | R2023a+ | Produce lookahead guidance commands to follow a sequence of waypoints — use for path-following autopilots. |
| Guidance Model | uavalgslib/Guidance Model | R2023a+ | Reduced-order model for a closed-loop system including UAV dynamics and autopilot. The model approximates the behavior of a closed-loop system consisting of an autopilot controller and a kinematic UAV model for 3D motion. This guidance model is designed for small multirotor and fixed-wing UAVs. The block accepts control and environment inputs (bus signals) and outputs the UAV state (bus signal). Use the Model Type drop-down to switch between fixed-wing and multirotor based on the type of UAV you are trying to model. Use the Data Type combo box to change the data type used by the numeric values within the input and output bus signals. Supported data types are 'double' and 'single'. Use the Initial State tab to configure the UAV's initial state according to the selected UAV model. Use the Configuration tab to configure the UAV's autopilot control gains. Use the Input/Output Bus Names tab to configure the bus signal names used by the block. |
| Multi-Instance Guidance Model | uavalgslib/Multi-Instance Guidance Model | R2025a+ | Simulate multiple UAVs using reduced-order multirotor and fixed-wing UAV models. The control input port accepts a bus. For fixed-wing UAV, the bus contains Height, Airspeed, and RollAngle signals. For multirotor UAV, the bus contains Roll, Pitch, YawRate, and Thrust signals. Specify each signal as a [1xN] vector of single or double precision values, where N is the number of UAV that you want to simulate. The environment input port accepts a bus. For fixed-wing UAV, the bus contains WindNorth, WindEast, WindDown, and Gravity signals. For multirotor UAV, the bus contain only the Gravity signal. Specify each signal as a [1xN] vector of single or double precision values, where N is the number of UAV that you want to simulate. The block outputs the UAV state as a bus. For fixed-wing UAV, the bus contains North, East, Height, AirSpeed, HeadingAngle, FlightPathAngle, RollAngle, and RollAngleRate signals, where each signal is a [1xN] vector of single or double precision data. For multirotor UAV, the bus consists of WorldPosition, WorldVelocity, EulerZYX, and BodyAngularRateRPY signals as [3xN] matrix, and Thrust signal as [1xN] vector of single or double precision data. Use the Model Type parameter to select the fixed-wing or multirotor model. Use the Data Type parameter to select single or double-precision data type for the inputs and outputs. Specify the UAV's autopilot control gains in the Configuration tab. |
| Path Manager | uavalgslib/Path Manager | R2023a+ | Execute a UAV autonomous mission. The block switches sequentially between the mission points in the mission data. The Pose input is a 4x1 matrix containing the current [x,y,z] position and course angle of the UAV. The MissionData input accepts mission data (bus signal) representing the mission points. Use the boolean isModeDone input to switch to the next mission point. Change the block behaviour at run-time using the uint8 MissionCmd input signal. The Home input is a 3x1 matrix containing the home [x,y,z] location. Switch between a fixed-wing and multi-rotor with the UAV type drop-down. For a fixed-wing UAV, specify the Loiter radius in meters. Specify the data type using the Data type combo box to change the data type of the UAV mission bus. Specify the name of the input bus using the Mission bus name edit box. |
| UAV Scenario Configuration | uavsimlib/UAV Scenario Configuration | R2023a+ | Import a uavScenario object and simulate the scenario. You must have this block in models that have UAV Scenario sensor and motion blocks to test perception, control and planning algorithms with data from uavScenario environment. Sample time must be a positive value. This block only supports discrete sample time. |
| Read UAV Trajectory | uavutilslib/Read UAV Trajectory | R2024b+ | Generate translation and rotation samples from UAV trajectory source. The block accepts a scalar numeric value that specifies the trajectory sample time. Translation port outputs the xyz-position of UAV relative to inertial frame as a [1x3] vector of double-precision data. Rotation port outputs the Euler ZYX angle that rotates the inertial frame to the UAV body frame as a [1x3] vector of double-precision data. |

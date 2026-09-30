---
type: Simulink Block Category
title: Controller interface
description: Read vehicle state and issue setpoints when authoring custom ArduPilot controllers
tags: [controller interface, setpoint, current, attitude, velocity, position]
status: stable
source: custom_library
library_root: UAV Toolbox Support Package for ArduPilot Autopilots
category_path: Controller interface
block_count: 10
---

# Controller interface

Use these blocks for controller interface.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Ang Velocity Setpoint | ardupilotControllerInterfacelib/Ang Velocity Setpoint | R2026a+ | Send the commanded angular-velocity (body-rate) setpoint to the ArduPilot controller interface — use when authoring a custom rate controller for an ArduPilot vehicle. |
| Attitude Setpoint | ardupilotControllerInterfacelib/Attitude Setpoint | R2026a+ | Send the commanded attitude (orientation) setpoint to the ArduPilot controller — use when authoring a custom attitude controller. |
| Current Ang Velocity | ardupilotControllerInterfacelib/Current Ang Velocity | R2026a+ | Read the vehicle's current angular velocity from ArduPilot — use as feedback in a custom rate controller. |
| Current Attitude | ardupilotControllerInterfacelib/Current Attitude | R2026a+ | Read the vehicle's current attitude estimate from ArduPilot — use as feedback in a custom attitude controller. |
| Current Position | ardupilotControllerInterfacelib/Current Position | R2026a+ | Read the vehicle's current position estimate from ArduPilot — use as feedback for guidance or position control. |
| Current Velocity | ardupilotControllerInterfacelib/Current Velocity | R2026a+ | Read the vehicle's current velocity estimate from ArduPilot — use as feedback for velocity control. |
| Position Setpoint | ardupilotControllerInterfacelib/Position Setpoint | R2025b+ | Send the commanded position setpoint to the ArduPilot controller — use when authoring a custom position/guidance controller. |
| Velocity Setpoint | ardupilotControllerInterfacelib/Velocity Setpoint | R2026a+ | Send the commanded velocity setpoint to the ArduPilot controller — use when authoring a custom velocity controller. |
| ArduPlane Actuator Write | ardupilotControllerInterfacelib/ArduPlane Actuator Write | R2025b+ | Set actuator values for Motors and Servos. The block accepts single scalar values between -1 to 1 as input and writes those values to the selected Motors/Servos. An input value of 1 indicates maximum output, 0 indicates centered servos or minimum motor thrust, and -1 indicates maximum output in the opposite direction (if supported). Configure the Actuators in Mission Planner. For more information, click 'Help'. |
| Write Torque & Thrust | ardupilotControllerInterfacelib/Write Torque & Thrust | R2025b+ | Write the normalized torque and thrust command in the range of [-1, 1] for roll, pitch, and yaw and [0, 1] for throttle to the ArduPilot Mixer. A custom mixer matrix can be defined in this block for custom airframe. |

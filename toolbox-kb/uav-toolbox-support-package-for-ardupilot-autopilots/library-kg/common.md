---
type: Block Selection Guide
title: Common Blocks
description: High-value blocks selected for quick agent discovery.
status: stable
source: custom_library
block_count: 12
---

# Common Blocks

Prefer these blocks when their intent matches the user request.

| Intent | Preferred Block | Library |
|---|---|---|
| Send the commanded attitude (orientation) setpoint to the ArduPilot controller — use when authoring a custom attitude controller. | Attitude Setpoint | UAV Toolbox Support Package for ArduPilot Autopilots |
| Read the vehicle's current attitude estimate from ArduPilot — use as feedback in a custom attitude controller. | Current Attitude | UAV Toolbox Support Package for ArduPilot Autopilots |
| Read the vehicle's current position estimate from ArduPilot — use as feedback for guidance or position control. | Current Position | UAV Toolbox Support Package for ArduPilot Autopilots |
| Read the vehicle's current velocity estimate from ArduPilot — use as feedback for velocity control. | Current Velocity | UAV Toolbox Support Package for ArduPilot Autopilots |
| Send the commanded position setpoint to the ArduPilot controller — use when authoring a custom position/guidance controller. | Position Setpoint | UAV Toolbox Support Package for ArduPilot Autopilots |
| Send the commanded velocity setpoint to the ArduPilot controller — use when authoring a custom velocity controller. | Velocity Setpoint | UAV Toolbox Support Package for ArduPilot Autopilots |
| Set actuator values for Motors and Servos. The block accepts single scalar values between -1 to 1 as input and writes those values to the selected Motors/Servos. An input value of 1 indicates maximum output, 0 indicates centered servos or minimum motor thrust, and -1 indicates maximum output in the opposite direction (if supported). Configure the Actuators in Mission Planner. For more information, click 'Help'. | ArduPlane Actuator Write | UAV Toolbox Support Package for ArduPilot Autopilots |
| Write the normalized torque and thrust command in the range of [-1, 1] for roll, pitch, and yaw and [0, 1] for throttle to the ArduPilot Mixer. A custom mixer matrix can be defined in this block for custom airframe. | Write Torque & Thrust | UAV Toolbox Support Package for ArduPilot Autopilots |
| Send the commanded angular-velocity (body-rate) setpoint to the ArduPilot controller interface — use when authoring a custom rate controller for an ArduPilot vehicle. | Ang Velocity Setpoint | UAV Toolbox Support Package for ArduPilot Autopilots |
| Read the vehicle's current angular velocity from ArduPilot — use as feedback in a custom rate controller. | Current Ang Velocity | UAV Toolbox Support Package for ArduPilot Autopilots |
| RC Receive block fetches raw channel data, with optional trim and deadzone adjustments from RC transmitter signals for the selected channels. | RC Receive | UAV Toolbox Support Package for ArduPilot Autopilots |
| Read the current ArduPilot system timestamp — use to time-stamp data or compute time deltas in deployed control code. | Timestamp | UAV Toolbox Support Package for ArduPilot Autopilots |

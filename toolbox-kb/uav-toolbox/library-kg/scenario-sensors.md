---
type: Simulink Block Category
title: Scenario sensors
description: Scenario-based sensor models (GPS, INS, barometer)
tags: [scenario, gps, ins, barometer, sensor modeling]
status: stable
source: custom_library
library_root: UAV Toolbox
category_path: Scenario sensors
block_count: 7
---

# Scenario sensors

Use these blocks for scenario sensors.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| MAVLink Deserializer | uavmavlinklib/MAVLink Deserializer | R2023a+ | The MAVLink Deserializer accepts a MAVLink data stream consisting of uint8 values and filters the stream for the selected MAVLink message type. The block outputs a Simulink bus that contains the corresponding payload data along with System ID, Component ID, and Sequence. The IsNew output is a boolean indicating whether a new MAVLink message for the requested message ID is available. When IsNew is true, the Msg port outputs the new MAVLink message. If the deserialization is in progress or no new MAVLink message is available, IsNew is false and Msg port holds the last received MAVLink message. Select the "Filter output MAVLink messages by System ID" and "Filter output MAVLink messages by Component ID" parameters to filter the incoming MAVLink messages for a given System ID and Component ID. If more than one message for the same message ID is available, the MAVLink Deserializer outputs the latest MAVLink message. To queue the messages in the incoming buffer and output the oldest message, select the parameter "Queue MAVLink messages in output". |
| Barometer | uavsimlib/Barometer | R2025a+ | Model a barometric pressure/altitude sensor with configurable noise — use to simulate altitude measurements for state estimation. |
| GPS | uavsimlib/GPS | R2023a+ | Model a GPS receiver producing position and velocity with configurable noise — use to simulate satellite navigation measurements. |
| INS | uavsimlib/INS | R2023a+ | Model a fused inertial navigation output (position/orientation/velocity) with error characteristics — use to simulate an INS/GNSS estimate. |
| UAV Scenario Get Transform | uavsimlib/UAV Scenario Get Transform | R2023a+ | Get 4x4 transform matrix that maps points in source frame to target frame in UAV Scenario. Use the Select button to choose the source frame and target frame based on the scenario currently loaded in your model. To use this block, ensure that UAV Scenario Configuration block is in your model. This block uses the sample time specified in the UAV Scenario Configuration block. |
| UAV Scenario Motion Read | uavsimlib/UAV Scenario Motion Read | R2023a+ | Read platform and sensor motions from UAV scenario simulation. Use the Select button to choose the platform or sensor to read from based on the scenario currently loaded in your model. To use this block, ensure that UAV Scenario Configuration block is in your model. This block uses the sample time specified in the UAV Scenario Configuration block. |
| UAV Scenario Motion Write | uavsimlib/UAV Scenario Motion Write | R2023a+ | Update platform motion in UAV scenario simulation. Use the Select button to choose the platform to write to based on the scenario currently loaded in your model. Position, Velocity and Acceleration are 1x3 vectors that describe the platform's linear motion in the coordinate frame of your choice. Orientation is a 1x4 quaternion that describes the frame rotation from the input coordinate frame to platform's body frame. Angular Velocity is a 1x3 vector that describes the platforms rotation rate in the input coordinate frame. To use this block, ensure that UAV Scenario Configuration block is in your model. This block uses the sample time specified in the UAV Scenario Configuration block. |

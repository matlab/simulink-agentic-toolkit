---
type: Simulink Block Category
title: Communication
description: Network and device-to-host data exchange on iOS
tags: [tcp, udp, communication, network, send, receive]
status: stable
source: custom_library
library_root: Simulink Support Package for Apple iOS Devices
category_path: Communication
block_count: 7
---

# Communication

Use these blocks for communication.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| FromApp | iosadvancedlib/FromApp | R2023a+ | Receive data from a method in the generated app. The block calls the specified method of the app's InfoViewController. The block outputs the values returned by the method as an [Nx1] array. |
| ToApp | iosadvancedlib/ToApp | R2023a+ | Send data to a method in the generated app. The block calls the specified method of the app's InfoViewController. The block accepts 1-D arrays of type uint8, int8, uint16, int16, uint32, int32, single or double. |
| TCP/IP Receive | ioscommunicationlib/TCP/IP Receive | R2023a+ | Receive data over a TCP/IP network connection on an Apple iOS device — use to stream sensor data, setpoints, or commands into a model deployed to iPhone/iPad. |
| TCP/IP Send | ioscommunicationlib/TCP/IP Send | R2023a+ | Send data over a TCP/IP network connection from an Apple iOS device — use to stream results, telemetry, or commands out of a model deployed to iPhone/iPad. |
| ThingSpeak Write | ioscommunicationlib/ThingSpeak Write | R2023a+ | Send data to ThingSpeak. Each input port accepts numeric scalars. Set Update interval parameter to the number of seconds to wait between two successive data send requests. The minimum update interval for a free channel is 15 seconds. |
| UDP Receive | ioscommunicationlib/UDP Receive | R2023a+ | Receive UDP packets from another UDP host on an Internet network. The block outputs the values received as an [Nx1] array. Set the Local IP port parameter to the port number used by the sending UDP host. |
| UDP Send | ioscommunicationlib/UDP Send | R2023a+ | Send UDP packets to another UDP host on an Internet network. The block accepts 1-D arrays of type uint8, int8, uint16, int16, uint32, int32, single or double. Set the Remote IP address and Remote IP port parameters to the IP address and port number of the receiving UDP host, respectively. |

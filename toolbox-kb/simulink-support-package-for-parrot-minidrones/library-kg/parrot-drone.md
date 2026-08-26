---
type: Simulink Block Category
title: Parrot drone
description: Parrot minidrone communication and accessory control
tags: [parrot, drone, udp, camera, flight]
status: stable
source: mathworks_toolbox
library_root: Simulink Support Package for Parrot Minidrones
category_path: Parrot drone
block_count: 8
---

# Parrot drone

Use these blocks for parrot drone.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Keyboard Read | parrotlib/Keyboard Read | R2023a+ | Read keyboard input during simulation — use for manual pilot control or interactive testing of drone flight algorithms |
| Cannon | parrotlib/Cannon | R2023a+ | Fire the cannon accessory on a Parrot minidrone — use for triggering the ball launcher in drone competition or gamification scenarios |
| Grabber | parrotlib/Grabber | R2023a+ | Control the grabber accessory on a Parrot minidrone — use for picking up and releasing objects in autonomous retrieval missions |
| PARROT Image Conversion | parrotlib/PARROT Image Conversion | R2023a+ | Convert raw camera images from Parrot drone format — use for preprocessing onboard camera data before computer vision algorithms |
| TCP/IP Receive | parrotlib/TCP/IP Receive | R2023a+ | Receive data over TCP/IP from a Parrot drone — use for receiving telemetry, status, or sensor data from the drone during flight |
| TCP/IP Send | parrotlib/TCP/IP Send | R2023a+ | Send data over TCP/IP to a Parrot drone — use for transmitting commands or configuration to the drone during operation |
| UDP Receive | parrotlib/UDP Receive | R2023a+ | Receive data over UDP from a Parrot drone — use for low-latency reception of video, sensor, or navigation data from the drone |
| UDP Send | parrotlib/UDP Send | R2023a+ | Send data over UDP to a Parrot drone — use for low-latency command transmission to the drone flight controller |

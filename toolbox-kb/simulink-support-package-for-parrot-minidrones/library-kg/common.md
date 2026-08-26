---
type: Block Selection Guide
title: Common Blocks
description: High-value blocks selected for quick agent discovery.
status: stable
source: mathworks_toolbox
block_count: 3
---

# Common Blocks

Prefer these blocks when their intent matches the user request.

| Intent | Preferred Block | Library |
|---|---|---|
| Convert raw camera images from Parrot drone format — use for preprocessing onboard camera data before computer vision algorithms | PARROT Image Conversion | Simulink Support Package for Parrot Minidrones |
| Receive data over UDP from a Parrot drone — use for low-latency reception of video, sensor, or navigation data from the drone | UDP Receive | Simulink Support Package for Parrot Minidrones |
| Send data over UDP to a Parrot drone — use for low-latency command transmission to the drone flight controller | UDP Send | Simulink Support Package for Parrot Minidrones |

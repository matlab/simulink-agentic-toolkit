---
type: Block Selection Guide
title: Common Blocks
description: High-value blocks selected for quick agent discovery.
status: stable
source: mathworks_toolbox
block_count: 5
---

# Common Blocks

Prefer these blocks when their intent matches the user request.

| Intent | Preferred Block | Library |
|---|---|---|
| Estimate orientation using an Attitude and Heading Reference System filter — use for fusing accelerometer, gyroscope, and magnetometer data into robust orientation estimates | AHRS | Navigation Toolbox |
| Simulate GPS receiver measurements — use for generating realistic position and velocity readings with configurable noise and satellite geometry | GPS | Navigation Toolbox |
| Simulate inertial measurement unit sensor readings — use for generating realistic accelerometer and gyroscope measurements with configurable noise models | IMU | Navigation Toolbox |
| Simulate integrated navigation system measurements — use for generating fused position, velocity, and orientation data from a combined GPS/IMU system | INS | Navigation Toolbox |
| Follow a path using the pure pursuit steering algorithm — use for autonomous vehicle or robot lateral control to track waypoint-based reference paths | Pure Pursuit | Navigation Toolbox |

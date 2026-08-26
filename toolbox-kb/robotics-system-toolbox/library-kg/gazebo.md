---
type: Simulink Block Category
title: Gazebo
description: Gazebo co-simulation interface
tags: [gazebo, pacer, entity, command]
status: stable
source: mathworks_toolbox
library_root: Robotics System Toolbox
category_path: Gazebo
block_count: 7
---

# Gazebo

Use these blocks for gazebo.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Gazebo Apply Command | robotgazebolib/Gazebo Apply Command | R2023a+ | Send a command to a Gazebo simulation entity — use for applying forces, torques, or joint commands in Gazebo |
| Gazebo Blank Message | robotgazebolib/Gazebo Blank Message | R2023a+ | Create an empty Gazebo message — use for initializing Gazebo communication structures |
| Gazebo Pacer | robotgazebolib/Gazebo Pacer | R2023a+ | Synchronize Simulink and Gazebo simulation rates — use for ensuring lockstep co-simulation timing |
| Gazebo Publish | robotgazebolib/Gazebo Publish | R2023a+ | Publish data to Gazebo — use for sending commands or signals from Simulink to the Gazebo simulator |
| Gazebo Read | robotgazebolib/Gazebo Read | R2023a+ | Read state data from Gazebo — use for getting joint positions, velocities, or link poses from the simulator |
| Gazebo Select Entity | robotgazebolib/Gazebo Select Entity | R2023a+ | Select a Gazebo model or link — use for specifying which simulation entity to interact with |
| Gazebo Subscribe | robotgazebolib/Gazebo Subscribe | R2023a+ | Subscribe to Gazebo data — use for receiving sensor or state updates from the Gazebo simulator |

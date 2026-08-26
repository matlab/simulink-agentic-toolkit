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
| Control a specific traffic participant (vehicle, pedestrian, or cyclist) in the SUMO simulation — use to override SUMO-managed actor behavior with Simulink-computed trajectories for ego or controlled vehicles | Actor | Automated Driving Toolbox Interface for Eclipse SUMO Traffic Simulator |
| Establish and manage the TraCI connection to a running SUMO traffic simulation — use as the central communication hub that synchronizes simulation time steps between Simulink and SUMO | Client | Automated Driving Toolbox Interface for Eclipse SUMO Traffic Simulator |
| Read traffic state data (vehicle positions, speeds, traffic light phases) from the SUMO simulation — use to import the current traffic environment state into Simulink for perception or planning algorithms | Reader | Automated Driving Toolbox Interface for Eclipse SUMO Traffic Simulator |

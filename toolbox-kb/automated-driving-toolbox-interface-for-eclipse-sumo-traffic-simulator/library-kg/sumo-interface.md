---
type: Simulink Block Category
title: Sumo interface
description: Eclipse SUMO traffic simulator co-simulation blocks for closed-loop testing with microscopic traffic
tags: [sumo, traffic, traci, cosimulation, vehicle]
status: stable
source: mathworks_toolbox
library_root: Automated Driving Toolbox Interface for Eclipse SUMO Traffic Simulator
category_path: Sumo interface
block_count: 5
---

# Sumo interface

Use these blocks for sumo interface.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Actor | SumoInterfaceLibrary/Actor | R2026a+ | Control a specific traffic participant (vehicle, pedestrian, or cyclist) in the SUMO simulation — use to override SUMO-managed actor behavior with Simulink-computed trajectories for ego or controlled vehicles |
| Client | SumoInterfaceLibrary/Client | R2026a+ | Establish and manage the TraCI connection to a running SUMO traffic simulation — use as the central communication hub that synchronizes simulation time steps between Simulink and SUMO |
| Reader | SumoInterfaceLibrary/Reader | R2026a+ | Read traffic state data (vehicle positions, speeds, traffic light phases) from the SUMO simulation — use to import the current traffic environment state into Simulink for perception or planning algorithms |
| Server | SumoInterfaceLibrary/Server | R2026a+ | Launch and manage a SUMO traffic simulation server instance — use to start SUMO with a specified network and route configuration, controlling its lifecycle from within Simulink |
| Writer | SumoInterfaceLibrary/Writer | R2026a+ | Send commands and data to the SUMO simulation (e.g., set traffic light phases, add vehicles) — use to modify the traffic environment dynamically based on Simulink controller decisions |

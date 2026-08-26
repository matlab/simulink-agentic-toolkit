---
type: Simulink Block Category
title: Roadrunner
description: RoadRunner co-simulation for high-fidelity road environments
tags: [roadrunner, cosimulation, scenario, writer, reader]
status: stable
source: mathworks_toolbox
library_root: Automated Driving Toolbox
category_path: Roadrunner
block_count: 3
---

# Roadrunner

Use these blocks for roadrunner.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| RoadRunner Scenario | roadrunnerscenario/RoadRunner Scenario | R2023a+ | Co-simulate with a RoadRunner scenario providing high-fidelity road networks and traffic — use when the driving environment requires detailed road geometry, signage, and traffic signals from RoadRunner |
| RoadRunner Scenario Reader | roadrunnerscenario/RoadRunner Scenario Reader | R2023a+ | Read actor poses and road data from a running RoadRunner co-simulation — use to import real-time traffic participant states into Simulink for closed-loop testing |
| RoadRunner Scenario Writer | roadrunnerscenario/RoadRunner Scenario Writer | R2023a+ | Send ego vehicle state back to a RoadRunner co-simulation — use to close the loop by updating the ego pose in RoadRunner based on Simulink controller outputs |

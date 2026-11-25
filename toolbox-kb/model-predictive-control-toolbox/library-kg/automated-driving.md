---
type: Simulink Block Category
title: Automated driving
description: Pre-built MPC-based automated driving controllers (4 blocks)
tags: [toolbox-kb, model-predictive-control-toolbox, cruise, lane, path, vehicle, driving]
status: stable
sources:
  - resource: matlab:mpclib
source: toolbox_kb
managed_by: satk
library: Model Predictive Control Toolbox
kb_folder: model-predictive-control-toolbox
category: automated-driving
block_count: 4
generated: { by: satk-toolbox-build/1, at: "2026-11-23T18:23:24Z" }
---

# Automated driving

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Adaptive Cruise Control System | mpclib/Automated Driving/Adaptive Cruise Control System | R2023a+ | Pre-built adaptive cruise control using MPC — use for maintaining desired speed while keeping safe following distance from a lead vehicle |
| Lane Keeping Assist System | mpclib/Automated Driving/Lane Keeping Assist System | R2023a+ | Pre-built lane keeping assist using MPC — use for automatic steering to keep a vehicle centered within lane markings |
| Path Following Control System | mpclib/Automated Driving/Path Following Control System | R2023a+ | Pre-built path following controller using MPC — use for tracking a reference path with combined lateral and longitudinal vehicle control |
| Vehicle Path Planner System | mpclib/Automated Driving/Vehicle Path Planner System | R2023a+ | Pre-built vehicle path planner using MPC — use for generating collision-free trajectories that satisfy vehicle dynamics constraints |

---
type: Simulink Block Category
title: Rotor dynamics
description: Helicopter and multirotor rotor models (4 blocks)
tags: [toolbox-kb, aerospace-blockset, rotor, blade, inflow, multirotor, helicopter]
status: stable
sources:
  - resource: matlab:aerolibinflowmodels
source: toolbox_kb
managed_by: satk
library: Aerospace Blockset
kb_folder: aerospace-blockset
category: rotor-dynamics
block_count: 4
generated: { by: satk-toolbox-build/1, at: "2026-11-23T18:23:13Z" }
---

# Rotor dynamics

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Dynamic Inflow (3-State) | aerolibinflowmodels/Dynamic Inflow (3-State) | R2026a+ | Model rotor induced velocity using Pitt-Peters 3-state dynamic inflow — provides uniform and first-harmonic inflow for helicopter trim and stability |
| Dynamic Inflow (Finite-State) | aerolibinflowmodels/Dynamic Inflow (Finite-State) | R2026a+ | Model rotor inflow using Peters-He finite-state dynamic inflow theory — higher-fidelity inflow for advanced rotorcraft analysis |
| Multirotor | aerolibrotordyn/Multirotor | R2023a+ | Model a complete multirotor aircraft (quadrotor, hexarotor, etc.) with motor dynamics and thrust allocation — use for eVTOL/drone simulation |
| Rotor | aerolibrotordyn/Rotor | R2023a+ | Model a complete helicopter rotor (main or tail) with collective/cyclic inputs producing thrust, torque, and hub moments |

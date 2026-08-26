---
type: Simulink Block Category
title: Rotor dynamics
description: Helicopter and multirotor rotor models
tags: [rotor, blade, inflow, multirotor, helicopter]
status: stable
source: mathworks_toolbox
library_root: Aerospace Blockset
category_path: Rotor dynamics
block_count: 4
---

# Rotor dynamics

Use these blocks for rotor dynamics.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Dynamic Inflow (3-State) | aerolibinflowmodels/Dynamic Inflow (3-State) | R2026a+ | Model rotor induced velocity using Pitt-Peters 3-state dynamic inflow — provides uniform and first-harmonic inflow for helicopter trim and stability |
| Dynamic Inflow (Finite-State) | aerolibinflowmodels/Dynamic Inflow (Finite-State) | R2026a+ | Model rotor inflow using Peters-He finite-state dynamic inflow theory — higher-fidelity inflow for advanced rotorcraft analysis |
| Multirotor | aerolibrotordyn/Multirotor | R2023a+ | Model a complete multirotor aircraft (quadrotor, hexarotor, etc.) with motor dynamics and thrust allocation — use for eVTOL/drone simulation |
| Rotor | aerolibrotordyn/Rotor | R2023a+ | Model a complete helicopter rotor (main or tail) with collective/cyclic inputs producing thrust, torque, and hub moments |

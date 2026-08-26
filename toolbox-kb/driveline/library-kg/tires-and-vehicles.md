---
type: Simulink Block Category
title: Tires and vehicles
description: Vehicle bodies, tires, and road interaction models for longitudinal dynamics
tags: [tire, vehicle, road, wheel, body]
status: stable
source: mathworks_toolbox
library_root: Driveline
category_path: Tires and vehicles
block_count: 9
---

# Tires and vehicles

Use these blocks for tires and vehicles.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Longitudinal Vehicle | sdl_lib/Tires & Vehicles/Longitudinal Vehicle | R2023a+ | Model vehicle longitudinal dynamics including aerodynamic drag, rolling resistance, and grade effects — use for drive cycle simulation, fuel economy, or acceleration studies |
| Road Profile | sdl_lib/Tires & Vehicles/Road Profile | R2023a+ | Generate road surface elevation profile for tire and suspension excitation — use for ride comfort analysis, suspension design, or durability studies |
| Three-Axle Vehicle Body | sdl_lib/Tires & Vehicles/Three-Axle Vehicle Body | R2023a+ | Model a three-axle vehicle body with load distribution and pitch dynamics — use for heavy trucks, buses, or multi-axle vehicle ride and handling studies |
| Tire (Friction Parameterized) | sdl_lib/Tires & Vehicles/Tire (Friction Parameterized) | R2023a+ | Model tire longitudinal force using friction-based parameterization — use when tire data is specified as friction coefficients rather than Magic Formula parameters |
| Tire (Magic Formula) | sdl_lib/Tires & Vehicles/Tire (Magic Formula) | R2023a+ | Model tire force generation using Pacejka Magic Formula — use for accurate tire-road interaction in vehicle dynamics, handling, and traction studies |
| Tire (Simple) | sdl_lib/Tires & Vehicles/Tire (Simple) | R2023a+ | Model tire force with a simplified linear slip relationship — use for system-level powertrain studies where detailed tire modeling is not critical |
| Vehicle Body | sdl_lib/Tires & Vehicles/Vehicle Body | R2023a+ | Model a two-axle vehicle body with longitudinal and pitch dynamics — use for passenger car or light truck drive cycle simulation, braking, and acceleration studies |
| Rolling Resistance | sdl_lib/Tires & Vehicles/Tire Subcomponents/Rolling Resistance | R2023a+ | Model tire rolling resistance as a speed and load dependent force — use as a subcomponent for custom tire assemblies or to add rolling losses to simplified models |
| Tire-Road Interaction (Magic Formula) | sdl_lib/Tires & Vehicles/Tire Subcomponents/Tire-Road Interaction (Magic Formula) | R2023a+ | Compute tire-road contact forces using Pacejka Magic Formula slip equations — use as a subcomponent for building custom tire models with full slip-force characteristics |

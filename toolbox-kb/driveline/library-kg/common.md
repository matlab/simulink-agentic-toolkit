---
type: Block Selection Guide
title: Common Blocks
description: High-value blocks selected for quick agent discovery.
status: stable
source: mathworks_toolbox
block_count: 13
---

# Common Blocks

Prefer these blocks when their intent matches the user request.

| Intent | Preferred Block | Library |
|---|---|---|
| Model a multi-plate friction clutch with configurable engagement characteristics — use for automatic transmission clutches, launch devices, or torque-limiting couplings | Disc Friction Clutch | Driveline |
| Model a velocity-dependent translational damper with asymmetric compression and rebound characteristics — use for vehicle suspension dampers or vibration isolation systems | Shock Absorber | Driveline |
| Model a hydrodynamic torque converter with torque multiplication and lockup — use for automatic transmission launch devices connecting engine to gearbox | Torque Converter | Driveline |
| Model a parallel rotational spring and damper between two shafts — use for coupling compliance, drivetrain flexibility, or torsional vibration damping | Torsional Spring-Damper | Driveline |
| Model an engine with torque output mapped from throttle and speed — use for simplified powertrain studies where detailed combustion modeling is not required | Generic Engine | Driveline |
| Model a generic electric motor with drive electronics as a torque source — use for electrified powertrain studies, EV drivetrain sizing, or hybrid vehicle motor modeling | Motor & Drive | Driveline |
| Model a standard bevel-gear differential splitting torque between two outputs — use for vehicle axle differentials, allowing speed difference between driven wheels | Differential | Driveline |
| Model a simple planetary gear set with sun, planet carrier, and ring — use as the fundamental building block for automatic transmissions or compound gear trains | Planetary Gear | Driveline |
| Model a fixed-ratio gear pair with optional efficiency loss — use for any constant gear reduction, final drives, or gear meshes in a powertrain | Simple Gear | Driveline |
| Convert rotational motion to translational motion via a helical thread — use for linear actuators, machine tool feeds, or precision positioning mechanisms | Leadscrew | Driveline |
| Model vehicle longitudinal dynamics including aerodynamic drag, rolling resistance, and grade effects — use for drive cycle simulation, fuel economy, or acceleration studies | Longitudinal Vehicle | Driveline |
| Model tire force generation using Pacejka Magic Formula — use for accurate tire-road interaction in vehicle dynamics, handling, and traction studies | Tire (Magic Formula) | Driveline |
| Model a two-axle vehicle body with longitudinal and pitch dynamics — use for passenger car or light truck drive cycle simulation, braking, and acceleration studies | Vehicle Body | Driveline |

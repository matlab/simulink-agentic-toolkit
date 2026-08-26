---
type: Simulink Block Category
title: Engines and motors
description: Internal combustion engines, electric motors, propellers, and turbines
tags: [engine, motor, propeller, turbine, combustion]
status: stable
source: mathworks_toolbox
library_root: Driveline
category_path: Engines and motors
block_count: 13
---

# Engines and motors

Use these blocks for engines and motors.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Aerodynamic Propeller | sdl_lib/Engines & Motors/Aerodynamic Propeller | R2023a+ | Model a propeller generating thrust and drag torque from rotational speed and air conditions — use for aircraft propulsion, drone motors, or fan load modeling |
| Generic Engine | sdl_lib/Engines & Motors/Generic Engine | R2023a+ | Model an engine with torque output mapped from throttle and speed — use for simplified powertrain studies where detailed combustion modeling is not required |
| Marine Propeller | sdl_lib/Engines & Motors/Marine Propeller | R2023a+ | Model a marine propeller generating thrust and resistance torque in water — use for boat propulsion, ship powertrain, or marine drivetrain studies |
| Motor & Drive | sdl_lib/Engines & Motors/Motor & Drive | R2023a+ | Model a generic electric motor with drive electronics as a torque source — use for electrified powertrain studies, EV drivetrain sizing, or hybrid vehicle motor modeling |
| Piston | sdl_lib/Engines & Motors/Piston | R2023a+ | Model a single piston converting pressure force to linear motion — use as a subcomponent in custom engine assemblies or pneumatic/hydraulic actuator studies |
| Piston Engine | sdl_lib/Engines & Motors/Piston Engine | R2023a+ | Model a multi-cylinder piston engine with torque pulsation and inertia effects — use for detailed powertrain vibration studies or engine mounting analysis |
| Spark Ignition Engine | sdl_lib/Engines & Motors/Spark Ignition Engine | R2023a+ | Model a spark-ignition gasoline engine with throttle control and torque output — use for gasoline vehicle powertrain studies, fuel economy, or engine control development |
| Wind Turbine | sdl_lib/Engines & Motors/Wind Turbine | R2023a+ | Model a wind turbine rotor extracting power from wind speed — use for wind energy drivetrain studies, generator sizing, or renewable energy system simulation |
| Air Intake | sdl_lib/Engines & Motors/Engine Subcomponents/Air Intake | R2023a+ | Model engine air intake manifold dynamics including throttle and plenum — use as a subcomponent for detailed engine breathing and volumetric efficiency studies |
| Crankshaft | sdl_lib/Engines & Motors/Engine Subcomponents/Crankshaft | R2023a+ | Model a crankshaft converting piston reciprocating motion to rotation — use as a subcomponent in detailed multi-cylinder engine assemblies |
| Exhaust Manifold Thermal | sdl_lib/Engines & Motors/Engine Subcomponents/Exhaust Manifold Thermal | R2023a+ | Model thermal dynamics of an exhaust manifold — use for catalyst warm-up studies, thermal management, or aftertreatment system development |
| Ignition Trigger | sdl_lib/Engines & Motors/Engine Subcomponents/Ignition Trigger | R2023a+ | Generate ignition timing signals for spark-ignition engine cylinders — use as a subcomponent to control combustion phasing in detailed engine models |
| SI Combustion Cylinder | sdl_lib/Engines & Motors/Engine Subcomponents/SI Combustion Cylinder | R2023a+ | Model a single spark-ignition combustion cylinder with pressure and torque output — use as a subcomponent for building detailed multi-cylinder engine assemblies |

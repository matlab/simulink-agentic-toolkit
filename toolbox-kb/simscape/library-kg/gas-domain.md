---
type: Simulink Block Category
title: Gas domain
description: Compressible gas flow elements, chambers, pipes, sensors, sources, and utilities
tags: [gas, compressible, pneumatic, chamber, pipe]
status: stable
source: mathworks_toolbox
library_root: Simscape
category_path: Gas domain
block_count: 18
---

# Gas domain

Use these blocks for gas domain.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Absolute Reference (G) | fl_lib/Gas/Elements/Absolute Reference (G) | R2023a+ | Use to define the absolute zero-pressure zero-temperature reference for a gas network |
| Cap (G) | fl_lib/Gas/Elements/Cap (G) | R2023a+ | Use to terminate an unused gas port and prevent unconnected-port warnings |
| Constant Volume Chamber (G) | fl_lib/Gas/Elements/Constant Volume Chamber (G) | R2023a+ | Use when modeling a fixed-volume gas accumulator or pressure vessel with compressibility effects |
| Flow Resistance (G) | fl_lib/Gas/Elements/Flow Resistance (G) | R2023a+ | Use when modeling a generic pressure drop element in a gas flow path |
| Infinite Flow Resistance (G) | fl_lib/Gas/Elements/Infinite Flow Resistance (G) | R2023a+ | Use to block gas flow between two ports while maintaining the thermal connection |
| Local Restriction (G) | fl_lib/Gas/Elements/Local Restriction (G) | R2023a+ | Use when modeling a sudden area change such as an orifice or nozzle in a gas system |
| Pipe (G) | fl_lib/Gas/Elements/Pipe (G) | R2023a+ | Use when modeling distributed pressure loss and thermal effects along a gas pipe segment |
| Reservoir (G) | fl_lib/Gas/Elements/Reservoir (G) | R2023a+ | Use when modeling a large gas volume at fixed boundary conditions such as atmospheric pressure |
| Rotational Mechanical Converter (G) | fl_lib/Gas/Elements/Rotational Mechanical Converter (G) | R2023a+ | Use when converting gas pressure into rotational torque, such as a gas turbine or pneumatic motor |
| Translational Mechanical Converter (G) | fl_lib/Gas/Elements/Translational Mechanical Converter (G) | R2023a+ | Use when converting gas pressure into translational force, such as a pneumatic cylinder |
| Flow Rate Sensor (G) | fl_lib/Gas/Sensors/Flow Rate Sensor (G) | R2023a+ | Use when measuring mass or volumetric flow rate in a gas network |
| Mach Number Sensor (G) | fl_lib/Gas/Sensors/Mach Number Sensor (G) | R2023a+ | Use when measuring Mach number to detect compressibility effects or choking conditions |
| Pressure & Temperature Sensor (G) | fl_lib/Gas/Sensors/Pressure & Temperature Sensor (G) | R2023a+ | Use when measuring pressure and temperature at a node in a gas network |
| Thermodynamic Properties Sensor (G) | fl_lib/Gas/Sensors/Thermodynamic Properties Sensor (G) | R2023a+ | Use when measuring density, enthalpy, or entropy at a node in a gas system |
| Transport Properties Sensor (G) | fl_lib/Gas/Sensors/Transport Properties Sensor (G) | R2023a+ | Use when measuring viscosity and thermal conductivity of the gas at a node |
| Flow Rate Source (G) | fl_lib/Gas/Sources/Flow Rate Source (G) | R2023b+ | Use when imposing a specified mass flow rate as a boundary condition in a gas network |
| Pressure Source (G) | fl_lib/Gas/Sources/Pressure Source (G) | R2023a+ | Use when imposing a specified pressure differential as a boundary condition in a gas network |
| Gas Properties (G) | fl_lib/Gas/Utilities/Gas Properties (G) | R2023a+ | Use to define the working gas mixture properties for all gas domain blocks in the network |

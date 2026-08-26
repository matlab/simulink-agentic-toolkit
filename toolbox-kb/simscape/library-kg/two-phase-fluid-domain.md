---
type: Simulink Block Category
title: Two phase fluid domain
description: Two-phase fluid flow elements with phase change, vapor quality, sensors, and sources
tags: [two-phase, refrigerant, evaporator, condenser, vapor]
status: stable
source: mathworks_toolbox
library_root: Simscape
category_path: Two phase fluid domain
block_count: 19
---

# Two phase fluid domain

Use these blocks for two phase fluid domain.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Absolute Reference (2P) | fl_lib/Two-Phase Fluid/Elements/Absolute Reference (2P) | R2023a+ | Use to define the absolute zero-pressure zero-energy reference for a two-phase fluid network |
| Cap (2P) | fl_lib/Two-Phase Fluid/Elements/Cap (2P) | R2023a+ | Use to terminate an unused two-phase fluid port and prevent unconnected-port warnings |
| Constant Volume Chamber (2P) | fl_lib/Two-Phase Fluid/Elements/Constant Volume Chamber (2P) | R2023a+ | Use when modeling a fixed-volume vessel with two-phase fluid accumulation and phase change |
| Flow Resistance (2P) | fl_lib/Two-Phase Fluid/Elements/Flow Resistance (2P) | R2023a+ | Use when modeling a generic pressure drop in a two-phase fluid flow path |
| Infinite Flow Resistance (2P) | fl_lib/Two-Phase Fluid/Elements/Infinite Flow Resistance (2P) | R2023a+ | Use to block two-phase fluid flow between ports while maintaining connection topology |
| Local Restriction (2P) | fl_lib/Two-Phase Fluid/Elements/Local Restriction (2P) | R2023a+ | Use when modeling an orifice or expansion valve in a two-phase fluid system |
| Pipe (2P) | fl_lib/Two-Phase Fluid/Elements/Pipe (2P) | R2023a+ | Use when modeling distributed pressure and thermal losses along a two-phase fluid pipe |
| Reservoir (2P) | fl_lib/Two-Phase Fluid/Elements/Reservoir (2P) | R2023a+ | Use when modeling a large two-phase fluid volume at fixed boundary conditions |
| Rotational Mechanical Converter (2P) | fl_lib/Two-Phase Fluid/Elements/Rotational Mechanical Converter (2P) | R2023a+ | Use when converting two-phase fluid pressure to rotational torque in a turbine or expander |
| Translational Mechanical Converter (2P) | fl_lib/Two-Phase Fluid/Elements/Translational Mechanical Converter (2P) | R2023a+ | Use when converting two-phase fluid pressure to translational force in a piston compressor |
| Flow Rate Sensor (2P) | fl_lib/Two-Phase Fluid/Sensors/Flow Rate Sensor (2P) | R2023a+ | Use when measuring mass or volumetric flow rate in a two-phase fluid network |
| Pressure, Temperature & Internal Energy Sensor (2P) | fl_lib/Two-Phase Fluid/Sensors/Pressure, Temperature & Internal Energy Sensor (2P) | R2023a+ | Use when measuring pressure, temperature, and internal energy at a two-phase fluid node |
| Saturation Properties Sensor (2P) | fl_lib/Two-Phase Fluid/Sensors/Saturation Properties Sensor (2P) | R2023a+ | Use when measuring saturation pressure and temperature to determine phase boundaries |
| Thermodynamic Properties Sensor (2P) | fl_lib/Two-Phase Fluid/Sensors/Thermodynamic Properties Sensor (2P) | R2023a+ | Use when measuring density, enthalpy, or entropy at a node in a two-phase fluid system |
| Transport Properties Sensor (2P) | fl_lib/Two-Phase Fluid/Sensors/Transport Properties Sensor (2P) | R2023a+ | Use when measuring viscosity and thermal conductivity in a two-phase fluid at a node |
| Vapor Quality Sensor (2P) | fl_lib/Two-Phase Fluid/Sensors/Vapor Quality Sensor (2P) | R2023a+ | Use when measuring the vapor mass fraction to determine the liquid-vapor mixture state |
| Flow Rate Source (2P) | fl_lib/Two-Phase Fluid/Sources/Flow Rate Source (2P) | R2023a+ | Use when imposing a specified mass flow rate boundary condition in a two-phase fluid network |
| Pressure Source (2P) | fl_lib/Two-Phase Fluid/Sources/Pressure Source (2P) | R2023a+ | Use when imposing a specified pressure differential in a two-phase fluid network |
| Two-Phase Fluid Properties (2P) | fl_lib/Two-Phase Fluid/Utilities/Two-Phase Fluid Properties (2P) | R2023a+ | Use to define the working fluid properties for all two-phase fluid domain blocks in the network |

---
type: Simulink Block Category
title: Thermal liquid domain
description: Liquid flow elements with thermal energy transport, sensors, and sources
tags: [thermal liquid, cooling, heat exchanger, flow, pipe]
status: stable
source: mathworks_toolbox
library_root: Simscape
category_path: Thermal liquid domain
block_count: 17
---

# Thermal liquid domain

Use these blocks for thermal liquid domain.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Absolute Reference (TL) | fl_lib/Thermal Liquid/Elements/Absolute Reference (TL) | R2023a+ | Use to define the absolute zero-pressure zero-temperature reference for a thermal liquid network |
| Cap (TL) | fl_lib/Thermal Liquid/Elements/Cap (TL) | R2023a+ | Use to terminate an unused thermal liquid port and prevent unconnected-port warnings |
| Constant Volume Chamber (TL) | fl_lib/Thermal Liquid/Elements/Constant Volume Chamber (TL) | R2023a+ | Use when modeling a fixed-volume liquid chamber with both pressure and thermal dynamics |
| Flow Resistance (TL) | fl_lib/Thermal Liquid/Elements/Flow Resistance (TL) | R2023a+ | Use when modeling a generic pressure drop in a thermal liquid flow path |
| Infinite Flow Resistance (TL) | fl_lib/Thermal Liquid/Elements/Infinite Flow Resistance (TL) | R2023a+ | Use to block thermal liquid flow between two ports while maintaining connection topology |
| Local Restriction (TL) | fl_lib/Thermal Liquid/Elements/Local Restriction (TL) | R2023a+ | Use when modeling an orifice or area change in a thermal liquid system with heat exchange |
| Pipe (TL) | fl_lib/Thermal Liquid/Elements/Pipe (TL) | R2023a+ | Use when modeling distributed pressure loss and wall heat transfer along a thermal liquid pipe |
| Reservoir (TL) | fl_lib/Thermal Liquid/Elements/Reservoir (TL) | R2023a+ | Use when modeling a large liquid volume at fixed temperature and pressure boundary conditions |
| Rotational Mechanical Converter (TL) | fl_lib/Thermal Liquid/Elements/Rotational Mechanical Converter (TL) | R2023a+ | Use when converting thermal liquid pressure to rotational torque with thermal effects |
| Translational Mechanical Converter (TL) | fl_lib/Thermal Liquid/Elements/Translational Mechanical Converter (TL) | R2023a+ | Use when converting thermal liquid pressure to translational force with thermal effects |
| Flow Rate Sensor (TL) | fl_lib/Thermal Liquid/Sensors/Flow Rate Sensor (TL) | R2023a+ | Use when measuring mass or volumetric flow rate in a thermal liquid network |
| Pressure & Temperature Sensor (TL) | fl_lib/Thermal Liquid/Sensors/Pressure & Temperature Sensor (TL) | R2023a+ | Use when measuring pressure and temperature at a node in a thermal liquid network |
| Thermodynamic Properties Sensor (TL) | fl_lib/Thermal Liquid/Sensors/Thermodynamic Properties Sensor (TL) | R2023a+ | Use when measuring density, enthalpy, or specific heat at a node in a thermal liquid system |
| Transport Properties Sensor (TL) | fl_lib/Thermal Liquid/Sensors/Transport Properties Sensor (TL) | R2023a+ | Use when measuring viscosity and thermal conductivity of a thermal liquid at a node |
| Flow Rate Source (TL) | fl_lib/Thermal Liquid/Sources/Flow Rate Source (TL) | R2023a+ | Use when imposing a specified mass flow rate boundary condition in a thermal liquid network |
| Pressure Source (TL) | fl_lib/Thermal Liquid/Sources/Pressure Source (TL) | R2023a+ | Use when imposing a specified pressure differential in a thermal liquid network |
| Thermal Liquid Settings (TL) | fl_lib/Thermal Liquid/Utilities/Thermal Liquid Settings (TL) | R2023a+ | Use to define the working fluid properties for all thermal liquid domain blocks in the network |

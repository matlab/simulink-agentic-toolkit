---
type: Simulink Block Category
title: Moist air domain
description: Psychrometric moist air flow elements, moisture control, sensors, and sources
tags: [moist air, humidity, HVAC, psychrometric, condensation]
status: stable
source: mathworks_toolbox
library_root: Simscape
category_path: Moist air domain
block_count: 22
---

# Moist air domain

Use these blocks for moist air domain.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Absolute Reference (MA) | fl_lib/Moist Air/Elements/Absolute Reference (MA) | R2023a+ | Use to define the absolute zero-pressure zero-temperature reference for a moist air network |
| Cap (MA) | fl_lib/Moist Air/Elements/Cap (MA) | R2023a+ | Use to terminate an unused moist air port and prevent unconnected-port warnings |
| Constant Volume Chamber (MA) | fl_lib/Moist Air/Elements/Constant Volume Chamber (MA) | R2023a+ | Use when modeling a fixed-volume air plenum where pressure changes with mass accumulation |
| Flow Resistance (MA) | fl_lib/Moist Air/Elements/Flow Resistance (MA) | R2023a+ | Use when modeling a generic pressure drop element in a moist air flow path |
| Infinite Flow Resistance (MA) | fl_lib/Moist Air/Elements/Infinite Flow Resistance (MA) | R2023a+ | Use to block moist air flow between two ports while maintaining the connection topology |
| Local Restriction (MA) | fl_lib/Moist Air/Elements/Local Restriction (MA) | R2023a+ | Use when modeling a sudden area change or damper in a moist air duct system |
| Moisture Separator (MA) | fl_lib/Moist Air/Elements/Moisture Separator (MA) | R2023a+ | Use when modeling a device that removes condensed moisture from a moist air stream |
| Pipe (MA) | fl_lib/Moist Air/Elements/Pipe (MA) | R2023a+ | Use when modeling distributed pressure loss and heat transfer along a moist air duct |
| Reservoir (MA) | fl_lib/Moist Air/Elements/Reservoir (MA) | R2023a+ | Use when modeling a large open atmosphere or fixed boundary condition for moist air |
| Rotational Mechanical Converter (MA) | fl_lib/Moist Air/Elements/Rotational Mechanical Converter (MA) | R2023a+ | Use when converting moist air pressure to rotational torque in a pneumatic turbine model |
| Translational Mechanical Converter (MA) | fl_lib/Moist Air/Elements/Translational Mechanical Converter (MA) | R2023a+ | Use when converting moist air pressure to translational force in a pneumatic actuator |
| Flow Rate Sensor (MA) | fl_lib/Moist Air/Sensors/Flow Rate Sensor (MA) | R2023a+ | Use when measuring mass or volumetric flow rate in a moist air network |
| Measurement Selector (MA) | fl_lib/Moist Air/Sensors/Measurement Selector (MA) | R2023a+ | Use when selecting which measurement outputs to expose from a moist air sensor block |
| Moisture & Trace Gas Sensor (MA) | fl_lib/Moist Air/Sensors/Moisture & Trace Gas Sensor (MA) | R2023a+ | Use when measuring humidity ratio, relative humidity, or trace gas concentration at a moist air node |
| Pressure & Temperature Sensor (MA) | fl_lib/Moist Air/Sensors/Pressure & Temperature Sensor (MA) | R2023a+ | Use when measuring pressure and temperature at a node in a moist air network |
| Thermodynamic Properties Sensor (MA) | fl_lib/Moist Air/Sensors/Thermodynamic Properties Sensor (MA) | R2023a+ | Use when measuring density, enthalpy, or entropy at a node in a moist air system |
| Transport Properties Sensor (MA) | fl_lib/Moist Air/Sensors/Transport Properties Sensor (MA) | R2023a+ | Use when measuring viscosity and thermal conductivity of moist air at a node |
| Flow Rate Source (MA) | fl_lib/Moist Air/Sources/Flow Rate Source (MA) | R2023a+ | Use when imposing a specified mass flow rate boundary condition in a moist air network |
| Pressure Source (MA) | fl_lib/Moist Air/Sources/Pressure Source (MA) | R2023a+ | Use when imposing a specified pressure differential in a moist air network |
| Moisture Source (MA) | fl_lib/Moist Air/Sources/Moisture & Trace Gas Sources/Moisture Source (MA) | R2023a+ | Use when injecting or removing moisture mass flow at a node in a moist air system |
| Trace Gas Source (MA) | fl_lib/Moist Air/Sources/Moisture & Trace Gas Sources/Trace Gas Source (MA) | R2023a+ | Use when injecting or removing trace gas mass flow at a node in a moist air system |
| Moist Air Properties (MA) | fl_lib/Moist Air/Utilities/Moist Air Properties (MA) | R2023a+ | Use to define the moist air mixture properties for all moist air domain blocks in the network |

---
type: Simulink Block Category
title: Isothermal liquid domain
description: Incompressible isothermal liquid flow elements, actuators, sensors, and sources
tags: [hydraulic, liquid, isothermal, pressure, cylinder]
status: stable
source: mathworks_toolbox
library_root: Simscape
category_path: Isothermal liquid domain
block_count: 17
---

# Isothermal liquid domain

Use these blocks for isothermal liquid domain.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Cap (IL) | fl_lib/Isothermal Liquid/Elements/Cap (IL) | R2025a+ | Use to terminate an unused isothermal liquid port and prevent unconnected-port warnings |
| Constant Volume Chamber (IL) | fl_lib/Isothermal Liquid/Elements/Constant Volume Chamber (IL) | R2023a+ | Use when modeling a fixed-volume liquid accumulator with fluid compressibility |
| Flow Resistance (IL) | fl_lib/Isothermal Liquid/Elements/Flow Resistance (IL) | R2023a+ | Use when modeling a generic pressure drop in an isothermal liquid flow path |
| Infinite Flow Resistance (IL) | fl_lib/Isothermal Liquid/Elements/Infinite Flow Resistance (IL) | R2023a+ | Use to block liquid flow between two isothermal liquid ports |
| Laminar Leakage (IL) | fl_lib/Isothermal Liquid/Elements/Laminar Leakage (IL) | R2023a+ | Use when modeling parasitic leakage flow between two fluid chambers through a small clearance gap |
| Local Restriction (IL) | fl_lib/Isothermal Liquid/Elements/Local Restriction (IL) | R2023a+ | Use when modeling a sharp-edged orifice or sudden area change in an isothermal liquid system |
| Pipe (IL) | fl_lib/Isothermal Liquid/Elements/Pipe (IL) | R2023a+ | Use when modeling distributed viscous losses along a pipe in an isothermal liquid system |
| Reservoir (IL) | fl_lib/Isothermal Liquid/Elements/Reservoir (IL) | R2023a+ | Use when modeling a tank or sump at fixed pressure boundary conditions for isothermal liquid |
| Rotational Mechanical Converter (IL) | fl_lib/Isothermal Liquid/Elements/Rotational Mechanical Converter (IL) | R2023a+ | Use when converting hydraulic pressure to rotational torque, such as a hydraulic motor |
| Translational Mechanical Converter (IL) | fl_lib/Isothermal Liquid/Elements/Translational Mechanical Converter (IL) | R2023a+ | Use when converting hydraulic pressure to translational force, such as a hydraulic cylinder |
| Translational Mechanical Converter (IL-PB) | fl_lib/Isothermal Liquid/Elements/Translational Mechanical Converter (IL-PB) | R2023a+ | Use when converting isothermal liquid pressure to translational force with position-based mechanical ports |
| Flow Rate Sensor (IL) | fl_lib/Isothermal Liquid/Sensors/Flow Rate Sensor (IL) | R2023a+ | Use when measuring volumetric or mass flow rate in an isothermal liquid network |
| Liquid Properties Sensor (IL) | fl_lib/Isothermal Liquid/Sensors/Liquid Properties Sensor (IL) | R2023a+ | Use when measuring fluid density and bulk modulus at a node in an isothermal liquid system |
| Pressure Sensor (IL) | fl_lib/Isothermal Liquid/Sensors/Pressure Sensor (IL) | R2023a+ | Use when measuring gauge or absolute pressure at a node in an isothermal liquid network |
| Flow Rate Source (IL) | fl_lib/Isothermal Liquid/Sources/Flow Rate Source (IL) | R2023a+ | Use when imposing a specified flow rate as a boundary condition in an isothermal liquid network |
| Pressure Source (IL) | fl_lib/Isothermal Liquid/Sources/Pressure Source (IL) | R2023a+ | Use when imposing a specified pressure differential in an isothermal liquid network |
| Isothermal Liquid Properties (IL) | fl_lib/Isothermal Liquid/Utilities/Isothermal Liquid Properties (IL) | R2023a+ | Use to define the working fluid properties for all isothermal liquid domain blocks |

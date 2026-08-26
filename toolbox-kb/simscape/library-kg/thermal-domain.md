---
type: Simulink Block Category
title: Thermal domain
description: Heat transfer elements, thermal mass, temperature and heat flow sources and sensors
tags: [thermal, heat transfer, temperature, conduction, convection]
status: stable
source: mathworks_toolbox
library_root: Simscape
category_path: Thermal domain
block_count: 16
---

# Thermal domain

Use these blocks for thermal domain.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Conductive Heat Transfer | fl_lib/Thermal/Thermal Elements/Conductive Heat Transfer | R2023a+ | Use when modeling heat conduction through a solid material with specified thermal conductivity and geometry |
| Convective Heat Transfer | fl_lib/Thermal/Thermal Elements/Convective Heat Transfer | R2023a+ | Use when modeling heat exchange between a surface and a fluid via convection |
| Infinite Thermal Resistance | fl_lib/Thermal/Thermal Elements/Infinite Thermal Resistance | R2023a+ | Use to thermally isolate two nodes while keeping them connected in the model topology |
| Perfect Insulator | fl_lib/Thermal/Thermal Elements/Perfect Insulator | R2023a+ | Use to cap an unused thermal port with zero heat flow for topology completeness |
| Phase-Change Thermal Mass | fl_lib/Thermal/Thermal Elements/Phase-Change Thermal Mass | R2023a+ | Use when modeling thermal energy storage in a material that undergoes phase transition with latent heat |
| Radiative Heat Transfer | fl_lib/Thermal/Thermal Elements/Radiative Heat Transfer | R2023a+ | Use when modeling heat exchange between surfaces via thermal radiation following Stefan-Boltzmann law |
| Thermal Mass | fl_lib/Thermal/Thermal Elements/Thermal Mass | R2023a+ | Use when modeling thermal energy storage in a body with specified heat capacity |
| Thermal Reference | fl_lib/Thermal/Thermal Elements/Thermal Reference | R2023a+ | Use to establish absolute zero temperature as the thermal ground reference node |
| Thermal Resistance | fl_lib/Thermal/Thermal Elements/Thermal Resistance | R2023a+ | Use when modeling a generic thermal resistance between two temperature nodes |
| Variable Thermal Resistance | fl_lib/Thermal/Thermal Elements/Variable Thermal Resistance | R2023a+ | Use when the thermal resistance is controlled by an external physical signal for active thermal management |
| Heat Flow Rate Sensor | fl_lib/Thermal/Thermal Sensors/Heat Flow Rate Sensor | R2023a+ | Use when measuring heat flow rate through a thermal connection and converting it to a physical signal |
| Temperature Sensor | fl_lib/Thermal/Thermal Sensors/Temperature Sensor | R2023a+ | Use when measuring temperature difference across two thermal nodes and converting it to a physical signal |
| Controlled Temperature Source | fl_lib/Thermal/Thermal Sources/Controlled Temperature Source | R2023a+ | Use when imposing a temperature controlled by an external physical signal for thermal boundary conditions |
| Controlled Heat Flow Rate Source | fl_lib/Thermal/Thermal Sources/Controlled Heat Flow Rate Source | R2023a+ | Use when injecting a heat flow rate controlled by an external physical signal |
| Heat Flow Rate Source | fl_lib/Thermal/Thermal Sources/Heat Flow Rate Source | R2023a+ | Use when injecting a constant heat flow rate between two thermal nodes |
| Temperature Source | fl_lib/Thermal/Thermal Sources/Temperature Source | R2023a+ | Use when imposing a constant temperature difference between two thermal nodes |

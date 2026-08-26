---
type: Simulink Block Category
title: Equations of motion 6dof
description: Six-degree-of-freedom flight dynamics
tags: [6DOF, Euler, quaternion, ECEF, equations of motion]
status: stable
source: mathworks_toolbox
library_root: Aerospace Blockset
category_path: Equations of motion 6dof
block_count: 17
---

# Equations of motion 6dof

Use these blocks for equations of motion 6dof.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| 6DOF Acceleration | aerolib6dof2/6DOF Acceleration | R2025a+ | Compute translational acceleration from forces and body-axis velocity for full six-degree-of-freedom motion |
| 6DOF Angular Acceleration | aerolib6dof2/6DOF Angular Acceleration | R2025a+ | Compute angular acceleration from moments, inertia tensor, and angular velocity for full 6DOF motion |
| 6DOF ECEF (Quaternion) | aerolib6dof2/6DOF ECEF (Quaternion) | R2023a+ | Integrate 6DOF equations in ECEF frame using quaternion attitude — use for long-range or orbital flight where Earth curvature and rotation matter |
| 6DOF Wind (Wind Angles) | aerolib6dof2/6DOF Wind (Wind Angles) | R2023a+ | Integrate 6DOF equations in wind axes using alpha/beta/mu angles — use when aerodynamic angles are natural state variables |
| 6DOF (Euler Angles) | aerolib6dof2/6DOF (Euler Angles) | R2023a+ | Integrate 6DOF body-axis equations using Euler angle attitude — the most common EoM block for conventional aircraft simulation |
| 6DOF (Quaternion) | aerolib6dof2/6DOF (Quaternion) | R2023a+ | Integrate 6DOF body-axis equations using quaternion attitude — use to avoid gimbal lock in highly maneuverable vehicle or spacecraft simulation |
| 6DOF Wind (Quaternion) | aerolib6dof2/6DOF Wind (Quaternion) | R2023a+ | Integrate 6DOF wind-axis equations using quaternion attitude — combine wind-axis convenience with singularity-free representation |
| Custom Variable Mass 6DOF ECEF (Quaternion) | aerolib6dof2/Custom Variable Mass 6DOF ECEF (Quaternion) | R2023a+ | Integrate 6DOF ECEF equations with user-defined time-varying mass properties — use for long-range variable-mass vehicles like launch vehicles |
| Custom Variable Mass 6DOF (Euler Angles) | aerolib6dof2/Custom Variable Mass 6DOF (Euler Angles) | R2023a+ | Integrate 6DOF body-axis Euler equations with user-defined time-varying mass, inertia, and mass flow |
| Custom Variable Mass 6DOF (Quaternion) | aerolib6dof2/Custom Variable Mass 6DOF (Quaternion) | R2023a+ | Integrate 6DOF body-axis quaternion equations with user-defined time-varying mass properties |
| Custom Variable Mass 6DOF Wind (Quaternion) | aerolib6dof2/Custom Variable Mass 6DOF Wind (Quaternion) | R2023a+ | Integrate 6DOF wind-axis quaternion equations with user-defined time-varying mass properties |
| Custom Variable Mass 6DOF Wind (Wind Angles) | aerolib6dof2/Custom Variable Mass 6DOF Wind (Wind Angles) | R2023a+ | Integrate 6DOF wind-axis wind-angle equations with user-defined time-varying mass properties |
| Simple Variable Mass 6DOF ECEF (Quaternion) | aerolib6dof2/Simple Variable Mass 6DOF ECEF (Quaternion) | R2023a+ | Integrate 6DOF ECEF quaternion equations with linearly decreasing mass — use for simplified launch vehicle or long-range missile models |
| Simple Variable Mass 6DOF (Euler Angles) | aerolib6dof2/Simple Variable Mass 6DOF (Euler Angles) | R2023a+ | Integrate 6DOF body-axis Euler equations with linearly decreasing mass — simple rocket or missile model |
| Simple Variable Mass 6DOF (Quaternion) | aerolib6dof2/Simple Variable Mass 6DOF (Quaternion) | R2023a+ | Integrate 6DOF body-axis quaternion equations with linearly decreasing mass |
| Simple Variable Mass 6DOF Wind (Quaternion) | aerolib6dof2/Simple Variable Mass 6DOF Wind (Quaternion) | R2023a+ | Integrate 6DOF wind-axis quaternion equations with linearly decreasing mass |
| Simple Variable Mass 6DOF Wind (Wind Angles) | aerolib6dof2/Simple Variable Mass 6DOF Wind (Wind Angles) | R2023a+ | Integrate 6DOF wind-axis wind-angle equations with linearly decreasing mass |

---
type: Simulink Block Category
title: Equations of motion 3dof
description: Three-degree-of-freedom flight dynamics
tags: [3DOF, longitudinal, body axes, wind axes, variable mass]
status: stable
source: mathworks_toolbox
library_root: Aerospace Blockset
category_path: Equations of motion 3dof
block_count: 8
---

# Equations of motion 3dof

Use these blocks for equations of motion 3dof.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| 3DOF Acceleration | aerolib3dof2/3DOF Acceleration | R2025a+ | Compute translational acceleration from forces, mass, and body velocity for 3DOF longitudinal-plane motion |
| 3DOF Angular Acceleration | aerolib3dof2/3DOF Angular Acceleration | R2025a+ | Compute pitch angular acceleration from moments and inertia for 3DOF longitudinal-plane motion |
| 3dof (Body Axes) | aerolib3dof2/3dof (Body Axes) | R2023a+ | Integrate 3DOF equations of motion in body axes — use for longitudinal-plane flight simulation of fixed-wing aircraft with constant mass |
| 3dof (Wind Axes) | aerolib3dof2/3dof (Wind Axes) | R2023a+ | Integrate 3DOF equations of motion in wind axes — use for longitudinal-plane trajectory analysis where angle of attack is a natural state variable |
| Custom Variable Mass 3dof (Body Axes) | aerolib3dof2/Custom Variable Mass 3dof (Body Axes) | R2023a+ | Integrate 3DOF body-axis equations with user-defined time-varying mass, inertia, and mass flow — use for rocket or missile longitudinal simulation |
| Custom Variable Mass 3dof (Wind Axes) | aerolib3dof2/Custom Variable Mass 3dof (Wind Axes) | R2023a+ | Integrate 3DOF wind-axis equations with user-defined time-varying mass properties — use for variable-mass trajectory analysis in wind coordinates |
| Simple Variable Mass 3dof (Body Axes) | aerolib3dof2/Simple Variable Mass 3dof (Body Axes) | R2023a+ | Integrate 3DOF body-axis equations with linearly decreasing mass — use for simple rocket/missile models with constant mass flow rate |
| Simple Variable Mass 3dof (Wind Axes) | aerolib3dof2/Simple Variable Mass 3dof (Wind Axes) | R2023a+ | Integrate 3DOF wind-axis equations with linearly decreasing mass — use for simple variable-mass trajectory analysis |

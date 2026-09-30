---
type: Simulink Block Category
title: Electric propulsion
description: Electric motors, inverters, and motor controllers
tags: [electric motors, motor controllers, pmsm, induction motor, inverter, mapped motor]
status: stable
source: custom_library
library_root: Powertrain Blockset
category_path: Electric propulsion
block_count: 7
---

# Electric propulsion

Use these blocks for electric propulsion.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Flux-Based PM Controller | autolibmotorctrlr/Flux-Based PM Controller | R2023a+ | Field-oriented controller for a flux-based permanent-magnet motor — use to command torque/current in a flux-based PMSM drive. |
| Flux-Based PMSM | autolibemachines/Flux-Based PMSM | R2023a+ | Model a permanent-magnet synchronous motor from flux-linkage maps — use for high-fidelity PMSM simulation that captures saturation. |
| Induction Motor | autolibemachines/Induction Motor | R2023a+ | Model a three-phase induction machine with electrical and mechanical dynamics — use as an ACIM traction motor. |
| Interior PMSM | autolibemachines/Interior PMSM | R2023a+ | Model an interior-permanent-magnet synchronous motor with saliency and reluctance torque — use for IPMSM traction drives. |
| Mapped Motor | autolibemachines/Mapped Motor | R2023a+ | Model an electric motor and inverter from efficiency/torque maps — use for fast system-level EV powertrain studies. |
| Surface Mount PMSM | autolibemachines/Surface Mount PMSM | R2023a+ | Model a surface-mount permanent-magnet synchronous motor — use for SPMSM traction and drive simulation. |
| Three-Phase Voltage Source Inverter | autolibemachines/Three-Phase Voltage Source Inverter | R2023a+ | Model a three-phase voltage-source inverter driving a motor — use to convert DC-bus voltage to AC phase voltages. |

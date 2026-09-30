---
type: Simulink Block Category
title: Motor models
description: HDL-ready machine plant models and their parameter configuration blocks for FPGA-in-the-loop simulation
tags: [pmsm, bldc, induction, plant, configuration]
status: stable
source: custom_library
library_root: Motor Control Blockset HDL Support
category_path: Motor models
block_count: 6
---

# Motor models

Use these blocks for motor models.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| BLDC Configuration | mcbhdllib/Electrical Systems/Motors/BLDC Configuration | R2023a+ | Parameter block holding BLDC machine data consumed by the BLDC HDL plant and associated control blocks so parameters stay consistent across the design. |
| BLDC HDL | mcbhdllib/Electrical Systems/Motors/BLDC HDL | R2023a+ | HDL-ready plant model of a brushless DC motor for real-time / FPGA-in-the-loop simulation and controller verification. |
| Induction Motor Configuration | mcbhdllib/Electrical Systems/Motors/Induction Motor Configuration | R2023a+ | Parameter block defining induction-machine data used by the Induction Motor HDL plant and the ACIM control blocks. |
| Induction Motor HDL | mcbhdllib/Electrical Systems/Motors/Induction Motor HDL | R2023a+ | HDL-ready induction-machine plant model for FPGA-in-the-loop simulation of ACIM drives. |
| PMSM Configuration | mcbhdllib/Electrical Systems/Motors/PMSM Configuration | R2023a+ | Central parameter block defining PMSM electrical and mechanical data (Rs, Ld, Lq, back-EMF constant, pole pairs) shared by the PMSM HDL plant and control blocks. Set motor parameters here rather than block by block. |
| PMSM HDL | mcbhdllib/Electrical Systems/Motors/PMSM HDL | R2023a+ | HDL-ready plant model of a permanent-magnet synchronous machine for FPGA-in-the-loop / real-time simulation of the motor alongside HDL controllers. |

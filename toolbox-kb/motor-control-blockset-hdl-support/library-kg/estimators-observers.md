---
type: Simulink Block Category
title: Estimators observers
description: Sensorless estimation of flux, angle, slip, and torque from measured electrical quantities
tags: [observer, flux, estimator, sensorless, slip]
status: stable
source: custom_library
library_root: Motor Control Blockset HDL Support
category_path: Estimators observers
block_count: 3
---

# Estimators observers

Use these blocks for estimators observers.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| ACIM Slip Speed Estimator | mcbhdllib/Controls/Control Reference/ACIM Slip Speed Estimator | R2023a+ | Estimate induction-motor slip speed from rotor flux and q-axis current; required to build the synchronous field angle in indirect FOC of ACIMs. |
| ACIM Torque Estimator | mcbhdllib/Controls/Control Reference/ACIM Torque Estimator | R2023a+ | Estimate developed electromagnetic torque of an induction motor from flux and current for monitoring or closed-loop torque control without a physical torque sensor. |
| Flux Observer | mcbhdllib/Sensorless Estimators/Flux Observer | R2023a+ | Estimate rotor flux position and magnitude from measured currents and voltages for sensorless PMSM FOC, supplying the electrical angle to the Park transforms without a position sensor. Fixed-point HDL for FPGA sensorless drives. |

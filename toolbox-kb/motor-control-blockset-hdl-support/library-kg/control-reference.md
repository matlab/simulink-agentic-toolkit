---
type: Simulink Block Category
title: Control reference
description: Reference generation and estimators for AC induction motor control
tags: [control reference, acim, dq limiter, position generator]
status: stable
source: custom_library
library_root: Motor Control Blockset HDL Support
category_path: Control reference
block_count: 6
---

# Control reference

Use these blocks for control reference.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| ACIM Control Reference | mcbhdllib/Controls/Control Reference/ACIM Control Reference | R2023a+ | Generate flux and torque current references for AC induction motor field-oriented control — use to set the d/q current setpoints for ACIM FOC. |
| ACIM Feed Forward Control | mcbhdllib/Controls/Control Reference/ACIM Feed Forward Control | R2023a+ | Compute feed-forward voltage terms for ACIM current control — use to improve current-loop dynamics and axis decoupling. |
| ACIM Slip Speed Estimator | mcbhdllib/Controls/Control Reference/ACIM Slip Speed Estimator | R2023a+ | Estimate rotor slip speed for indirect field-oriented control of an induction motor — use to compute the flux angle in ACIM FOC. |
| ACIM Torque Estimator | mcbhdllib/Controls/Control Reference/ACIM Torque Estimator | R2023a+ | Estimate the electromagnetic torque of an induction motor from currents and flux — use for torque monitoring or torque control. |
| DQ Limiter | mcbhdllib/Controls/Control Reference/DQ Limiter | R2023a+ | Limit the magnitude of the d-q current/voltage vector within a bound — use to enforce inverter and motor limits in FOC. |
| Position Generator | mcbhdllib/Controls/Control Reference/Position Generator | R2023a+ | Generate a ramping electrical position/angle — use to drive open-loop or test excitation of a motor model. |

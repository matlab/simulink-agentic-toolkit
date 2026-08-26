---
type: Block Selection Guide
title: Common Blocks
description: High-value blocks selected for quick agent discovery.
status: stable
source: mathworks_toolbox
block_count: 15
---

# Common Blocks

Prefer these blocks when their intent matches the user request.

| Intent | Preferred Block | Library |
|---|---|---|
| Regulate d and q axis currents to their references with decoupled PI loops and voltage limiting — use as the inner current loop of any FOC-based motor drive | Field-Oriented Current Controller | Motor Control Blockset |
| Discrete PI controller with anti-windup and output saturation tailored for motor-control loops — use to build custom current, speed, position, or flux regulators | PI Controller | Motor Control Blockset |
| Convert three-phase stationary quantities (ia, ib, ic) into two-axis alpha/beta stationary components — use as the first math step of any FOC current or voltage transformation | Clarke Transform | Motor Control Blockset |
| Convert alpha/beta stationary components back into three-phase voltage or current commands — use as the final math step before driving PWM in an FOC controller | Inverse Clarke Transform | Motor Control Blockset |
| Rotate d/q axis quantities back to the stationary alpha/beta frame using the electrical angle — use to convert voltage commands from the rotor-oriented frame before PWM generation | Inverse Park Transform | Motor Control Blockset |
| Generate space-vector or sine-triangle PWM duty cycles from three-phase voltage references — use to drive a three-phase inverter from an FOC or vector controller | PWM Reference Generator | Motor Control Blockset |
| Rotate alpha/beta stationary quantities into the d/q rotor-oriented frame using the electrical angle — use to move currents and voltages into the rotating frame for FOC math | Park Transform | Motor Control Blockset |
| Model a three-phase inverter as an ideal voltage source proportional to duty cycle — use for fast, non-switching plant simulations of FOC loops when switching harmonics are not of interest | Average-Value Inverter | Motor Control Blockset |
| Trapezoidal back-EMF permanent-magnet motor model — use as the plant in six-step commutated BLDC drive simulations | BLDC | Motor Control Blockset |
| Squirrel-cage induction machine model with configurable equivalent-circuit parameters — use as the plant for scalar V/F, direct torque, or vector-control simulations | Induction Motor | Motor Control Blockset |
| Surface-mount permanent-magnet synchronous machine model with symmetric d/q inductance — use as the plant for FOC studies on non-salient PMSMs | Surface Mount PMSM | Motor Control Blockset |
| Decode Hall-sensor A/B/C states into electrical angle and rotor speed — use to obtain position/speed feedback for BLDC drives and low-resolution PMSM applications | Hall Speed and Position | Motor Control Blockset |
| Decode A/B encoder pulses into an accumulated count, direction, and index reset — use to convert incremental encoder feedback into position and speed for high-resolution servos | Quadrature Decoder | Motor Control Blockset |
| Estimate stator flux and rotor angle by integrating the voltage equation with drift compensation — use as the position observer for medium- to high-speed sensorless FOC | Flux Observer | Motor Control Blockset |
| Estimate back-EMF and rotor angle using a sliding-mode current observer — use for robust sensorless PMSM position estimation in the presence of parameter variation | Sliding Mode Observer | Motor Control Blockset |

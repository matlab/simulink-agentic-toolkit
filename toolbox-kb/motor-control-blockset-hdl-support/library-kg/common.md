---
type: Block Selection Guide
title: Common Blocks
description: High-value blocks selected for quick agent discovery.
status: stable
source: custom_library
block_count: 27
---

# Common Blocks

Prefer these blocks when their intent matches the user request.

| Intent | Preferred Block | Library |
|---|---|---|
| Discrete PI controller with anti-windup — use for current, speed, or voltage regulation loops in motor control. | PI Controller | Motor Control Blockset HDL Support |
| Transform three-phase (abc) quantities to the stationary two-axis (αβ) frame — use as the first step of field-oriented control. | Clarke Transform | Motor Control Blockset HDL Support |
| Transform rotating d-q quantities to the stationary αβ frame using the rotor angle — use to convert controller outputs back for modulation. | Inverse Park Transform | Motor Control Blockset HDL Support |
| Generate PWM duty-cycle references (e.g., space-vector PWM) from voltage commands — use to drive the inverter switching stage. | PWM Reference Generator | Motor Control Blockset HDL Support |
| Transform stationary two-axis (αβ) quantities to the rotating d-q frame using the rotor angle — use to obtain DC-like control variables in FOC. | Park Transform | Motor Control Blockset HDL Support |
| Decode quadrature encoder A/B/index pulses into position and direction — use to measure rotor position from an incremental encoder. | Quadrature Decoder | Motor Control Blockset HDL Support |
| Estimate rotor flux position and magnitude for sensorless FOC — use to run field-oriented control without a position sensor. | Flux Observer | Motor Control Blockset HDL Support |
| Generate flux and torque current references for AC induction motor field-oriented control — use to set the d/q current setpoints for ACIM FOC. | ACIM Control Reference | Motor Control Blockset HDL Support |
| Compute feed-forward voltage terms for ACIM current control — use to improve current-loop dynamics and axis decoupling. | ACIM Feed Forward Control | Motor Control Blockset HDL Support |
| Estimate rotor slip speed for indirect field-oriented control of an induction motor — use to compute the flux angle in ACIM FOC. | ACIM Slip Speed Estimator | Motor Control Blockset HDL Support |
| Estimate the electromagnetic torque of an induction motor from currents and flux — use for torque monitoring or torque control. | ACIM Torque Estimator | Motor Control Blockset HDL Support |
| Limit the magnitude of the d-q current/voltage vector within a bound — use to enforce inverter and motor limits in FOC. | DQ Limiter | Motor Control Blockset HDL Support |
| Reduce a torque or current reference based on temperature/voltage limits — use to protect the drive under stress. | Derating Function | Motor Control Blockset HDL Support |
| Transform vector-space (d-q-x-y-z-0) components back to six-phase quantities — use to reconstruct phase references for a six-phase machine. | 6-Phase Inverse VSD Transform | Motor Control Blockset HDL Support |
| Decompose six-phase currents/voltages into vector-space (d-q-x-y-z-0) components — use for control of six-phase machines. | 6-Phase VSD Transform | Motor Control Blockset HDL Support |
| Transform stationary two-axis (αβ) quantities back to three-phase (abc) — use to produce phase voltage references. | Inverse Clarke Transform | Motor Control Blockset HDL Support |
| Compute the four-quadrant arctangent — use to derive an angle from αβ components, such as a flux or position angle. | atan2 | Motor Control Blockset HDL Support |
| Set the electrical and mechanical parameters of a BLDC motor for the paired plant block — use to configure a BLDC machine. | BLDC Configuration | Motor Control Blockset HDL Support |
| HDL-ready BLDC motor plant model — use to simulate a brushless-DC machine in a hardware-targeted design. | BLDC HDL | Motor Control Blockset HDL Support |
| Set the parameters of an induction motor for the paired plant block — use to configure an ACIM machine. | Induction Motor Configuration | Motor Control Blockset HDL Support |
| HDL-ready induction motor plant model — use to simulate an ACIM in a hardware-targeted design. | Induction Motor HDL | Motor Control Blockset HDL Support |
| Set the parameters of a PMSM for the paired plant block — use to configure a permanent-magnet synchronous machine. | PMSM Configuration | Motor Control Blockset HDL Support |
| Trip and protect the drive when currents or voltages exceed limits — use for fault protection in motor control. | Protection Relay | Motor Control Blockset HDL Support |
| Convert mechanical rotor angle to electrical angle using pole-pair count — use to obtain the electrical angle needed for FOC. | Mechanical to Electrical Position | Motor Control Blockset HDL Support |
| Compute rotor speed from successive position measurements — use to close the speed control loop. | Speed Measurement | Motor Control Blockset HDL Support |
| Compensate inverter dead-time distortion in the voltage command — use to improve current-waveform quality. | Dead-Time Compensator | Motor Control Blockset HDL Support |
| General IIR filter — use for signal conditioning such as smoothing measured feedback in motor control. | IIR Filter | Motor Control Blockset HDL Support |

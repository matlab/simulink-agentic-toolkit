---
type: Simulink Block Category
title: Measurements and observers
description: Power, RMS, THD, PLL measurements and state observers
tags: [measurement, pll, rms, observer, pmu]
status: stable
source: mathworks_toolbox
library_root: Electrical
category_path: Measurements and observers
block_count: 13
---

# Measurements and observers

Use these blocks for measurements and observers.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Phasor Measurement Unit (PMU, Three-Phase) | ee_sl_lib/Measurements/Phasor Measurement Unit (PMU, Three-Phase) | R2023a+ | Model a PMU extracting synchrophasor measurements from three-phase voltages and currents — use for wide-area monitoring, state estimation, or grid stability analysis |
| Power Measurement | ee_sl_lib/Measurements/Power Measurement | R2023a+ | Measure active and reactive power from voltage and current signals — use for single-phase power monitoring, efficiency calculation, or control feedback |
| Power Measurement (Three-Phase) | ee_sl_lib/Measurements/Power Measurement (Three-Phase) | R2023a+ | Measure three-phase active and reactive power — use for power system monitoring, generator dispatch, or efficiency analysis in balanced systems |
| Power Measurement (Three-Phase, Instantaneous) | ee_sl_lib/Measurements/Power Measurement (Three-Phase, Instantaneous) | R2023a+ | Compute instantaneous three-phase power without filtering — use for fast power tracking, transient power analysis, or instantaneous control strategies |
| RMS Measurement | ee_sl_lib/Measurements/RMS Measurement | R2023a+ | Compute the RMS value of a periodic signal — use for voltage or current magnitude measurement, power quality assessment, or protection threshold detection |
| Sequence Analyzer | ee_sl_lib/Measurements/Sequence Analyzer | R2023a+ | Extract positive, negative, and zero sequence magnitudes from three-phase signals — use for unbalance detection, protection, or sequence-based control |
| Sinusoidal Measurement (PLL) | ee_sl_lib/Measurements/Sinusoidal Measurement (PLL) | R2023a+ | Extract magnitude, phase, and frequency of a sinusoidal signal using a PLL — use for grid synchronization, phase tracking, or frequency estimation |
| Sinusoidal Measurement (PLL, Three-Phase) | ee_sl_lib/Measurements/Sinusoidal Measurement (PLL, Three-Phase) | R2023a+ | Extract magnitude, phase, and frequency from three-phase sinusoidal signals using a PLL — use for grid synchronization in three-phase inverter control |
| Total Harmonic Distortion | ee_sl_lib/Measurements/Total Harmonic Distortion | R2023a+ | Measure THD of a periodic signal — use for power quality assessment, harmonic compliance checking, or filter performance evaluation |
| Induction Machine Flux Observer | ee_sl_lib/Observers/Induction Machine Flux Observer | R2023a+ | Estimate rotor or stator flux of an induction machine — use for sensorless field-oriented control or flux monitoring without direct measurement |
| Luenberger Observer | ee_sl_lib/Observers/Luenberger Observer | R2023a+ | Implement a Luenberger state observer for linear systems — use for state estimation in motor drives, converters, or control systems with unmeasured states |
| Quadrature Shaft Decoder | ee_sl_lib/Observers/Quadrature Shaft Decoder | R2023a+ | Decode quadrature encoder signals to position and speed — use for processing A/B encoder pulses into rotor angle and velocity for drive control |
| Resolver-to-Digital Converter | ee_sl_lib/Observers/Resolver-to-Digital Converter | R2023a+ | Convert resolver sine/cosine signals to digital angle and speed — use for processing resolver outputs into rotor position feedback for motor control |

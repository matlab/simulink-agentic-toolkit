---
type: Simulink Block Category
title: Physical signal dynamics
description: Integrators, transfer functions, state-space models, delays, and lookup tables for physical signals
tags: [integrator, transfer function, lookup table, delay, filter]
status: stable
source: mathworks_toolbox
library_root: Simscape
category_path: Physical signal dynamics
block_count: 16
---

# Physical signal dynamics

Use these blocks for physical signal dynamics.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| PS Constant Delay | fl_lib/Physical Signals/Delays/PS Constant Delay | R2023a+ | Use when delaying a physical signal by a fixed time interval |
| PS Variable Delay | fl_lib/Physical Signals/Delays/PS Variable Delay | R2023a+ | Use when delaying a physical signal by a time interval that varies during simulation |
| PS Asynchronous Sample & Hold | fl_lib/Physical Signals/Discrete/PS Asynchronous Sample & Hold | R2023a+ | Use when capturing and holding a physical signal value triggered by an asynchronous event |
| PS Integrator | fl_lib/Physical Signals/Linear Operators/PS Integrator | R2023a+ | Use when computing the time integral of a physical signal for accumulation or state tracking |
| PS State-Space | fl_lib/Physical Signals/Linear Operators/PS State-Space | R2025a+ | Use when implementing a linear state-space model in the physical signal domain for control or filtering |
| PS Transfer Function | fl_lib/Physical Signals/Linear Operators/PS Transfer Function | R2023a+ | Use when implementing a linear transfer function in the physical signal domain for filtering or compensation |
| PS Lookup Table (1D) | fl_lib/Physical Signals/Lookup Tables/PS Lookup Table (1D) | R2023a+ | Use when mapping a physical signal through a one-dimensional interpolation table |
| PS Lookup Table (2D) | fl_lib/Physical Signals/Lookup Tables/PS Lookup Table (2D) | R2023a+ | Use when mapping two physical signals through a two-dimensional interpolation table |
| PS Lookup Table (3D) | fl_lib/Physical Signals/Lookup Tables/PS Lookup Table (3D) | R2023a+ | Use when mapping three physical signals through a three-dimensional interpolation table |
| PS Lookup Table (4D) | fl_lib/Physical Signals/Lookup Tables/PS Lookup Table (4D) | R2023a+ | Use when mapping four physical signals through a four-dimensional interpolation table |
| PS Scattered Lookup Table (2D) | fl_lib/Physical Signals/Lookup Tables/PS Scattered Lookup Table (2D) | R2023a+ | Use when interpolating from irregularly spaced 2-D data points in the physical signal domain |
| PS Scattered Lookup Table (3D) | fl_lib/Physical Signals/Lookup Tables/PS Scattered Lookup Table (3D) | R2023a+ | Use when interpolating from irregularly spaced 3-D data points in the physical signal domain |
| PS Constant Offset Estimator | fl_lib/Physical Signals/Periodic Operators/PS Constant Offset Estimator | R2023a+ | Use when estimating the DC offset component of a periodic physical signal |
| PS Harmonic Estimator (Amplitude, Phase) | fl_lib/Physical Signals/Periodic Operators/PS Harmonic Estimator (Amplitude, Phase) | R2023a+ | Use when extracting harmonic amplitude and phase from a periodic physical signal |
| PS Harmonic Estimator (Real, Imaginary) | fl_lib/Physical Signals/Periodic Operators/PS Harmonic Estimator (Real, Imaginary) | R2023a+ | Use when extracting real and imaginary Fourier components from a periodic physical signal |
| PS RMS Estimator | fl_lib/Physical Signals/Periodic Operators/PS RMS Estimator | R2023a+ | Use when estimating the root-mean-square value of a periodic physical signal |

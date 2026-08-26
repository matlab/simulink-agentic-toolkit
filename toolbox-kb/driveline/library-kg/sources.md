---
type: Simulink Block Category
title: Sources
description: Mechanical excitation sources: sinusoidal, noise, and battery
tags: [source, sinusoidal, noise, battery, excitation]
status: stable
source: mathworks_toolbox
library_root: Driveline
category_path: Sources
block_count: 9
---

# Sources

Use these blocks for sources.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Battery (System-Level) | sdl_lib/Sources/Battery (System-Level) | R2023a+ | Model a battery as a voltage source with internal resistance and state-of-charge dynamics — use for system-level EV range studies or hybrid energy management |
| Force Noise Source | sdl_lib/Sources/Force Noise Source | R2023a+ | Generate random translational force excitation — use for vibration testing, NVH analysis, or stochastic load simulation in mechanical systems |
| Rotational Velocity Noise Source | sdl_lib/Sources/Rotational Velocity Noise Source | R2023a+ | Generate random rotational velocity excitation — use for vibration testing of rotating machinery or stochastic disturbance injection |
| Sinusoidal Rotational Velocity Source | sdl_lib/Sources/Sinusoidal Rotational Velocity Source | R2023a+ | Generate sinusoidal angular velocity — use for frequency-domain testing of rotational systems, resonance sweeps, or harmonic excitation |
| Sinusoidal Translational Velocity Source | sdl_lib/Sources/Sinusoidal Translational Velocity Source | R2023a+ | Generate sinusoidal linear velocity — use for frequency-domain testing of translational systems, vibration characterization, or shake testing |
| Sinusoidal Force Source | sdl_lib/Sources/Sinusoidal Force Source | R2023a+ | Generate sinusoidal force excitation — use for forced vibration analysis, frequency response testing, or harmonic load application |
| Sinusoidal Torque Source | sdl_lib/Sources/Sinusoidal Torque Source | R2023a+ | Generate sinusoidal torque excitation — use for torsional vibration analysis, frequency response testing, or rotational harmonic loading |
| Torque Noise Source | sdl_lib/Sources/Torque Noise Source | R2023a+ | Generate random torque excitation — use for NVH analysis, torsional vibration testing, or stochastic torque disturbance simulation |
| Translational Velocity Noise Source | sdl_lib/Sources/Translational Velocity Noise Source | R2023a+ | Generate random translational velocity excitation — use for vibration testing of linear systems or stochastic velocity disturbance injection |

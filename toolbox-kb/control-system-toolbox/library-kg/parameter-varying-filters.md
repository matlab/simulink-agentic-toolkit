---
type: Simulink Block Category
title: Parameter varying filters
description: Lowpass and notch filters whose cutoff or center frequency adapts to operating conditions.
tags: [filter, lowpass, notch, varying, bandwidth]
status: stable
source: custom_library
library_root: Control System Toolbox
category_path: Parameter varying filters
block_count: 4
---

# Parameter varying filters

Use these blocks for parameter varying filters.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Discrete Varying Lowpass | cstblocks/Linear Parameter Varying/Discrete Varying Lowpass | R2023a+ | Discrete first-order lowpass with an input-driven cutoff frequency. Use to schedule filter bandwidth against operating point on embedded targets. |
| Discrete Varying Notch | cstblocks/Linear Parameter Varying/Discrete Varying Notch | R2023a+ | Discrete notch filter with runtime-adjustable center frequency and depth. Use to attenuate a disturbance tone whose frequency shifts with operating condition in fixed-step models. |
| Varying Lowpass Filter | cstblocks/Linear Parameter Varying/Varying Lowpass Filter | R2023a+ | Continuous first-order lowpass whose cutoff frequency is set at runtime by an input. Use to adapt filter bandwidth to operating conditions, such as speed-dependent noise filtering. |
| Varying Notch Filter | cstblocks/Linear Parameter Varying/Varying Notch Filter | R2023a+ | Continuous notch filter with adjustable center frequency and depth from inputs. Use to reject a disturbance tone that tracks a scheduling variable, such as a resonance that moves with shaft speed. |

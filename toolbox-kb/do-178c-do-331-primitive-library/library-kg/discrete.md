---
type: Simulink Block Category
title: Discrete
description: Discrete-time delays and integration
tags: [discrete, delay, unit delay, integrator]
status: stable
source: custom_library
library_root: DO-178C/DO-331 Primitive Library
category_path: Discrete
block_count: 6
---

# Discrete

Use these blocks for discrete.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Decrement Real World | do178Lib/Simulink/Additional Math & Discrete/Additional Math: Increment - Decrement/Decrement Real World | R2023a+ | Decrease the Real World Value of Signal by 1.0 Overflows will always wrap. |
| Increment Real World | do178Lib/Simulink/Additional Math & Discrete/Additional Math: Increment - Decrement/Increment Real World | R2023a+ | Increase the Real World Value of Signal by 1.0 Overflows will always wrap. |
| Delay | do178Lib/Simulink/Discrete/Delay | R2023b+ | Delay a signal by a configurable number of sample steps — use to align timing or model transport delay in discrete systems. |
| Discrete-Time Integrator | do178Lib/Simulink/Discrete/Discrete-Time Integrator | R2023b+ | Accumulate a signal over time in discrete steps, with optional limits and reset — use for discrete integration in controllers and estimators. |
| Unit Delay | do178Lib/Simulink/Discrete/Unit Delay | R2023b+ | Hold the input for one sample period (z^-1) — use to introduce a one-step delay or break an algebraic loop. |
| Difference | do178Lib/Simulink/Discrete/Difference | R2023b+ | Output the current input value minus the previous input value. |

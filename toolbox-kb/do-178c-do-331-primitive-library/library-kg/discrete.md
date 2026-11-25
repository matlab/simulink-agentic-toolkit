---
type: Simulink Block Category
title: Discrete
description: Discrete-time delays and integration (6 blocks)
tags: [toolbox-kb, do-178c-do-331-primitive-library, discrete, delay, unit delay, integrator]
status: draft
sources:
  - resource: matlab:do178Lib
source: toolbox_kb
managed_by: satk
library: DO-178C/DO-331 Primitive Library
kb_folder: do-178c-do-331-primitive-library
category: discrete
block_count: 6
generated: { by: satk-toolbox-build/1, at: "2026-11-23T18:23:17Z" }
---

# Discrete

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Decrement Real World | do178Lib/Simulink/Additional Math & Discrete/Additional Math: Increment - Decrement/Decrement Real World | R2023a+ | Decrease the Real World Value of Signal by 1.0 Overflows will always wrap. |
| Increment Real World | do178Lib/Simulink/Additional Math & Discrete/Additional Math: Increment - Decrement/Increment Real World | R2023a+ | Increase the Real World Value of Signal by 1.0 Overflows will always wrap. |
| Delay | do178Lib/Simulink/Discrete/Delay | R2023b+ | Delay a signal by a configurable number of sample steps — use to align timing or model transport delay in discrete systems. |
| Discrete-Time Integrator | do178Lib/Simulink/Discrete/Discrete-Time Integrator | R2023b+ | Accumulate a signal over time in discrete steps, with optional limits and reset — use for discrete integration in controllers and estimators. |
| Unit Delay | do178Lib/Simulink/Discrete/Unit Delay | R2023b+ | Hold the input for one sample period (z^-1) — use to introduce a one-step delay or break an algebraic loop. |
| Difference | do178Lib/Simulink/Discrete/Difference | R2023b+ | Output the current input value minus the previous input value. |

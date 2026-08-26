---
type: Simulink Block Category
title: Initialized dynamics
description: Transfer functions and state-space with initial conditions
tags: [transfer, state-space, initial, discrete, zero-pole]
status: stable
source: mathworks_toolbox
library_root: Simulink Extras
category_path: Initialized dynamics
block_count: 10
---

# Initialized dynamics

Use these blocks for initialized dynamics.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Discrete Transfer Fcn (with initial outputs) | simulink_extras/Additional Discrete/Discrete Transfer Fcn (with initial outputs) | R2023a+ | Discrete transfer function with specified initial output values — use when you need a known output at t=0 for bumpless transfer or initialization |
| Discrete Transfer Fcn (with initial states) | simulink_extras/Additional Discrete/Discrete Transfer Fcn (with initial states) | R2023a+ | Discrete transfer function with specified initial state vector — use when internal filter states must match a known operating point |
| Discrete Zero-Pole (with initial outputs) | simulink_extras/Additional Discrete/Discrete Zero-Pole (with initial outputs) | R2023a+ | Discrete zero-pole model with specified initial outputs — use for initialized discrete filters defined by zeros and poles |
| Discrete Zero-Pole (with initial states) | simulink_extras/Additional Discrete/Discrete Zero-Pole (with initial states) | R2023a+ | Discrete zero-pole model with specified initial states — use when discrete filter states must be preset |
| Idealized ADC quantizer | simulink_extras/Additional Discrete/Idealized ADC quantizer | R2023a+ | Quantize a signal to n-bit ADC resolution — use for modeling analog-to-digital conversion effects without timing |
| State-Space (with initial outputs) | simulink_extras/Additional Linear/State-Space (with initial outputs) | R2023a+ | Continuous state-space model with specified initial outputs — use when output must start at a known value |
| Transfer Fcn (with initial outputs) | simulink_extras/Additional Linear/Transfer Fcn (with initial outputs) | R2023a+ | Continuous transfer function with specified initial outputs — use for bumpless initialization of continuous filters |
| Transfer Fcn (with initial states) | simulink_extras/Additional Linear/Transfer Fcn (with initial states) | R2023a+ | Continuous transfer function with specified initial state vector — use when filter states must match a trim condition |
| Zero-Pole (with initial outputs) | simulink_extras/Additional Linear/Zero-Pole (with initial outputs) | R2023a+ | Continuous zero-pole model with specified initial outputs — use for initialized continuous filters defined by zeros and poles |
| Zero-Pole (with initial states) | simulink_extras/Additional Linear/Zero-Pole (with initial states) | R2023a+ | Continuous zero-pole model with specified initial states — use when filter internal states must be preset |

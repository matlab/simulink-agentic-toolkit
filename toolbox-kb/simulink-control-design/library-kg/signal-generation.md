---
type: Simulink Block Category
title: Signal generation
description: Test signal generators for identification
tags: [prbs, sinestream, superposition, start-stop, signal]
status: stable
source: mathworks_toolbox
library_root: Simulink Control Design
category_path: Signal generation
block_count: 5
---

# Signal generation

Use these blocks for signal generation.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Frequency Response Estimator | slctrl_fre/Frequency Response Estimator | R2023b+ | Estimate frequency response during simulation — use for online Bode measurement of a running system |
| PRBS Signal Generator | slctrl_signal/PRBS Signal Generator | R2024a+ | Generate pseudo-random binary sequence — use for broadband excitation in system identification and frequency response tests |
| Sinestream Signal Generator | slctrl_signal/Sinestream Signal Generator | R2024a+ | Generate swept or stepped sinusoidal excitation — use for frequency-by-frequency plant identification |
| Start-Stop Generator | slctrl_signal/Start-Stop Generator | R2024a+ | Generate start and stop triggers for experiments — use for coordinating autotuning experiment timing |
| Superposition Signal Generator | slctrl_signal/Superposition Signal Generator | R2024b+ | Superimpose perturbation on a control signal — use for injecting test signals without disrupting normal operation |

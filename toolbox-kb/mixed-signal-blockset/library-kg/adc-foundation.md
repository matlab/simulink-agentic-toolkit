---
type: Simulink Block Category
title: Adc foundation
description: ADC building blocks and modulators
tags: [integrator, dsm, quantizer, clock, modulator]
status: stable
source: mathworks_toolbox
library_root: Mixed-Signal Blockset
category_path: Adc foundation
block_count: 5
---

# Adc foundation

Use these blocks for adc foundation.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Continuous Time Delta Sigma Modulator | msbAdcFoundation/Continuous Time Delta Sigma Modulator | R2024b+ | Model a continuous-time delta-sigma ADC — use for simulating oversampled CT DSM architectures with noise shaping |
| DT Integrator | msbAdcFoundation/DT Integrator | R2026a+ | Discrete-time integrator for delta-sigma modulators — use for modeling switched-capacitor integrators in DT DSMs |
| Delta Sigma Modulator | msbAdcFoundation/Delta Sigma Modulator | R2023a+ | Model a discrete-time delta-sigma modulator — use for simulating oversampled DT DSM architectures |
| Quantizer | msbAdcFoundation/Quantizer | R2026a+ | Multi-level quantizer for DSM loops — use for modeling the comparator array within delta-sigma modulators |
| Sampling Clock Source | msbAdcFoundation/Sampling Clock Source | R2023a+ | Generate a sampling clock with jitter — use for providing realistic clock signals to ADC models |

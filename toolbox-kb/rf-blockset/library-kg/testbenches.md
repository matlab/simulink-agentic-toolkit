---
type: Simulink Block Category
title: Testbenches
description: RF measurement testbenches
tags: [testbench, iip3, noise figure, gain, oip]
status: stable
source: mathworks_toolbox
library_root: RF Blockset
category_path: Testbenches
block_count: 9
---

# Testbenches

Use these blocks for testbenches.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| IIP2 Testbench | simrfV2testbenches/IIP2 Testbench | R2023a+ | Measure input 2nd-order intercept point — use for characterizing 2nd-order nonlinearity |
| IIP3 Testbench | simrfV2testbenches/IIP3 Testbench | R2023a+ | Measure input 3rd-order intercept point — use for characterizing 3rd-order nonlinearity and dynamic range |
| Noise Figure Testbench | simrfV2testbenches/Noise Figure Testbench | R2023a+ | Measure noise figure — use for characterizing receiver noise performance |
| MATLAB Function | simrfV2testbenches/Noise Figure Testbench/Enabled Subsystem/MATLAB Function | R2023a+ | Custom MATLAB function in RF model — use for implementing custom signal processing within testbenches |
| OIP2 Testbench | simrfV2testbenches/OIP2 Testbench | R2023a+ | Measure output 2nd-order intercept point — use for characterizing transmitter 2nd-order distortion |
| OIP3 Testbench | simrfV2testbenches/OIP3 Testbench | R2023a+ | Measure output 3rd-order intercept point — use for characterizing transmitter 3rd-order distortion |
| S-Parameter Testbench | simrfV2testbenches/S-Parameter Testbench | R2023a+ | Measure S-parameters of a circuit — use for extracting scattering parameters from an RF subsystem |
| Transducer Gain Testbench | simrfV2testbenches/Transducer Gain Testbench | R2023a+ | Measure transducer power gain — use for characterizing amplifier gain under specific source and load conditions |
| Enable | simrfV2testbenches/Noise Figure Testbench/Enabled Subsystem/Enable | R2023a+ | Enable port for conditional execution — use for gating subsystem execution in testbenches |

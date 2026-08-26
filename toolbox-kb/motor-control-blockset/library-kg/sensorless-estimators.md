---
type: Simulink Block Category
title: Sensorless estimators
description: Rotor position and speed observers that eliminate the need for a physical position sensor
tags: [sensorless, observer, flux, sliding mode, EMF, high frequency]
status: stable
source: mathworks_toolbox
library_root: Motor Control Blockset
category_path: Sensorless estimators
block_count: 4
---

# Sensorless estimators

Use these blocks for sensorless estimators.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Extended EMF Observer | mcblib/Sensorless Estimators/Extended EMF Observer | R2023a+ | Estimate rotor position of a salient PMSM from extended back-EMF at medium-to-high speed — use for sensorless FOC of interior PMSMs above the low-speed region |
| Flux Observer | mcblib/Sensorless Estimators/Flux Observer | R2023a+ | Estimate stator flux and rotor angle by integrating the voltage equation with drift compensation — use as the position observer for medium- to high-speed sensorless FOC |
| Pulsating High Freq Observer | mcblib/Sensorless Estimators/Pulsating High Freq Observer | R2023a+ | Inject a high-frequency voltage signal on the d-axis and demodulate the resulting current ripple to extract rotor position — use for sensorless PMSM control at zero and low speed where back-EMF is too small |
| Sliding Mode Observer | mcblib/Sensorless Estimators/Sliding Mode Observer | R2023a+ | Estimate back-EMF and rotor angle using a sliding-mode current observer — use for robust sensorless PMSM position estimation in the presence of parameter variation |

---
type: Simulink Block Category
title: Rate conversion
description: Rate transition and interpolation between solver domains (4 blocks)
tags: [toolbox-kb, network-couplers, prediction, smoothing, rate, discrete, continuous]
status: stable
sources:
  - resource: matlab:SimscapeNetworkCouplersLib
source: toolbox_kb
managed_by: satk
library: Network Couplers
kb_folder: network-couplers
category: rate-conversion
block_count: 4
generated: { by: satk-toolbox-build/1, at: "2026-11-23T18:23:24Z" }
---

# Rate conversion

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Prediction (discrete->continuous) | SimscapeNetworkCouplersLib/Fundamental Components/Prediction (discrete->continuous) | R2023a+ | Predict continuous-time values from discrete-time samples — use at the boundary where a discrete solver feeds into a continuous Simscape network |
| Prediction (slow->fast) | SimscapeNetworkCouplersLib/Fundamental Components/Prediction (slow->fast) | R2023a+ | Predict fast-rate values from slow-rate samples — use at multi-rate boundaries where a slow subsystem drives a faster Simscape network |
| Smoothing (continuous->discrete) | SimscapeNetworkCouplersLib/Fundamental Components/Smoothing (continuous->discrete) | R2023a+ | Smooth continuous-time signals for discrete sampling — use at the boundary where a continuous Simscape network feeds into a discrete solver |
| Smoothing (fast->slow) | SimscapeNetworkCouplersLib/Fundamental Components/Smoothing (fast->slow) | R2023a+ | Smooth fast-rate signals for slow-rate consumption — use at multi-rate boundaries where a fast Simscape network feeds a slower subsystem |

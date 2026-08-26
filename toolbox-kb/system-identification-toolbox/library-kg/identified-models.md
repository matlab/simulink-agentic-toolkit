---
type: Simulink Block Category
title: Identified models
description: Simulation of identified dynamic models
tags: [model, idmodel, nonlinear, arx, neural]
status: stable
source: mathworks_toolbox
library_root: System Identification Toolbox
category_path: Identified models
block_count: 5
---

# Identified models

Use these blocks for identified models.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Hammerstein-Wiener Model | slident/Models/Hammerstein-Wiener Model | R2023a+ | Simulate a Hammerstein-Wiener nonlinear model — use for modeling systems with input and output static nonlinearities surrounding a linear dynamic core |
| Idmodel | slident/Models/Idmodel | R2023a+ | Simulate any identified linear model in Simulink — use for embedding estimated transfer functions, state-space, or polynomial models into a system simulation |
| Neural State Space Model | slident/Models/Neural State Space Model | R2023a+ | Simulate a neural network-based state space model — use for deploying deep learning-identified dynamics models in Simulink for prediction or control |
| Nonlinear ARX Model | slident/Models/Nonlinear ARX Model | R2023a+ | Simulate a nonlinear autoregressive model with exogenous inputs — use for deploying identified NLARX models that capture nonlinear input-output behavior |
| Nonlinear Grey-Box Model | slident/Models/Nonlinear Grey-Box Model | R2023a+ | Simulate a nonlinear grey-box model with estimated parameters — use for deploying first-principles models whose parameters were identified from data |

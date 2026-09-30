---
type: Simulink Block Category
title: State estimators
description: Online recursive state and parameter estimation from noisy measurements
tags: [kalman, filter, estimator, particle, recursive least squares, estimation]
status: stable
source: custom_library
library_root: System Identification Toolbox
category_path: State estimators
block_count: 7
---

# State estimators

Use these blocks for state estimators.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Extended Kalman Filter | slident/Estimators/Extended Kalman Filter | R2023a+ | Estimate states of a nonlinear system online by linearizing the dynamics about the current estimate at each step — use for state/parameter estimation when the model is differentiable and only mildly nonlinear. |
| Kalman Filter | slident/Estimators/Kalman Filter | R2023a+ | Optimal recursive state observer for linear (time-invariant or time-varying) systems driven by Gaussian noise — use for sensor fusion and state estimation when a linear model is adequate. |
| Particle Filter | slident/Estimators/Particle Filter | R2023a+ | Estimate states of a highly nonlinear or non-Gaussian system with a set of weighted sample particles — use for multimodal problems where Kalman-family filters fail. |
| Recursive Least Squares Estimator | slident/Estimators/Recursive Least Squares Estimator | R2023a+ | Estimate model parameters online by recursively minimizing squared prediction error — use for adaptive parameter identification and online model tuning as data arrives. |
| Unscented Kalman Filter | slident/Estimators/Unscented Kalman Filter | R2023a+ | Estimate states of a nonlinear system using deterministic sigma-point sampling instead of Jacobian linearization — use when nonlinearities are strong enough that an EKF loses accuracy. |
| Model Type Converter | slident/Estimators/Model Type Converter | R2023a+ | Convert discrete-time polynomial model coefficients (ARX, ARMAX, OE, BJ) to state-space matrices. |
| Recursive Polynomial Model Estimator | slident/Estimators/Recursive Polynomial Model Estimator | R2023a+ | Estimate discrete-time, polynomial models of AR, ARX, ARMA, ARMAX, BJ or OE structures. |

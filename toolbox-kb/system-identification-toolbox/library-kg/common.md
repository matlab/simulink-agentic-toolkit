---
type: Block Selection Guide
title: Common Blocks
description: High-value blocks selected for quick agent discovery.
status: stable
source: custom_library
block_count: 12
---

# Common Blocks

Prefer these blocks when their intent matches the user request.

| Intent | Preferred Block | Library |
|---|---|---|
| Estimate states of a nonlinear system online by linearizing the dynamics about the current estimate at each step — use for state/parameter estimation when the model is differentiable and only mildly nonlinear. | Extended Kalman Filter | System Identification Toolbox |
| Optimal recursive state observer for linear (time-invariant or time-varying) systems driven by Gaussian noise — use for sensor fusion and state estimation when a linear model is adequate. | Kalman Filter | System Identification Toolbox |
| Estimate states of a highly nonlinear or non-Gaussian system with a set of weighted sample particles — use for multimodal problems where Kalman-family filters fail. | Particle Filter | System Identification Toolbox |
| Estimate model parameters online by recursively minimizing squared prediction error — use for adaptive parameter identification and online model tuning as data arrives. | Recursive Least Squares Estimator | System Identification Toolbox |
| Estimate states of a nonlinear system using deterministic sigma-point sampling instead of Jacobian linearization — use when nonlinearities are strong enough that an EKF loses accuracy. | Unscented Kalman Filter | System Identification Toolbox |
| Export simulation data to workspace as IDDATA object. The object stores input and output signals sampled at the specified sample time when simulation stops. The object is created in the MATLAB base workspace when simulating from the model window or caller workspace when simulating programmatically. Specify the variable name in "IDDATA Name". Specify a positive number, representing the sampling interval, in "Sample Time". | Iddata Sink | System Identification Toolbox |
| This block allows to import IDDATA object from the MATLAB Workspace. The first output port of the block corresponds to the input signal of the IDDATA object and the second output port corresponds to the output signal. Specify a variable representing an IDDATA object corresponding to a single-experiment, time-domain data. Start time = -1 means that the start time for the signals in the IDDATA object matches that of the Simulink model. You can change it to a specific value (such as the value of the "Tstart" property of the IDDATA object) by specifying a non-negative real scalar value for it. | Iddata Source | System Identification Toolbox |
| Simulate a Hammerstein-Wiener (idnlhw) model. Specify the name of an estimated idnlhw model for "Model". Specify initial conditions for simulation as one of the following: 1. String "zero" to use a value of zero for all initial state values. 2. Double vector representing the initial states of the linear block of the model. Click on Help button for information on how to determine initial states from various requirements. | Hammerstein-Wiener Model | System Identification Toolbox |
| The Idmodel block accepts any of the linear identified models: state-space (idss), linear grey box (idgrey), polynomial (idpoly), transfer function (idtf) or process (idproc) models. Internally, models will be converted to their state-space equivalent for evaluation. Specify initial conditions as a numeric vector (idss, idgrey only) or as an initialCondition object. Use '[]' to denote zero initial condition. For simulations with noise, Seed(s) may be left empty for random restarts. To generate specific noise realizations, specify one noise seed per output. | Idmodel | System Identification Toolbox |
| Simulate a Neural State Space model. Specify a trained "idNeuralStateSpace" object in the "Model" parameter. | Neural State Space Model | System Identification Toolbox |
| Convert discrete-time polynomial model coefficients (ARX, ARMAX, OE, BJ) to state-space matrices. | Model Type Converter | System Identification Toolbox |
| Estimate discrete-time, polynomial models of AR, ARX, ARMA, ARMAX, BJ or OE structures. | Recursive Polynomial Model Estimator | System Identification Toolbox |

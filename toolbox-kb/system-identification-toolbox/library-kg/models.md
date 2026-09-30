---
type: Simulink Block Category
title: Models
description: Identified dynamic models for simulation and prediction
tags: [model, idmodel, polynomial, transfer function]
status: stable
source: custom_library
library_root: System Identification Toolbox
category_path: Models
block_count: 7
---

# Models

Use these blocks for models.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Iddata Sink | slident/Iddata Sink | R2023a+ | Export simulation data to workspace as IDDATA object. The object stores input and output signals sampled at the specified sample time when simulation stops. The object is created in the MATLAB base workspace when simulating from the model window or caller workspace when simulating programmatically. Specify the variable name in "IDDATA Name". Specify a positive number, representing the sampling interval, in "Sample Time". |
| Iddata Source | slident/Iddata Source | R2023a+ | This block allows to import IDDATA object from the MATLAB Workspace. The first output port of the block corresponds to the input signal of the IDDATA object and the second output port corresponds to the output signal. Specify a variable representing an IDDATA object corresponding to a single-experiment, time-domain data. Start time = -1 means that the start time for the signals in the IDDATA object matches that of the Simulink model. You can change it to a specific value (such as the value of the "Tstart" property of the IDDATA object) by specifying a non-negative real scalar value for it. |
| Hammerstein-Wiener Model | slident/Models/Hammerstein-Wiener Model | R2023a+ | Simulate a Hammerstein-Wiener (idnlhw) model. Specify the name of an estimated idnlhw model for "Model". Specify initial conditions for simulation as one of the following: 1. String "zero" to use a value of zero for all initial state values. 2. Double vector representing the initial states of the linear block of the model. Click on Help button for information on how to determine initial states from various requirements. |
| Idmodel | slident/Models/Idmodel | R2023a+ | The Idmodel block accepts any of the linear identified models: state-space (idss), linear grey box (idgrey), polynomial (idpoly), transfer function (idtf) or process (idproc) models. Internally, models will be converted to their state-space equivalent for evaluation. Specify initial conditions as a numeric vector (idss, idgrey only) or as an initialCondition object. Use '[]' to denote zero initial condition. For simulations with noise, Seed(s) may be left empty for random restarts. To generate specific noise realizations, specify one noise seed per output. |
| Neural State Space Model | slident/Models/Neural State Space Model | R2023a+ | Simulate a Neural State Space model. Specify a trained "idNeuralStateSpace" object in the "Model" parameter. |
| Nonlinear ARX Model | slident/Models/Nonlinear ARX Model | R2023a+ | Simulate a nonlinear ARX (idnlarx) model. Specify the name of an estimated idnlarx model for "Model". Specify initial conditions for simulation as one of the following: 1. Steady-state (equilibrium) input and output signal levels. 2. An initial state vector. Click on Help button for information on how to determine initial states from various requirements. |
| Nonlinear Grey-Box Model | slident/Models/Nonlinear Grey-Box Model | R2023a+ | Enter name of an IDNLGREY object and, optionally, an initial state X0. |

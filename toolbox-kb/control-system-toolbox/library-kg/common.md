---
type: Block Selection Guide
title: Common Blocks
description: High-value blocks selected for quick agent discovery.
status: stable
source: custom_library
block_count: 14
---

# Common Blocks

Prefer these blocks when their intent matches the user request.

| Intent | Preferred Block | Library |
|---|---|---|
| Simulate an imported Control System Toolbox LTI model object (tf/ss/zpk) directly as a block — use to drop a designed or identified linear model into a model. | LTI System | Control System Toolbox |
| Simulate a linear parameter-varying model that interpolates among precomputed linearizations by a scheduling parameter — use to represent a nonlinear plant for gain-scheduled control design. | LPV System | Control System Toolbox |
| Simulate a linear time-varying model whose matrices change with time — use for trajectory-linearized dynamics. | LTV System | Control System Toolbox |
| Continuous-time gain-scheduled PID with runtime-varying gains — use for LPV control of a continuous plant. | Varying PID Controller | Control System Toolbox |
| Estimate states of a nonlinear system online by linearizing the dynamics about the current estimate — use for state/parameter estimation when the model is differentiable and only mildly nonlinear. | Extended Kalman Filter | Control System Toolbox |
| Optimal recursive state observer for a linear system with Gaussian noise — use for sensor fusion and state estimation when a linear model is adequate. | Kalman Filter | Control System Toolbox |
| Simulate a large sparse second-order (mechanical/FE-style) model efficiently — use for high-order structural or mechanical dynamics without dense state-space. | Sparse Second Order | Control System Toolbox |
| Discrete-time gain-scheduled two-degree-of-freedom PID whose gains vary with scheduling inputs — use for LPV control with separate setpoint and feedback weighting. | Discrete Varying 2DOF PID | Control System Toolbox |
| Discrete-time delay whose length varies at runtime from an input — use in gain-scheduled/LPV models with time-varying transport delay. | Discrete Varying Delay | Control System Toolbox |
| Discrete-time lowpass filter whose cutoff varies at runtime — use for adaptive filtering within a gain-scheduled design. | Discrete Varying Lowpass | Control System Toolbox |
| Discrete-time notch filter whose notch frequency varies at runtime — use to reject a time-varying tone in an LPV design. | Discrete Varying Notch | Control System Toolbox |
| Discrete-time observer-canonical state-space block with matrices supplied at runtime — use for LPV estimation/control in observer form. | Discrete Varying Observer Form | Control System Toolbox |
| Estimate states of a highly nonlinear or non-Gaussian system using weighted sample particles — use when Kalman-family filters fail on multimodal or strongly nonlinear problems. | Particle Filter | Control System Toolbox |
| Estimate states of a nonlinear system using sigma-point sampling instead of linearization — use when EKF accuracy degrades from strong nonlinearity. | Unscented Kalman Filter | Control System Toolbox |

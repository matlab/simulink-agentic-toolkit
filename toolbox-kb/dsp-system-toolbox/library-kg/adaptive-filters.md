---
type: Simulink Block Category
title: Adaptive filters
description: Adaptive filtering structures and updates
tags: [adaptive, lms, frequency-domain adaptive]
status: stable
source: custom_library
library_root: DSP System Toolbox
category_path: Adaptive filters
block_count: 7
---

# Adaptive filters

Use these blocks for adaptive filters.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Block LMS Filter | dspadpt3/Block LMS Filter | R2023a+ | Computes filter weights based on the Block LMS algorithm for filtering of the input signal. The filter weights are updated once for every block of data that is processed. Select the Adapt port check box to create an Adapt port on the block. When the input to this port is nonzero, the block continuously updates the filter weights. When the input to this port is zero, the filter weights remain constant. If the Reset port is enabled and a reset event occurs, the block resets the filter weights to their initial values. |
| Frequency-Domain Adaptive Filter | dspadpt3/Frequency-Domain Adaptive Filter | R2023a+ | Adaptive FIR filter that updates its coefficients in the frequency domain — use for efficient adaptation of long filters such as echo cancellers. |
| LMS Filter | dspadpt3/LMS Filter | R2023a+ | Adapts the filter weights based on the chosen algorithm for filtering of the input signal. Select the Adapt port check box to create an Adapt port on the block. When the input to this port is nonzero, the block continuously updates the filter weights. When the input to this port is zero, the filter weights remain constant. If the Reset port is enabled and a reset event occurs, the block resets the filter weights to their initial values. |
| LMS Update | dspadpt3/LMS Update | R2023a+ | Compute the LMS/normalized-LMS coefficient update for an adaptive filter — use to build custom adaptive-filter structures. |
| Fast Block LMS Filter | dspadpt3/Fast Block LMS Filter | R2023a+ | Computes filter weights based on the Fast Block LMS algorithm for filtering of the input signal. The filter weights are updated once for every block of data that is processed. This block uses FFT for fast convolution. Select the Adapt port check box to create an Adapt port on the block. When the input to this port is nonzero, the block continuously updates the filter weights. When the input to this port is zero, the filter weights remain constant. If the Reset port is enabled and a reset event occurs, the block resets the filter weights to their initial values. |
| Kalman Filter | dspadpt3/Kalman Filter | R2023a+ | Estimate the state of a dynamic system from a series of incomplete and/or noisy measurements. This block can use the previously estimated state to predict the current state. It can also use the current measurement and the predicted state to estimate the current state value. All filters have the same state transition matrix, measurement matrix, initial conditions, and noise covariance, but their state, measurement, enable, and MSE signals are unique. Within the state, measurement, enable, and MSE signals, each column corresponds to a filter. |
| RLS Filter | dspadpt3/RLS Filter | R2023a+ | Computes filter weights based on the exponentially weighted recursive least-squares (RLS) algorithm for adaptive filtering of the input signal. Select the Adapt port check box to create an Adapt port on the block. When the input to this port is nonzero, the block continuously updates the filter weights. When the input to this port is zero, the filter weights remain constant. If the Reset port is enabled and a reset event occurs, the block resets the filter weights to their initial values. |

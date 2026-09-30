---
type: Simulink Block Category
title: Statistics
description: Moving statistics and power measurement
tags: [statistics, moving, power meter, median]
status: stable
source: custom_library
library_root: DSP System Toolbox
category_path: Statistics
block_count: 17
---

# Statistics

Use these blocks for statistics.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Autocorrelation | dspstat3/Autocorrelation | R2023a+ | Compute the autocorrelation along the first dimension of an N-D input array. |
| Correlation | dspstat3/Correlation | R2023a+ | Correlate two inputs in the time or frequency domain. To allow the block to compute the correlation in the domain that minimizes the number of computations, set the 'Computation domain' parameter to 'Fastest'. To minimize memory usage, set the 'Computation domain' parameter to 'Time'. |
| Histogram | dspstat3/Histogram | R2023a+ | Generate a histogram of the elements in the specified dimension of the input or across time (running histogram). |
| Maximum | dspstat3/Maximum | R2023a+ | Compute the maximum value along the specified dimension of the input or across time (running maximum). |
| Mean | dspstat3/Mean | R2023a+ | Compute the mean value along the specified dimension of the input or across time (running mean). |
| Minimum | dspstat3/Minimum | R2023a+ | Compute the minimum value along the specified dimension of the input or across time (running minimum). |
| Moving Average | dspstat3/Moving Average | R2023a+ | Compute a moving (sliding-window or exponential) average — use for smoothing or trend extraction. |
| Moving Maximum | dspstat3/Moving Maximum | R2023a+ | Compute the moving maximum over a sliding window — use for peak tracking. |
| Moving Minimum | dspstat3/Moving Minimum | R2023a+ | Compute the moving minimum over a sliding window — use for trough tracking. |
| Moving RMS | dspstat3/Moving RMS | R2023a+ | Compute the moving root-mean-square over a window — use to track signal energy or level. |
| Moving Standard Deviation | dspstat3/Moving Standard Deviation | R2023a+ | Compute the moving standard deviation over a window — use to track signal variability. |
| Moving Variance | dspstat3/Moving Variance | R2023a+ | Compute the moving variance over a window — use to track signal spread. |
| Power Meter | dspstat3/Power Meter | R2023a+ | Measure the average and peak power of a signal — use to monitor signal levels. |
| RMS | dspstat3/RMS | R2023a+ | Compute the root-mean-square (RMS) along the specified dimension of the input or across time (running RMS). |
| Standard Deviation | dspstat3/Standard Deviation | R2023a+ | Compute the standard deviation along the specified dimension of the input or across time (running standard deviation). |
| Variance | dspstat3/Variance | R2023a+ | Compute the variance along the specified dimension of the input or across time (running variance). |
| Detrend | dspstat3/Detrend | R2023a+ | Remove linear trend from vector input. |

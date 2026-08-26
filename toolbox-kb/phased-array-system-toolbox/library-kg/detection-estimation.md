---
type: Simulink Block Category
title: Detection estimation
description: Target detection, matched filtering, CFAR, and range-Doppler processing
tags: [detection, CFAR, matched-filter, range, Doppler, SNR]
status: stable
source: mathworks_toolbox
library_root: Phased Array System Toolbox
category_path: Detection estimation
block_count: 15
---

# Detection estimation

Use these blocks for detection estimation.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Dechirp Mixer | phaseddetectlib/Dechirp Mixer | R2023a+ | Mix a received chirp signal with a reference to convert range into frequency for stretch processing |
| Pulse Integrator | phaseddetectlib/Pulse Integrator | R2023a+ | Coherently or noncoherently integrate multiple radar pulses to improve detection SNR |
| Whitening Matrix | phaseddetectlib/Whitening Matrix | R2026a+ | Compute the whitening transformation to decorrelate noise and interference in array data |
| 2-D CFAR Detector | phaseddetectlib/2-D CFAR Detector | R2023a+ | Detect targets in range-Doppler or range-angle maps using 2-D constant false alarm rate processing |
| CFAR Detector | phaseddetectlib/CFAR Detector | R2023a+ | Detect targets using constant false alarm rate processing with adaptive threshold estimation |
| Doppler Estimator | phaseddetectlib/Doppler Estimator | R2023a+ | Estimate target Doppler shift from detection indices in range-Doppler processing |
| GLRT Detector | phaseddetectlib/GLRT Detector | R2023b+ | Detect targets using the generalized likelihood ratio test when signal parameters are unknown |
| LRT Detector | phaseddetectlib/LRT Detector | R2023b+ | Detect targets using the likelihood ratio test when noise statistics are known |
| Matched Filter | phaseddetectlib/Matched Filter | R2023a+ | Apply matched filtering to maximize SNR of a known radar waveform in received data |
| Range Angle Response | phaseddetectlib/Range Angle Response | R2023a+ | Compute a joint range-angle map from array data for target localization |
| Range Doppler Response | phaseddetectlib/Range Doppler Response | R2023a+ | Compute range-Doppler map from pulse data for simultaneous range and velocity estimation |
| Range Estimator | phaseddetectlib/Range Estimator | R2023a+ | Estimate target range from detection indices in range-processed data |
| Range Response | phaseddetectlib/Range Response | R2023a+ | Compute range response from time-domain pulse data via matched filtering or dechirp |
| Stretch Processor | phaseddetectlib/Stretch Processor | R2023a+ | Process dechirped wideband signals to extract range information via spectral analysis |
| Time Varying Gain | phaseddetectlib/Time Varying Gain | R2023a+ | Apply range-dependent gain to compensate for propagation loss in received radar signals |

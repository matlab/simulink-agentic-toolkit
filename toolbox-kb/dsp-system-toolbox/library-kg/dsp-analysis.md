---
type: Simulink Block Category
title: Dsp analysis
description: Signal analysis: estimation, feature extraction, statistics, and transforms
tags: [estimation, feature, statistics, spectrum, transform]
status: stable
source: mathworks_toolbox
library_root: DSP System Toolbox
category_path: Dsp analysis
block_count: 6
---

# Dsp analysis

Use these blocks for dsp analysis.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Estimation | dsplibv4/Estimation | R2023a+ | Estimate signal parameters including power spectrum, autocorrelation, and frequency content — use for spectral analysis, system identification, or adaptive filtering applications |
| Frequency Feature Extractor | dspfeatures/Frequency Feature Extractor | R2026a+ | Extract frequency-domain features (spectral centroid, bandwidth, roll-off) from signals — use for condition monitoring, audio classification, or vibration analysis feature engineering |
| Time Feature Extractor | dspfeatures/Time Feature Extractor | R2025a+ | Extract time-domain features (RMS, crest factor, kurtosis, peak-to-peak) from signals — use for condition monitoring or signal characterization without transforming to frequency domain |
| Wavelet Scattering | dspfeatures/Wavelet Scattering | R2023a+ | Compute wavelet scattering transform coefficients for robust signal representation — use for signal classification tasks where translation-invariant features outperform raw spectral content |
| Statistics | dsplibv4/Statistics | R2023a+ | Compute running statistics (mean, variance, histogram, min/max) on streaming signals — use for online signal monitoring and statistical characterization |
| Transforms | dsplibv4/Transforms | R2023a+ | Apply spectral and time-frequency transforms (FFT, DCT, Hilbert, spectrogram) — use to convert signals between time and frequency domains for analysis or processing |

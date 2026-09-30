---
type: Block Selection Guide
title: Common Blocks
description: High-value blocks selected for quick agent discovery.
status: stable
source: custom_library
block_count: 30
---

# Common Blocks

Prefer these blocks when their intent matches the user request.

| Intent | Preferred Block | Library |
|---|---|---|
| Apply a tunable lowpass filter specified by cutoff frequency — use for smoothing or anti-aliasing. | Lowpass Filter | DSP System Toolbox |
| Apply an FIR filter with given coefficients — use for general linear-phase filtering. | Discrete FIR Filter | DSP System Toolbox |
| Convert between arbitrary sample rates with an automatically-designed multistage filter chain — use for high-quality rate conversion. | Sample-Rate Converter | DSP System Toolbox |
| Collect scalar samples into frames with optional overlap — use to convert sample-based to frame-based processing. | Buffer | DSP System Toolbox |
| Numerically controlled oscillator generating sine/cosine from a phase accumulator — use as a tunable carrier or tone source. | NCO | DSP System Toolbox |
| Convert between arbitrary sample rates with an automatically-designed multistage filter chain — use for high-quality rate conversion. | Sample-Rate Converter | DSP System Toolbox |
| Display the frequency spectrum of a signal during simulation — use to inspect spectral content. | Spectrum Analyzer | DSP System Toolbox |
| Plot signals against time during simulation — use to view waveforms. | Time Scope | DSP System Toolbox |
| Numerically controlled oscillator generating sine/cosine from a phase accumulator — use as a tunable carrier or tone source. | NCO | DSP System Toolbox |
| Computes filter weights based on the Block LMS algorithm for filtering of the input signal. The filter weights are updated once for every block of data that is processed. Select the Adapt port check box to create an Adapt port on the block. When the input to this port is nonzero, the block continuously updates the filter weights. When the input to this port is zero, the filter weights remain constant. If the Reset port is enabled and a reset event occurs, the block resets the filter weights to their initial values. | Block LMS Filter | DSP System Toolbox |
| Adapts the filter weights based on the chosen algorithm for filtering of the input signal. Select the Adapt port check box to create an Adapt port on the block. When the input to this port is nonzero, the block continuously updates the filter weights. When the input to this port is zero, the filter weights remain constant. If the Reset port is enabled and a reset event occurs, the block resets the filter weights to their initial values. | LMS Filter | DSP System Toolbox |
| Computes filter weights based on the Fast Block LMS algorithm for filtering of the input signal. The filter weights are updated once for every block of data that is processed. This block uses FFT for fast convolution. Select the Adapt port check box to create an Adapt port on the block. When the input to this port is nonzero, the block continuously updates the filter weights. When the input to this port is zero, the filter weights remain constant. If the Reset port is enabled and a reset event occurs, the block resets the filter weights to their initial values. | Fast Block LMS Filter | DSP System Toolbox |
| Estimate the state of a dynamic system from a series of incomplete and/or noisy measurements. This block can use the previously estimated state to predict the current state. It can also use the current measurement and the predicted state to estimate the current state value. All filters have the same state transition matrix, measurement matrix, initial conditions, and noise covariance, but their state, measurement, enable, and MSE signals are unique. Within the state, measurement, enable, and MSE signals, each column corresponds to a filter. | Kalman Filter | DSP System Toolbox |
| Computes filter weights based on the exponentially weighted recursive least-squares (RLS) algorithm for adaptive filtering of the input signal. Select the Adapt port check box to create an Adapt port on the block. When the input to this port is nonzero, the block continuously updates the filter weights. When the input to this port is zero, the filter weights remain constant. If the Reset port is enabled and a reset event occurs, the block resets the filter weights to their initial values. | RLS Filter | DSP System Toolbox |
| Detect signal anomalies using a trained deepSignalAnomalyDetectorLSTM or deepSignalAnomalyDetectorLSTMForecaster object. A Deep Learning Toolbox license is required. | Deep Signal Anomaly Detector | DSP System Toolbox |
| A template Dataflow subsystem. | Dataflow Subsystem | DSP System Toolbox |
| Frame-based parametric AR estimation using the Burg maximum entropy method. Outputs AR model coefficients A and/or reflection coefficients K, plus the model gain, G. | Burg AR Estimator | DSP System Toolbox |
| Frame-based parametric AR estimation using the Covariance method. The AR model coefficients are given in A and the gain is given in G. | Covariance AR Estimator | DSP System Toolbox |
| Frame-based parametric AR estimation using the Modified Covariance method. The AR model coefficients are given in A and the gain is given in G. | Modified Covariance AR Estimator | DSP System Toolbox |
| Extract frequency-domain features from signal | Frequency Feature Extractor | DSP System Toolbox |
| Extract time-domain features from signal | Time Feature Extractor | DSP System Toolbox |
| Design one of several standard analog filters, implemented in state-space form. | Analog Filter Design | DSP System Toolbox |
| Launches FDATool to design and implement single-rate filters using the Digital Filter block. | Digital Filter Design | DSP System Toolbox |
| Compute the Discrete Wavelet Transform or decompose a signal into subbands with smaller bandwidths and slower sample rates. This block uses a filter bank with lowpass and highpass FIR filters that you specify either directly on the block mask, or using wavelets from the Wavelet Toolbox. The lowpass and highpass filters are usually half-band filters designed to complement each other. Inputs are always interpreted as frames. The frame size must be a multiple of 2^n, where you specify n in the 'Number of levels' parameter. When the 'Output' parameter is set to 'Multiple ports', the block outputs each subband from a different port as a vector or matrix. The topmost port outputs the subband with the highest frequency band. When the 'Output' parameter is set to 'Single port', the block outputs one vector or matrix of concatenated subbands. | Dyadic Analysis Filter Bank | DSP System Toolbox |
| Compute the Inverse Discrete Wavelet Transform or reconstruct a signal from subbands with smaller bandwidths and slower sample rates. This block uses a filter bank with lowpass and highpass FIR filters that you specify either directly on the block mask, or using wavelets from the Wavelet Toolbox. The lowpass and highpass filters are usually half-band filters designed to complement each other. When 'Input' is set to 'Multiple ports', you must provide each subband to the block through a different input port as a vector or matrix. You should input the highest frequency band through the topmost port. When 'Input' is set to 'Single port', the block input must be a vector or matrix of concatenated subbands. | Dyadic Synthesis Filter Bank | DSP System Toolbox |
| Decompose a signal into a high-frequency subband (Hi band) and a low-frequency subband (Lo band) using the specified highpass and lowpass FIR filters. Each subband has half the bandwidth and half the sample rate of the original signal. Usually, the highpass and lowpass filters should be half-band filters designed to complement each other. | Two-Channel Analysis Subband Filter | DSP System Toolbox |
| Implement a general IIR filter using biquad structures. Biquad implementations of general IIR filters are often preferred due to their desirable numeric properties. | Biquad Filter | DSP System Toolbox |
| Apply an FIR filter to the input signal, then downsample the signal by an integer-valued factor. The block implements the FIR filter using a polyphase filter structure. | FIR Decimation | DSP System Toolbox |
| Upsample the input signal by an integer-valued factor, then apply an FIR filter. The block scales the filter coefficients by the interpolation factor and implements the FIR filter using a polyphase structure. | FIR Interpolation | DSP System Toolbox |
| Upsample the input signal by an integer-valued factor, apply an FIR filter, and downsample the input signal by another integer-valued factor. The block implements the FIR filter using a polyphase structure. | FIR Rate Conversion | DSP System Toolbox |

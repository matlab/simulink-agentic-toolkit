---
type: Simulink Block Category
title: Transforms
description: FFT and wavelet transforms
tags: [transforms, fft, dwt, idwt, wavelet]
status: stable
source: custom_library
library_root: DSP System Toolbox
category_path: Transforms
block_count: 15
---

# Transforms

Use these blocks for transforms.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Magnitude FFT | dspspect3/Magnitude FFT | R2023a+ | Compute the magnitude (or magnitude-squared) FFT of a frame — use for spectrum or periodogram estimation. |
| Wavelet Scattering | dspfeatures/Wavelet Scattering | R2023a+ | Perform wavelet scattering. A Wavelet Toolbox license is required. |
| DCT | dspxfrm3/DCT | R2023a+ | Compute the discrete cosine transform (DCT) across the first dimension of the input. The first dimension of the input must have a power-of-two length. |
| DWT | dspxfrm3/DWT | R2023a+ | Compute the discrete wavelet transform via a dyadic analysis filter bank — use for multiresolution/wavelet analysis. |
| FFT | dspxfrm3/FFT | R2023a+ | Compute the fast Fourier transform (FFT) across the first dimension of the input. When you set the 'FFT implementation' parameter to 'Radix-2', the FFT length must be a power of two. |
| IDCT | dspxfrm3/IDCT | R2023a+ | Compute the inverse discrete cosine transform (IDCT) across the first dimension of the input. The first dimension of the input must have a power-of-two length. |
| IDWT | dspxfrm3/IDWT | R2023a+ | Reconstruct a signal from wavelet coefficients via a synthesis filter bank — use to invert the DWT. |
| IFFT | dspxfrm3/IFFT | R2023a+ | Compute the inverse fast Fourier transform (IFFT) across the first dimension of the input. When you set the 'FFT implementation' parameter to 'Radix-2', the FFT length must be a power of two. |
| Magnitude FFT | dspxfrm3/Magnitude FFT | R2023a+ | Compute the magnitude (or magnitude-squared) FFT of a frame — use for spectrum or periodogram estimation. |
| Zoom FFT | dspxfrm3/Zoom FFT | R2023a+ | Compute a high-resolution FFT over a narrow band — use to zoom into a frequency region of interest. |
| Analytic Signal | dspxfrm3/Analytic Signal | R2023a+ | Complex analytic signal of input. |
| Complex Cepstrum | dspxfrm3/Complex Cepstrum | R2023a+ | Complex cepstrum of input signal. Input is modified to remove possible phase discontinuity at +/- pi radians. |
| Inverse  Short-Time FFT | dspxfrm3/Inverse  Short-Time FFT | R2023a+ | Reconstructs a signal from its Short-Time FFT (STFFT) by using the OLA method. The block takes as an input the analysis window w[n] used in the generation of the STFFT to normalize the output signal. Optionally, the block asserts if the analysis window does not satisfy constraints that permit perfect reconstruction of the signal. |
| Real Cepstrum | dspxfrm3/Real Cepstrum | R2023a+ | Real cepstrum of input signal. |
| Short-Time FFT | dspxfrm3/Short-Time FFT | R2023a+ | Output the Short-Time FFT of the input signal x[n]. Uses an externally specified analysis window w[n]. |

---
type: Simulink Block Category
title: Linear prediction
description: Linear-prediction / AR coefficient estimation
tags: [linear prediction, levinson]
status: stable
source: custom_library
library_root: DSP System Toolbox
category_path: Linear prediction
block_count: 8
---

# Linear prediction

Use these blocks for linear prediction.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| LPC to LSF/LSP Conversion | dsplp/LPC to LSF/LSP Conversion | R2023a+ | Convert linear prediction coefficients (LPCs) to line spectral pairs (LSPs) or line spectral frequencies (LSFs). An optional output indicates the validity of the current output. Outputs can be invalid due to unstable inputs, or failure to find all LSF/LSPs. The first input coefficient must be 1. If it is not, the block normalizes the input by default, and optionally gives a warning. |
| LPC to/from Cepstral Coefficients  | dsplp/LPC to/from Cepstral Coefficients  | R2023a+ | Converts linear prediction coefficients (LPCs) to/from cepstral coefficients (CCs). When converting from LPCs to CCs, you can assume the prediction error power is 1, or specify a different value using input port P. The size of the output vector of cepstral coefficients can be the same length as the input LPC vector, or you can define a nonzero length. The first input coefficient must be 1. If it is not, you can replace it with 1, normalize the input with the non-unity first coefficient, normalize and warn, or error out. When converting from CCs to LPCs, you can output the prediction error power at port P. |
| LPC to/from RC | dsplp/LPC to/from RC | R2023a+ | Converts Linear Prediction polynomial coefficients (A) to/from Reflection coefficients (K). The normalized prediction error power of the linear prediction filter is given in the optional P output. The stability of the prediction coefficients is given in the optional S output. In the LPC to RC conversion, the first input coefficient must be 1. If it is not, you can optionally replace it with 1, or normalize the input with the non-unity 1st coefficient and warn, or error out. |
| LPC/RC to Autocorrelation | dsplp/LPC/RC to Autocorrelation | R2023a+ | Converts Linear Prediction Coefficients (A) or Reflection Coefficients (K) into Autocorrelation coefficients (AC). We can have an optional prediction error power (P) input port which expects a scalar value, in the absence of which P is assumed to be 1. In the LPC to Autocorrelation coefficient conversion, the first input coefficient is expected to be 1. If it is not, user can select one of 4 options, like replace the first coefficient with 1, or normalize the input vector with first coefficient, or normalize and warn, or just error out. |
| LSF/LSP to LPC Conversion | dsplp/LSF/LSP to LPC Conversion | R2023a+ | Convert line spectral frequencies (LSFs) or line spectral pairs (LSPs) to linear prediction coefficients (LPCs). The LSF inputs can be in the range (0 pi), or normalized to be in the range (0 0.5). |
| Levinson-Durbin | dsplp/Levinson-Durbin | R2023a+ | Solve for LPC/AR coefficients from an autocorrelation sequence via the Levinson-Durbin recursion — use for linear prediction, speech coding, and AR modeling. |
| Autocorrelation LPC | dsplp/Autocorrelation LPC | R2023a+ | Output the coefficients of an Nth order forward linear predictor such that the sum of the squares of the errors is minimized (using the autocorrelation LPC method). The prediction coefficients are given in A (polynomial coefficients) and/or K (reflection coefficients). The prediction error power is given in the optional P output. |
| Levinson-Durbin | dspsolvers/Levinson-Durbin | R2023a+ | Solve for LPC/AR coefficients from an autocorrelation sequence via the Levinson-Durbin recursion — use for linear prediction, speech coding, and AR modeling. |

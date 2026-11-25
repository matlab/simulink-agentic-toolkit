---
type: Simulink Block Category
title: Adc measurements
description: ADC performance measurement (4 blocks)
tags: [toolbox-kb, mixed-signal-blockset, snr, inl, dnl, jitter, testbench]
status: stable
sources:
  - resource: matlab:msbAdcMeasurements
source: toolbox_kb
managed_by: satk
library: Mixed-Signal Blockset
kb_folder: mixed-signal-blockset
category: adc-measurements
block_count: 4
generated: { by: satk-toolbox-build/1, at: "2026-11-23T18:23:24Z" }
---

# Adc measurements

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| ADC AC Measurement | msbAdcMeasurements/ADC AC Measurement | R2023a+ | Measure ADC AC performance metrics — use for extracting SNR, SNDR, SFDR, and harmonic distortion |
| ADC DC Measurement | msbAdcMeasurements/ADC DC Measurement | R2023a+ | Measure ADC DC performance metrics — use for extracting INL, DNL, offset, and gain error |
| ADC Testbench | msbAdcMeasurements/ADC Testbench | R2023a+ | Complete ADC test environment — use for automated characterization of ADC models with stimulus and measurement |
| Aperture Jitter Measurement | msbAdcMeasurements/Aperture Jitter Measurement | R2023a+ | Measure ADC aperture jitter — use for quantifying timing uncertainty in sample-and-hold circuits |

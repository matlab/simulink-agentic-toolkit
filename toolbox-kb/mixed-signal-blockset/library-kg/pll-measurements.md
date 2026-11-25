---
type: Simulink Block Category
title: Pll measurements
description: PLL performance measurement (5 blocks)
tags: [toolbox-kb, mixed-signal-blockset, lock, phase noise, testbench, measurement]
status: stable
sources:
  - resource: matlab:msbPllMeasurements
source: toolbox_kb
managed_by: satk
library: Mixed-Signal Blockset
kb_folder: mixed-signal-blockset
category: pll-measurements
block_count: 5
generated: { by: satk-toolbox-build/1, at: "2026-11-23T18:23:24Z" }
---

# Pll measurements

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Lock Time Measurement | msbPllMeasurements/Lock Time Measurement | R2023a+ | Measure PLL lock acquisition time — use for characterizing how fast the PLL achieves frequency lock |
| PFD and Charge Pump Testbench | msbPllMeasurements/PFD and Charge Pump Testbench | R2023a+ | Test environment for PFD and charge pump — use for verifying dead-zone, linearity, and current matching |
| PLL Testbench | msbPllMeasurements/PLL Testbench | R2023a+ | Complete PLL test environment — use for automated PLL characterization including lock time and phase noise |
| Phase Noise Measurement | msbPllMeasurements/Phase Noise Measurement | R2023a+ | Measure oscillator phase noise — use for extracting phase noise spectral density from PLL or VCO output |
| VCO Testbench | msbPllMeasurements/VCO Testbench | R2023a+ | Test environment for VCO characterization — use for measuring tuning gain, frequency range, and phase noise |

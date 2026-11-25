---
type: Simulink Block Category
title: Pll architectures
description: Complete PLL architecture models (5 blocks)
tags: [toolbox-kb, mixed-signal-blockset, fractional, integer, baseband, pll]
status: stable
sources:
  - resource: matlab:msbPllArchitectures
source: toolbox_kb
managed_by: satk
library: Mixed-Signal Blockset
kb_folder: mixed-signal-blockset
category: pll-architectures
block_count: 5
generated: { by: satk-toolbox-build/1, at: "2026-11-23T18:23:24Z" }
---

# Pll architectures

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Baseband PLL | msbPllArchitectures/Baseband PLL | R2025a+ | Model a baseband phase-locked loop — use for simulating PLL behavior at baseband for fast behavioral analysis |
| Fractional N PLL with Accumulator | msbPllArchitectures/Fractional N PLL with Accumulator | R2023a+ | Model a fractional-N PLL using accumulator — use for simulating fine-resolution frequency synthesis with spurs |
| Fractional N PLL with Delta Sigma Modulator | msbPllArchitectures/Fractional N PLL with Delta Sigma Modulator | R2023a+ | Model a fractional-N PLL using DSM — use for simulating low-spur fractional frequency synthesis |
| Integer N PLL with Dual Modulus Prescaler | msbPllArchitectures/Integer N PLL with Dual Modulus Prescaler | R2023a+ | Model an integer-N PLL with dual-modulus divider — use for simulating programmable frequency synthesis |
| Integer N PLL with Single Modulus Prescaler | msbPllArchitectures/Integer N PLL with Single Modulus Prescaler | R2023a+ | Model an integer-N PLL with fixed divider — use for simulating basic frequency multiplication |

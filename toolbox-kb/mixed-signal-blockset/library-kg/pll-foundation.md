---
type: Simulink Block Category
title: Pll foundation
description: PLL building blocks (9 blocks)
tags: [toolbox-kb, mixed-signal-blockset, vco, pfd, charge, filter, divider, prescaler]
status: stable
sources:
  - resource: matlab:msbPllFoundation
source: toolbox_kb
managed_by: satk
library: Mixed-Signal Blockset
kb_folder: mixed-signal-blockset
category: pll-foundation
block_count: 9
generated: { by: satk-toolbox-build/1, at: "2026-11-23T18:23:24Z" }
---

# Pll foundation

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Charge Pump | msbPllFoundation/Charge Pump | R2023a+ | Model a PLL charge pump — use for converting phase detector output to a current that drives the loop filter |
| Dual Modulus Prescaler | msbPllFoundation/Dual Modulus Prescaler | R2023a+ | Model a dual-modulus frequency divider — use for implementing swallow-counter based programmable division |
| Fractional Clock Divider with Accumulator | msbPllFoundation/Fractional Clock Divider with Accumulator | R2023a+ | Model fractional division using accumulator — use for generating fractional divide ratios with spurs |
| Fractional Clock Divider with DSM | msbPllFoundation/Fractional Clock Divider with DSM | R2023a+ | Model fractional division using delta-sigma modulation — use for generating low-spur fractional divide ratios |
| Loop Filter | msbPllFoundation/Loop Filter | R2023a+ | Model a PLL loop filter — use for filtering charge pump output to produce VCO control voltage |
| PFD | msbPllFoundation/PFD | R2023a+ | Model a phase-frequency detector — use for comparing reference and feedback clock edges in PLL loops |
| Ring Oscillator VCO | msbPllFoundation/Ring Oscillator VCO | R2023a+ | Model a ring oscillator VCO — use for simulating low-cost VCOs with ring topology and phase noise |
| Single Modulus Prescaler | msbPllFoundation/Single Modulus Prescaler | R2023a+ | Model a fixed-ratio frequency divider — use for dividing VCO frequency by a constant integer |
| VCO | msbPllFoundation/VCO | R2023a+ | Model a voltage-controlled oscillator — use for simulating frequency modulation by control voltage with phase noise |

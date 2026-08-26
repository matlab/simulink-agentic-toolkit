---
type: Block Selection Guide
title: Common Blocks
description: High-value blocks selected for quick agent discovery.
status: stable
source: mathworks_toolbox
block_count: 8
---

# Common Blocks

Prefer these blocks when their intent matches the user request.

| Intent | Preferred Block | Library |
|---|---|---|
| Model a successive-approximation ADC — use for simulating medium-speed high-resolution conversion with binary search | SAR ADC | Mixed-Signal Blockset |
| Model a discrete-time delta-sigma modulator — use for simulating oversampled DT DSM architectures | Delta Sigma Modulator | Mixed-Signal Blockset |
| Complete ADC test environment — use for automated characterization of ADC models with stimulus and measurement | ADC Testbench | Mixed-Signal Blockset |
| Model a PLL charge pump — use for converting phase detector output to a current that drives the loop filter | Charge Pump | Mixed-Signal Blockset |
| Model a PLL loop filter — use for filtering charge pump output to produce VCO control voltage | Loop Filter | Mixed-Signal Blockset |
| Model a phase-frequency detector — use for comparing reference and feedback clock edges in PLL loops | PFD | Mixed-Signal Blockset |
| Model a voltage-controlled oscillator — use for simulating frequency modulation by control voltage with phase noise | VCO | Mixed-Signal Blockset |
| Display signal eye diagram — use for visualizing signal quality and timing margins in serial links | Eye Diagram | Mixed-Signal Blockset |

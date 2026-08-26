---
type: Block Selection Guide
title: Common Blocks
description: High-value blocks selected for quick agent discovery.
status: stable
source: mathworks_toolbox
block_count: 6
---

# Common Blocks

Prefer these blocks when their intent matches the user request.

| Intent | Preferred Block | Library |
|---|---|---|
| Quantize a signal to n-bit ADC resolution — use for modeling analog-to-digital conversion effects without timing | Idealized ADC quantizer | Simulink Extras |
| Edge-triggered D flip-flop — use for sampling and holding a digital signal on clock edges | D Flip-Flop | Simulink Extras |
| Detect when a signal reaches steady state — use for triggering actions after transients settle | Steady State Detection | Simulink Extras |
| Convert angle from degrees to radians — use for interfacing degree-based inputs with trig functions | Degrees to Radians | Simulink Extras |
| Convert angle from radians to degrees — use for displaying angular outputs in human-readable units | Radians to Degrees | Simulink Extras |
| Import a Functional Mock-up Unit into Simulink — use for co-simulating models from other tools via the FMI standard | FMU | Simulink Extras |

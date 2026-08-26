---
type: Simulink Block Category
title: Utilities
description: General mixed-signal utilities and measurements
tags: [eye, clock, slew, op-amp, binary, timing]
status: stable
source: mathworks_toolbox
library_root: Mixed-Signal Blockset
category_path: Utilities
block_count: 14
---

# Utilities

Use these blocks for utilities.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Binary Vector Conversion | msbUtilities/Binary Vector Conversion | R2023a+ | Convert between binary vectors and numeric values — use for interfacing digital bus representations with numeric signals |
| Clock Jitter Measurement | msbUtilities/Clock Jitter Measurement | R2023a+ | Measure clock signal jitter — use for characterizing timing uncertainty on clock edges |
| Linear Circuit Wizard | msbUtilities/Linear Circuit Wizard | R2023a+ | Generate Simulink models from circuit netlists — use for importing analog filter or amplifier topologies |
| Operational Amplifier | msbUtilities/Operational Amplifier | R2023a+ | Model an operational amplifier — use for simulating op-amp circuits with gain, bandwidth, and slew rate limits |
| Slew Rate | msbUtilities/Slew Rate | R2023a+ | Apply slew-rate limiting to a signal — use for modeling output rate constraints of analog circuits |
| Timing Measurement | msbUtilities/Timing Measurement | R2023a+ | Measure signal timing parameters — use for extracting rise time, fall time, and propagation delay |
| Clock Generator | msbUtilities/Clock Generator | R2023a+ | Generate a periodic clock signal — use for providing timing reference to mixed-signal circuits |
| Eye Diagram | msbUtilities/Eye Diagram | R2023a+ | Display signal eye diagram — use for visualizing signal quality and timing margins in serial links |
| Eye Measurement | msbUtilities/Eye Measurement | R2024a+ | Measure eye diagram parameters — use for extracting eye height, width, and jitter from serial signals |
| Jitter Measurement | msbUtilities/Jitter Measurement | R2026a+ | Measure signal jitter components — use for decomposing jitter into deterministic and random components |
| Logic Decision | msbUtilities/Logic Decision | R2023a+ | Make binary logic decisions on analog signals — use for determining digital values from analog waveforms with thresholds |
| Lowpass Resampler | msbUtilities/Lowpass Resampler | R2023a+ | Resample discrete signals to continuous time — use for converting sampled data back to continuous waveforms with filtering |
| Signal Sampler | msbUtilities/Signal Sampler | R2023a+ | Sample a continuous signal at clock edges — use for modeling sample-and-hold behavior with configurable timing |
| Variable Pulse Delay | msbUtilities/Variable Pulse Delay | R2023a+ | Apply variable delay to pulse signals — use for modeling jitter injection or propagation delay variation |

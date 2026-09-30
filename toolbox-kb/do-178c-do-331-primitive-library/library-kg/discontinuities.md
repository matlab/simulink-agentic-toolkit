---
type: Simulink Block Category
title: Discontinuities
description: Dead zone, relay, and saturation nonlinearities
tags: [discontinuities, dead zone, relay, saturation]
status: stable
source: custom_library
library_root: DO-178C/DO-331 Primitive Library
category_path: Discontinuities
block_count: 6
---

# Discontinuities

Use these blocks for discontinuities.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Dead Zone | do178Lib/Simulink/Discontinuities/Dead Zone | R2023b+ | Output zero while the input is within a dead band, then pass the offset beyond it — use to model backlash or ignore small signals. |
| Relay | do178Lib/Simulink/Discontinuities/Relay | R2023b+ | Switch the output between two values with hysteresis around on/off thresholds — use for bang-bang control or thermostat-like logic. |
| Saturation | do178Lib/Simulink/Discontinuities/Saturation | R2023b+ | Clip a signal to specified upper and lower limits — use to enforce actuator or physical bounds. |
| Dead Zone Dynamic | do178Lib/Simulink/Discontinuities/Dead Zone Dynamic | R2023b+ | Output zero for inputs within a dead zone. Offset input signals by either the Start or End value when outside of the dead zone. |
| Saturation Dynamic | do178Lib/Simulink/Discontinuities/Saturation Dynamic | R2023a+ | Bound the range of the second input by using the first input (upper limit) and the third input (lower limit). |
| Wrap To Zero | do178Lib/Simulink/Discontinuities/Wrap To Zero | R2023b+ | If the input is above the threshold, the output is zero, otherwise the output equals the input. |

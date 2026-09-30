---
type: Simulink Block Category
title: Discontinuities
description: Nonlinear discontinuity blocks
tags: [saturation, dead zone, backlash, relay, friction, hit crossing]
status: stable
source: custom_library
library_root: HDL Coder
category_path: Discontinuities
block_count: 8
---

# Discontinuities

Use these blocks for discontinuities.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Backlash | hdlsllib/Discontinuities/Backlash | R2023a+ | Model mechanical play/hysteresis where output lags input within a dead band — use for gear backlash effects. |
| Coulomb & Viscous Friction | hdlsllib/Discontinuities/Coulomb & Viscous Friction | R2023a+ | Model friction as a Coulomb offset plus a velocity-proportional viscous term — use for mechanical friction. |
| Dead Zone | hdlsllib/Discontinuities/Dead Zone | R2023a+ | Output zero within a fixed dead band and offset outside it — use to model insensitivity or thresholds. |
| Dead Zone Dynamic | hdlsllib/Discontinuities/Dead Zone Dynamic | R2023a+ | Dead zone with runtime-variable band limits — use for adjustable insensitivity thresholds. |
| Hit  Crossing | hdlsllib/Discontinuities/Hit  Crossing | R2023a+ | Detect when a signal crosses a specified value — use to flag threshold-crossing events. |
| Relay | hdlsllib/Discontinuities/Relay | R2023a+ | Switch output between two values with hysteresis around on/off thresholds — use for bang-bang control. |
| Saturation | hdlsllib/Discontinuities/Saturation | R2023a+ | Clip a signal to fixed lower/upper limits — use to enforce actuator or safety limits. |
| Saturation Dynamic | hdlsllib/Discontinuities/Saturation Dynamic | R2023a+ | Clip a signal to runtime-variable limits — use for adjustable saturation bounds. |

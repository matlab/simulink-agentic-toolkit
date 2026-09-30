---
type: Simulink Block Category
title: Discontinuities
description: Nonlinear discontinuity blocks
tags: [saturation, dead zone, rate limiter, backlash, relay, quantizer]
status: stable
source: custom_library
library_root: Simulink
category_path: Discontinuities
block_count: 15
---

# Discontinuities

Use these blocks for discontinuities.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Saturation | simulink/Commonly
Used Blocks/Saturation | R2023a+ | Clip a signal to fixed lower/upper limits — use to enforce actuator or safety limits. |
| Backlash | simulink/Discontinuities/Backlash | R2023a+ | Model mechanical play/hysteresis where output lags input within a dead band — use for gear backlash effects. |
| Coulomb & Viscous Friction | simulink/Discontinuities/Coulomb & Viscous Friction | R2023a+ | Model friction as a Coulomb offset plus a velocity-proportional viscous term — use for mechanical friction. |
| Dead Zone | simulink/Discontinuities/Dead Zone | R2023a+ | Output zero within a fixed dead band and offset outside it — use to model insensitivity or thresholds. |
| Dead Zone Dynamic | simulink/Discontinuities/Dead Zone Dynamic | R2023a+ | Dead zone with runtime-variable band limits — use for adjustable insensitivity thresholds. |
| Hit  Crossing | simulink/Discontinuities/Hit  Crossing | R2023a+ | Detect when a signal crosses a specified value — use to flag threshold-crossing events. |
| PWM | simulink/Discontinuities/PWM | R2023a+ | Generate a pulse-width-modulated waveform from a duty-cycle input — use to model switching/PWM drive signals. |
| Quantizer | simulink/Discontinuities/Quantizer | R2023a+ | Quantize a signal to discrete amplitude levels — use to model ADC quantization or reduce precision. |
| Rate Limiter | simulink/Discontinuities/Rate Limiter | R2023a+ | Limit the rate of change of a signal to fixed rise/fall slopes — use to smooth abrupt changes. |
| Rate Limiter Dynamic | simulink/Discontinuities/Rate Limiter Dynamic | R2023a+ | Limit the rate of change using runtime-variable slope limits — use for adjustable slew limiting. |
| Relay | simulink/Discontinuities/Relay | R2023a+ | Switch output between two values with hysteresis around on/off thresholds — use for bang-bang control. |
| Saturation | simulink/Discontinuities/Saturation | R2023a+ | Clip a signal to fixed lower/upper limits — use to enforce actuator or safety limits. |
| Saturation Dynamic | simulink/Discontinuities/Saturation Dynamic | R2023a+ | Clip a signal to runtime-variable limits — use for adjustable saturation bounds. |
| Variable Pulse Generator | simulink/Discontinuities/Variable Pulse Generator | R2023a+ | Generate pulses with runtime-variable period/width — use for adjustable pulse timing. |
| Wrap To Zero | simulink/Discontinuities/Wrap To Zero | R2023a+ | Reset the output to zero when the input exceeds a threshold — use for wrap-around/rollover behavior. |

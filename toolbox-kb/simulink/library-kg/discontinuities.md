---
type: Simulink Block Category
title: Discontinuities
description: Nonlinear elements with discontinuous behavior such as saturation, dead zones, and relay switches
tags: [saturation, dead zone, rate limiter, relay, backlash]
status: stable
source: mathworks_toolbox
library_root: Simulink
category_path: Discontinuities
block_count: 14
---

# Discontinuities

Use these blocks for discontinuities.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Backlash | simulink/Discontinuities/Backlash | R2023a+ | Use when modeling mechanical backlash or play in gear trains where output does not respond until input exceeds deadband |
| Coulomb & Viscous Friction | simulink/Discontinuities/Coulomb & Viscous Friction | R2023a+ | Use when modeling friction forces combining a constant Coulomb component with a velocity-proportional viscous component |
| Dead Zone | simulink/Discontinuities/Dead Zone | R2023a+ | Use when zeroing out signals within a specified band around zero to model insensitivity regions |
| Dead Zone Dynamic | simulink/Discontinuities/Dead Zone Dynamic | R2023a+ | Use when the dead zone limits are determined dynamically by input signals |
| Hit  Crossing | simulink/Discontinuities/Hit  Crossing | R2023a+ | Use when detecting the exact time instant a signal crosses a specified threshold value |
| PWM | simulink/Discontinuities/PWM | R2023a+ | Use when generating a pulse-width modulated output signal based on a duty cycle input |
| Quantizer | simulink/Discontinuities/Quantizer | R2023a+ | Use when discretizing a continuous signal into equally spaced levels for ADC modeling |
| Rate Limiter | simulink/Discontinuities/Rate Limiter | R2023a+ | Use when constraining how fast a signal can change to model actuator slew rate limits |
| Rate Limiter Dynamic | simulink/Discontinuities/Rate Limiter Dynamic | R2023a+ | Use when the rising and falling rate limits are determined dynamically by input signals |
| Relay | simulink/Discontinuities/Relay | R2023a+ | Use when implementing hysteresis switching that turns on at one threshold and off at another |
| Saturation | simulink/Discontinuities/Saturation | R2023a+ | Use when clamping a signal between upper and lower bounds to model actuator limits or constraints |
| Saturation Dynamic | simulink/Discontinuities/Saturation Dynamic | R2023a+ | Use when the saturation limits are determined dynamically by input signals |
| Variable Pulse Generator | simulink/Discontinuities/Variable Pulse Generator | R2023a+ | Use when generating pulses with variable width and period controlled by input signals |
| Wrap To Zero | simulink/Discontinuities/Wrap To Zero | R2023a+ | Use when resetting a signal to zero once it exceeds a threshold for overflow or counter wrap modeling |

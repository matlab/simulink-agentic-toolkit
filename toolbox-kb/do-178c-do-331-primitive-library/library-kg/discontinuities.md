---
type: Simulink Block Category
title: Discontinuities
description: Saturation, dead zones, relays, and signal limiting
tags: [saturation, dead zone, relay, clamp, limit]
status: stable
source: mathworks_toolbox
library_root: DO-178C/DO-331 Primitive Library
category_path: Discontinuities
block_count: 6
---

# Discontinuities

Use these blocks for discontinuities.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Dead Zone Dynamic | do178Lib/Simulink/Discontinuities/Dead Zone Dynamic | R2023b+ | Zero the output within a dynamically varying dead band — use when the dead zone limits change at runtime based on operating conditions or adaptive thresholds |
| Saturation Dynamic | do178Lib/Simulink/Discontinuities/Saturation Dynamic | R2023a+ | Clamp a signal between dynamically varying upper and lower bounds — use when saturation limits depend on operating conditions, available authority, or fault state |
| Wrap To Zero | do178Lib/Simulink/Discontinuities/Wrap To Zero | R2023b+ | Reset output to zero when input exceeds a threshold — use for counter overflow handling, watchdog-style resets, or periodic signal wrapping in certified logic |
| Dead Zone | do178Lib/Simulink/Discontinuities/Dead Zone | R2023b+ | Zero the output when the input is within a specified band around zero — use for eliminating sensor noise near neutral, preventing actuator chatter, or modeling mechanical play |
| Relay | do178Lib/Simulink/Discontinuities/Relay | R2023b+ | Implement hysteresis switching between two output values — use for on/off control with noise rejection, thermostat-style logic, or mode switching with debounce |
| Saturation | do178Lib/Simulink/Discontinuities/Saturation | R2023b+ | Clamp a signal between fixed upper and lower bounds — use to enforce actuator limits, protect downstream logic from out-of-range values, or implement safety envelopes |

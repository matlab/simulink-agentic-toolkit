---
type: Simulink Block Category
title: Signal management
description: Signal packing, filtering, PLLs, dead-time compensation, and protocol codecs for embedded motor-control signal paths
tags: [byte pack, IIR, PLL, dead-time, protocol, memory, filter]
status: stable
source: mathworks_toolbox
library_root: Motor Control Blockset
category_path: Signal management
block_count: 12
---

# Signal management

Use these blocks for signal management.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Byte Pack | mcblib/Signal Management/Byte Pack | R2024a+ | Pack heterogeneous scalar signals into a single byte buffer using a specified layout — use to build serial or CAN telemetry frames from Simulink signals |
| Byte Reversal | mcblib/Signal Management/Byte Reversal | R2024a+ | Reverse the byte order of a value or vector — use to convert between little-endian and big-endian representations when talking to external hardware |
| Byte Unpack | mcblib/Signal Management/Byte Unpack | R2024a+ | Unpack a byte buffer into heterogeneous scalar signals using a specified layout — use to parse incoming serial or CAN telemetry frames |
| Compute Parameter | mcblib/Signal Management/Compute Parameter | R2024a+ | Perform a one-time computation at model start based on workspace parameters and expose the result on an outport — use to derive constants (e.g., inverse Rs) that would otherwise recur every step |
| Dead-Time Compensator | mcblib/Signal Management/Dead-Time Compensator | R2024a+ | Compensate inverter dead-time distortion by adding a current-sign-dependent voltage offset — use to restore output-voltage linearity in FOC drives at low modulation index |
| IIR Filter | mcblib/Signal Management/IIR Filter | R2023a+ | Second-order IIR filter with fixed-point-friendly implementation — use for anti-aliasing sensor measurements, smoothing speed feedback, or shaping references in motor-control loops |
| Memory Copy | mcblib/Signal Management/Memory Copy | R2024a+ | Copy a block of data between arrays or buffers in generated code — use to move telemetry or parameter blocks efficiently without loop constructs |
| PLL with Feed Forward | mcblib/Signal Management/PLL with Feed Forward | R2023b+ | Track the phase and frequency of a sinusoidal signal or estimated back-EMF using a PLL with feed-forward speed input — use to smooth rotor angle estimates from noisy observers |
| Position Compensation | mcblib/Signal Management/Position Compensation | R2023a+ | Compensate rotor angle for the one-sample delay between current sample time and the next PWM update — use to sharpen FOC current tracking at high electrical frequencies |
| Protocol Decoder | mcblib/Signal Management/Protocol Decoder | R2024a+ | Decode framed messages according to a user-defined protocol (headers, checksum, payload) — use to parse serial or embedded communication streams inside the target model |
| Protocol Encoder | mcblib/Signal Management/Protocol Encoder | R2024a+ | Encode framed messages according to a user-defined protocol — use to construct serial or embedded communication streams from Simulink signals |
| Vector plot | mcblib/Signal Management/Vector plot | R2023a+ | Visualize two-dimensional vector quantities (e.g. alpha/beta or d/q) as an animated diagram during simulation — use to inspect FOC transforms and current-vector trajectories |

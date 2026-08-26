---
type: Simulink Block Category
title: Sensor decoders
description: Position/speed decoders for Hall, quadrature encoder, and resolver sensors, plus watchdog and speed-measurement helpers
tags: [hall, encoder, resolver, quadrature, position, speed, watchdog]
status: stable
source: mathworks_toolbox
library_root: Motor Control Blockset
category_path: Sensor decoders
block_count: 7
---

# Sensor decoders

Use these blocks for sensor decoders.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Hall Speed and Position | mcblib/Sensor Decoders/Hall Speed and Position | R2023a+ | Decode Hall-sensor A/B/C states into electrical angle and rotor speed — use to obtain position/speed feedback for BLDC drives and low-resolution PMSM applications |
| Hall Validity | mcblib/Sensor Decoders/Hall Validity | R2023a+ | Detect illegal Hall-sensor state transitions such as all-high or all-low patterns — use to flag broken Hall sensors or wiring errors so the drive can go into a safe state |
| Mechanical to Electrical Position | mcblib/Sensor Decoders/Mechanical to Electrical Position | R2023a+ | Convert mechanical shaft angle to electrical angle using the pole-pair count and apply modulo wrapping — use anywhere a mechanical sensor feeds an electrical control loop |
| Quadrature Decoder | mcblib/Sensor Decoders/Quadrature Decoder | R2023a+ | Decode A/B encoder pulses into an accumulated count, direction, and index reset — use to convert incremental encoder feedback into position and speed for high-resolution servos |
| Resolver Decoder | mcblib/Sensor Decoders/Resolver Decoder | R2023a+ | Demodulate resolver sine/cosine channels and excitation to recover rotor angle — use for motor-control feedback in high-vibration or high-temperature environments where encoders are unsuitable |
| Software Watchdog Timer | mcblib/Sensor Decoders/Software Watchdog Timer | R2023a+ | Software watchdog that trips if a periodic kick signal is missed — use to detect task overruns or firmware hangs and force the drive into a safe state |
| Speed Measurement | mcblib/Sensor Decoders/Speed Measurement | R2023a+ | Differentiate an accumulated position with configurable filtering to produce a low-noise speed estimate — use to close speed loops from encoder or resolver feedback |

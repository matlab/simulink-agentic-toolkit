---
type: Simulink Block Category
title: Sensor decoders
description: Position and speed sensor decoding
tags: [sensor decoders, quadrature, speed, position]
status: stable
source: custom_library
library_root: Motor Control Blockset HDL Support
category_path: Sensor decoders
block_count: 3
---

# Sensor decoders

Use these blocks for sensor decoders.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Mechanical to Electrical Position | mcbhdllib/Sensor Decoders/Mechanical to Electrical Position | R2023a+ | Convert mechanical rotor angle to electrical angle using pole-pair count — use to obtain the electrical angle needed for FOC. |
| Quadrature Decoder | mcbhdllib/Sensor Decoders/Quadrature Decoder | R2023a+ | Decode quadrature encoder A/B/index pulses into position and direction — use to measure rotor position from an incremental encoder. |
| Speed Measurement | mcbhdllib/Sensor Decoders/Speed Measurement | R2023a+ | Compute rotor speed from successive position measurements — use to close the speed control loop. |

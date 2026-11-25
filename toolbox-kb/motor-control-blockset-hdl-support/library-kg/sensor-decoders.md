---
type: Simulink Block Category
title: Sensor decoders
description: Position and speed sensor decoding (3 blocks)
tags: [toolbox-kb, motor-control-blockset-hdl-support, sensor decoders, quadrature, speed, position]
status: stable
sources:
  - resource: matlab:mcbhdllib
source: toolbox_kb
managed_by: satk
library: Motor Control Blockset HDL Support
kb_folder: motor-control-blockset-hdl-support
category: sensor-decoders
block_count: 3
generated: { by: satk-toolbox-build/1, at: "2026-11-23T18:23:36Z" }
---

# Sensor decoders

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Mechanical to Electrical Position | mcbhdllib/Sensor Decoders/Mechanical to Electrical Position | R2023a+ | Convert mechanical rotor angle to electrical angle using pole-pair count — use to obtain the electrical angle needed for FOC. |
| Quadrature Decoder | mcbhdllib/Sensor Decoders/Quadrature Decoder | R2023a+ | Decode quadrature encoder A/B/index pulses into position and direction — use to measure rotor position from an incremental encoder. |
| Speed Measurement | mcbhdllib/Sensor Decoders/Speed Measurement | R2023a+ | Compute rotor speed from successive position measurements — use to close the speed control loop. |

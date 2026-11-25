---
type: Simulink Block Category
title: Logitech g29
description: Blocks for Logitech g29 (1 blocks)
tags: [toolbox-kb, simulink-real-time]
status: draft
sources:
  - resource: matlab:slrealtimeG29lib
source: toolbox_kb
managed_by: satk
library: Simulink Real-Time
kb_folder: simulink-real-time
category: logitech-g29
block_count: 1
generated: { by: satk-toolbox-build/1, at: "2026-11-23T18:23:32Z" }
---

# Logitech g29

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Steering Wheel Read | slrealtimeG29lib/Steering Wheel Read | R2024a+ | Block to read data from Logitech G29 Steering Wheel (PS3 only). Block does not support Stick Shift module. OUTPUT PORTS: BUTTONS: Vector of booleans that reflect status of buttons on steering wheel. 1 = pressed, 0 = unpressed. Order: 1: Square, 2: X, 3: Circle, 4: Triangle, 5: LPaddle, 6: RPaddle, 7: L2, 8: R2, 9: L3, 10: R3, 11: Share, 12: Option, 13: PS STEERING: uint16 type value for position of steering wheel. 0: left most, 65535: right most. PEDALS: uint8 vector of length 3, throttle, brake, and clutch. DIRECTION: uint8 output of directional pad on the steering wheel. UNPRESSED: 8 UP: 0 RIGHT: 2 DOWN: 4 LEFT: 6 Intermediate values when pressed in between. STATUS: int32 type indicates status of communication with steering wheel. Default value: 0 Error state value: less than 0 |

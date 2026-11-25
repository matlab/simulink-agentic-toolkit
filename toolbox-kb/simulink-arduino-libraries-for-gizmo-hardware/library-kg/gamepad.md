---
type: Simulink Block Category
title: Gamepad
description: Gamepad input for teleoperation (3 blocks)
tags: [toolbox-kb, simulink-arduino-libraries-for-gizmo-hardware, gamepad, joystick, axis, button, controller]
status: stable
sources:
  - resource: matlab:gizmoLibrary
source: toolbox_kb
managed_by: satk
library: Simulink Arduino Libraries for Gizmo Hardware
kb_folder: simulink-arduino-libraries-for-gizmo-hardware
category: gamepad
block_count: 3
generated: { by: satk-toolbox-build/1, at: "2026-11-23T18:23:29Z" }
---

# Gamepad

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Gamepad Select Axis | gizmoLibrary/Gizmo Blocks/Gamepad Select Axis | R2025a+ | Select a specific axis from the gamepad — use for mapping joystick axes to motor or servo commands |
| Gamepad Select Button | gizmoLibrary/Gizmo Blocks/Gamepad Select Button | R2025a+ | Select a specific button from the gamepad — use for mapping gamepad buttons to Gizmo actions or mode switches |
| Gizmo Gamepad | gizmoLibrary/Gizmo Blocks/Gizmo Gamepad | R2025a+ | Read all axes and buttons from a connected gamepad — use as the primary input device for teleoperating Gizmo robots |

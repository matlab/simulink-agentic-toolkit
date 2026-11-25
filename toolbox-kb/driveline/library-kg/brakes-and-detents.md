---
type: Simulink Block Category
title: Brakes and detents
description: "Friction brakes, drum brakes, and position detents for rotation and translation (7 blocks)"
tags: [toolbox-kb, driveline, brake, detent, friction, band, drum]
status: stable
sources:
  - resource: matlab:sdl_lib
source: toolbox_kb
managed_by: satk
library: Driveline
kb_folder: driveline
category: brakes-and-detents
block_count: 7
generated: { by: satk-toolbox-build/1, at: "2026-11-23T18:23:18Z" }
---

# Brakes and detents

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Band Brake | sdl_lib/Brakes & Detents/Rotational/Band Brake | R2023a+ | Model a band-wrapped drum brake generating friction torque from applied force — use for parking brakes, industrial machinery, or transmission holding elements |
| Disc Brake | sdl_lib/Brakes & Detents/Rotational/Disc Brake | R2023a+ | Model a caliper-type disc brake generating friction torque proportional to applied pressure — use for vehicle wheel brakes, dynamometer loads, or safety stops |
| Double-Shoe Brake | sdl_lib/Brakes & Detents/Rotational/Double-Shoe Brake | R2023a+ | Model a drum brake with two friction shoes — use for automotive drum brakes where leading and trailing shoe geometry affects braking torque distribution |
| Loaded-Contact Rotational Friction | sdl_lib/Brakes & Detents/Rotational/Loaded-Contact Rotational Friction | R2023a+ | Apply speed-dependent rotational friction whose magnitude scales with a normal load input — use for bearing friction, loaded shaft resistance, or contact-dependent drag |
| Rotational Detent | sdl_lib/Brakes & Detents/Rotational/Rotational Detent | R2023a+ | Apply a position-dependent restoring torque at discrete angular positions — use for indexing mechanisms, selector notches, or rotary switch detents |
| Loaded-Contact Translational Friction | sdl_lib/Brakes & Detents/Translational/Loaded-Contact Translational Friction | R2023a+ | Apply speed-dependent translational friction whose magnitude scales with a normal load input — use for slider friction, rail guides, or loaded linear contacts |
| Translational Detent | sdl_lib/Brakes & Detents/Translational/Translational Detent | R2023a+ | Apply a position-dependent restoring force at discrete linear positions — use for latch mechanisms, ball-detent selectors, or snap-fit positioning |

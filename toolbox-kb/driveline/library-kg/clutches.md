---
type: Simulink Block Category
title: Clutches
description: Friction clutches, synchronizers, dog clutches, and one-way clutches
tags: [clutch, synchronizer, engagement, friction, one-way]
status: stable
source: mathworks_toolbox
library_root: Driveline
category_path: Clutches
block_count: 8
---

# Clutches

Use these blocks for clutches.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Cone Clutch | sdl_lib/Clutches/Cone Clutch | R2023a+ | Model a friction clutch with a conical contact surface — use for manual transmission synchronizers or compact high-torque engagement devices |
| Disc Friction Clutch | sdl_lib/Clutches/Disc Friction Clutch | R2023a+ | Model a multi-plate friction clutch with configurable engagement characteristics — use for automatic transmission clutches, launch devices, or torque-limiting couplings |
| Dog Clutch | sdl_lib/Clutches/Dog Clutch | R2023a+ | Model a positive-engagement jaw clutch with no slip — use for gear selection in manual transmissions or transfer cases where synchronization is handled externally |
| Double-Sided Synchronizer | sdl_lib/Clutches/Double-Sided Synchronizer | R2023a+ | Model a synchronizer that can engage either of two gears — use for manual transmission gear selection where one synchronizer hub serves two adjacent ratios |
| Logic-Controlled Clutch | sdl_lib/Clutches/Logic-Controlled Clutch | R2023a+ | Model a clutch that locks or unlocks based on a Boolean control signal — use for simplified transmission modeling, mode switching, or conditional power path engagement |
| Synchronizer | sdl_lib/Clutches/Synchronizer | R2023a+ | Model a single-sided cone synchronizer for gear engagement — use for manual transmission shift modeling where friction brings shafts to matched speed before dog engagement |
| Unidirectional Clutch | sdl_lib/Clutches/Unidirectional Clutch | R2023a+ | Model a one-way clutch that transmits torque in only one direction — use for freewheels, overrunning clutches, or automatic transmission sprag elements |
| Fundamental Friction Clutch | sdl_lib/Clutches/Fundamental Components/Fundamental Friction Clutch | R2023a+ | Model a basic friction clutch with fundamental torque-speed characteristics — use as a building block for custom clutch assemblies or for teaching friction engagement dynamics |

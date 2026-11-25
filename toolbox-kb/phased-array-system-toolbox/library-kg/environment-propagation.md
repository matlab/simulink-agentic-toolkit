---
type: Simulink Block Category
title: Environment propagation
description: "Signal propagation, target RCS modeling, and platform motion (11 blocks)"
tags: [toolbox-kb, phased-array-system-toolbox, free-space, propagation, target, RCS, platform, channel]
status: stable
sources:
  - resource: matlab:phasedenvlib
source: toolbox_kb
managed_by: satk
library: Phased Array System Toolbox
kb_folder: phased-array-system-toolbox
category: environment-propagation
block_count: 11
generated: { by: satk-toolbox-build/1, at: "2026-11-23T18:23:25Z" }
---

# Environment propagation

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Azimuth Broadside Converter | phasedenvlib/Azimuth Broadside Converter | R2023a+ | Convert between azimuth angle and broadside angle for linear array calculations |
| Backscatter Radar Target | phasedenvlib/Backscatter Radar Target | R2023a+ | Model a narrowband radar target with angle-dependent radar cross section |
| Free Space | phasedenvlib/Free Space | R2023a+ | Model narrowband signal propagation through free space with path loss and time delay |
| LOS Channel | phasedenvlib/LOS Channel | R2023a+ | Model a line-of-sight propagation channel with atmospheric and weather effects |
| Motion Platform | phasedenvlib/Motion Platform | R2023a+ | Model platform motion to provide position, velocity, and orientation for moving sensors or targets |
| Radar Target | phasedenvlib/Radar Target | R2023a+ | Model a point radar target with specified radar cross section for reflection simulation |
| Range Angle Calculator | phasedenvlib/Range Angle Calculator | R2023a+ | Compute range and angle between two platforms from their position vectors |
| Scattering MIMO Channel | phasedenvlib/Scattering MIMO Channel | R2023a+ | Model a MIMO propagation channel with multiple scatterers for multipath simulation |
| Wideband Backscatter Radar Target | phasedenvlib/Wideband Backscatter Radar Target | R2023a+ | Model a wideband radar target with frequency-dependent backscatter response |
| Wideband Free Space | phasedenvlib/Wideband Free Space | R2023a+ | Model wideband signal propagation through free space preserving signal bandwidth |
| Wideband LOS Channel | phasedenvlib/Wideband LOS Channel | R2023a+ | Model wideband line-of-sight propagation with frequency-dependent atmospheric attenuation |

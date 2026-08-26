---
type: Simulink Block Category
title: Gears
description: Gear pairs, planetary sets, differentials, and rotational-to-translational converters
tags: [gear, planetary, differential, ratio, mesh]
status: stable
source: mathworks_toolbox
library_root: Driveline
category_path: Gears
block_count: 19
---

# Gears

Use these blocks for gears.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Compound Planetary Gear | sdl_lib/Gears/Compound Planetary Gear | R2023a+ | Model a compound planetary gear set with multiple planet sets on a shared carrier — use for complex automatic transmissions or multi-ratio gear trains |
| Cycloidal Drive | sdl_lib/Gears/Cycloidal Drive | R2023a+ | Model a cycloidal speed reducer with high reduction ratio — use for robotics joints, precision positioning, or compact high-ratio drives |
| Differential | sdl_lib/Gears/Differential | R2023a+ | Model a standard bevel-gear differential splitting torque between two outputs — use for vehicle axle differentials, allowing speed difference between driven wheels |
| Double-Pinion Planetary Gear | sdl_lib/Gears/Double-Pinion Planetary Gear | R2023a+ | Model a planetary gear set with two planet meshes between sun and ring — use for compound gear trains where double planets provide specific ratio relationships |
| Harmonic Drive | sdl_lib/Gears/Harmonic Drive | R2023a+ | Model a harmonic drive speed reducer with very high gear ratio in a compact form — use for robotics, aerospace actuators, or precision instruments |
| Limited-Slip Differential | sdl_lib/Gears/Limited-Slip Differential | R2023a+ | Model a differential with torque-biasing capability — use for performance vehicles, off-road drivetrains, or traction control studies where wheel slip must be limited |
| Planetary Gear | sdl_lib/Gears/Planetary Gear | R2023a+ | Model a simple planetary gear set with sun, planet carrier, and ring — use as the fundamental building block for automatic transmissions or compound gear trains |
| Ravigneaux Gear | sdl_lib/Gears/Ravigneaux Gear | R2023a+ | Model a Ravigneaux compound planetary gear set with shared carrier — use for compact automatic transmissions providing multiple ratios from a single gear assembly |
| Simple Gear | sdl_lib/Gears/Simple Gear | R2023a+ | Model a fixed-ratio gear pair with optional efficiency loss — use for any constant gear reduction, final drives, or gear meshes in a powertrain |
| Simple Gear with Variable Efficiency | sdl_lib/Gears/Simple Gear with Variable Efficiency | R2023a+ | Model a fixed-ratio gear pair whose efficiency varies with operating conditions — use when gear losses depend on speed, torque, or temperature |
| Transmission | sdl_lib/Gears/Transmission | R2023a+ | Model a multi-speed transmission selecting discrete gear ratios — use for simplified gearbox modeling with ratio changes driven by an external gear command |
| Worm Gear | sdl_lib/Gears/Worm Gear | R2023a+ | Model a worm and wheel gear set with high reduction and potential self-locking — use for lifting mechanisms, steering gears, or applications needing irreversibility |
| Planet-Planet | sdl_lib/Gears/Planetary Subcomponents/Planet-Planet | R2023a+ | Model the mesh between two planet gears on a compound planetary — use as a subcomponent when building custom compound planetary gear assemblies |
| Ring-Planet | sdl_lib/Gears/Planetary Subcomponents/Ring-Planet | R2023a+ | Model the internal mesh between ring gear and planet gear — use as a subcomponent when building custom planetary gear configurations |
| Sun-Planet | sdl_lib/Gears/Planetary Subcomponents/Sun-Planet | R2023a+ | Model the external mesh between sun gear and planet gear — use as a subcomponent when building custom planetary gear configurations |
| Sun-Planet Bevel | sdl_lib/Gears/Planetary Subcomponents/Sun-Planet Bevel | R2023a+ | Model a bevel gear mesh between sun and planet in a differential — use as a subcomponent for custom differential or bevel gear assemblies |
| Sun-Planet Worm Gear | sdl_lib/Gears/Planetary Subcomponents/Sun-Planet Worm Gear | R2023a+ | Model a worm gear mesh between sun and planet — use as a subcomponent for custom self-locking planetary configurations |
| Leadscrew | sdl_lib/Gears/Rotational- Translational/Leadscrew | R2023a+ | Convert rotational motion to translational motion via a helical thread — use for linear actuators, machine tool feeds, or precision positioning mechanisms |
| Rack & Pinion | sdl_lib/Gears/Rotational- Translational/Rack & Pinion | R2023a+ | Convert rotational motion to translational motion via gear teeth — use for steering systems, linear actuators, or machine tool positioning |

---
type: Simulink Block Category
title: Flight parameters
description: Airspeed, Mach, angles, and aerodynamic parameter computation
tags: [airspeed, Mach, dynamic pressure, incidence, sideslip]
status: stable
source: mathworks_toolbox
library_root: Aerospace Blockset
category_path: Flight parameters
block_count: 8
---

# Flight parameters

Use these blocks for flight parameters.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Dynamic Pressure | aerolibasang/Dynamic Pressure | R2023a+ | Compute dynamic pressure (q-bar) from airspeed and density — fundamental for aerodynamic force calculation |
| Ideal Airspeed Correction | aerolibasang/Ideal Airspeed Correction | R2023a+ | Correct indicated airspeed for compressibility effects to obtain calibrated or equivalent airspeed |
| Incidence  & Airspeed | aerolibasang/Incidence  & Airspeed | R2023a+ | Compute angle of attack and total airspeed from body-axis velocity components (u, w) for 2D flight |
| Incidence, Sideslip, & Airspeed | aerolibasang/Incidence, Sideslip, & Airspeed | R2023a+ | Compute angle of attack, sideslip angle, and total airspeed from body-axis velocity components (u, v, w) |
| Mach Number | aerolibasang/Mach Number | R2023a+ | Compute Mach number from airspeed and speed of sound for compressibility-related calculations |
| Radius at Geocentric Latitude | aerolibasang/Radius at Geocentric Latitude | R2023a+ | Compute Earth's radius at a given geocentric latitude accounting for oblateness — use for altitude calculations over non-spherical Earth |
| Relative Ratio | aerolibasang/Relative Ratio | R2023a+ | Compute ratios of atmospheric properties relative to sea-level standard values for non-dimensional analysis |
| Wind Angular Rates | aerolibasang/Wind Angular Rates | R2023a+ | Compute angular rates in wind axes from body rates and aerodynamic angles — use when wind-axis rate feedback is needed |

---
type: Simulink Block Category
title: Gravity magnetic field
description: Gravity and geomagnetic field models
tags: [gravity, magnetic, geoid, WGS84, harmonic]
status: stable
source: mathworks_toolbox
library_root: Aerospace Blockset
category_path: Gravity magnetic field
block_count: 7
---

# Gravity magnetic field

Use these blocks for gravity magnetic field.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Centrifugal Effect Model | aerolibgravity2/Centrifugal Effect Model | R2023a+ | Compute centrifugal acceleration due to Earth's rotation — add to gravity for effective weight in rotating reference frames |
| Geoid Height | aerolibgravity2/Geoid Height | R2023a+ | Look up the geoid undulation (difference between geoid and WGS84 ellipsoid) at a given location for altitude reference conversion |
| World Magnetic Model | aerolibgravity2/World Magnetic Model | R2023a+ | Compute Earth's magnetic field vector using the WMM — use for magnetometer simulation and compass heading correction |
| Zonal Harmonic Gravity Model | aerolibgravity2/Zonal Harmonic Gravity Model | R2023a+ | Compute gravity with zonal (J2, J3, J4) harmonic corrections — use for orbit propagation when oblateness matters but full spherical harmonics are too expensive |
| International Geomagnetic Reference Field | aerolibgravity2/International Geomagnetic Reference Field | R2023a+ | Compute Earth's magnetic field from the IGRF model with full spherical harmonic expansion — use for high-fidelity magnetometer simulation |
| Spherical Harmonic Gravity Model | aerolibgravity2/Spherical Harmonic Gravity Model | R2023a+ | Compute gravitational acceleration using full spherical harmonic expansion (EGM96/EGM2008) — use for highest-fidelity orbit propagation |
| WGS84 Gravity Model   | aerolibgravity2/WGS84 Gravity Model   | R2023a+ | Compute normal gravity on or near the WGS84 ellipsoid using the Somigliana formula — use for standard aircraft-level gravity modeling |

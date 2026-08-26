---
type: Simulink Block Category
title: Celestial phenomena
description: Celestial bodies, ephemeris, eclipse, and Earth orientation
tags: [ephemeris, eclipse, nutation, planetary, solar flux]
status: stable
source: mathworks_toolbox
library_root: Aerospace Blockset
category_path: Celestial phenomena
block_count: 9
---

# Celestial phenomena

Use these blocks for celestial phenomena.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Earth Nutation | aerolibcelestial/Earth Nutation | R2023a+ | Compute Earth nutation angles (longitude and obliquity corrections) for precise ECI-to-ECEF transformations in high-fidelity orbital simulations |
| Moon Libration | aerolibcelestial/Moon Libration | R2023a+ | Compute lunar libration angles for precise Moon-relative pointing and selenocentric frame transformations |
| Delta UT1 | aerolibcelestial/Delta UT1 | R2023a+ | Look up the difference between UTC and UT1 for precise sidereal time calculation in high-accuracy orbit propagation |
| Earth Orientation Parameters | aerolibcelestial/Earth Orientation Parameters | R2023a+ | Retrieve polar motion, precession, and nutation parameters from IERS data for sub-arcsecond frame alignment |
| Eclipse Shadow Model (Cylindrical) | aerolibcelestial/Eclipse Shadow Model (Cylindrical) | R2023b+ | Determine if a spacecraft is in Earth's shadow using a cylindrical approximation — use for fast solar power availability estimation |
| Eclipse Shadow Model (Dual Cone) | aerolibcelestial/Eclipse Shadow Model (Dual Cone) | R2023b+ | Determine if a spacecraft is in Earth's penumbra or umbra using a dual-cone model — use when partial eclipse effects on solar arrays matter |
| Planetary Ephemeris | aerolibcelestial/Planetary Ephemeris | R2023a+ | Compute position and velocity of solar system bodies from JPL ephemeris data — use for interplanetary mission design or third-body perturbation forces |
| Solar Flux and Geomagnetic Index | aerolibcelestial/Solar Flux and Geomagnetic Index | R2023a+ | Look up F10.7 solar flux and Ap/Kp geomagnetic indices by date — required inputs for NRLMSISE-00 and other upper-atmosphere density models |
| Delta UT1 | aerolibtransform2/Delta UT1 | R2023a+ | Look up the difference between UTC and UT1 for precise sidereal time calculation in high-accuracy orbit propagation |

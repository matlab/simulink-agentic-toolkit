---
type: Simulink Block Category
title: Atmosphere
description: Standard and non-standard atmosphere models
tags: [atmosphere, density, pressure, temperature, altitude]
status: stable
source: mathworks_toolbox
library_root: Aerospace Blockset
category_path: Atmosphere
block_count: 8
---

# Atmosphere

Use these blocks for atmosphere.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| CIRA-86 Atmosphere Model | aerolibatmos2/CIRA-86 Atmosphere Model | R2023a+ | Compute temperature, pressure, and density using the COSPAR International Reference Atmosphere 1986 — use for middle atmosphere (up to 120 km) studies |
| COESA Atmosphere Model | aerolibatmos2/COESA Atmosphere Model | R2023a+ | Compute atmospheric properties using the U.S. Standard Atmosphere 1976 (COESA) — the most common atmosphere model for aircraft simulation |
| ISA Atmosphere Model | aerolibatmos2/ISA Atmosphere Model | R2023a+ | Compute temperature, pressure, and density using the International Standard Atmosphere with optional temperature offset — use for standard-day flight performance |
| NRLMSISE-00 Atmosphere Model | aerolibatmos2/NRLMSISE-00 Atmosphere Model | R2023a+ | Compute atmospheric density and temperature using the NRL MSIS empirical model — use for spacecraft drag estimation in low Earth orbit |
| Pressure Altitude | aerolibatmos2/Pressure Altitude | R2023a+ | Convert static pressure to geopotential altitude using standard atmosphere pressure-altitude relationship |
| Lapse Rate Model | aerolibatmos2/Lapse Rate Model | R2023a+ | Compute atmospheric properties using a configurable temperature lapse rate — use for simplified atmosphere modeling with custom lapse rates |
| Non-Standard Day 210C | aerolibatmos2/Non-Standard Day 210C | R2023a+ | Compute atmosphere for MIL-STD-210C hot/cold/tropical non-standard day profiles — use for worst-case environmental performance analysis |
| Non-Standard Day 310 | aerolibatmos2/Non-Standard Day 310 | R2023a+ | Compute atmosphere for MIL-HDBK-310 non-standard day profiles — use for updated military environmental extremes analysis |

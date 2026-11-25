---
type: Simulink Block Category
title: Wind turbulence
description: "Wind, turbulence, and gust disturbance models (14 blocks)"
tags: [toolbox-kb, aerospace-blockset, wind, turbulence, gust, Dryden, Von Karman]
status: stable
sources:
  - resource: matlab:aerolibwind2
source: toolbox_kb
managed_by: satk
library: Aerospace Blockset
kb_folder: aerospace-blockset
category: wind-turbulence
block_count: 14
generated: { by: satk-toolbox-build/1, at: "2026-11-23T18:23:13Z" }
---

# Wind turbulence

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Discrete Wind Gust Model | aerolibwind2/Discrete Wind Gust Model | R2023a+ | Generate a 1-cosine discrete gust profile per MIL-F-8785C — use for gust load analysis and control law robustness testing |
| Dryden Wind Turbulence Model  (Continuous (+q -r)) | aerolibwind2/Dryden Wind Turbulence Model  (Continuous (+q -r)) | R2023a+ | Generate continuous stochastic turbulence per MIL-F-8785C Dryden spectra — the standard turbulence model for fixed-wing simulation (positive pitch, negative yaw convention) |
| Horizontal Wind Model | aerolibwind2/Horizontal Wind Model | R2023a+ | Compute steady-state horizontal winds (eastward and northward components) as a function of altitude and location |
| Wind Shear Model | aerolibwind2/Wind Shear Model | R2023a+ | Generate a vertical wind shear profile representing low-level wind shear or microburst for approach/departure safety analysis |
| Dryden Wind Turbulence Model  (Continuous (+q +r)) | aerolibwind2/Dryden Wind Turbulence Model  (Continuous (+q +r)) | R2023a+ | Dryden continuous turbulence with positive pitch and positive yaw rate convention |
| Dryden Wind Turbulence Model  (Continuous (-q +r)) | aerolibwind2/Dryden Wind Turbulence Model  (Continuous (-q +r)) | R2023a+ | Dryden continuous turbulence with negative pitch and positive yaw rate convention |
| Dryden Wind Turbulence Model  (Discrete (+q +r)) | aerolibwind2/Dryden Wind Turbulence Model  (Discrete (+q +r)) | R2023a+ | Discrete-time Dryden turbulence for digital simulation with positive pitch and yaw convention |
| Dryden Wind Turbulence Model  (Discrete (+q -r)) | aerolibwind2/Dryden Wind Turbulence Model  (Discrete (+q -r)) | R2023a+ | Discrete-time Dryden turbulence for digital simulation with positive pitch, negative yaw convention |
| Dryden Wind Turbulence Model  (Discrete (-q +r)) | aerolibwind2/Dryden Wind Turbulence Model  (Discrete (-q +r)) | R2023a+ | Discrete-time Dryden turbulence for digital simulation with negative pitch, positive yaw convention |
| Horizontal Wind Model 07 | aerolibwind2/Horizontal Wind Model 07 | R2023a+ | Compute quiet-time horizontal winds using the HWM07 empirical model — accounts for latitude, longitude, altitude, and solar activity |
| Horizontal Wind Model 14 | aerolibwind2/Horizontal Wind Model 14 | R2023a+ | Compute horizontal winds using the updated HWM14 empirical model — improved accuracy over HWM07 for upper atmosphere |
| Von Karman Wind Turbulence Model  (Continuous (+q +r)) | aerolibwind2/Von Karman Wind Turbulence Model  (Continuous (+q +r)) | R2023a+ | Generate continuous Von Karman turbulence with positive pitch and yaw — preferred for European standards and MIL-HDBK-1797B |
| Von Karman Wind Turbulence Model  (Continuous (+q -r)) | aerolibwind2/Von Karman Wind Turbulence Model  (Continuous (+q -r)) | R2023a+ | Generate continuous Von Karman turbulence with positive pitch, negative yaw rate convention |
| Von Karman Wind Turbulence Model  (Continuous (-q +r)) | aerolibwind2/Von Karman Wind Turbulence Model  (Continuous (-q +r)) | R2023a+ | Generate continuous Von Karman turbulence with negative pitch, positive yaw rate convention |

---
type: Simulink Block Category
title: Direction finding
description: Direction of arrival estimation and spatial spectrum analysis
tags: [DOA, MUSIC, ESPRIT, monopulse, spectrum, angle]
status: stable
source: mathworks_toolbox
library_root: Phased Array System Toolbox
category_path: Direction finding
block_count: 15
---

# Direction finding

Use these blocks for direction finding.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Beamscan Spectrum | phaseddoalib/Beamscan Spectrum | R2023a+ | Estimate spatial spectrum by scanning conventional beamformer across all angles |
| Beamspace ESPRIT DOA | phaseddoalib/Beamspace ESPRIT DOA | R2023a+ | Estimate direction of arrival using ESPRIT in reduced beamspace for computational efficiency |
| ESPRIT DOA | phaseddoalib/ESPRIT DOA | R2023a+ | Estimate direction of arrival using the ESPRIT algorithm with shift-invariant array structure |
| GCC DOA and TOA | phaseddoalib/GCC DOA and TOA | R2023a+ | Estimate direction and time of arrival using generalized cross-correlation between sensor pairs |
| MUSIC Spectrum | phaseddoalib/MUSIC Spectrum | R2023a+ | Estimate spatial spectrum using the MUSIC algorithm for high-resolution DOA estimation |
| MVDR Spectrum | phaseddoalib/MVDR Spectrum | R2023a+ | Estimate spatial spectrum using MVDR for adaptive spatial filtering with better resolution than beamscan |
| Monopulse Estimator | phaseddoalib/Monopulse Estimator | R2023a+ | Estimate precise angular position of a target using sum and difference beam ratio |
| Monopulse Feed | phaseddoalib/Monopulse Feed | R2023a+ | Generate sum and difference channel outputs from an array for monopulse angle estimation |
| Root MUSIC DOA | phaseddoalib/Root MUSIC DOA | R2023a+ | Estimate DOA by polynomial rooting of the MUSIC pseudo-spectrum for ULA geometries |
| Root WSF DOA | phaseddoalib/Root WSF DOA | R2023a+ | Estimate DOA using weighted subspace fitting with polynomial rooting for improved accuracy |
| ULA Beamscan Spectrum | phaseddoalib/ULA Beamscan Spectrum | R2023a+ | Estimate spatial spectrum for a uniform linear array using conventional beamscan |
| ULA MUSIC Spectrum | phaseddoalib/ULA MUSIC Spectrum | R2023a+ | Estimate spatial spectrum for a uniform linear array using the MUSIC algorithm |
| ULA MVDR Spectrum | phaseddoalib/ULA MVDR Spectrum | R2023a+ | Estimate spatial spectrum for a uniform linear array using MVDR beamforming |
| ULA Sum and Difference Monopulse | phaseddoalib/ULA Sum and Difference Monopulse | R2023a+ | Estimate azimuth angle using sum-difference monopulse with a uniform linear array |
| URA Sum and Difference Monopulse | phaseddoalib/URA Sum and Difference Monopulse | R2023a+ | Estimate azimuth and elevation angles using sum-difference monopulse with a uniform rectangular array |

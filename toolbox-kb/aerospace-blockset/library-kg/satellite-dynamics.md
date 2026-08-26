---
type: Simulink Block Category
title: Satellite dynamics
description: Orbit propagation, spacecraft attitude, and CubeSat vehicles
tags: [orbit, satellite, spacecraft, CubeSat, attitude]
status: stable
source: mathworks_toolbox
library_root: Aerospace Blockset
category_path: Satellite dynamics
block_count: 13
---

# Satellite dynamics

Use these blocks for satellite dynamics.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| CubeSat Vehicle (Nadir Pointing) | aerolibcubesatveh/CubeSat Vehicle (Nadir Pointing) | R2023a+ | Pre-configured CubeSat model with nadir-pointing attitude — drag-and-drop for quick CubeSat orbit simulation |
| CubeSat Vehicle (Custom Pointing) | aerolibcubesatveh/CubeSat Vehicle (Custom Pointing) | R2023a+ | CubeSat model with user-defined pointing direction — use when non-standard attitude profiles are needed |
| CubeSat Vehicle (Sun Tracking) | aerolibcubesatveh/CubeSat Vehicle (Sun Tracking) | R2023a+ | CubeSat model that tracks the Sun for maximum solar panel illumination — use for power budget analysis |
| Attitude Profile (Nadir Pointing) | aerolibsatdyn/Attitude Profile (Nadir Pointing) | R2023a+ | Generate quaternion commands for Earth-nadir pointing attitude — use for Earth observation satellite attitude guidance |
| Attitude Dynamics | aerolibsatdyn/Attitude Dynamics | R2023a+ | Propagate spacecraft rotational dynamics (angular velocity and quaternion) from applied torques and inertia — the core spacecraft attitude block |
| Attitude Profile (Geographic Pointing) | aerolibsatdyn/Attitude Profile (Geographic Pointing) | R2023a+ | Generate quaternion commands to point at a geographic location on Earth — use for targeted observation or communication pointing |
| Attitude Profile (Sun Tracking) | aerolibsatdyn/Attitude Profile (Sun Tracking) | R2023a+ | Generate quaternion commands for Sun-pointing attitude — use for solar panel orientation or sun-sensor calibration |
| Cartesian State Vectors to Keplerian Orbital Elements | aerolibsatdyn/Cartesian State Vectors to Keplerian Orbital Elements | R2023a+ | Convert position/velocity vectors to classical Keplerian elements (a, e, i, RAAN, omega, nu) for orbit characterization |
| Keplerian Orbital Elements to Cartesian State Vectors | aerolibsatdyn/Keplerian Orbital Elements to Cartesian State Vectors | R2023a+ | Convert Keplerian orbital elements to position/velocity vectors for initializing orbit propagation |
| Line of Sight Access | aerolibsatdyn/Line of Sight Access | R2024b+ | Determine if two objects have unobstructed line of sight considering Earth occultation — use for communication link and sensor coverage analysis |
| Orbit Propagator Kepler (unperturbed) | aerolibsatdyn/Orbit Propagator Kepler (unperturbed) | R2023a+ | Propagate a Keplerian orbit analytically without perturbations — use for quick orbit prediction when perturbations are negligible |
| Orbit Propagator Numerical (high precision) | aerolibsatdyn/Orbit Propagator Numerical (high precision) | R2023a+ | Propagate orbit numerically with drag, solar radiation pressure, third-body, and gravity perturbations — use for mission-fidelity orbit analysis |
| Spacecraft Dynamics | aerolibsatdyn/Spacecraft Dynamics | R2023a+ | Integrate combined translational and rotational spacecraft equations of motion — a single block for complete 6DOF spacecraft simulation |

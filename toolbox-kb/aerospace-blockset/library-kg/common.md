---
type: Block Selection Guide
title: Common Blocks
description: High-value blocks selected for quick agent discovery.
status: stable
source: mathworks_toolbox
block_count: 20
---

# Common Blocks

Prefer these blocks when their intent matches the user request.

| Intent | Preferred Block | Library |
|---|---|---|
| Model linear actuator dynamics as a second-order transfer function — use for control surface deflection response with natural frequency and damping | Linear Second-Order Actuator | Aerospace Blockset |
| Compute body-axis aerodynamic forces and moments from coefficients, dynamic pressure, and reference geometry — the primary aero block for any flight vehicle model | Aerodynamic Forces and Moments | Aerospace Blockset |
| Compute atmospheric properties using the U.S. Standard Atmosphere 1976 (COESA) — the most common atmosphere model for aircraft simulation | COESA Atmosphere Model | Aerospace Blockset |
| Compute normal gravity on or near the WGS84 ellipsoid using the Somigliana formula — use for standard aircraft-level gravity modeling | WGS84 Gravity Model   | Aerospace Blockset |
| Generate a 1-cosine discrete gust profile per MIL-F-8785C — use for gust load analysis and control law robustness testing | Discrete Wind Gust Model | Aerospace Blockset |
| Generate continuous stochastic turbulence per MIL-F-8785C Dryden spectra — the standard turbulence model for fixed-wing simulation (positive pitch, negative yaw convention) | Dryden Wind Turbulence Model  (Continuous (+q -r)) | Aerospace Blockset |
| Integrate 6DOF equations in ECEF frame using quaternion attitude — use for long-range or orbital flight where Earth curvature and rotation matter | 6DOF ECEF (Quaternion) | Aerospace Blockset |
| Integrate 6DOF body-axis equations using Euler angle attitude — the most common EoM block for conventional aircraft simulation | 6DOF (Euler Angles) | Aerospace Blockset |
| Integrate 6DOF body-axis equations using quaternion attitude — use to avoid gimbal lock in highly maneuverable vehicle or spacecraft simulation | 6DOF (Quaternion) | Aerospace Blockset |
| Compute dynamic pressure (q-bar) from airspeed and density — fundamental for aerodynamic force calculation | Dynamic Pressure | Aerospace Blockset |
| Compute angle of attack, sideslip angle, and total airspeed from body-axis velocity components (u, v, w) | Incidence, Sideslip, & Airspeed | Aerospace Blockset |
| Compute Mach number from airspeed and speed of sound for compressibility-related calculations | Mach Number | Aerospace Blockset |
| Propagate orbit numerically with drag, solar radiation pressure, third-body, and gravity perturbations — use for mission-fidelity orbit analysis | Orbit Propagator Numerical (high precision) | Aerospace Blockset |
| Integrate combined translational and rotational spacecraft equations of motion — a single block for complete 6DOF spacecraft simulation | Spacecraft Dynamics | Aerospace Blockset |
| Convert ECEF Cartesian coordinates to geodetic latitude, longitude, and altitude — standard GPS-to-map conversion | ECEF Position to LLA | Aerospace Blockset |
| Convert flat-Earth (NED) position back to geodetic coordinates — use at end of flat-Earth simulation for geo-referenced output | Flat Earth to LLA | Aerospace Blockset |
| Convert geodetic latitude, longitude, and altitude to ECEF Cartesian coordinates — standard map-to-Cartesian conversion | LLA to ECEF Position | Aerospace Blockset |
| Convert geodetic coordinates to flat-Earth NED position relative to a reference point — use for local-area aircraft simulation | LLA to Flat Earth | Aerospace Blockset |
| Construct a DCM from Euler rotation angles for any sequence — the standard attitude initialization method | Rotation Angles to Direction Cosine Matrix | Aerospace Blockset |
| Normalize a quaternion to unit length — essential after numerical integration to prevent attitude drift | Quaternion Normalize | Aerospace Blockset |

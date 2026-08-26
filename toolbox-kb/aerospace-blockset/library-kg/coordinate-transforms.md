---
type: Simulink Block Category
title: Coordinate transforms
description: Frame conversions between ECEF, ECI, NED, LLA, body, and wind axes
tags: [DCM, ECEF, ECI, LLA, NED]
status: stable
source: mathworks_toolbox
library_root: Aerospace Blockset
category_path: Coordinate transforms
block_count: 30
---

# Coordinate transforms

Use these blocks for coordinate transforms.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Besselian Epoch to Julian Epoch | aerolibtransform2/Besselian Epoch to Julian Epoch | R2023a+ | Convert Besselian epoch year to Julian epoch year — use when processing legacy star catalogs or precession models |
| Direction Cosine Matrix Body to Wind | aerolibtransform2/Direction Cosine Matrix Body to Wind | R2023a+ | Construct the DCM from body to wind axes using angle of attack and sideslip — use for force resolution between body and wind frames |
| Direction Cosine Matrix Body to Wind to Alpha and Beta | aerolibtransform2/Direction Cosine Matrix Body to Wind to Alpha and Beta | R2023a+ | Extract angle of attack and sideslip from a body-to-wind DCM — inverse of DCM construction from aero angles |
| Direction Cosine Matrix ECEF to NED | aerolibtransform2/Direction Cosine Matrix ECEF to NED | R2023a+ | Construct the DCM from ECEF to local NED frame using geodetic latitude and longitude — fundamental for local-level navigation |
| Direction Cosine Matrix ECEF to NED to Latitude and Longitude | aerolibtransform2/Direction Cosine Matrix ECEF to NED to Latitude and Longitude | R2023a+ | Extract geodetic latitude and longitude from an ECEF-to-NED direction cosine matrix |
| Direction Cosine Matrix ECI to ECEF | aerolibtransform2/Direction Cosine Matrix ECI to ECEF | R2023a+ | Construct the DCM from ECI to ECEF using Julian date and Earth rotation — required for satellite position in Earth-fixed coordinates |
| Direction Cosine Matrix to Wind Angles | aerolibtransform2/Direction Cosine Matrix to Wind Angles | R2023a+ | Extract wind angles (flight path, heading, bank) from a direction cosine matrix |
| ECI Position to AER | aerolibtransform2/ECI Position to AER | R2023a+ | Convert ECI position to azimuth, elevation, and range relative to a ground station — use for ground-to-satellite tracking |
| ECI Position to LLA | aerolibtransform2/ECI Position to LLA | R2023a+ | Convert ECI position vector to geodetic latitude, longitude, and altitude — use for satellite ground-track computation |
| Julian Epoch to Besselian Epoch | aerolibtransform2/Julian Epoch to Besselian Epoch | R2023a+ | Convert Julian epoch year to Besselian epoch year for compatibility with older astronomical catalogs |
| LLA to ECI Position | aerolibtransform2/LLA to ECI Position | R2023a+ | Convert geodetic latitude, longitude, and altitude to ECI position vector — use for ground station position in inertial frame |
| Wind Angles to  Direction Cosine Matrix | aerolibtransform2/Wind Angles to  Direction Cosine Matrix | R2023a+ | Construct a DCM from wind angles (flight path, heading, bank) — inverse of DCM-to-wind-angles extraction |
| Direction Cosine Matrix to Rotation Angles | aerolibtransform2/Direction Cosine Matrix to Rotation Angles | R2023a+ | Extract Euler rotation angles from a DCM for any rotation sequence (ZYX, XYZ, etc.) |
| Direction Cosine Matrix  to Quaternions | aerolibtransform2/Direction Cosine Matrix  to Quaternions | R2023a+ | Convert a direction cosine matrix to equivalent quaternion representation — use when switching between rotation representations |
| Direction Cosine Matrix to Rodrigues | aerolibtransform2/Direction Cosine Matrix to Rodrigues | R2023a+ | Convert a DCM to Rodrigues (Gibbs) vector representation for small-angle applications |
| ECEF Position to LLA | aerolibtransform2/ECEF Position to LLA | R2023a+ | Convert ECEF Cartesian coordinates to geodetic latitude, longitude, and altitude — standard GPS-to-map conversion |
| Flat Earth to LLA | aerolibtransform2/Flat Earth to LLA | R2023a+ | Convert flat-Earth (NED) position back to geodetic coordinates — use at end of flat-Earth simulation for geo-referenced output |
| Geocentric to  Geodetic Latitude | aerolibtransform2/Geocentric to  Geodetic Latitude | R2023a+ | Convert geocentric latitude to geodetic latitude accounting for Earth oblateness |
| Geodetic to  Geocentric Latitude | aerolibtransform2/Geodetic to  Geocentric Latitude | R2023a+ | Convert geodetic latitude to geocentric latitude for spherical Earth calculations |
| LLA to ECEF Position | aerolibtransform2/LLA to ECEF Position | R2023a+ | Convert geodetic latitude, longitude, and altitude to ECEF Cartesian coordinates — standard map-to-Cartesian conversion |
| LLA to Flat Earth | aerolibtransform2/LLA to Flat Earth | R2023a+ | Convert geodetic coordinates to flat-Earth NED position relative to a reference point — use for local-area aircraft simulation |
| Quaternions to Rodrigues | aerolibtransform2/Quaternions to Rodrigues | R2023a+ | Convert quaternion to Rodrigues (Gibbs) vector representation |
| Quaternions to  Direction Cosine Matrix | aerolibtransform2/Quaternions to  Direction Cosine Matrix | R2023a+ | Convert quaternion to equivalent 3x3 DCM — use for applying quaternion attitude to vector rotations |
| Quaternions to Rotation Angles | aerolibtransform2/Quaternions to Rotation Angles | R2023a+ | Extract Euler angles from quaternion for display or controller feedback |
| Rodrigues to Direction Cosine Matrix | aerolibtransform2/Rodrigues to Direction Cosine Matrix | R2023a+ | Convert Rodrigues vector to equivalent direction cosine matrix |
| Rodrigues to Quaternions | aerolibtransform2/Rodrigues to Quaternions | R2023a+ | Convert Rodrigues vector to quaternion representation for singularity-free propagation |
| Rodrigues to Rotation Angles | aerolibtransform2/Rodrigues to Rotation Angles | R2023a+ | Extract Euler angles from a Rodrigues vector |
| Rotation Angles to Direction Cosine Matrix | aerolibtransform2/Rotation Angles to Direction Cosine Matrix | R2023a+ | Construct a DCM from Euler rotation angles for any sequence — the standard attitude initialization method |
| Rotation Angles to Quaternions | aerolibtransform2/Rotation Angles to Quaternions | R2023a+ | Convert Euler angles to quaternion — use for singularity-free attitude initialization from common angle inputs |
| Rotation Angles to Rodrigues | aerolibtransform2/Rotation Angles to Rodrigues | R2023a+ | Convert Euler angles to Rodrigues vector representation |

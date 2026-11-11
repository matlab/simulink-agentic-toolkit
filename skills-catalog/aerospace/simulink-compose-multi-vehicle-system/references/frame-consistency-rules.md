# Keep Coordinate Frames Consistent

A frame mismatch compiles and simulates without a warning, but every relative
position is wrong. Pick one frame for the whole scene and align every component
to it.

## Choose the Frame

| Scene | `actorFrame` |
|-------|--------------|
| Local, all vehicles within about 50 km (default) | `Flat Earth` |
| Global routes, or positions given or needed as latitude and longitude | `WGS84 Ellipsoid` |
| The user works in Earth-centered Cartesian coordinates, for example vehicles spread across continents or in orbit | `ECEF Frame` |

When unsure, use `Flat Earth`. Separation is then a plain vector difference.
In `WGS84 Ellipsoid`, compute separation as a great-circle distance, not a
vector difference of latitude and longitude.

## Align Every Component

| `actorFrame` | Trajectory source | Tracker parameter | Tracker options |
|--------------|-------------------|-------------------|-----------------|
| `Flat Earth` | Any function, default output (`xNorth`, `yEast`) | `trackerCoordinatesFlatEarth` | `Sensor Frame`, `Flat Earth` |
| `WGS84 Ellipsoid` | `polylineTrajectory` with `CoordinatePlane` `Ellipsoidal` (`Lat`, `Lon`), or your own conversion | `trackerCoordinatesWGSECEF` | `Sensor Frame`, `ECEF Frame`, `WGS84 Ellipsoid` |
| `ECEF Frame` | Your own conversion. No function outputs ECEF | `trackerCoordinatesWGSECEF` | `Sensor Frame`, `ECEF Frame`, `WGS84 Ellipsoid` |

- Every actor in the scene must have the same `actorFrame`.
- Every Target States input must use the same Actor States bus object as the actors that feed it.
- Only `polylineTrajectory` has `CoordinatePlane`. Every other function outputs Flat Earth NED.
- The tracker parameter shown in the dialog switches with `actorFrame`, but its
  value is yours to set. Check that it matches how you read the measurements.
- With `Flat Earth` tracker coordinates, the X, Y, Z output is the displacement
  from the observer to the target, not the target's absolute position.

## Position Meaning per Frame

| `actorFrame` | Actor States position elements |
|--------------|--------------------------------|
| `Flat Earth` | X, Y, Z in metres or feet, from the local origin |
| `ECEF Frame` | X, Y, Z in metres or feet, from Earth's center |
| `WGS84 Ellipsoid` | Latitude and longitude in degrees, altitude |

In `Flat Earth`, the axes depend on the actor type:

| Actor type | `[X, Y, Z]` | `actorInitialXY` |
|------------|-------------|------------------|
| Fixed Wing, Agile Aerial Vehicle | North, East, Down | `[North East]` |
| Surface Vehicle | East, North, Up | `[East North]` |

Convert a Surface Vehicle position before you compare it with an aerial one:

```matlab
vesselNED = [vessel(2), vessel(1), -vessel(3)];
separation = norm(aircraft - vesselNED);
```

The same `actorInitialXY = [250 100]` places a Surface Vehicle at East 250,
North 100, and a Fixed Wing at North 250, East 100. In a mixed fleet, ask which
convention the user means, or derive it from the scenario. For example, "a
vessel directly below the aircraft" means the same geographic point, so the two
`actorInitialXY` values are swapped.

The NED/ENU difference does not matter when:
- each vehicle follows its own trajectory with no cross-vehicle math,
- you only plot each vehicle's own path, or
- buses only pass through the architecture model without computation.

## Verify

1. Run `model_query_params` with `params: ["actorFrame"]` on every actor block. All values must match.
2. For each actor with a tracker, read the tracker parameter for its frame and confirm the option.
3. Check that each trajectory's output fields match the frame: `xNorth`/`yEast` for Flat Earth, `Lat`/`Lon` for WGS84. For `ECEF Frame`, confirm the model converts trajectory output to ECEF.
4. Check the active initial-state parameters. Hidden ones keep old values after a frame change.
5. If one block disagrees, report it. Fix the whole scene, not that one block.

## Symptoms

| Symptom | Likely cause |
|---------|--------------|
| Vehicles millions of metres apart | One actor in `ECEF Frame`, another in `Flat Earth` |
| Separation off by about 6.4e6 m | A position read as ECEF while the actor is Flat Earth |
| Latitude values appear as X | A WGS84 state bus read as a Flat Earth bus |
| Tracker NaN for every target in range | Target positions in the wrong frame, so they fall outside the limits |
| Aircraft-to-ship distance wrong, frames match | NED aircraft mixed with ENU surface vehicle positions |
| Vehicles converge in the state output, but the tracker shows them diverging | Tracker coordinate option does not match how the measurements are read |
| Separation wrong in a WGS84 scene | Latitude and longitude subtracted as a vector instead of a great-circle distance |

----

Copyright 2026 The MathWorks, Inc.

----

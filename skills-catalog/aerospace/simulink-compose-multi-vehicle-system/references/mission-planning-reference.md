# Generate Trajectories with Aero.trajectory

All functions take name-value arguments and return reference signals for one
vehicle. Run `help Aero.trajectory.<name>` for the full argument list. In the
MATLAB Command Window, tab completion lists the argument names after you type
the function name.

## Choose a Function

1. Transit through waypoints → `polylineTrajectory` (default).
2. Smooth transit between two points → `bezierTrajectory` or `polynomialTrajectory`.
3. Perimeter patrol, loiter, orbit, or transit with turn-radius limits → `circularTrajectory`.
4. Area search:
   - Parallel tracks → `parallelSweepTrajectory`
   - Tracks perpendicular to the long side, or coordinated vehicles → `creepingTrajectory`
   - Spiral outward from a datum → `expandingSquareTrajectory`
   - Radial legs from a datum → `sectorTrajectory`
   - Along a track line → `tracklineTrajectory`
5. Area coverage (R2026b): Lissajous, figure-8, and star curves → `lissajousTrajectory`; Hilbert, Peano, or lawnmower → `spaceFillingTrajectory`.
6. Join two trajectories with a smooth bridge → `merge` (R2026b). Chain a new segment onto an old one → `PriorTrajectory`.

## Two Families

| Family | Functions | Behavior |
|--------|-----------|----------|
| Waypoint | `polyline`, `parallelSweep`, `creeping`, `expandingSquare`, `sector`, `trackline`, `spaceFilling` | Straight legs; heading changes instantly at each waypoint |
| Smooth | `bezier`, `polynomial`, `circular`, `lissajous` | Sampled curves; also output `LateralAcceleration` or `Turnrate` |

- `spaceFillingTrajectory` is waypoint-based. It has no `ReferenceSignalType` and no lateral-acceleration output.
- Do not chain a smooth trajectory onto a waypoint trajectory with
  `PriorTrajectory`, or the reverse. Concatenating the two families is not
  supported. Use `merge` to join them.

## Common Arguments

| Argument | Default | Notes |
|----------|---------|-------|
| `Speed` | 90 on waypoint and search functions; 10 on `bezier`, `polynomial`, `circular`, `lissajous`, `spaceFilling` | In the speed unit of `Units` |
| `Altitude` | None on `polyline` and the search functions, so omitting it errors. 0 on the others | Constant along the path |
| `InitialPosition` | `[0 0]` | `[x y]`. `[lat lon]` for `polylineTrajectory` on a Spherical or Ellipsoidal plane |
| `InitialHeading` | 0 | Radians, 0 to 2*pi. `bezier`, `polynomial`, `circular` need `InitialHeading` or `FinalHeading` |
| `Units` | `'Metric (MKS)'` | Also `'English (Velocity in ft/s)'`, `'English (Velocity in kts)'` |
| `OutputFormat` | `timeseries` | Or `timetable` |
| `StartTime` | `datetime('now')` | Absolute mission clock |
| `PriorTrajectory` | None | Chain onto a previous trajectory of the same family |

With `'English (Velocity in kts)'`, positions are in nautical miles and altitude
in feet. The actor block's `units` values spell `velocity` in lowercase, so do
not copy the string between them.

## Waypoint and Search Arguments

`polyline`, `parallelSweep`, `creeping`, `expandingSquare`, `sector`, and
`trackline` also take:

| Argument | Notes |
|----------|-------|
| `InitialAltitude` | Default 0. The trajectory climbs or descends from here to `Altitude` |
| `ClimbRate`, `DescentRate` | At most `Speed`. When omitted they equal `Speed`, which gives a steep climb. Set them explicitly |
| `NFZBoundaryPoints` | No-fly zone polygon as an N-by-2 array (N ≥ 3). For several zones, a cell array of N-by-2 arrays. The path reroutes around each zone |
| `NFZAltitudeBound` | Vehicles above this altitude fly through the zone. One value per zone |

Search geometry. Omitting a required argument errors:

| Function | Required | Optional |
|----------|----------|----------|
| `parallelSweepTrajectory` | `DatumPoint`, `Bearing`, `FieldLength`, `FieldWidth`, `TrackSpacing`, `Altitude` | |
| `creepingTrajectory` | `DatumPoint`, `Bearing`, `FieldLength`, `FieldWidth`, `TrackSpacing`, `Altitude` | `Mode`: `'Independent'`, `'1 to 1 coordination'`, `'1 to 2 coordination'`, `'1 to 3 coordination'` |
| `expandingSquareTrajectory` | `DatumPoint`, `Bearing`, `TrackSpacing`, `NumberOfLegs`, `Altitude` | `SearchDirection`: `Clockwise` (default), `Counterclockwise` |
| `sectorTrajectory` | `DatumPoint`, `Bearing`, `Radius`, `Altitude` | `SearchDirection`: `Counterclockwise` (default), `Clockwise` |
| `tracklineTrajectory` | `TrackPoint1`, `TrackPoint2`, `TrackLineType`, `TrackSpacing`, `Altitude` | |

- `Bearing` is in radians, 0 to 2*pi.
- `TrackLineType` is `'Trackline Search, Return (TSR)'` or `'Trackline Search, No Return (TSN)'`.
- The two `SearchDirection` defaults differ. Do not assume one default for both.

`polylineTrajectory` arguments:

| Argument | Notes |
|----------|-------|
| `SegmentDistance` | Leg length. Required |
| `AbsoluteBearing` or `RelativeBearing` | Radians, 0 to 2*pi. Give one, never both |
| `CoordinatePlane` | `Flat` (default), `Spherical`, `Ellipsoidal` |
| `PathSegment` | `Shortest distance` (default) or `Constant heading`. Spherical and Ellipsoidal only |
| `Eccentricity` | Ellipsoidal plane only. Default 0.0818 |
| `SphereRadius` | Spherical plane only. Default 6378000 |
| `NumberOfSamples` | Only with `PathSegment` `Shortest distance` on Spherical or Ellipsoidal. Errors on Flat |

## Smooth Trajectory Arguments

`bezierTrajectory`, `polynomialTrajectory`, and `circularTrajectory` take:

| Argument | Notes |
|----------|-------|
| `FinalPosition` | Default `[50 50]` |
| `InitialHeading`, `FinalHeading` | Give at least one. Omitting both errors |
| `ShapeFactor` | Bezier and polynomial: at most 10, default 1 for Bezier. Circular: 0 to 1, default 0 |
| `NumberOfSamples` | Default 10, at least 2 |
| `ReferenceSignalType` | `lateral-acceleration` (default) or `turnrate` |
| `MinimumTurnRadius`, `MaximumTurnRadius` | `circularTrajectory` only. Defaults 0 and Inf |
| `Warnings` | `circularTrajectory` only. `'off'` (default) or `'on'` |

`lissajousTrajectory`:
- `TrajectoryType`: `Simple` (default), `Rectilinear`, `Circular`, `Star`.
- Shape arguments: `FieldCenter`, `FieldLength`, `FieldWidth`, `Tilt`,
  `FrequencyRatio`, `InitialPhase`, `Cycles`, `RadiusRange`, `AngularRange`,
  `FieldSize`, `NumberOfLobes`, `Sharpness`, `Bearing`.
- Each `TrajectoryType` accepts only its own shape arguments. For example,
  `RadiusRange` errors with `Simple` and `FieldSize` errors with `Circular`.
- `NumberOfSamples` defaults to 500, not 10.

`spaceFillingTrajectory`:
- `TrajectoryType`: `Hilbert` (default), `Peano`, `LawnMower`.
- Shape arguments: `FieldCenter`, `FieldLength`, `FieldWidth`, `Order`,
  `Orientation`, `Tilt`, `NumberOfSwathes`, `Bearing`.
- `Order` errors with `LawnMower`. `NumberOfSwathes` errors with `Hilbert` and `Peano`.

Neither function takes `InitialAltitude`, `ClimbRate`, `DescentRate`, or
no-fly-zone arguments.

## Output

A struct of `timeseries`. Each `timeseries` has `.Time` in seconds from 0 and `.Data`.

| Field | Unit |
|-------|------|
| `xNorth`, `yEast` | Position unit of `Units`. `Lat`, `Lon` instead on Spherical or Ellipsoidal planes |
| `Speed` | Speed unit of `Units` |
| `Altitude` | Altitude unit of `Units` |
| `Heading`, `FlightPathAngle` | Radians |
| `WaypointIndex` | Index of the current leg |
| `LateralAcceleration` or `Turnrate` | Smooth trajectories only |

- With `OutputFormat="timetable"`, the columns carry their units in the name
  (`xNorth(m)`, `Speed(m/s)`, `Heading(rad)`), and the row times are absolute
  `datetime` values from `StartTime`.
- One call returns one struct. A vector argument returns a cell array, one struct per element.
- `PriorTrajectory` chaining returns one combined struct.
- Every output is Flat Earth NED, except `polylineTrajectory` on a Spherical or Ellipsoidal plane.
- Run `fieldnames(traj)` to list the fields of an output.

## Join Trajectories

**Chain with `PriorTrajectory`** (same family only). The new segment starts
where the prior one ends. Do not pass `InitialHeading` together with
`PriorTrajectory`; it errors.

```matlab
seg1 = Aero.trajectory.sectorTrajectory(DatumPoint=[0 0], Bearing=pi/2, ...
    Radius=500, Altitude=100);
seg2 = Aero.trajectory.polylineTrajectory(PriorTrajectory=seg1, ...
    SegmentDistance=2000, AbsoluteBearing=0, Altitude=100);
```

**Bridge with `merge`** (R2026b): `merge(traj1, traj2, transition)` inserts a
`"bezier"`, `"circular"`, or `"polynomial"` bridge. `transition` is positional.

- Both inputs must be Flat Earth. Spherical or Ellipsoidal polyline output errors.
- `ShapeFactor` must be 0 to 1 for every transition type, even Bezier.
- `MinimumTurnRadius` and `MaximumTurnRadius` (default 0 and 50) work only with `"circular"`.
- Other arguments: `NumberOfSamples` (default 10), `ReferenceSignalType`, `OutputFormat`, `Units`.
- `merge` errors when the end of `traj1` already coincides with the start of `traj2`. Chain them with `PriorTrajectory` instead.

**Add events** with `addEvent(traj, eventName, ...)`. Give either
`StartTime`/`EndTime` (datetime) or `StartPositionIndex`/`EndPositionIndex`
(waypoint indices). It accepts trajectories from `bezier`, `circular`,
`polynomial`, `polyline`, `parallelSweep`, `creeping`, `expandingSquare`, and
`trackline`.

## Pack Signals for an Actor

Pack each vehicle's trajectory into a struct of `timeseries` whose fields match
the actor's reference bus order. Load it with a From Workspace block whose output
data type is that bus object.

```matlab
stopTime = 600;
hold = @(ts, f) timeseries(f([ts.Data; ts.Data(end)]), [ts.Time; stopTime]);
ref.SpeedRef   = hold(traj.Speed, @(x) x);
ref.FPARef     = hold(traj.FlightPathAngle, @rad2deg);
ref.HeadingRef = hold(traj.Heading, @rad2deg);
```

| Actor | Fields, in order | Source |
|-------|------------------|--------|
| Fixed Wing, heading mode | SpeedRef, FPARef, HeadingRef | `Speed`, `FlightPathAngle`, `Heading` |
| Surface Vehicle | SpeedRef, HeadingRef | `Speed`, `Heading`. Do not include FPA; the bus then has the wrong element count |
| Fixed Wing, bank mode | SpeedRef, FPARef, BankRef | No trajectory outputs bank. Compute it yourself |
| Agile Aerial Vehicle | SpeedRef, LateralAccRef, VerticalAccRef | `LateralAcceleration` from a smooth trajectory. Supply vertical acceleration yourself |

- Convert angles with `rad2deg` when the actor's **Attitude units** is `Degrees` (the default).
- Hold the last value to the stop time, as above. Otherwise the reference ends early.
- On the From Workspace block, set `Interpolate` to `off` for waypoint
  trajectories, and `OutputAfterFinalValue` to `Holding final value`. There is
  no separate zero-order-hold option: `Interpolate` `off` is zero-order hold.
- Set the actor's `actorInitialAltitude` to the trajectory's `InitialAltitude`.
  For level flight, set `InitialAltitude` equal to `Altitude`. Otherwise the
  vehicle climbs from the wrong height.
- Give each vehicle its own variable, and read it with a From Workspace block in the parent model. A From Workspace inside a shared vehicle model makes every vehicle fly the same path.
- A Signal Editor block can replace From Workspace when the user wants to edit
  scenarios interactively.

## Imported Mission Data

For flight plans or route files, read them with `readtable`, `load`, or
`jsondecode`, then pass the waypoints, speeds, and altitudes to `Aero.trajectory`
functions. Do not build reference signals from raw waypoints by hand: the
functions keep speed, altitude, and heading consistent.

----

Copyright 2026 The MathWorks, Inc.

----

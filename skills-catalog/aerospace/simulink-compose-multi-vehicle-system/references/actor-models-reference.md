# Configure the Kinematic Aerospace Actor Block

Library path: Aerospace Blockset / Integrated Systems / Actor Models. To add the
block programmatically, use the library `aerolibactor`, block
`aerolibactor/Kinematic Aerospace Actor`. Use one block per vehicle. The block
models point-mass kinematic motion with no aerodynamics or propulsion.

The dialog has four tabs: **Main** (units, type, frame, initial states),
**GNC** (controller behavior, response dynamics, limits), **Sensor** (inertial
sensor, tracker), and **Signal Attributes** (bus objects).

## Actor Type and Frame

| Actor type | Use for |
|------------|---------|
| `Fixed Wing` | Aircraft in aerodynamic flight: speed, flight path angle, heading or bank |
| `Agile Aerial Vehicle` | High-g maneuvers: speed, lateral and vertical acceleration |
| `Surface Vehicle` | Ships and ground vehicles constrained to a surface: speed, heading |

| Parameter | Values | Default |
|-----------|--------|---------|
| `actorType` | `Fixed Wing`, `Agile Aerial Vehicle`, `Surface Vehicle` | `Fixed Wing` |
| `actorFrame` | `Flat Earth`, `ECEF Frame`, `WGS84 Ellipsoid` | `Flat Earth` |
| `units` | `Metric (MKS)`, `English (velocity in ft/s)`, `English (velocity in kts)` | `Metric (MKS)` |
| `attitudeUnits` | `Degrees`, `Radians` | `Degrees` |

- `attitudeUnits` applies to every angle and angular rate except latitude and
  longitude. Latitude and longitude are always in degrees.
- `units` sets length, velocity, and acceleration. Length is metres for
  `Metric (MKS)` and feet for both English options. The trajectory functions use
  nautical miles for position with `'English (Velocity in kts)'`, so convert any
  position you copy between them.
- In `Flat Earth`, Fixed Wing and Agile Aerial Vehicle use NED. Surface Vehicle uses ENU.
- Changing `attitudeUnits` to `Radians` does not convert the angle limits. The
  defaults (heading ±180, FPA ±45, bank ±30) then fail validation. Set the
  limits in radians in the same `model_edit` configure operation.

## Controller Behavior

| `controllerBehavior` | Input port | Use when |
|----------------------|------------|----------|
| `General GNC` (default) | Reference inputs | Trajectories drive the vehicle |
| `External Controller` | Control inputs | Your own controller supplies accelerations and rates |

- `External Controller` bypasses the response dynamics, so the dynamics
  parameters are not used. The block still integrates position from the
  commanded motion.
- Write the full value. The block always reports the full string, so a
  comparison against an abbreviation fails.

## Input Buses

Every input is a nonvirtual bus of scalar `double` elements. Element ORDER must
match the table. Bus object and element names are free; use the table names for
readability.

**Reference inputs** (`General GNC`):

| Actor type | Parameter | Value (element order) |
|------------|-----------|-----------------------|
| Fixed Wing, heading mode (default) | `fixedWingReferenceInput` | `{'SpeedRef', 'FPARef', 'HeadingRef'}` |
| Fixed Wing, bank mode | `fixedWingReferenceInput` | `{'SpeedRef', 'FPARef', 'BankRef'}` |
| Agile Aerial Vehicle | `agileAerialVehicleReferenceInput` | `{'SpeedRef', 'LateralAccRef', 'VerticalAccRef'}` |
| Surface Vehicle | `surfaceVehicleReferenceInput` | `{'SpeedRef', 'HeadingRef'}` |

**Control inputs** (`External Controller`):

| Actor type | Parameter | Value (element order) |
|------------|-----------|-----------------------|
| Fixed Wing, heading mode | `fixedWingControlInput` | `{'LongitudinalAcc', 'PitchRate', 'TurnRate'}` |
| Fixed Wing, bank mode | `fixedWingControlInput` | `{'LongitudinalAcc', 'PitchRate', 'RollRate'}` |
| Agile Aerial Vehicle | `agileAerialVehicleControlInput` | `{'LongitudinalAcc', 'LateralAcc', 'VerticalAcc'}` |
| Surface Vehicle | `surfaceVehicleControlInput` | `{'LongitudinalAcc', 'TurnRate'}` |

- These parameters take the whole cell-string value. `'Bank'` or `'Heading'` alone errors.
- Only Fixed Wing has a choice. Agile Aerial Vehicle and Surface Vehicle have one value each.

**Target States** (when `detectionType` is `Tracker`): an array of nonvirtual
buses, one per target. Each element must use the same bus object as the Actor
States output. A bus object with identical elements but a different name does
not match. Set the number of targets in the port dimensions.

To build the Target States input:
1. Take the Actor States output of every other actor.
2. Pass each one through a Unit Delay (or a Memory block in a continuous-time
   model) to avoid an algebraic loop. An initial condition of `0` works for a bus.
3. Combine them with a Vector Concatenate block. It needs nonvirtual buses, so
   set `BusOutputAsStruct` to `on` on any Inport that carries them.
4. Wire the result to Target States. In a referenced vehicle model, set the
   Inport's port dimensions to the number of targets.

**Mount Attitude** (when `mountType` is `Gimbal`): a bus of Roll, Pitch, Yaw in
`attitudeUnits`.

## Output Buses

| Output | Elements, in order |
|--------|--------------------|
| Actor States, `Flat Earth` | X, Y, Z, Roll, Pitch, Heading, Speed |
| Actor States, `ECEF Frame` | X, Y, Z, Roll, Pitch, Heading, Speed |
| Actor States, `WGS84 Ellipsoid` | Latitude, Longitude, Altitude, Roll, Pitch, Heading, Speed |
| Inertial Measurement | Body X, Y, Z acceleration, roll rate, pitch rate, yaw rate |
| Tracker Measurement, `Sensor Frame` | Range, Azimuth, Elevation |
| Tracker Measurement, `Flat Earth` or `ECEF Frame` | X, Y, Z |
| Tracker Measurement, `WGS84 Ellipsoid` | Latitude, Longitude, Altitude |

The Tracker Measurement output has one bus per target. An undetected target
gives NaN in every element of its bus.

## Bus Objects

The bus parameters on the **Signal Attributes** tab (`stateBusStr`,
`inertialMeasurementBusStr`, `trackerMeasurementBusStr`) ship with a placeholder
name. Compile fails until each one names a real bus object. Create the bus
objects in the data dictionary first:

```matlab
names = {'X','Y','Z','Roll','Pitch','Heading','Speed'};
statesBus = Simulink.Bus;
for k = 1:numel(names)
    e = Simulink.BusElement;
    e.Name = names{k};
    statesBus.Elements(k) = e;
end
```

Then set `stateBusStr` to `Bus: <name>` with `model_edit`. Reuse one Actor
States bus object for every actor in the scene and for every Target States input.

## Initial States

| Parameter | Available when |
|-----------|----------------|
| `actorInitialXY` (`[x y]`) | `Flat Earth` or `ECEF Frame` |
| `actorInitialZ` | `ECEF Frame` (default is Earth's surface at X=0, Y=0) |
| `actorInitialLatitude`, `actorInitialLongitude` (degrees) | `WGS84 Ellipsoid` |
| `actorInitialAltitude` | `Flat Earth` or `WGS84 Ellipsoid` |
| `actorInitialAttitude` (`[roll pitch yaw]`) | Fixed Wing or Agile Aerial Vehicle |
| `actorInitialHeading` | Surface Vehicle |
| `actorInitialSpeed` (default 10) | Always |

- `actorInitialXY` follows the actor's convention: `[North East]` for Fixed Wing
  and Agile Aerial Vehicle, `[East North]` for Surface Vehicle.
- Set `actorInitialAltitude` to the trajectory's starting altitude. Otherwise the
  vehicle starts with a climb that saturates at the FPA limit.
- Hidden parameters keep old values after you change `actorFrame`. Re-set the
  ones that become active.
- Attitude uses Z-Y-X intrinsic Euler angles (yaw, pitch, roll), from the navigation frame to the body. It does not use quaternions.

## Response Dynamics (General GNC)

Each controlled channel tracks its reference with a first- or second-order response.

| Parameter pattern | Meaning | Default |
|-------------------|---------|---------|
| `<ch>Order` | `First order` or `Second order` | `First order` |
| `<ch>DCGain`, `<ch>TimeConstant` | First-order response | 1, 1 |
| `<ch>NaturalFrequency`, `<ch>DampingRatio` | Second-order response | 1, 1 |
| `<ch>Min`, `<ch>Max` | State limits | See the next table |

Channels (`<ch>`): `speed`, `FPA`, `heading`, `bank`, `lateralAcc`, `verticalAcc`.
Which ones apply depends on the actor type and reference input.

| Limit | Default |
|-------|---------|
| `speedMin`, `speedMax` | 0, Inf |
| `FPAMin`, `FPAMax` | -45, 45 |
| `headingMin`, `headingMax` | -180, 180 |
| `bankMin`, `bankMax` | -30, 30 |
| `lateralAccMin/Max`, `verticalAccMin/Max` | -Inf, Inf |
| `pitchRateMin/Max`, `turnRateMin/Max`, `rollRateMin/Max` | -Inf, Inf |

- Each Min must be less than or equal to its Max.
- Heading tracking always takes the shorter turn across ±180 degrees.
- Surface vehicles stay at constant altitude, and their Roll and Pitch outputs
  stay at 0, even while turning. Altitude parameters have no effect.

## Inertial Sensor

Set `inertialSensorFlag` to `on` to add the Inertial Measurement output. Set the
sensor offset from the center of gravity with `inertialCGDistance` (`[x y z]`).

## Tracker

| Parameter | Values | Default |
|-----------|--------|---------|
| `detectionType` | `None`, `Tracker` | `None` |
| `mountType` | `Fixed`, `Rotary`, `Gimbal` | `Fixed` |
| `trackerCoordinatesFlatEarth` (Flat Earth actors) | `Sensor Frame`, `Flat Earth` | `Sensor Frame` |
| `trackerCoordinatesWGSECEF` (ECEF and WGS84 actors) | `Sensor Frame`, `ECEF Frame`, `WGS84 Ellipsoid` | `Sensor Frame` |
| `mountPosition` | `[x y z]` offset in the body frame | `[0 0 0]` |
| `mountAttitude` | Fixed mount attitude relative to the vehicle body frame, `[roll pitch yaw]`, Z-Y-X Euler | `[0 0 0]` |
| `mountInitialAttitude`, `mountAngularVelocity` | Rotary mount start attitude and rate | `[0 0 0]` |
| `detectionRangeMin`, `detectionRangeMax` | Range limits | 0, Inf |
| `detectionAzimuthMin`, `detectionAzimuthMax` | Azimuth limits in `attitudeUnits` | -180, 180 |
| `detectionElevationMin`, `detectionElevationMax` | Elevation limits in `attitudeUnits` | -90, 90 |

- Set `detectionType` to `Tracker`. With `None` there are no tracker ports and no detections.
- Use the exact strings above. `No Sensor` is not valid.
- The default limits detect everything. Narrow them only to model a real field of view.
- A Rotary mount turns at `mountAngularVelocity` from `mountInitialAttitude`.

## Inspect the Block

Use `model_query_params` on the actor block:
- `params: ["all"]` lists every parameter and its current value.
- `params: ["actorType", "actorFrame", "controllerBehavior"]` checks the configuration.

----

Copyright 2026 The MathWorks, Inc.

----

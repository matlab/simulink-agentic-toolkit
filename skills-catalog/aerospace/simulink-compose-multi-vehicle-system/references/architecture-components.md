# Structure a Multi-Vehicle Model

## Decompose the Scene

- **Always:** one `.slx` per vehicle, used through Model Reference. Separate
  models compile in parallel, test alone, and scale without one huge file.
- **3+ vehicles or a complex mission:** a System Composer architecture model is
  the top level. It wires the vehicle models and the coordination model through
  explicit ports. Create it with `systemcomposer.createModel`; delegate the
  mechanics to `building-architecture-models`.
- A mission is **complex** when it has several coordination modes, sensor
  interactions between vehicles, or mixed vehicle types.
- **Exactly 2 vehicles, simple scene:** a plain Simulink top model that
  references the two vehicle models is enough.
- Decomposition costs more files and more bus routing. It pays back in
  scalability, reuse, clear interface contracts, and easier fleet growth.

| Model | Contains |
|-------|----------|
| Architecture `.slx` (System Composer) | One component per vehicle model, plus the coordination model |
| Vehicle `.slx` | One Kinematic Aerospace Actor and its local guidance. The trajectory enters through a reference Inport |
| Coordination `.slx` | The Stateflow chart(s). Reads every vehicle's Actor States bus |

Name models and variables after the scenario: `SearchAircraft`, `RescueVessel`,
not `UAV1`, `UAV2`.

| Component | Implemented as |
|-----------|----------------|
| Vehicle actor | Kinematic Aerospace Actor block in the vehicle model |
| Mission planner | From Workspace block fed by `Aero.trajectory` output, in the parent model, wired to the vehicle model's reference Inport. One per vehicle, or one shared generator script that writes a variable per vehicle. For references that react at run time, see `coordination-patterns.md` § Make Coordination Change Motion |
| Coordination manager | Stateflow chart in the coordination model. One per scene |
| Sensor suite | Tracker parameters on the actor block. There is no separate sensor block |

## Interfaces

All connections are nonvirtual buses.

| From | Signal | To |
|------|--------|----|
| Trajectory variable | Reference bus | Vehicle actor |
| Vehicle actor | Actor States bus | Coordination model |
| Vehicle actor | Actor States bus | Other actors' Target States inputs (through a Unit Delay) |
| Coordination model | Mode or phase signal | Each vehicle model |
| Vehicle actor with tracker | Tracker Measurement bus | Coordination model (optional) |

- Coordination outputs modes and phases. It never generates trajectories.
- Each vehicle model selects its own reference from the coordination output.
  Use a time-offset trajectory, a switch between a hold reference and the
  trajectory, or a mode selector.
- Every reference source must output a nonvirtual bus that matches the actor input.
- Keep alternate guidance (hold, return-to-base) in the vehicle model, not in the coordination model.

## Model Reference Gotchas

- A root Outport that carries a bus must name its bus object. Without it, the
  model compiles alone and fails only when referenced.
- Put the model folder on the project path before you configure Model blocks.
  Otherwise each instance warns that the model is not found and shows no arguments.
- Set Inport and Outport `BusOutputAsStruct` to `on` where you need a nonvirtual
  bus, for example before a Vector Concatenate block.
- Name every line that enters a Bus Creator to match the bus object. Unnamed
  lines cause an element-name mismatch.

## Per-Instance Data

Decide reuse by the model's ports. The ports are the interface.

**Reuse one referenced vehicle model** for instances whose input and output
ports match: the same number of ports, and on each port a bus with the same
signals in the same order (name, data type, dimensions). The instances then
differ only by parameter values: initial position, heading, speed, altitude,
response gains and limits, and the trajectory they receive.

**Create a separately named model** when any port's signal list differs, or
when the model internals differ (for example, one vehicle has a return-to-base
mode selector and another does not). Name it by role plus what makes it
different: `SearchAircraft`, `TrackerAircraft`, `RelayVessel`. Reused instances
share the model name; name each Model block by instance (`SearchAircraftNW`).

These actor settings change the ports, so instances that differ in any of them
need separate models:

| Setting | Port change |
|---------|-------------|
| `actorType` | Reference or control bus signals (3 vs 2) |
| `fixedWingReferenceInput` (heading vs bank) | Reference bus signals (`HeadingRef` vs `BankRef`) |
| `controllerBehavior` | Reference port vs control port |
| `actorFrame` | Actor States bus signals (X, Y, Z vs Latitude, Longitude, Altitude) |
| `detectionType` | Adds the Target States input and Tracker Measurement output |
| `mountType` `Gimbal` | Adds the Mount Attitude input |
| `inertialSensorFlag` | Adds the Inertial Measurement output |
| Number of targets | Target States dimensions |

Hold `units` and `attitudeUnits` the same in every instance of a model. They
change what the port values mean without changing the port.

Use one bus object for each distinct signal list, and reuse it on every
matching port. Simulink matches buses by bus object, not by contents.

### Feed the trajectory through an Inport

A From Workspace block inside the shared model reads the same variable in every
instance, so every vehicle flies the same path. Instead:

1. Give the vehicle model a reference Inport typed with the reference bus object.
2. In the parent model, add one From Workspace block per instance, each reading
   that vehicle's own trajectory variable, and wire it to the instance's Inport.

Generate one trajectory variable per vehicle, named after the vehicle. Its name
must match the `VariableName` of that vehicle's From Workspace block. Never
share one variable name across vehicles.

### Vary parameters with model arguments

1. Create each argument as a variable in the referenced model's model workspace.
   Base workspace or dictionary variables cannot become arguments.
2. Use the variable in the actor parameter, for example `actorInitialXY` = `initXY`.
3. List the variables in the model's `ParameterArgumentNames`.
4. On each Model block, read back its `InstanceParameters`, change only the
   values, and write the same structure back.

Initial states and response parameters (for example `headingTimeConstant`) both
work as model arguments.

## Project Layout

```
<ProjectRoot>/
├── <ProjectName>.prj
├── models/      all .slx files: architecture, vehicles, coordination
├── data/        the .sldd data dictionary
├── utilities/   all .m files: dictionary generator, trajectory generator,
│                startup, shutdown, model builders
└── work/        simulation cache (not under version control)
```

- The startup callback loads the dictionary and generates the trajectories.
- The trajectory generator reads its mission parameters from the dictionary, so a
  parameter change in one place updates every trajectory.
- The shutdown callback clears the workspace.

## Data Dictionary

Store in the `.sldd`:
- Bus objects for every actor port and every bus between models
- Per-vehicle parameter structs, grouped by concern (actor, guidance, trajectory)
- Simulation settings (stop time, sample time)
- Coordination thresholds, timeouts, and radii

Write one function that generates the whole dictionary. Build in stages: add a
stage, run it, verify it (compile, inspect parameters, check signals), then add
the next. A generator run only once at the end hides which stage broke.

## Scale the Fleet

- **Same ports:** one vehicle model, N instances with model arguments and their own trajectory inputs.
- **Different ports** (mixed types, frames, or sensor setups): one vehicle model per distinct port set. Each type has its own reference bus;
  the Actor States bus depends only on the frame, so it is shared when all actors share a frame.
- **Adding a vehicle:** add the model or instance, set its parameters, generate its
  trajectory, extend the coordination inputs and logic, and extend the Target States inputs of tracker actors.

## Choose a Simulation Strategy

| Scenario | Tool |
|----------|------|
| Single run, debugging, initial development (default) | `sim` |
| Parameter sweep on one machine: fleet size, sensitivity studies | `parsim` |
| Large or long-running campaigns on a cluster | `batchsim` |
| Structured catalog of what-if scenarios | `simulink.multisim.DesignStudy` |

Delegate execution to `simulating-simulink-models` or
`simulink-run-parallel-simulations`. In a sweep, override parameters per
simulation. Never write to the shared dictionary from parallel workers: the
workers conflict on the same file.

## Common Mistakes

| Mistake | Correction |
|---------|-----------|
| A separate sensor block | Configure the tracker on the actor block |
| One coordination chart per vehicle | One coordination model per scene. Several coordinators issue conflicting commands |
| Trajectory generation inside the coordination chart | Coordination outputs modes; vehicle models select references. Mixing them makes both untestable |
| Target States input left unconnected | Wire every other actor's Actor States bus into it |
| Actors in different frames sharing Target States | One frame for the whole scene |

----

Copyright 2026 The MathWorks, Inc.

----

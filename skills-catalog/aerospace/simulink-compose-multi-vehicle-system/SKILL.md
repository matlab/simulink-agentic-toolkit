---
name: simulink-compose-multi-vehicle-system
description: >
  Use this skill to build or configure a multi-vehicle aerospace simulation in
  Simulink with Aerospace Blockset system-level actor models and mission
  planning functions: fleet simulations, multi-UAV missions, formation flights,
  search and rescue missions, coordinated aircraft and ship scenarios,
  or any model where several vehicles share one scene. Also use it to plan a
  mission or generate trajectories with Aero.trajectory functions (waypoints,
  search patterns, loiters, transits) or to configure Kinematic Aerospace Actor
  blocks, even when the request does not say "multi-vehicle". The skill covers
  scene setup, trajectory generation, coordination logic, architecture
  decomposition, and coordinate frame consistency. Requires MATLAB R2026b or
  later.
license: https://www.mathworks.com/content/dam/mathworks/license/pmrl/license.md
metadata:
  author: MathWorks
  version: "1.2"
---

# Compose Multi-Vehicle Systems

Build multi-vehicle scenes with the Kinematic Aerospace Actor block and the
`Aero.trajectory` functions in Aerospace Blockset.

Requires MATLAB R2026b or later; the Kinematic Aerospace Actor block and several
`Aero.trajectory` functions first ship in R2026b. Before anything else, check the release
with `isMATLABReleaseOlderThan("R2026b")`. If it returns true, tell the user this skill
needs R2026b or later and stop.

## When to Use

- Several vehicles (aircraft, UAVs, agile aerial vehicles, ships) share one Simulink scene.
- The task is a coordinated mission: surveillance, formation, coverage, escort, or search and rescue.
- Reference trajectories must drive vehicle models.
- The request names the Kinematic Aerospace Actor block or `Aero.trajectory` functions.

## When NOT to Use

- One vehicle with detailed aerodynamics: use 6DOF blocks or a custom plant.
- 3D visualization: out of scope.
- Wind and atmosphere effects: out of scope. Scenes assume calm air.
- Model-building mechanics (block placement, wiring, running simulations): delegate to the companion skills below.

| Companion skill | Skill group | Delegate for |
|-----------------|-------------|--------------|
| `building-simulink-models` | Model-Based Design Core | Block placement, wiring, bus configuration, data dictionary API |
| `building-architecture-models` | Model-Based System Engineering | System Composer models, components, ports |
| `managing-simulink-projects` | Model-Based Design Core | MATLAB Project creation, paths, startup and shutdown |
| `simulating-simulink-models` | Model-Based Design Core | Running `sim`, `SimulationInput`, logged data |
| `simulink-run-parallel-simulations` | Simulink Simulation | Parameter sweeps with `parsim`, `batchsim`, `DesignStudy` |
| `testing-simulink-models` | Verification, Validation & Test | Test harnesses and regression tests |

Model-Based Design Core installs by default. If a companion skill from another group is not
installed, name the group to install. For example, scenes with three or more vehicles use
`building-architecture-models` from Model-Based System Engineering.

## Workflow

1. **Collect the Required Inputs.** Verify: every row of the table below has a value.
2. **Decompose the architecture** with System Composer (3+ vehicles or a complex mission).
   Verify: each component maps to one referenced model.
3. **Create the MATLAB Project** with the required folders. Verify: the project opens and its startup runs without errors.
4. **Generate the data dictionary** with code: bus objects, fleet parameters, simulation settings.
   Verify: every bus object the actor blocks name exists in the dictionary.
5. **Create one vehicle model per vehicle** with one Kinematic Aerospace Actor block.
   Verify: the model compiles on its own.
6. **Generate trajectories** with `Aero.trajectory` and load them for each vehicle.
   Verify: plot each trajectory before you wire it.
7. **Wire coordination and integrate.** Verify: the frame check and compile check in § Validation pass.
8. **Simulate and check intent.** Verify: the mission-intent check in § Validation passes.

## Required Inputs

| Input | Ask or derive | Rule |
|-------|---------------|------|
| Number of vehicles | **ASK** if not given | It cannot be inferred safely |
| Vehicle types | DERIVE | "UAV/aircraft" → Fixed Wing. "ship/boat" → Surface Vehicle. "agile/high-maneuver vehicle" → Agile Aerial Vehicle. ASK if ambiguous |
| Mission type | DERIVE | "patrol" → surveillance. "fly together" → formation. "search area" → coverage. "protect" → escort. ASK if unclear |
| Coordinate frame | DERIVE | Local area under about 50 km → Flat Earth. Global routes, or positions given as latitude and longitude → WGS84 Ellipsoid |
| Trajectory type | DERIVE | See § Trajectory Selection. ASK only when two options fit equally well |
| Fidelity | DERIVE | Kinematic by default. Redirect if the user asks for aerodynamics or 6DOF |
| Mission area (coverage, search, patrol) | **ASK** if no size or location is given | It sets the trajectory geometry. A guessed area wastes the build |

List every derived value in your response so the user can override it, then continue.

## Guardrails

**Always**
1. Get all seven Required Inputs before you build. A wrong vehicle count or frame forces a rebuild.
2. Put each vehicle in its own `.slx` and use it through Model Reference. Separate models compile in parallel, test alone, and scale.
3. Make a System Composer architecture model the top level for 3+ vehicles or a complex mission (several coordination modes, sensor interactions, or mixed vehicle types). It keeps the interfaces between vehicles and coordination explicit. Expressing the architecture only in a build script does not satisfy this rule.
4. Use the same frame for every actor and trajectory. A mismatch runs without error and gives wrong relative positions.
5. Define a bus object for every actor port before you compile. The block ships with a placeholder bus name, so compile fails until you set real bus objects.
6. Generate the data dictionary (`.sldd`) with code and keep fleet parameters, bus objects, and settings in it. Never create entries in the GUI. A scripted dictionary is reproducible and reviewable.
7. Organize the work as a MATLAB Project. The root holds only the `.prj` file, `README.md`, `buildLog.md`, and the folders `models/` (all `.slx`), `data/` (`.sldd`), `utilities/` (all `.m`), and `work/` (cache). A fixed layout lets the user find every file.
8. Put coordination in Stateflow, in its own referenced model, and make its output change vehicle motion. A flag that nothing reads is not coordination.
9. Keep a run log while you work, and write a README when the build works. The log makes a long build reviewable and resumable.

**Ask First**
- Before you skip or change any Always rule. Give the rule number, the reason, and your alternative. The user cannot review a decision that is already built, and finding it later costs them rework.
- When the mission type is not in the Required Inputs table and the request needs coordination.
- When a rule costs a lot of effort. Cost is a reason to ask, never a reason to decide alone.

**Never**
- Never build the simulation as a MATLAB script. Use scripts only for setup and analysis.
- Never hand-roll kinematics with Integrator or MATLAB Function blocks. Use the actor block.
- Never use MATLAB Function blocks for coordination logic.
- Never build first and report a deviation afterward. An unapproved deviation is a violation.
- Never clamp or saturate an output to hide a wrong value. Fix the parameter that caused it.
- Never rely on automatic signal names at bus boundaries. Name every signal explicitly.
- Never write to the shared dictionary inside a parallel sweep. Override parameters per simulation instead.

## Key Functions

| Function or block | Purpose | Toolbox | Available From |
|-------------------|---------|---------|----------------|
| Kinematic Aerospace Actor | Kinematic motion, inertial sensing, and target tracking for one vehicle | Aerospace Blockset | R2026b |
| `Aero.trajectory.polylineTrajectory` | Straight legs between waypoints | Aerospace Blockset | R2026a |
| `Aero.trajectory.bezierTrajectory`, `polynomialTrajectory`, `circularTrajectory` | Smooth transit between two points | Aerospace Blockset | R2026a |
| `Aero.trajectory.parallelSweepTrajectory`, `creepingTrajectory`, `expandingSquareTrajectory`, `sectorTrajectory`, `tracklineTrajectory` | Search patterns | Aerospace Blockset | R2026a |
| `Aero.trajectory.lissajousTrajectory`, `spaceFillingTrajectory` | Coverage patterns | Aerospace Blockset | R2026b |
| `Aero.trajectory.merge` | Join two trajectories with a smooth transition | Aerospace Blockset | R2026b |
| `Aero.trajectory.addEvent` | Add named events to a trajectory | Aerospace Blockset | R2026a |

## Trajectory Selection

| Mission intent | Use |
|----------------|-----|
| Transit through waypoints (default) | `polylineTrajectory` |
| Smooth transit between two points | `bezierTrajectory` or `polynomialTrajectory` |
| Perimeter patrol, loiter, orbit, or transit with turn-radius limits | `circularTrajectory` |
| Area search | `parallelSweepTrajectory`, `creepingTrajectory`, `expandingSquareTrajectory`, `sectorTrajectory`, `tracklineTrajectory` |
| Area coverage (R2026b) | `lissajousTrajectory`, `spaceFillingTrajectory` |
| Join two segments of the same family | `PriorTrajectory` on the new segment |
| Join a smooth segment and a waypoint segment | `merge` (R2026b). `PriorTrajectory` does not support mixing the families |

```matlab
ref = Aero.trajectory.parallelSweepTrajectory( ...
    DatumPoint=[100 50], Bearing=pi/4, ...
    FieldLength=500, FieldWidth=200, TrackSpacing=25, ...
    Speed=15, Altitude=100);
```

The output is a struct of `timeseries`: `xNorth`, `yEast`, `Speed`, `Altitude`,
`Heading`, `FlightPathAngle`, `WaypointIndex`. Run `help Aero.trajectory.<name>`
for exact arguments. Read `references/mission-planning-reference.md` for
arguments, gotchas, and packing.

## Actor Selection

| Vehicle role | Actor type | Controlled channels |
|--------------|------------|---------------------|
| Aircraft, fixed-wing UAVs (default) | `Fixed Wing` | Speed, flight path angle, heading or bank |
| High-maneuver aerial vehicles, agile UAVs | `Agile Aerial Vehicle` | Speed, lateral and vertical acceleration |
| Ships, ground vehicles | `Surface Vehicle` | Speed, heading |

| Scene | Navigation frame |
|-------|------------------|
| Local, under about 50 km (default) | `Flat Earth` |
| Latitude and longitude inputs or outputs | `WGS84 Ellipsoid` |
| Earth-centered Cartesian positions | `ECEF Frame` |

Read `references/frame-consistency-rules.md` when you set up a scene or debug
distances and positions.

Use `model_query_params` with `params: ["all"]` on an actor block to read its
parameters and valid values. Read `references/actor-models-reference.md` for
ports, buses, dynamics, and the tracker.

## Gotchas

- `Bearing`, `AbsoluteBearing`, and `RelativeBearing` are in RADIANS.
- `parallelSweepTrajectory` takes `FieldLength`, `FieldWidth`, `TrackSpacing`. It has no `SweepWidth` or `LegSpacing`.
- `Altitude` has no default on the waypoint and search functions. Omitting it errors.
- Search patterns require `DatumPoint` and `Bearing`.
- A vector argument (for example `Speed=[15 20 25]`) returns a cell array, one trajectory per element. Index it with `traj{k}`.
- Only `polylineTrajectory` takes `CoordinatePlane`. All other functions output Flat Earth NED.
- Trajectory angles are radians. The actor reads angles in its **Attitude units** (default Degrees). Convert when you pack the signals.
- Declare the unit convention once, in the data dictionary. Store each angle parameter in the unit of the layer that reads it, and check units at every boundary. Never assume they match.
- Hold the last trajectory value until the simulation stop time. Otherwise the reference signal ends early.
- Bus element ORDER must match the actor's port definition. Element names are free.
- In Flat Earth, Fixed Wing and Agile Aerial Vehicle positions are NED. Surface Vehicle positions are ENU. Convert before you compute distances between them.
- Surface vehicles stay at constant altitude. Do not set FPA or altitude dynamics on them; those parameters have no effect.
- **Detection type** defaults to `None`. Set it to `Tracker`, or no target is ever detected.
- Feeding actor states back into another actor's Target States input can create an algebraic loop. Insert a Unit Delay.
- Reuse one referenced vehicle model when instances have the same ports (same number, and the same bus signals in the same order). Feed each instance its trajectory through an Inport and vary its parameters with model arguments. Use a separately named model when any port differs. Read `references/architecture-components.md` § Per-Instance Data.

## Coordination

| Mission type | Pattern |
|--------------|---------|
| Surveillance, coverage | Timing Gate |
| Formation flight | Leader Rotation |
| Staged or sequential area entry | Phased Entry |
| Any mission with abort criteria | Recall Watchdog, in parallel with the primary pattern |

Feed each vehicle's Actor States bus into the chart. Feed the chart's mode or
phase output back into each vehicle model, and select that vehicle's reference
from it. Use temporal logic (`after(N, sec)`), never manual counters. Read
`references/coordination-patterns.md` for each pattern.

## Validation

Run these checks through the MCP tools after you build or change a model.

| Check | How | Run when |
|-------|-----|----------|
| Frame consistency | `model_query_params` with `params: ["actorFrame"]` on every actor block. All values must match | After you add or change an actor |
| Trajectory | Plot `xNorth` against `yEast` for each trajectory | Before wiring |
| Compile | `evaluate_matlab_code`: `mdl([],[],[],'compile'); mdl([],[],[],'term')` | After wiring buses |
| Simulation | Run through `simulating-simulink-models` and plot each vehicle's path | After compile passes |
| Mission intent | Compare simulated results against numbers you wrote down before the build | Before you report complete |

**Mission intent.** Before you build, write down the numbers the scenario must
produce: closest-approach distances and times, mode-change times, detection
windows. After simulation, compare the results against them. "It compiles" is
not a pass criterion.

**Before you report complete,** mark each Always and Never rule as yes,
approved deviation (with the user's approval), or VIOLATION. "Partly" counts as
a violation. Name every violation in the report and do not call the task complete.
Do not hide a violation as a design note, an "as-built deviation", or a known limitation.

## Deliverables

Offer both at the start of the task.

1. **Run log** (`buildLog.md`, updated as you work): the plan, the action history, each error and its fix, inputs and corrections from the user, and each approved deviation with its rule number, the user's decision, and the date.
2. **README** (`README.md`): what each folder holds, how to run the simulation, and how to change fleet size, a trajectory, or a controller.

Read `references/common-mistakes.md` when a model misbehaves or a build step fails.

----

Copyright 2026 The MathWorks, Inc.

----

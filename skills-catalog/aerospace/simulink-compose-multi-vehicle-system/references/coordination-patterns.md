# Implement Coordination in Stateflow

Use Stateflow for coordination. Coordination is phases, events, and timers, and
Stateflow expresses those directly. A MATLAB Function block hides the same
logic in persistent variables and has no temporal operators.

## Choose a Pattern

| Mission | Pattern |
|---------|---------|
| Surveillance or coverage with staggered entry | Timing Gate |
| Formation flight with role handoff | Leader Rotation |
| Staged or sequential entry into an area | Phased Entry |
| Any mission with abort or recall criteria | Recall Watchdog, in parallel with the primary pattern |

Combine patterns as parallel (AND) states in one chart:
- Surveillance with recall = Timing Gate + Recall Watchdog
- Formation with phased handoff = Leader Rotation + Timing Gate
- Staged entry with abort = Phased Entry + Recall Watchdog

## Wire the Chart

- **Inputs:** each vehicle's Actor States bus. Set the chart input's data type to
  the Actor States bus object, then read fields such as `leader.X`.
- Up to a few vehicles: one input per vehicle, named by role (`leader`, `wingman`).
  Large fleets of one type: one array-of-buses input, indexed by vehicle.
- **Outputs:** modes, phases, go/no-go flags, target assignments, and formation
  offsets. Use enumerations (`Simulink.IntEnumType`) rather than raw integers.
- Feed each output back into the vehicle models. Each vehicle model selects its
  reference from it.
- Do not split a nonvirtual bus with a Demux. Use a bus-typed chart input or a Bus Selector.

| Actor States field | Use in coordination |
|--------------------|---------------------|
| X, Y | Distance to a gate, a target, or another vehicle, in metres or feet |
| Latitude, Longitude (WGS84) | Great-circle distance, in degrees of latitude and longitude |
| Z (or Altitude) | Altitude separation. Z is Down for aerial actors and Up for surface vehicles in Flat Earth |
| Roll | Formation alignment checks |
| Pitch | Climb and descent phase detection |
| Heading | Alignment and convergence checks |
| Speed | Time-to-arrival and speed matching |

The trajectory's `WaypointIndex` signal increases at each waypoint. Feed it to
the chart as a phase-completion trigger: waypoint reached, then change phase.

## Make Coordination Change Motion

Every coordination output must change how a vehicle moves. Choose one per output:

| Method | How |
|--------|-----|
| Time offset | Delay the vehicle's trajectory by its entry time when you generate it. The coordination model then checks the timing |
| Switch-gated reference | A Switch in the vehicle model selects a hold reference or the trajectory reference from the coordination flag |
| Mode selector | A Multiport Switch in the vehicle model selects one reference per mode |

```
Cleared (Inport) → Switch → actor Reference input
                     ├── false: Constant hold reference (nonvirtual bus)
                     └── true:  trajectory reference Inport (nonvirtual bus)
```

A flag that is terminated or ignored is cosmetic coordination. It is wrong.

**Time offset example.** Shift a packed reference so the vehicle starts its
trajectory `entryDelay` seconds late:

```matlab
delay = @(ts) timeseries([ts.Data(1); ts.Data], [0; ts.Time + entryDelay]);
ref.SpeedRef   = delay(ref.SpeedRef);
ref.FPARef     = delay(ref.FPARef);
ref.HeadingRef = delay(ref.HeadingRef);
```

With `Interpolate` `off`, the first reference value holds until `entryDelay`. A
fixed-wing vehicle keeps flying at its initial speed and heading during that
time; it cannot hover. Place its start point so the straight run is harmless,
or use a loiter reference with a switch-gated reference instead.

**Runtime references.** When a reference must react to the simulation (for
example, meet a moving vehicle), compute it at run time in the vehicle model
with a Stateflow chart or MATLAB Function block instead of From Workspace. This
is reference generation, not coordination, so a MATLAB Function block is allowed here.

## Pattern 1: Timing Gate

Release vehicles one at a time, a fixed interval apart. Use it for staggered
coverage, sequential overflight, or time-on-target spacing.

- **States:** a sequence `Release1 → Release2 → … → ReleaseN`. Each transition is
  `after(separationInterval, sec)`. Entry to `Releasek` sets `cleared(k) = true`.
- `after` counts from entry to its own source state, so chaining the states gives
  the interval between successive releases.
- **Inputs:** X, Y for distance to the gate; Speed for time-to-arrival; Heading to
  confirm each vehicle is converging on the gate.
- **Outputs:** per-vehicle `cleared` flag.
- **Parameters:** `separationInterval` (s), `gatePosition`, `gateRadius`.
- **Effect on motion:** a switch-gated reference holds each vehicle until its
  flag is set. Or use time-offset trajectories and let the chart verify the spacing.

## Pattern 2: Leader Rotation

Rotate the leader role among formation members. Use it for extended formation
flights, relay surveillance, or sensor coverage that needs periodic handoff.

- **States:** one state per leader assignment (`Leader1`, `Leader2`, …).
  Transitions on `after(rotationPeriod, sec)`, or on a condition: fuel below a
  threshold, a reached waypoint, sensor coverage, or hazard exposure.
- **Inputs:** X, Y, Z for formation geometry; Heading and Speed to confirm alignment before handoff.
- **Outputs:** `leaderId`, per-vehicle role (Leader, Follower, Transitioning), `handoffActive`.
- **Parameters:** `rotationPeriod` (s), `handoffDuration` (s), `formationOffset`, `alignmentTolerance`.
- **Effect on motion:** each vehicle model uses a mode selector. As leader it
  follows the mission trajectory. As follower it follows the leader's trajectory
  shifted by `formationOffset`.

## Pattern 3: Phased Entry

Send vehicles into an area in phases. A phase starts only when every vehicle of
the previous phase is on station. Use it for staged arrivals, sequential area
coverage, entry into restricted airspace, or coordinated landing sequences.

- **States:** `Phase1 … PhaseN`. Each phase holds a parallel substate per vehicle:
  `Holding → Entering → OnStation`.
- **Inputs:** X, Y, Z for distance to the entry point; Heading for approach direction; Speed for time-to-arrival.
- **Outputs:** `currentPhase`, per-vehicle phase state, `phaseComplete`.
- **Parameters:** phase assignments, entry bearing, `stationRadius`, `phaseTimeout` (s).
- **Effect on motion:** a switch-gated reference holds each vehicle until its
  phase starts, then releases its entry trajectory.

## Pattern 4: Recall Watchdog

Watch abort conditions across the fleet and trigger recall, either all at once
or in sequence. Use it for geofences, fuel reserves, link loss, time-on-station
limits, or hazard detection.

- **States:** one parallel state `Watchdog` with `Monitoring → RecallActive → AllRecalled`.
  `Monitoring → RecallActive` fires when any abort condition is met.
  `RecallActive → AllRecalled` fires when every vehicle confirms return to base.
- **Inputs:** X, Y, Z for geofence checks; Speed for stall or overspeed; Heading for corridor deviation.
  Optional non-bus inputs: fuel, link status, hazard flag.
- **Outputs:** `recallActive`, `recallReason` (enumeration: Geofence, Fuel,
  Timeout, Hazard, Manual), per-vehicle `recalled`.
- **Parameters:** geofence polygon, `maxTimeOnStation` (s), fuel threshold, and
  `recallPriority`: `Immediate` (all vehicles at once) or `Phased` (one after another).
- **Effect on motion:** a mode selector in each vehicle model switches to a
  return-to-base reference when that vehicle is recalled.

## Compose Patterns

- Put each pattern in its own parallel state.
- Share data between them through chart-local data, not events. Events between
  parallel states can race.
- The watchdog wins: the primary pattern checks `recallActive` before it clears a
  gate or advances a phase. Without the check, vehicles continue the mission during recall.
- Merge the outputs: the primary pattern writes `nominalMode`, the watchdog writes
  `overrideMode`, and a switch downstream selects `overrideMode` while
  `recallActive` is true.

Example, surveillance with recall: the chart has parallel states
`TimingGateLogic` and `RecallWatchdog`, sharing local data `recallActive`. When
`recallActive` becomes true, the timing gate stops clearing vehicles, and
vehicles still approaching switch to return to base.

## Conventions

- Name states by mission phase: `Holding`, `OnStation`. Not `State1`.
- Use `after`, `before`, `duration`, and `elapsed` for timing. Never count ticks by hand.
- Use relative timing (`after` from state entry), not absolute simulation time.
  It survives trajectory time shifts.
- Do not use history junctions. Coordination state should follow from inputs and time.
- Keep single-vehicle guidance out of the coordination chart.

----

Copyright 2026 The MathWorks, Inc.

----

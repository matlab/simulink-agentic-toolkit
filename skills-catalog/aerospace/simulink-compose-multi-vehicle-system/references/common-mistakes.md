# Fix Common Multi-Vehicle Mistakes

Check this table when a model misbehaves, a build step fails, or before you
report the task complete. **[A<n>]** marks a breach of Always rule n in
`SKILL.md` § Guardrails.

## Modelling Mistakes

| Mistake | Correction |
|---------|-----------|
| Simulation written as a MATLAB script | Build a Simulink model. Use scripts only for setup and analysis |
| Kinematics hand-rolled with Integrator or MATLAB Function blocks | Use the Kinematic Aerospace Actor block |
| Coordination in a MATLAB Function block **[A8]** | Use a Stateflow chart with temporal logic |
| Actors in different frames **[A4]** | Set the same `actorFrame` on every actor |
| `CoordinatePlane` passed to a function other than `polylineTrajectory` | Only `polylineTrajectory` has it |
| Guessed trajectory argument names (`SweepWidth`, `LegSpacing`) | Use `FieldLength`, `FieldWidth`, `TrackSpacing`. Check `help` |
| Copied subsystems, one per vehicle **[A2]** | One `.slx` per vehicle through Model Reference |
| One flat model for 3+ vehicles **[A2, A3]** | Decompose with System Composer first |
| Bus parameters left at the placeholder name **[A5]** | Create bus objects and set `stateBusStr` and the other bus parameters |
| Virtual bus into the actor input | Use a nonvirtual bus with elements in the documented order |
| A converter block inserted to make a bus nonvirtual | Set the port's own bus virtuality to nonvirtual instead |
| `BusOutputAsStruct` left `off` on Inports and Outports that need a nonvirtual bus | Set it `on` on both. It is a port parameter, not an actor parameter. The dialog calls it "Output as nonvirtual bus" on an Inport and "Output as nonvirtual bus in parent model" on an Outport |
| A bus-typed Constant block given a vector value | Give it `0` or a struct that matches the bus exactly |
| A second bus object with the same elements used for Target States | Reuse the Actor States bus object. Buses match by object, not by structure |
| Trajectory struct wired into the model directly | Pack it into a struct of `timeseries` and hold the last value to the stop time |
| Trajectory radians fed to an actor set to Degrees | Convert with `rad2deg` when you pack |
| Trajectory `InitialAltitude` left at 0 while the actor starts higher | Match `actorInitialAltitude` to `InitialAltitude`, or set `InitialAltitude` equal to `Altitude` |
| `Attitude units` changed to Radians with default limits | Set the angle limits in radians in the same call |
| From Workspace left at `Interpolate` `on` for a waypoint trajectory | Set `Interpolate` to `off` and `OutputAfterFinalValue` to `Holding final value` |
| Tracker configured but `detectionType` left at `None` | Set `detectionType` to `Tracker` |
| One actor's states wired straight into another's Target States | Insert a Unit Delay, or a Memory block in a continuous-time model, to break the algebraic loop |
| A Demux used to split a nonvirtual bus | Use a Bus Selector or a bus-typed input |
| `PriorTrajectory` used to join a smooth and a waypoint trajectory | Use `merge`. Mixing the two families is not supported |
| Required search arguments omitted (`TrackSpacing`, `Radius`, `NumberOfLegs`, `TrackLineType`) | Pass them. They have no default at run time |
| A bad output clamped or saturated to look right | Find and fix the parameter that caused it |
| Parameters hardcoded in blocks **[A6]** | Store them in the data dictionary |
| Loose files without a MATLAB Project **[A7]** | Create a `.prj` with the required folders |
| Dictionary written inside a parallel sweep | Override parameters per simulation |
| To Workspace blocks in the architecture model | Log inside the vehicle models, or log the Actor States signals |
| Signal logging set on a line | Logging is a property of the source block's output port. Set it there |
| A parameter struct used in a MATLAB Function block derives fields from its own fields | Code generation rejects adding fields after a struct is read. Assign every field once, from literals, in a separate numeric struct |
| Searching shipped examples to learn the bus layout | Read the bus tables in `actor-models-reference.md` |

## Compliance Mistakes

These models compile, simulate, and pass every mechanical check, but still break the skill.

| Mistake | Correction |
|---------|-----------|
| An Always rule skipped because it felt like overhead | Ask first. The decision belongs to the user |
| A skipped rule recorded afterward as an "as-built deviation" | An unapproved deviation is a violation. Ask before you build |
| Half a rule treated as compliant | Model Reference without the architecture model, or a scripted build without the `.prj`, is still a deviation |
| Architecture expressed only in the build script | That is a deviation from Always rule 3, not another way to satisfy it |
| Compile and frame checks treated as proof of compliance | They test mechanics only. Mark every Always rule before you report complete |
| Run log or README written only at the end **[A9]** | Keep the run log as you work. A log written afterward misses the blockers that made it useful |
| "Complete" reported with a rule breach mentioned in passing | Fix it, or report it as a violation with what is missing |

----

Copyright 2026 The MathWorks, Inc.

----

---
name: inject-faults
description: "Add, configure, and manage faults on Simulink, Simscape, and System Composer model signals for robustness analysis and safety validation. Use when injecting faults (stuck, noise, gain, offset) onto block inports/outports, enabling fault simulation, or analyzing fault effects. Covers sensor failures, signal corruptions, actuator faults, FMEA validation, and robustness testing. Requires Simulink Fault Analyzer."
license: MathWorks BSD-3-Clause
metadata:
  version: "1.0"
  author: MathWorks
---

# Fault Injection

Use `evaluate_matlab_code` with the `Simulink.fault` API to programmatically inject faults into Simulink models. Faults override signal values at block ports to simulate hardware failures, sensor faults, and actuator malfunctions.

## When to Use

- Injecting sensor stuck-at faults, noise, or bias for safety analysis (Simulink, Simscape, System Composer)
- Validating FMEA failure modes through simulation
- Testing controller robustness against actuator or sensor failures
- Adding fault placeholders (without behavior) for FMEA traceability before defining fault logic
- Configuring fault trigger conditions (timed, conditional, always-on)
- Creating fault scenarios for automated testing
- Comparing nominal vs. faulted behavior
- Linking faults to FMEA failure mode cells
- Generating fault specification reports
- Exporting models with embedded fault behavior for teams without Simulink Fault Analyzer
- Registering custom fault behavior libraries
- Synchronizing (also called **resync** / **sync** / **synchronize faults** / **update fault references**) fault information from referenced models, subsystems, or linked libraries into a parent model

## When NOT to Use

- Creating FMEA spreadsheets or safety analysis documents -> use `manage-safety-analysis`
- Building or editing model structure -> use `building-simulink-models`
- Running standard (non-faulted) simulations -> use `simulating-simulink-models`
- Writing pass/fail tests -> use `testing-simulink-models`

## Probe

```matlab
hasFA = ~isempty(which('Simulink.fault.addFault'));
fprintf('Simulink Fault Analyzer available: %d\n', hasFA);
```

## Key Concepts

- **Fault**: A modification applied to a block port (inport or outport) that overrides the signal value.
- **Fault without Behavior**: A placeholder that documents a failure point but cannot be simulated.
- **Fault with Behavior**: A fault with an associated behavior model that can be simulated (see `references/fault-behaviors.md`).
- **Fault Model**: The `.slx` file containing fault behavior subsystem(s).
- **Trigger**: When the fault activates (Always On, Timed, Conditional, Manual).
- **Fault Info File**: `<ModelName>_faultInfo.xml` stores all fault metadata alongside the model.

## Critical Constraints

1. **Faults attach to block PORTS, not blocks.** You must get the port handle via `get_param(blockPath, 'PortHandles')`.
2. **NEVER directly edit `_faultInfo.xml` files.** Always use MATLAB APIs to modify fault definitions.
3. **Fault names must be valid MATLAB identifiers** (no spaces, slashes, or special characters). Use camelCase or PascalCase.
4. **The fault behavior model name (first arg to `addBehavior`) must also be a valid MATLAB identifier.**
5. **NEVER use `Simulink.fault.deleteAll` or `Simulink.fault.deleteFault` to toggle faults on/off for simulation.** Deleting faults destroys fault objects, their behavior models (.slx files), and their traceability links permanently. Use `Simulink.fault.injection(model, false)` to disable ALL fault injection for a nominal run, and `Simulink.fault.injection(model, true)` to re-enable. Use `Simulink.fault.enable(modelElement, false)` to disable faults on specific elements.
6. **Not supported:** Faults inside Stateflow charts, fault models, or observer models.

## Workflow

1. **Understand the model.** Use `model_overview` and `model_read` to identify fragile signal paths -- single-point actuators, sensor feedback, computed quantities with wide fan-out.
2. **Pre-flight check.** Query compiled port properties to confirm signal compatibility. If the model is not already compiled, ask the user before compiling. See `references/preflight-and-adding-faults.md`.
3. **Get port handles.** Faults attach to port handles, not block paths. Use `get_param(blk, 'PortHandles')`.
4. **Add fault.** Call `Simulink.fault.addFault(portHandle, Name=..., Description=...)`. See `references/preflight-and-adding-faults.md`.
5. **Add behavior.** Call `addBehavior(fault, modelName, FaultBehavior='mwfaultlib/...')`. See `references/fault-behaviors.md`.
6. **Configure trigger.** Set `fault.TriggerType` and the corresponding properties (e.g., `StartTime` for Timed, `Conditional` for Conditional, `TriggerActive` for Manual). See `references/triggers-and-conditionals.md`.
7. **Save.** Call `Simulink.fault.save('ModelName')`.
8. **Simulate.** Enable injection with `Simulink.fault.injection(mdl, true)` then `sim(...)`. See `references/simulation-workflows.md`.

## Guardrails

### Always
- Use `model_read` to identify target blocks before injecting faults
- Check compiled port info before creating faults (see `references/preflight-and-adding-faults.md`)
- Add behavior BEFORE setting trigger properties
- Save with `Simulink.fault.save('ModelName')` after any fault changes
- Verify fault is active before running faulted simulation with `activate(fault)`
- Disable fault injection after analysis with `Simulink.fault.injection(mdl, false)`
- Verify test input signals are non-zero at fault injection points
- Check bus compatibility before choosing a `mwfaultlib` behavior

### Never
- Use the `Simulink.fault.Fault()` constructor -- use `Simulink.fault.addFault()` instead
- Pass library block paths (e.g., `mwfaultlib/Stuck-at-Ground`) as the fault model name argument to `addBehavior` -- use the `FaultBehavior` name-value pair
- Assume fault simulation is off -- verify before each nominal run
- Violate any item in the Critical Constraints section

### Ask First
- Before modifying the design model for any reason (adding blocks, changing sample times, reconnecting signals)
- Before enabling faults on a model that may be shared (it modifies model behavior)
- Before deleting existing faults (the behavior model .slx is also deleted)
- Before enabling `fault.Persistent = true` -- it makes the fault irreversible during simulation

## Troubleshooting

| Issue | Cause | Fix |
|-------|-------|-----|
| `Assertion failed` in `Simulink.fault.Fault()` | Do not use the `Fault()` constructor directly | Use `Simulink.fault.addFault(portHandle, Name=..., Description=...)` instead |
| `Fault name must follow MATLAB variable naming conventions` | Name contains spaces or special chars | Use camelCase/PascalCase with no spaces (e.g., `SensorStuckAtZero`) |
| `Invalid name for a fault model` | Behavior model name has invalid characters | Use a simple MATLAB identifier (e.g., `StuckAtZero`, not `Stuck-at-Zero`) |
| `Unable to add fault... only to block input or output ports` | Passed a block path/handle instead of port handle | Use `ph = get_param(blockPath, 'PortHandles'); ph.Outport(1)` |
| `Target signal is a continuous-time signal` | Fault Analyzer cannot inject on continuous signals going to continuous blocks | See Continuous-Time Signal Decision Tree in `references/advanced-operations.md` |
| `Output dimensions do not match` or `Data type mismatch` | Fault constant size/type ≠ target signal | See "Vector and Matrix Fault Values" in `references/fault-behaviors.md` |
| Bus signal fault fails with non-Ground behavior | Most `mwfaultlib` behaviors are scalar-only | Use `Stuck-at-Ground` for full bus, or use `BusElement` to target individual elements |
| Multiple faults on same port but only one fires | Only one fault per port is active at a time | Use `activate(fault)` to select, or use different `StartTime` values |
| Fault exists but simulation runs nominally | Fault injection not enabled or fault not active | Call `Simulink.fault.injection('Model', true)` and `activate(f)` |

## Reference Files

| File | Contents |
|------|----------|
| `references/preflight-and-adding-faults.md` | Port inspection, compile checks, adding faults, port handle resolution, fault object properties/methods |
| `references/fault-behaviors.md` | Built-in behaviors, custom behaviors, bus faults, vector/matrix faults, discovery, data inport source |
| `references/triggers-and-conditionals.md` | Trigger types, conditional creation, conditional/symbol object properties |
| `references/simulation-workflows.md` | Running simulations, nominal vs. faulted comparison, selective fault isolation |
| `references/advanced-operations.md` | FMEA linking, reports, export, deletion, continuous-time workarounds, synchronizing faults from referenced models/subsystems/libraries |
| `references/test-case-integration.md` | Adding fault sets to Simulink Test cases (R2024a+) |

----

Copyright 2026 The MathWorks, Inc.

----

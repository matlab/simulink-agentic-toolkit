# Fault Behaviors

A fault without behavior is a documentation-only placeholder -- it cannot be simulated. To make a fault simulatable, you must add behavior. The behavior is a separate subsystem (stored as its own `.slx` file) with a `Fault Inport` (original signal) and a `Fault Outport` (faulted signal). Any Simulink logic can be placed between them.

The second argument to `addBehavior` is a **fault model name** -- a new `.slx` file gets created to hold the behavior logic.

```matlab
addBehavior(fault, 'faultModelName', FaultBehavior='mwfaultlib/Stuck-at-Constant');
```

| `addBehavior` Parameter | Kind | Description |
|-----------|------|-------------|
| `faultModelName` | required | Name for the generated fault model (valid MATLAB identifier) |
| `FaultBehavior` | name-value | Library block path (e.g., `'mwfaultlib/Stuck-at-Ground'`) |
| `FaultModelDir` | name-value | Directory to save the fault model .slx file |
| `BusElement` | name-value | Dot-notation path to fault a specific bus element |

**Requirements for the fault model name:**
- Must be a valid MATLAB identifier (letters, digits, underscore only)
- No spaces, hyphens, or special characters
- **Use a single shared fault model** (e.g., `[mdl '_faults']`) for all faults in an analysis. Before creating a new fault model, check if one already exists with `Simulink.fault.getFaultModels(mdl)` and reuse it. Only create separate fault models if the user explicitly requests it.

## Built-in Behaviors (`mwfaultlib`)

See the Discovery section below for listing available behaviors and registered libraries.

| Library Block | Signal Transformation | Parameters | Typical Use Case |
|---------------|----------------------|------------|------------------|
| `mwfaultlib/Stuck-at-Constant` | `y = C` (constant) | Constant value (default: 0) | Sensor jam, actuator stuck |
| `mwfaultlib/Stuck-at-Ground` | `y = 0` | None | Total signal loss, wire break |
| `mwfaultlib/Add Noise` | `y = u + noise` | Noise power, sample time | EMI, sensor degradation |
| `mwfaultlib/Gain` | `y = K * u` | Gain value (default: 2) | Calibration error, scaling fault |
| `mwfaultlib/Offset-by-1` | `y = u + 1` | Bias value (default: 1) | Sensor bias, drift approximation |
| `mwfaultlib/Negate Value` | `y = -u` | None | Wiring reversal, sign convention error |
| `mwfaultlib/Absolute Value` | `y = |u|` | None | Rectification fault |
| `mwfaultlib/Unit Delay` | `y = u(t - Ts)` | Sample time | Communication latency |

## Bus Compatibility

Only `mwfaultlib/Stuck-at-Ground` is bus-compatible (forces all elements to zero). All other `mwfaultlib` behaviors are scalar-only and will fail on bus signals. For non-ground faults on buses, use the `BusElement` name-value pair to target a specific element:

```matlab
addBehavior(fault, 'busFaultMdl', ...
    FaultBehavior='mwfaultlib/Stuck-at-Constant', ...
    BusElement='Sensors.Altitude');
```

Alternatively, create a custom fault behavior model that handles the full bus structure.

## Custom Behavior (Preferred for Non-Trivial Faults)

For anything beyond simple stuck/noise/gain faults, **prefer custom behaviors** over `mwfaultlib` blocks. Custom behaviors let you model any behavior.

**Critical:** All blocks inside the fault model must use inherited sample time (`SampleTime = '-1'`). The fault model inherits its sample time from the faulted port. Discrete-Time Integrator blocks require `IntegratorMethod` set to an Accumulation mode (e.g., `'Accumulation: Forward Euler'`) because the fault subsystem receives a triggered sample time.

**Programmatic construction (preferred):** The fault model contains a subsystem named after the fault. Inside that subsystem, `Fault Inport` provides the original signal and `Fault Outport` receives the faulted signal. An empty behavior has no connections — add blocks and wire them:

```matlab
addBehavior(fault, 'sensorDriftFault');
faultSubsys = getBehavior(fault);
```

Then use `model_edit` on the fault subsystem to build custom logic:
```
model_edit: delete connection In/1 -> Out/1
model_edit: add_block 'simulink/Math Operations/Add' as 'Add'
model_edit: add_block 'simulink/Sources/Ramp' as 'Drift'
model_edit: configure 'Drift' Slope='0.01' StartTime='0'
model_edit: connect In/1 -> Add/1, Drift/1 -> Add/2, Add/1 -> Out/1
```

Finally save the fault model:
```matlab
faultMdl = getFaultModel(fault);
save_system(faultMdl);
```

The same pattern applies to any custom fault: use `getBehavior(fault)` to get the subsystem path, then `add_block` your logic and `add_line` to connect `Fault Inport` and `Fault Outport`. Avoid Source blocks (like Ramp) that have internal fixed sample times — prefer Constant + Discrete-Time Integrator with Accumulation mode.

## Discovery

```matlab
libs   = Simulink.fault.libraries                  % list registered fault libraries
libs   = Simulink.fault.libraries(newLibrary)      % register a new fault library
Simulink.fault.unregisterLibrary(lib)              % unregister a fault library
blocks = Simulink.fault.libraryBlocks              % list available fault behavior blocks
```

## Data Inport Source

Gets or sets the data source for a fault data inport block inside a fault behavior model:

```matlab
sourcePath = Simulink.fault.dataInportSource(blockPath)           % get current source
sourcePath = Simulink.fault.dataInportSource(blockPath, source)   % set source
```

The `blockPath` must point to a fault data inport block inside a fault behavior model.

## Custom Fault Libraries

Library blocks must use `FaultInport` and `FaultOutport` block types (not standard `Inport`/`Outport`). Inspect an existing `mwfaultlib` block to see the required structure:

```text
model_read on mwfaultlib/Gain
% Shows: FaultInport → logic → FaultOutport
```

To create a custom fault library block programmatically:

```matlab
libName = 'myCustomFaultLib';
new_system(libName, 'Library');
save_system(libName);
```

Then use `model_edit` to build the library structure. The `mwfaultblocklib/Fault Subsystem` template includes `FaultInport`/`FaultOutport` blocks — standard `Inport`/`Outport` will not work:

```
model_edit on myCustomFaultLib:
  add_block 'mwfaultblocklib/Fault Subsystem' as 'MyBehavior'

model_edit on myCustomFaultLib/MyBehavior:
  add_block 'simulink/Discontinuities/Saturation' as 'Saturate'
  configure 'Saturate' UpperLimit='10' LowerLimit='-inf'
  connect 'Fault Inport'/1 -> Saturate/1, Saturate/1 -> 'Fault Outport'/1
```

Then register the library:
```matlab
save_system(libName);
Simulink.fault.libraries(libName);
```

## Saving Fault Models to a Custom Directory

By default, fault model `.slx` files are saved alongside the main model. Use `FaultModelDir` to specify a different location:

```matlab
addBehavior(fault, 'myFault', ...
    FaultBehavior='mwfaultlib/Gain', ...
    FaultModelDir='C:/project/faultModels');
```

## Modifying Behavior Parameters

After adding behavior, navigate into the fault subsystem (named after the fault) to adjust parameters:

```matlab
addBehavior(fault, 'myFaultMdl', FaultBehavior='mwfaultlib/Gain');
faultMdlName = getFaultModel(fault);
```

```
model_edit on <faultMdlName>/<faultName>:
  configure 'Gain' Gain='1.5'
```

```matlab
save_system(faultMdlName);
```

## Vector and Matrix Fault Values

When faulting signals with width > 1 (vectors or matrices), the fault behavior parameters must match the signal dimensions and data type. Use the pre-flight check (see `preflight-and-adding-faults.md`) to determine the required width and type.

**Setting multi-element constants (Stuck-at-Constant):**

```matlab
ph = get_param(blk, 'PortHandles');
fault = Simulink.fault.addFault(ph.Outport(1), Name='ArrayStuck');
addBehavior(fault, 'arrayFaultMdl', FaultBehavior='mwfaultlib/Stuck-at-Constant');
faultMdl = getFaultModel(fault);
```

Then use `model_edit` to set the constant value to match the 3-element vector:
```
model_edit on <faultMdl>/<faultName>:
  configure 'Constant' Value='[0 0 0]'
```

```matlab
save_system(faultMdl);
```

**Matching data types with `OutDataTypeStr`:**

```text
model_edit on <faultMdl>/<faultName>:
  % For a boolean signal
  configure 'Constant' Value='true' OutDataTypeStr='boolean'

  % For a single-precision 4-element vector
  configure 'Constant' Value='[0 0 0 0]' OutDataTypeStr='single'

  % For an int16 signal
  configure 'Constant' Value='int16(100)' OutDataTypeStr='int16'

  % For a fixdt type (common in production code)
  configure 'Constant' Value='0.5' OutDataTypeStr='fixdt(1,16,12)'

save_system(faultMdl);
```

**Common dimension/type mismatch errors and fixes:**

| Error | Cause | Fix |
|-------|-------|-----|
| `Output dimensions do not match` | Constant value size ≠ signal width | Set `Value` to array matching `CompiledPortWidths` |
| `Data type mismatch` | Constant type ≠ signal type | Set `OutDataTypeStr` to match `CompiledPortDataTypes` |
| `Invalid setting for parameter 'Value'` | Type literal syntax wrong | Use MATLAB cast syntax: `'int16(0)'`, `'single([1 2 3])'` |

----

Copyright 2026 The MathWorks, Inc.

----

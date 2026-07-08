# Pre-Flight Check and Adding Faults

## Pre-Flight Check: Compile and Inspect Ports

Before creating faults, inspect the target port's compiled properties (data type, width, sample time). This prevents failures from type mismatches, unsupported continuous signals, or incorrect vector dimensions.

**First, check if the model is already compiled.** If compiled port data is available, use it directly. If not, ask the user before compiling -- compilation can take a long time on large models. Do not compile automatically.

Use `model_query_params` to retrieve compiled port properties:

```
model_query_params on MyModel/Sensors/Altimeter:
  CompiledPortDataTypes
  CompiledPortWidths
  CompiledSampleTime
```

If the model is not yet compiled, ask the user before compiling (compilation can take a long time on large models):

```
model_edit on MyModel:
  update_diagram
```

Then re-query the compiled properties.

**What to check before adding a fault:**

| Property | How to Query | What to Verify |
|----------|-------------|----------------|
| Data type | `cpdt.Outport{idx}` | Fault constant must match (e.g., `'boolean'`, `'single'`, `'int16'`) |
| Width | `cpw.Outport(idx)` | Multi-element faults must match vector/matrix dimensions |
| Sample time | `get_param(blk, 'CompiledSampleTime')` | `[0, 0]` = continuous -- requires discrete workaround (see Known Limitations in skill.md) |

**If sample time is `[0, 0]` (continuous):** The signal cannot be faulted directly. See the "Continuous-Time Signal Decision Tree" in `advanced-operations.md`.

## Adding Faults

Faults attach to **block port handles** (inport or outport), not block path strings. This works in Simulink and System Composer models.

**Inport vs. Outport:** Choose based on where the corruption logically occurs. Use outport faults to model a component producing incorrect output (e.g., sensor failure). Use inport faults to model corruption in the path to a component (e.g., wiring fault, bus corruption before the controller).

## Port Handle Resolution

Always resolve port handles from block paths using `get_param`:

```matlab
blkPath = 'Model/Subsystem/Block';
ph = get_param(blkPath, 'PortHandles');

% Available port types:
ph.Inport    % array of input port handles
ph.Outport   % array of output port handles
ph.Enable    % enable port handle (if exists)
ph.Trigger   % trigger port handle (if exists)
ph.State     % state port handle (if exists)
ph.LConn    % left physical connection ports (Simscape)
ph.RConn    % right physical connection ports (Simscape)
```

For blocks with multiple outputs, index the specific port:
```matlab
ph.Outport(1)  % first output
ph.Outport(4)  % fourth output
```

## Fault Object Properties and Methods

The `Simulink.fault.Fault` object returned by `addFault`:

| Property | Access | Type | Description |
|----------|--------|------|-------------|
| `Name` | Read/Write | string | Fault name (valid MATLAB identifier) |
| `Description` | Read/Write | string | Human-readable description |
| `ModelElement` | Read-only | char | Path of faulted port (e.g., `Model/Block/Outport/1`) |
| `Type` | Read-only | string | `'Simulink'`, `'Simscape'`, or `'System Composer'` |
| `IsActive` | Read-only | logical | Whether this fault is the active one on its port |
| `HasBehavior` | Read-only | logical | Whether behavior has been added |
| `TriggerType` | Read/Write | string | `"Always On"` \| `"Timed"` \| `"Conditional"` \| `"Manual"` \| `"Behavioral"` |
| `Persistent` | Read/Write | logical | Whether trigger is irreversible once activated |
| `StartTime` | Read/Write | double | Trigger time (only for `"Timed"` type) |
| `Conditional` | Read/Write | Conditional | Conditional object (only for `"Conditional"` type) |

Dynamic properties added based on trigger type:

| Property | Type | Description |
|----------|------|-------------|
| `TriggerActive` | logical | Manual trigger state (available when `TriggerType = "Manual"`) |
| `IsTriggered` | logical | Whether fault is currently triggered during simulation |

Methods:

```matlab
activate(fault)                % set as active fault on port
addBehavior(fault, faultModelName)                          % add empty behavior model
addBehavior(fault, faultModelName, FaultBehavior=libBlock)  % with library behavior
addBehavior(fault, faultModelName, FaultBehavior=libBlock, BusElement=elem)  % bus-specific
addBehavior(fault, faultModelName, FaultModelDir=dir)       % custom save location
deleteBehavior(fault)          % remove behavior model
getBehavior(fault)             % get fault subsystem block path (char)
openBehavior(fault)            % open fault model in Simulink
getFaultModel(fault)           % get fault model name (char)
getAssociatedModel(fault)      % get name of source model (char)
getFaultInfoFile(fault)        % get _faultInfo.xml file path (char)
```

See `fault-behaviors.md` for `addBehavior` parameter details and behavior construction.

### Adding Multiple Faults

```matlab
blocks = {[mdl '/Sensor/Alt'], [mdl '/Sensor/CAS'], [mdl '/Actuator/Elev']};
names  = {'AltStuck', 'CASNoise', 'ElevJam'};
behaviors = {'mwfaultlib/Stuck-at-Ground', 'mwfaultlib/Add Noise', 'mwfaultlib/Stuck-at-Constant'};

existingModels = Simulink.fault.getFaultModels(mdl);
if isempty(existingModels)
    faultModelName = [mdl '_faults'];
else
    faultModelName = existingModels{1};
end

for i = 1:numel(blocks)
    ph = get_param(blocks{i}, 'PortHandles');
    f = Simulink.fault.addFault(ph.Outport(1), Name=names{i});
    addBehavior(f, faultModelName, FaultBehavior=behaviors{i});
end
Simulink.fault.save(mdl);
```

----

Copyright 2026 The MathWorks, Inc.

----

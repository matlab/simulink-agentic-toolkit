# Triggers and Conditionals

## Trigger Configuration

**Important:** Add behavior BEFORE setting trigger properties. Setting trigger on a fault without behavior will error.

```matlab
% Always-on -- fault active for entire simulation (default)
fault.TriggerType = "Always On";

% Timed -- fault activates at specified simulation time
fault.TriggerType = "Timed";
fault.StartTime = 10;  % seconds

% Conditional -- fault activates when model condition is met
cond = Simulink.fault.addConditional('Model', 'overspeed', 'airspeed > 100');
fault.TriggerType = "Conditional";
fault.Conditional = cond;
% Then resolve the symbol to a model signal:
sym = getSymbols(cond, 'airspeed');
sym.Type = 'Model Element';
sym.Path = 'Model/Sensors/Airspeed/Outport/1';

% Manual -- controlled programmatically during simulation
fault.TriggerType = "Manual";
fault.TriggerActive = true;

% Persistent -- once triggered, stays active (cannot self-clear)
fault.Persistent = true;
```

### Trigger Types

| Type | Activation | Use Case |
|------|-----------|----------|
| `"Always On"` | Entire simulation | Permanent hardware failure |
| `"Timed"` | At `StartTime` seconds | Time-correlated failure analysis |
| `"Conditional"` | When expression becomes true | State-dependent faults |
| `"Manual"` | Via `TriggerActive` property | Interactive or scripted control |
| `"Behavioral"` | Determined by fault model logic | Complex trigger patterns |

## Conditionals

Reusable trigger conditions that can be shared across multiple faults.

```matlab
% Create (use symbolic names in the expression, then resolve via Path)
cond = Simulink.fault.addConditional('Model', 'highAlt', 'altitude > 5000');

% Enable activity logging for debugging
cond.LogActivity = true;

% Assign to fault
fault.TriggerType = "Conditional";
fault.Conditional = cond;

% Find all conditionals
conds = Simulink.fault.findConditionals('Model');

% Query which faults a conditional triggers
triggeredFaults = cond.getTriggeredFaults();

% Inspect symbols (signal references) in the condition expression
symbols = getSymbols(cond);            % all symbols
sym = getSymbols(cond, 'altitude');    % specific symbol by name
sym.Type = 'Model Element';           % must set before Path is accessible
sym.Path = 'Model/Navigation/Altitude/Outport/1';  % resolve to model element

% Delete
Simulink.fault.deleteConditional('Model', 'highAlt');
```

## Conditional Object (`Simulink.fault.Conditional`)

| Property | Access | Type | Description |
|----------|--------|------|-------------|
| `Name` | Read/Write | string | Conditional name (valid MATLAB identifier) |
| `Condition` | Read/Write | string | Condition expression (references symbols resolved via `getSymbols`) |
| `LogActivity` | Read/Write | logical | Whether to log conditional activation during simulation |

Methods:

```matlab
faults    = getTriggeredFaults(cond)               % get Fault array triggered by this conditional
symbols   = getSymbols(cond)                       % get all Symbol objects in the condition
symbols   = getSymbols(cond, name)                 % get a specific Symbol by name
modelName = getAssociatedModel(cond)               % get name of associated model (char)
```

## Symbol Object (`Simulink.fault.Symbol`)

Represents a signal reference used within a conditional expression. Each symbol maps a name in the condition expression to a model element path.

| Property | Access | Type | Description |
|----------|--------|------|-------------|
| `Name` | Read-only | string | Symbol name as it appears in the condition expression |
| `Type` | Read/Write | string | Must set to `'Model Element'` before `Path` is accessible |
| `Expression` | Read/Write | string | The expression or signal name this symbol represents |
| `Path` | Read/Write | char | Model element path that resolves this symbol (e.g., `'Model/Block/Outport/1'`) |

----

Copyright 2026 The MathWorks, Inc.

----

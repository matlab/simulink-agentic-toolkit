# Simulation Workflows

## Querying Faults

```matlab
% Find all faults in model
faults = Simulink.fault.findFaults('Model');

% Filter by property
faults = Simulink.fault.findFaults('Model', Name='SensorStuck');
faults = Simulink.fault.findFaults('Model', TriggerType="Timed");

% Get all faulted element paths
elements = Simulink.fault.findFaultedElements('Model');

% Get only enabled elements
elements = Simulink.fault.findFaultedElements('Model', Enabled=true);

% List all fault model names (.slx files)
faultModels = Simulink.fault.getFaultModels('Model');
```

## Enabling, Disabling, and Activating

```matlab
% Enable/disable fault injection for the entire model (master switch)
oldValue = Simulink.fault.injection('Model', true);   % enable, returns previous state
oldValue = Simulink.fault.injection('Model', false);  % disable, returns previous state
currentState = Simulink.fault.injection('Model');     % query without changing

% Enable/disable faults on a specific model element (per-fault control)
Simulink.fault.enable('Model/Block/Outport/1', true);   % enable fault on this element
Simulink.fault.enable('Model/Block/Outport/1', false);  % disable fault on this element

% Check if a specific element's fault is enabled
isOn = Simulink.fault.isEnabled('Model/Block/Outport/1');

% Activate a specific fault (when multiple faults exist on same port)
activate(fault);
```

**Note:** `Simulink.fault.injection` returns the previous injection state as a logical, useful for restoring state after a temporary change. `Simulink.fault.enable` takes a model element path (get it from `fault.ModelElement`), not the model name — passing the model name will error.

## Running Fault Simulation

```matlab
mdl = 'MyModel';

% Enable fault injection
Simulink.fault.injection(mdl, true);

% Simulate
in = Simulink.SimulationInput(mdl);
in = in.setModelParameter('StopTime', '30');
out = sim(in);

% Analyze
plot(out.logsout.get('altitude').Values);

% Disable when done
Simulink.fault.injection(mdl, false);
```

### Verify Test Scenario Excites the Fault

**Before running fault simulations, verify that the nominal input signals at the fault injection point are non-zero (or non-trivial).** A stuck-at-zero fault has no observable effect if the nominal signal is already zero. For example, if you inject a "stuck at ground" fault on a yaw rate sensor but your test scenario has the vehicle driving straight (yaw rate = 0), the fault produces identical results to nominal.

Always check:
1. What is the nominal value of the signal at the fault point during the test scenario?
2. Does the fault behavior produce a meaningfully different signal from nominal?
3. Does the test scenario exercise the downstream logic that would reveal the fault's effect?

### Comparing Nominal vs. Faulted

```matlab
mdl = 'MyModel';

% Nominal run (fault injection OFF)
Simulink.fault.injection(mdl, false);
outNom = sim(Simulink.SimulationInput(mdl));

% Faulted run (fault injection ON)
Simulink.fault.injection(mdl, true);
outFault = sim(Simulink.SimulationInput(mdl));

% Compare
figure;
plot(outNom.logsout.get('alt').Values, 'b'); hold on;
plot(outFault.logsout.get('alt').Values, 'r--');
legend('Nominal', 'Faulted'); title('Altitude Response');

% Disable injection when done
Simulink.fault.injection(mdl, false);
```

### CRITICAL: Never Delete Faults to Run Nominal Simulations

Use `Simulink.fault.injection(model, false)` to disable injection without deleting anything. See Critical Constraint #6 in `skill.md` for details on what deletion destroys.

### Selective Fault Simulation (Multiple Faults Exist)

**IMPORTANT:** `activate()` only selects among multiple faults on the **same port**. When faults exist on **different ports**, enabling fault injection activates ALL of them simultaneously (if their TriggerType is "Always On"). This is a common pitfall when validating individual FMEA failure modes.

**To isolate a single fault when multiple faults exist on different ports**, use `Simulink.fault.enable` with the specific model element path to disable/enable faults per-element:

```matlab
modelName = 'MyModel';
allFaults = Simulink.fault.findFaults(modelName);

% Disable all faulted elements
for i = 1:numel(allFaults)
    Simulink.fault.enable(allFaults(i).ModelElement, false);
end

% Enable only the fault under test
Simulink.fault.enable(allFaults(2).ModelElement, true);

% Run with injection on
Simulink.fault.injection(modelName, true);
in = Simulink.SimulationInput(modelName);
simOut = sim(in);

% Disable injection when done
Simulink.fault.injection(modelName, false);
```

**For same-port selection** (multiple faults on one port), use `activate()`:

```matlab
activate(allFaults(2));  % only relevant when multiple faults share a port
```

## Multiple Faults on the Same Port

Only one fault per port is active in a single simulation run (selected via `activate()`). To simulate a fault *sequence* (drift then failure), create a custom behavior model that implements the combined logic, or run separate simulations for each fault.

----

Copyright 2026 The MathWorks, Inc.

----

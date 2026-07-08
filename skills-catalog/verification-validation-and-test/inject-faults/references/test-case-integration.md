# Adding Faults to Simulink Test Cases (R2024a+)

Simulink Test Manager test cases can specify which faults are active during simulation via **Fault Sets**. When the test runs, the fault set handles enabling fault injection and activating the specified faults automatically — no manual `Simulink.fault.injection` or `Simulink.fault.enable` calls needed.

## Refreshing Faults

Before adding faults to test cases, call `refreshFaults` so Test Manager can see them:

```matlab
sltest.testmanager.refreshFaults('ModelName');
```

Required when faults were added or modified after fault sets were created. Safe to call unconditionally before `addSpecifiedFault`. Without it, `addSpecifiedFault` will error with "Unable to add specified fault ... fault is not defined on model element."

## Adding a Fault Set to a Test Case

```matlab
% Add a fault set (container for one or more faults)
fs = addFaultSet(tc, Name='HydraulicFaults');

% Add a specific fault to the set
fault = Simulink.fault.findFaults('MyModel', Name='HydPressureLoss');
addSpecifiedFault(fs, fault.ModelElement, 'HydPressureLoss');
```

The `modelElement` argument is the port path string (e.g., `'MyModel/Subsystem/Block/Outport/1'`). Get it from `fault.ModelElement`.

## Multiple Faults in One Test Case

Add multiple faults to a single fault set for simultaneous activation:

```matlab
fs = addFaultSet(tc, Name='DualChannelFailure');
f1 = Simulink.fault.findFaults('Model', Name='ChannelAFault');
f2 = Simulink.fault.findFaults('Model', Name='ChannelBFault');
addSpecifiedFault(fs, f1.ModelElement, 'ChannelAFault');
addSpecifiedFault(fs, f2.ModelElement, 'ChannelBFault');
```

## Fault Set and Specified Fault Properties

```matlab
% Fault set - enable/disable the entire set
fs.Active = true;       % default: true
fs.Name = 'MyFaults';

% Specified fault - control individual faults within the set
sf.IsActive = true;     % enable/disable this fault (default: true)
sf.FaultName           % read-only: fault name
sf.ModelElement        % read-only: port path
sf.Trigger             % trigger override for this test
```

## Querying and Removing

```matlab
faultSets = getFaultSets(tc);              % all fault sets on a test case
specFaults = getSpecifiedFaults(fs);       % all faults in a fault set
remove(fs);                                % remove fault set from test case
remove(sf);                                % remove fault from fault set
```

## Equivalence Tests

For back-to-back equivalence tests, specify which simulation gets the faults:

```matlab
fs = addFaultSet(tc, Name='FaultedSim', SimulationIndex=2);
```

`SimulationIndex=1` (default) injects in simulation 1; `SimulationIndex=2` injects in simulation 2.

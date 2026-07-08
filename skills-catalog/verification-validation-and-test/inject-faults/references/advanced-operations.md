# Advanced Operations

## Linking Faults to FMEA

Connect faults to Safety Analysis Manager spreadsheets via Requirements Toolbox for traceability. **Always link to the fault object, not the block path.** `slreq.createLink` accepts `Simulink.fault.Fault` objects directly — this creates a traceable link to the specific fault definition, not just the block it lives on.

```matlab
% Open the FMEA document
fmea = safetyAnalysisMgr.openDocument('MyModel_FMEA.mldatx');

% Get the FMEA row and the fault object
row = getRow(fmea, 1);
fault = Simulink.fault.findFaults('MyModel', Name='SensorStuck');

% Create traceability link from FMEA row to the FAULT (not the block)
link = slreq.createLink(row, fault);

% Save
save(fmea);
```

## Generating Reports

Generate a fault specification report documenting all faults in a model:

```matlab
status = Simulink.fault.report('Model')
status = Simulink.fault.report('Model', Name=Value)
```

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `Title` | char/string | `''` | Report title |
| `Author` | char/string | `''` | Report author |
| `FileType` | char/string | `'pdf'` | Output format (`'pdf'`, `'docx'`, `'htmx'`) |
| `FileName` | char/string | `'faultSpecReport'` | Output filename (without extension) |
| `IncludeFaultDetails` | logical | `true` | Include fault property details |
| `IncludeBehaviorDetails` | logical | `true` | Include behavior model details |
| `IncludeConditionalDetails` | logical | `true` | Include conditional trigger details |
| `IncludeLinkDetails` | logical | `true` | Include traceability link details |
| `IncludeFaultTable` | logical | `true` | Include summary fault table |
| `OpenAfterCreate` | logical | `false` | Open report after generation |

## Exporting Embedded Fault Model

Export a standalone model with fault behavior embedded directly (no Simulink Fault Analyzer required to simulate):

```matlab
newModelH = Simulink.fault.exportEmbeddedModel(model, newModel, saveFolder)
newModelH = Simulink.fault.exportEmbeddedModel(model, newModel, saveFolder, Name=Value)
```

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `model` | char/string/handle | required | Source model with faults |
| `newModel` | char/string | required | Name for exported model (valid MATLAB identifier) |
| `saveFolder` | char/string | required | Directory to save the exported model |
| `Overwrite` | logical | `false` | Overwrite existing model in saveFolder |
| `VariantSubsystems` | logical | `true` | Use variant subsystems for fault/nominal switching |
| `IncludeConditionals` | logical | `true` | Include conditional trigger logic in export |

The exported model uses variant subsystems to switch between nominal and faulted behavior. Useful for sharing with teams that don't have Simulink Fault Analyzer.

## Synchronizing Fault Information from Referenced Models

Also referred to as: **sync**, **resync**, **synchronize faults**, **update fault references**.

When a parent model references other models (model references, subsystem references, or linked library blocks) that have faults attached, call:

```matlab
Simulink.fault.updateReferences('model');
```

This synchronizes the fault information files used by the parent model by **copying the faults and their properties from referenced models, subsystems, or library blocks into the specified model**. After synchronization, the parent model has its own copy of the faults — modifying faults in the parent does *not* affect the faults defined in the referenced models, subsystems, or library blocks.

| Parameter | Type | Description |
|----------|------|-------------|
| `model` | string \| char \| handle | Path or handle to the parent model whose fault info file should be synchronized |

When to call this:
- After adding, modifying, or removing faults in a referenced model, subsystem, or library, to propagate the changes into the parent model's fault info file
- After opening a parent model that has a referenced model, subsystem, or library blocks with faults, before simulating or inspecting faults at the parent level

Subsystem and library sync support introduced in R2026a.

## Deleting Faults

```matlab
% Delete all faults on a port
Simulink.fault.deleteFault(ph.Outport(1));

% Delete a specific named fault on a port
Simulink.fault.deleteFault(ph.Outport(1), 'SensorStuck');

% Delete ALL faults and conditionals in model
Simulink.fault.deleteAll('Model');

% Delete only faults (keep conditionals)
Simulink.fault.deleteAll('Model', Conditionals=false);

% Save after deletion
Simulink.fault.save('Model');
```

Note: Deleting a fault also deletes its associated fault model `.slx` file.

## Identifying Fragile Signal Paths

When deciding where to inject faults, prioritize:

1. **Single-point actuator outputs** -- no redundancy means one fault causes total loss of authority
2. **Sensor feedback signals** -- altitude, airspeed, attitude sensors in closed-loop controllers
3. **Computed quantities with wide fan-out** -- Mach, dynamic pressure, AoA used by many blocks
4. **Cross-domain interfaces** -- environment-to-plant, sensor-to-avionics bus boundaries
5. **Rate-limited or saturated signals** -- already operating near limits, faults push past bounds
6. **Single-source bus elements** -- one corrupt element propagates through entire bus hierarchy

## Continuous-Time Signal Decision Tree

Fault Analyzer cannot inject faults on continuous-time signals whose destinations are also continuous. You will get:

```
Target signal is a continuous-time signal. Continuous-time signals
support faults only if their destinations are discrete.
```

**IMPORTANT: Never modify the design model without explicit user permission.** The strategies below that involve changing the model (steps 3-4) require asking the user first.

**Resolution strategy -- follow this decision tree:**

1. **Walk downstream to find the nearest discrete boundary.** Look for Rate Transition blocks, Zero-Order Hold (ZOH) blocks, Stateflow chart inputs, or Model Reference blocks with a discrete solver. Inject the fault at the *input* of that discrete boundary instead -- this requires no model changes:
   ```matlab
   % Instead of faulting the continuous source, fault the ZOH input
   ph = get_param([mdl '/ZOH_Sensor'], 'PortHandles');
   fault = Simulink.fault.addFault(ph.Inport(1), Name='SensorStuck');
   ```

2. **Walk upstream to find the nearest discrete source.** If the continuous signal originates from a discrete subsystem output passed through continuous integrators, inject at the discrete subsystem's outport before it enters the continuous domain. No model changes needed.

3. **Ask the user: set a discrete sample time on the target block.** If the block has a `SampleTime` parameter and making it discrete is physically appropriate (e.g., a sensor model that should be sampled), propose this to the user:
   ```
   model_edit on MyModel:
     configure 'Subsystem/SensorBlock' SampleTime='0.001'
   ```

4. **Ask the user: insert a Rate Transition or ZOH as a fault injection point.** If no suitable discrete boundary exists, propose adding a Zero-Order Hold block to create one. Use `model_edit` to add the block, set its sample time, and reconnect signals:
   ```
   model_edit: add_block 'simulink/Discrete/Zero-Order Hold' as 'FaultZOH'
   model_edit: configure 'FaultZOH' SampleTime='0.001'
   model_edit: connect <upstream>/1 -> FaultZOH/1, FaultZOH/1 -> <downstream>/1
   ```
   Then fault the ZOH output port.

**Key insight:** Always prefer relocating the fault to an existing discrete boundary (steps 1-2) over modifying the design model (steps 3-4).

## Files Created

| File | Purpose |
|------|---------|
| `<ModelName>_faultInfo.xml` | Fault metadata (triggers, names, port mappings) |
| `<FaultModelName>.slx` | Fault behavior model (auto-generated) |

Both files are stored alongside the main model `.slx` file.

----

Copyright 2026 The MathWorks, Inc.

----

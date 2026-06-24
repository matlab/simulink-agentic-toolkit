<!-- Copyright 2026 The MathWorks, Inc. -->

# System Composer API Reference

> **Execution model:** Execute all patterns in this file via `evaluate_matlab_code`. Do not create `.m` script files unless the user explicitly asks for this. Otherwise, write the code inline and execute it directly.

---

## Interface Dictionaries

Interface dictionaries (`.sldd`) define typed interfaces for component ports. They are not addressable by `model_edit`.

```matlab
Simulink.data.dictionary.closeAll("-discard");
dict = systemcomposer.createDictionary(fullfile(archDir, 'MyDict.sldd'));

iface = addInterface(dict, "PowerBus");
addElement(iface, "Voltage", Type="double");
addElement(iface, "Current", Type="double");

dict.save();

% Re-fetch after save — handles go stale
iface = dict.getInterface("PowerBus");
```

### Linking and Assigning Interfaces

The model must have the dictionary linked before any port on it can receive `setInterface`. Without `linkDictionary`, `setInterface` silently leaves the port untyped.

```matlab
% Step 1: link dictionary to model (prerequisite for setInterface)
linkDictionary(model, fullfile(archDir, 'MyDict.sldd'));

% Step 2: assign interface to port (only works after linkDictionary)
port.setInterface(iface);
```

### Applying setInterface to Composite Boundary Ports

When `model_edit` has already built a composite component (parent with sub-components), you may need to assign interfaces to its boundary ports via script. The boundary port has two views:

- **Internal (`ArchitecturePort`)** — returned by `addPort(comp.Architecture, name, dir)`. Use this for `setInterface`.
- **External (`ComponentPort`)** — returned by `comp.getPort(name)`. Used for connections in the parent scope.

If the port was created by `model_edit`, retrieve it for interface assignment:

```matlab
comp = model.Architecture.getComponent("MyComposite");
ports = comp.Architecture.Ports;  % ArchitecturePort array
for i = 1:numel(ports)
    if strcmp(ports(i).Name, "PowerIn")
        ports(i).setInterface(iface);
    end
end
```

### Gotchas

- Call `Simulink.data.dictionary.closeAll("-discard")` before `createDictionary` — stale handles block creation.
- Always re-fetch interfaces after `dict.save()` before passing to `setInterface`. Without this, the port links to an unresolvable name.
- Use `Type="double"` for all elements. Value type names (e.g., `Type="Temperature"`) create `Simulink.ValueType` objects the bus compiler cannot resolve.
- Use `systemcomposer.openDictionary` + `addInterface` for SC interfaces. Do NOT use `Simulink.data.dictionary.open` + `Simulink.Bus` — Bus entries are invisible to System Composer.
- `port.setInterface(iface)` is correct. `port.Interface = iface` throws a read-only error.

---

## Profiles and Stereotypes

Stereotypes attach quantitative properties to components (mass, power, cost, etc.).

```matlab
systemcomposer.profile.Profile.closeAll();
if isfile(fullfile(archDir, [profileName '.xml']))
    delete(fullfile(archDir, [profileName '.xml']));
end

profile = systemcomposer.profile.Profile.createProfile(profileName);
st = addStereotype(profile, 'ComponentProperties', AppliesTo="Component");
addProperty(st, 'Mass_kg',    Type="double", Units="kg", DefaultValue="0");
addProperty(st, 'Power_W',    Type="double", Units="W",  DefaultValue="0");

% CRITICAL: save takes a FOLDER, not a file path
profile.save(archDir);

applyProfile(model, profileName);
```

### Applying to Components

```matlab
comp = model.Architecture.getComponent("SensorUnit");
applyStereotype(comp, [profileName '.ComponentProperties']);
setProperty(comp, [profileName '.ComponentProperties.Mass_kg'], "4.0");
```

### Gotchas

- `profile.save(path)` takes a **folder**. Passing a file path creates a directory named `foo.xml`.
- `createProfile(name)` takes one argument only.
- `Profile.closeAll()` takes no arguments.
- `setProperty(comp, path, value)` — value is always a char/string. For string-type properties, double-quote inside: `'"standard"'`.
- `applyProfile` on a model that already has the profile throws a uniqueness error. Rebuild from scratch or guard with a check.
- `setPropertyValue` does not exist — use `setProperty`.

---

## Allocation Sets

Allocation sets map elements between models (Function → Logical, Logical → Physical).

```matlab
allocSet = systemcomposer.allocation.createAllocationSet( ...
    'FuncToLogical', 'MyFunctional', 'MyLogical');

% Use the default scenario — do NOT call createScenario
scenario = allocSet.Scenarios(1);
scenario.Name = "MainAllocation";

srcComp = funcArch.getComponent("SenseState");
dstComp = logArch.getComponent("SensingUnit");
allocate(scenario, srcComp, dstComp);

allocSet.save();
```

### Querying Allocations

```matlab
allocatedTo = getAllocatedTo(scenario, srcComp);
```

### Opening the Editor

```matlab
systemcomposer.allocation.editor('path/to/MyAllocation.mldatx')
```

### Resolving Nested Components

Sub-components inside composites (e.g., `ConveyorSystem/Motor`) require walking into each parent's `.Architecture`. Use the [`resolveComponent`](../scripts/resolveComponent.m) helper:

```matlab
comp = resolveComponent(arch, 'ConveyorSystem/Motor');
allocate(scenario, comp, dstComp);
```

### Gotchas

- Pass model **names** (char) to `createAllocationSet`, not model objects. Objects fail with an unhelpful `AllocationAppCatalog` signature error.
- `createAllocationSet` auto-creates a default scenario. Calling `createScenario` adds a second empty one that the Editor shows by default — looks like nothing is allocated.
- Rebuilding a model invalidates allocation links (SIDs change). Re-run allocation after any model rebuild.

---

## Architecture Views

Views surface components by stereotype property queries.

### Query-Driven

```matlab
import systemcomposer.query.*;
q = PropertyValue("MyProfile.ComponentProperties.Cost") > 150000;

try, deleteView(model, "CostDrivers"); end %#ok<TRYNC>
v = createView(model, "CostDrivers", Select=q, Color="#D62728");
```

### Explicit-Element

```matlab
v = createView(model, "ControlGroup", Color="blue");
v.Root.addElement(arch.getComponent('ControlCabinet'));
```

### Gotchas

- `Color` accepts hex strings universally. Some named colors (e.g., `"magenta"`) error.
- `find(model, constraint)` returns a cell of qualified-name **strings**, not Component objects. Resolve with `model.lookup("Path", pathString)`.
- Views live inside the `.slx` — a model rebuild wipes them. Create views after the structural build.

---

## Roll-Up Analysis

```matlab
instance = instantiate(arch, profileName, 'MyAnalysis');
iterate(instance, 'PostOrder', @myRollupAnalysis);

systemcomposer.analysis.openViewer('Source', instance);
save(instance, fullfile(analysisDir, 'MyAnalysis.mat'));
```

### Analysis Function Signature

```matlab
function myRollupAnalysis(instance, varargin)
    prefix = 'MyProfile.ComponentProperties.';
    prop = [prefix 'Mass_kg'];
    if instance.isComponent() && ~isempty(instance.Components) && instance.hasValue(prop)
        total = 0;
        for child = instance.Components
            if child.hasValue(prop)
                total = total + child.getValue(prop);
            end
        end
        instance.setValue(prop, total);
    end
end
```

### Key Points

- `PostOrder` visits children before parents — this is what makes roll-up work.
- `getValue` returns a double — no `str2double` needed.
- `setValue` writes to the analysis instance only, not the design model.
- Guard every block: `isComponent() && ~isempty(Components) && hasValue(path)`.
- Guard each child: `child.hasValue(path)`.
- `openViewer('Source', instance)` — the name-only form does not work in R2025b.
- PostOrder **overwrites** a parent's value with the aggregated children total. If children are an incomplete decomposition of the parent, the rolled-up total will be lower than the parent's original estimate. This is intentional — treat it as a signal to complete the decomposition or add a "balance" sub-part. Do not guard against the overwrite.

### Reading Top-Level Totals After Rollup

After `iterate` completes, read aggregated values from top-level children:

```matlab
function s = sumTop(comps, prop)
    s = 0;
    for i = 1:numel(comps)
        s = s + comps(i).getValue(prop);
    end
end

totMass = sumTop(instance.Components, [prefix 'Mass_kg']);
```

### Reading Budget Caps from Requirements

Store system-level limits in requirements (e.g., "The system shall not exceed 35 kg total mass"). Parse them at analysis time rather than hard-coding:

```matlab
function value = parseBudgetValue(srSet, reqId, unit)
    req  = srSet.find('Id', reqId);
    desc = req.Description;
    tok = regexp(desc, ['not exceed\s+([\d.]+)\s+' unit], 'tokens', 'once');
    if isempty(tok)
        tok = regexp(desc, ['not exceed\s+' unit '\s+([\d.]+)'], 'tokens', 'once');
    end
    value = str2double(tok{1});
end
```

This keeps the analysis script in sync with requirements without manual cap updates.

### Topology-Dependent Rollup

When aggregation depends on topology (e.g., throughput: MIN for serial, SUM for parallel), use a numeric stereotype flag:

```matlab
addProperty(st, "UseParallelThroughput", Type="double", DefaultValue="0");
```

Read the flag in the analysis function to branch between MIN and SUM. Use numeric (not string) because string properties do not propagate from variant choices to wrapper instances.

### Leaves-Only Rollup (Alternative Pattern)

When stereotypes are applied only to leaf components (composites are purely structural), the standard `iterate + PostOrder` silently produces zero totals — the parent's `hasValue` guard returns false because it has no stereotype, so aggregation never fires. Use recursive descent instead:

```matlab
function s = sumLeaves(instance, prop)
    s = 0;
    for child = instance.Components
        if ~isempty(child.Components)
            s = s + sumLeaves(child, prop);
        elseif child.hasValue(prop)
            s = s + child.getValue(prop);
        end
    end
end
```

Drive recursion on `~isempty(child.Components)`, not `~child.hasValue(prop)`. Profile defaults (e.g., `0`) leak through every instance — `hasValue` returns true even on components with no stereotype applied — so it is unreliable as a leaf detector.

---

## Verification After Build

### Unconnected Ports

Use `model_check` with `checks="unconnected_ports"` to detect ports that were added but never wired. Run this after each model build step.

### Type Resolution

Use `evaluate_matlab_code` to run an update diagram check — catches interface element type issues (e.g., a value type name that slipped through):

```matlab
set_param(modelName, "SimulationCommand", "update");
```

The "Architecture model contains no components or all components are virtual" warning is expected for pure architecture models — it does not indicate a problem.

---

## The String-vs-Char Trap

Many SC APIs silently fail or throw unhelpful errors when given a `string` where `char` is expected. The common source is `proj.RootFolder` (returns string), and `fullfile(string, ...)` stays string downstream.

Symptoms:
- `profile.save(archDir)` → "Value must be a scalar"
- `createAllocationSet` signature mismatch from a multi-element string array name
- `[baseName, 'Set']` where `baseName` is string builds a 2-element array, not a concatenation

Fix: cast early with `char()`:

```matlab
archDir = char(fullfile(proj.RootFolder, 'architecture'));
profile.save(char(archDir));
allocName = [char(baseName), 'Set'];
```

When an SC API errors with a signature-mismatch and the args look right, suspect string-vs-char before anything else.

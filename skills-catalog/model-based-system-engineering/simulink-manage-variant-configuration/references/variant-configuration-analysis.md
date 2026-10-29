# Variant Configuration Analysis

`Simulink.VariantConfigurationAnalysis` — returned by `Simulink.VariantManager.analyzeModel`. Use when the user wants to compare configurations: which blocks are shared, which differ, which models/libraries are pulled in by each configuration.

**Recommendation:** The interactive UI (`showUI`) provides the richest exploration experience. Suggest it to the user when they want visual comparison. Use the programmatic API when specific data is needed (e.g., listing differing blocks, checking conditions).

---

## Creating the Analysis Object

Two creation paths — via `Simulink.VariantManager.analyzeModel` (recommended starting from release R2026a) or directly via the constructor.

### Via `analyzeModel` (preferred)

```matlab
analysis = Simulink.VariantManager.analyzeModel(model, NamedConfigurations=["Config1","Config2"], ShowUI=false);
```

### Via Constructor

```matlab
analysis = Simulink.VariantConfigurationAnalysis(model, NamedConfigurations=["Config1","Config2"]);
analysis = Simulink.VariantConfigurationAnalysis(model, VariableGroups=groups);
```

### Name-Value Arguments (both creation paths)

| Name-Value | Default | Description |
|------------|---------|-------------|
| `NamedConfigurations` | — | Configurations to analyze (string array or cell) |
| `VariableGroups` | — | Struct array of variable names/values for ad-hoc groups |
| `ShowUI` | `true` | Open analysis report UI |
| `Verbose` | `false` | Display diagnostic messages |

### `VariableGroups` Format

Each element is a struct with fields `Name` and `VariantControls`:

```matlab
groups = struct( ...
    'Name', 'MyGroup', ...
    'VariantControls', {{'Ctrl', ControllerType.Linear, 'PlantLoc', PlantLocation.Internal, 'Noise', NoiseType.NoNoise}} ...
);
```

- `Name` — identifier for the group (like a configuration name)
- `VariantControls` — cell array of name-value pairs: `{'VarName1', value1, 'VarName2', value2, ...}`

Multiple groups as a struct array:

```matlab
groups(1) = struct('Name','GroupA','VariantControls',{{'Ctrl',ControllerType.Linear,'PlantLoc',PlantLocation.Internal}});
groups(2) = struct('Name','GroupB','VariantControls',{{'Ctrl',ControllerType.Nonlinear,'PlantLoc',PlantLocation.External}});
analysis = Simulink.VariantConfigurationAnalysis('slexVariantManagement', VariableGroups=groups, ShowUI=false);
```

Use `VariableGroups` when you want to analyze ad-hoc variable combinations without creating named configurations in the VCS.

---

## Properties

| Property | Type | Description |
|----------|------|-------------|
| `ModelName` | char | Model that was analyzed |
| `Configurations` | cell array | Configuration names included in this analysis |

---

## Object Functions

All methods use **positional arguments** (not name-value pairs).

### `getActiveBlocks`

Returns blocks active in a specific configuration. Includes blocks in referenced models.

**Syntax:**
```matlab
activeBlocks = analysis.getActiveBlocks(configName)
```

**Returns:** Cell array of block paths (char).

**Example:**
```matlab
activeBlocks = analysis.getActiveBlocks('LinInterStd');
```

---

### `getAlwaysActiveBlocks`

Returns blocks active in ALL analyzed configurations. These are the shared/common blocks across the analyzed set.

**Syntax:**
```matlab
alwaysActive = analysis.getAlwaysActiveBlocks()
```

**Returns:** Cell array of block paths.

**Example:**
```matlab
alwaysActive = analysis.getAlwaysActiveBlocks();
```

---

### `getNeverActiveBlocks`

Returns blocks inactive in ALL analyzed configurations. These blocks are dead code for the analyzed set.

**Syntax:**
```matlab
neverActive = analysis.getNeverActiveBlocks()
```

**Returns:** Cell array of block paths.

**Example:**
```matlab
neverActive = analysis.getNeverActiveBlocks();
```

---

### `getBlockDifferences`

Returns blocks that differ in their active/inactive state across the analyzed configurations.

**Syntax:**
```matlab
diffs = analysis.getBlockDifferences()
```

**Returns:** Cell array of block paths.

**Example:**
```matlab
diffs = analysis.getBlockDifferences();
```

---

### `getDependentModels`

Returns referenced models active in a specific configuration.

**Syntax:**
```matlab
depModels = analysis.getDependentModels(configName)
```

**Returns:** Cell array of model names.

**Example:**
```matlab
depModels = analysis.getDependentModels('NonLinExterHighFid');
% Returns: {'slexVariantManagementExternalPlantMdlRef'}
```

---

### `getDependentLibraries`

Returns libraries used by a specific configuration.

**Syntax:**
```matlab
depLibs = analysis.getDependentLibraries(configName)
```

**Returns:** Cell array of library names (empty if none).

**Example:**
```matlab
depLibs = analysis.getDependentLibraries('LinInterStd');
```

---

### `getVariantCondition`

Returns the variant condition expression on a block for a specific configuration. Returns empty for non-variant (always active) blocks.

**Syntax:**
```matlab
condition = analysis.getVariantCondition(configName, blockPath)
```

**Returns:** char (the condition expression, or empty).

**Example:**
```matlab
cond = analysis.getVariantCondition('LinInterStd', 'slexVariantManagement/Controller/Linear Controller');
% Returns: 'Ctrl == ControllerType.Linear'
```

---

### `showUI` / `hideUI`

Opens or closes the variant configuration analysis report UI.

**Syntax:**
```matlab
analysis.showUI()
analysis.hideUI()
```

---

## Typical Workflow

```matlab
% 1. Create analysis for configs of interest
analysis = Simulink.VariantManager.analyzeModel('myModel', ...
    NamedConfigurations=["ConfigA","ConfigB","ConfigC"], ShowUI=false);

% 2. What blocks differ?
diffs = analysis.getBlockDifferences();

% 3. What's always active (shared infrastructure)?
shared = analysis.getAlwaysActiveBlocks();

% 4. What's dead code for this set?
dead = analysis.getNeverActiveBlocks();

% 5. What referenced models does each config pull in?
modelsA = analysis.getDependentModels('ConfigA');

% 6. What condition guards a specific block?
cond = analysis.getVariantCondition('ConfigA', 'myModel/Subsystem/VariantBlock');

% 7. Show interactive report for deeper exploration
analysis.showUI();
```

----

Copyright 2026 The MathWorks, Inc.

----

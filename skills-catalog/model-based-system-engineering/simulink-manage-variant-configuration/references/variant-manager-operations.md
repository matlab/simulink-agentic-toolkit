# Variant Manager Operations

Static functions on `Simulink.VariantManager` for model-level operations.

A variant model is a **150% model** — one model representing many designs. These APIs let you apply, validate, analyze, and reduce it.

---

## State Escalation: apply → activate → update

Three distinct operations with different purposes and costs. If confused about which the user needs, ask with examples and a recommendation.

### `applyConfiguration`

**Introduced:** R2022b.

**Purpose:** Swaps workspace variable values with those stored in the configuration. Nothing else — no validation, no diagram refresh, no compilation.

**When to use:** Quick swap of variable values before another operation or when the user just wants to change the active variable state.

**Syntax:**
```matlab
Simulink.VariantManager.applyConfiguration(model, Configuration="<configName>")
```

**Example:**
```matlab
Simulink.VariantManager.applyConfiguration('slexVariantManagement', Configuration='LinInterStd');
```

---

### `variantConfigActivateModel` (script)

**Introduced:** R2022b (wraps `Simulink.VariantManager.activateModel`).

**Purpose:** Lightweight variant activation. Evaluates variant conditions and activates/deactivates variant blocks, variant parameters and variant Stateflow Transitions throughout the model hierarchy **without triggering a full update diagram**. Can report errors (e.g., undefined variables, constraint violations). Keeps the Variant Manager UI in sync if open.

**When to use:** When the user wants to see how variant elements react to a configuration — which paths become active, whether the configuration is viable. This is the most useful API for iterative exploration.

**Syntax (two-call pattern):**
```text
% Call 1: capture current path
mcp__matlab__evaluate_matlab_code(code: "currentPath = pwd;")

% Call 2: invoke script
mcp__matlab__evaluate_matlab_code(
  code: "variantConfigActivateModel(modelName, currentPath, 'Configuration', configName)",
  project_path: "SKILL_DIR/scripts"
)
```

**Example:**
```
mcp__matlab__evaluate_matlab_code(code: "currentPath = pwd;")
mcp__matlab__evaluate_matlab_code(
  code: "variantConfigActivateModel('slexVariantManagement', currentPath, 'Configuration', 'LinInterStd')",
  project_path: "SKILL_DIR/scripts"
)
```

**Silence is success.** The "Successfully activated configuration 'X'." message is relayed from the Variant Manager's diagnostic viewer, so it only appears when the UI is open. With the UI closed the script returns no output at all — that is a successful activation, not a no-op. Failures always raise an error either way, so absence of output never needs investigating.

---

### `variantConfigUpdateModel` (script)

**Introduced:** R2024b. Do not use if `releaseVersion` is older than `'2024b'`.

**Purpose:** Triggers a **full update diagram** (model compilation). Compiles the entire model — not just variant conditions but signal resolution, type checking, everything. This is costly but most accurate in identifying variant specification issues. Keeps the Variant Manager UI in sync if open.

**When to use:** Before simulation or code generation. Always confirm with the user before calling — it is expensive and may take significant time for large models.

**Syntax (two-call pattern):**
```text
% Call 1: capture current path
mcp__matlab__evaluate_matlab_code(code: "currentPath = pwd;")

% Call 2: invoke script
mcp__matlab__evaluate_matlab_code(
  code: "variantConfigUpdateModel(modelName, currentPath, 'Configuration', configName)",
  project_path: "SKILL_DIR/scripts"
)
```

**Example:**
```
mcp__matlab__evaluate_matlab_code(code: "currentPath = pwd;")
mcp__matlab__evaluate_matlab_code(
  code: "variantConfigUpdateModel('slexVariantManagement', currentPath, 'Configuration', 'NonLinExterHighFid')",
  project_path: "SKILL_DIR/scripts"
)
```

---

### Choosing between the three

| User says | Use | Why |
|-----------|-----|-----|
| "Switch to config X" / "Apply X" | `applyConfiguration` | Just swaps values |
| "Check if config X works" / "Activate X" / "Show active paths" | `variantConfigActivateModel` (script) | Validates variant logic, lightweight, UI sync |
| "Simulate" / "Generate code" / "Full compile" | `variantConfigUpdateModel` (script) | Full compilation needed, UI sync |
| Ambiguous | Ask user | Present the three options with cost/purpose |

---

## Discovery & Inspection

### `getConfigurationData`

**Introduced:** R2022b. Renamed to `getVariantConfigurations` in R2026b — use the new name on R2026b+.

Returns the VCS associated with a model.

**Syntax:**
```matlab
% R2022b – R2026a
vcdo = Simulink.VariantManager.getConfigurationData(model)

% R2026b+
vcs = Simulink.VariantManager.getVariantConfigurations(model)
```

**Returns:** `Simulink.VariantConfigurations` (R2026b+) or `Simulink.VariantConfigurationData` (R2022b–R2026a) object.

**Example:**
```matlab
% R2022b – R2026a
vcdo = Simulink.VariantManager.getConfigurationData('slexVariantManagement');

% R2026b+
vcs = Simulink.VariantManager.getVariantConfigurations('slexVariantManagement');
```

---

### `getPreferredConfigurationName`

**Introduced:** R2022b.

Gets the preferred configuration name for a model.

**Syntax:**
```matlab
configName = Simulink.VariantManager.getPreferredConfigurationName(model)
```

**Returns:** char (empty if none set).

**Example:**
```matlab
prefName = Simulink.VariantManager.getPreferredConfigurationName('slexVariantManagement');
```

---

### `findVariantControlVars`

**Introduced:** R2016a.

Discovers all control variables across the model hierarchy. See [Model Control Variables](variant-configurations-data-model.md#model-control-variables) for struct fields, unwrapping, and usage.

**Syntax:**
```matlab
vars = Simulink.VariantManager.findVariantControlVars(model)
```

---

### `open`

**Introduced:** R2026a.

Opens the Variant Manager UI.

**Syntax:**
```matlab
Simulink.VariantManager.open(model)
Simulink.VariantManager.open(VariantConfigurations="<vcsName>", Source="<src>")
```

`Source`: `"base workspace"`, `"caller"`, or data dictionary name.

**Example:**
```matlab
Simulink.VariantManager.open('slexVariantManagement')
Simulink.VariantManager.open(VariantConfigurations="vcd", Source="topData.sldd")
```

---

## Validation

### `validateConstraint`

**Introduced:** R2025a.

Verifies if a constraint is satisfied by the current model hierarchy state.

**Syntax:**
```matlab
Simulink.VariantManager.validateConstraint(model, Constraint="<constraintName>")
Simulink.VariantManager.validateConstraint(model, Condition="<expr>")
```

Use `Constraint` for a named constraint from the VCS. Use `Condition` for an arbitrary expression.

**Example:**
```matlab
Simulink.VariantManager.validateConstraint('slexVariantManagement', Constraint='LinNotExtern');
```

---

## Analysis

### `analyzeModel`

**Introduced:** R2026a.

Analyzes a variant model for specified configurations. Returns a `Simulink.VariantConfigurationAnalysis` object. Use this when the user is satisfied with a set of configurations and wants to compare them — which blocks differ, which are always active, etc.

**Recommendation:** The UI (`ShowUI=true`) is the most effective way to explore analysis results. APIs reveal limited information compared to the interactive report. Suggest the UI when appropriate.

**Syntax:**
```matlab
analysis = Simulink.VariantManager.analyzeModel(model, NamedConfigurations=["Config1","Config2"], ShowUI=false)
```

| Name-Value | Default | Description |
|------------|---------|-------------|
| `NamedConfigurations` | — | Configurations to analyze |
| `VariableGroups` | — | Struct array of variable names/values (ad-hoc groups) |
| `ShowUI` | `true` | Show analysis report UI |
| `Verbose` | `false` | Display diagnostic messages |

**Returns:** `Simulink.VariantConfigurationAnalysis` — see [variant-configuration-analysis.md](variant-configuration-analysis.md) for object methods.

**Example:**
```matlab
analysis = Simulink.VariantManager.analyzeModel('slexVariantManagement', NamedConfigurations=["LinInterStd","NonLinExterHighFid"], ShowUI=true);
```

---

## Generation

### `generateConfigurations`

**Introduced:** R2022b.

Automatically enumerates valid combinations of control variable values and generates a VCS. Useful for bootstrapping configurations or discovering the full valid space.

**Syntax:**
```matlab
varConfigs = Simulink.VariantManager.generateConfigurations(model)
[varConfigs, configsInfo] = Simulink.VariantManager.generateConfigurations(model, Name=Value)
```

| Name-Value | Default | Description |
|------------|---------|-------------|
| `Precondition` | — | Conditions generated configs must satisfy |
| `AddPreconditionAsConstraint` | `false` | Export preconditions as constraints |
| `Validity` | `"valid-unique"` | `"valid-unique"`, `"valid"`, or `"all"` |
| `ExcludeVariantConfigurationData` | — | **Name** of an existing VCS to exclude, as char/string — not the VCS object |
| `Verbose` | `false` | Display diagnostic messages |

Name-Value argument `ExcludeVariantConfigurationData` has been renamed to `ExcludeVariantConfigurations` in R2026b onwards.

**Returns:**
- `varConfigs` — `Simulink.VariantConfigurations` with generated configs
- `configsInfo` — struct array with `Name` and `ValidityStatus`

**Example:**
```matlab
[genVcs, info] = Simulink.VariantManager.generateConfigurations('slexVariantManagement', Validity="valid-unique", Verbose=true);
```

---

## Reduction

### `reduceModel`

**Introduced:** R2016a.

Generates a reduced copy of the 150% model containing only blocks active for specified configurations. Use when the user is done experimenting and wants to lock down specific designs as standalone models.

**Syntax:**
```matlab
Simulink.VariantManager.reduceModel(model, Name=Value)
```

| Name-Value | Default | Description |
|------------|---------|-------------|
| `NamedConfigurations` | — | Configurations to retain |
| `VariableGroups` | — | Variable groups to retain, as a cell of name/value pairs `{'V',1}` (or a struct array) |
| `FullRangeVariables` | — | Variables whose full range is considered, as a cell of name/**reference value** pairs `{'W',1}` |
| `CompileMode` | `'sim'` | `'sim'` or `'codegen'` |
| `ExcludeFiles` | — | Files to exclude |
| `RemoveVariantSubsystemLayer` | `true` | Remove outer Variant Subsystem layer |
| `OutputFolder` | — | Output folder |
| `PreserveSignalAttributes` | `true` | Preserve signal attributes |
| `Verbose` | `false` | Display reduction steps |
| `ModelSuffix` | `'_r'` | Suffix for reduced model name |
| `GenerateSummary` | `false` | Generate summary HTML |

**Prerequisite — nothing may be dirty.** The model and every data dictionary it uses must be saved before `reduceModel` runs. With unsaved changes it refuses outright: `variant_manager:VariantReducer:InvalidModelDDDirty`, listing the dictionaries at fault. This bites after any VCS edit, because the `evalin` write pattern leaves the dictionary dirty — save it first:

```matlab
dd = Simulink.data.dictionary.open('<slddFile>');
if dd.HasUnsavedChanges, saveChanges(dd); end
if strcmp(get_param(modelName,'Dirty'),'on'), save_system(modelName); end
```

Reduction is also slow — expect a minute or more per configuration, with no output at `Verbose=false`. A long silence is normal, not a hang.

**Example:**
```matlab
Simulink.VariantManager.reduceModel('slexVariantManagement', NamedConfigurations=["LinInterStd","NonLinExterHighFid"], OutputFolder="./reduced", Verbose=true);
```

**`FullRangeVariables` takes name/value pairs, not just names.** Every variable
listed needs a reference value for which the model compiles successfully —
`{'W'}` alone fails. Reduction then considers all valid values of `W`, compiling
the model once using the reference values given:

```matlab
% V is fixed at 1; the reduced model covers every valid value of W
Simulink.VariantManager.reduceModel('slexVariantReducer', ...
    VariableGroups={'V',1}, ...
    FullRangeVariables={'W',1});
```

---

## Show/Hide Control Variable Usage

### `vmgrHighlightControlVariables` (script)

Highlights blocks that use specified control variables in the **Variant Manager UI**. The Variant Manager must be open before calling.

**Syntax (two-call pattern):**
```
mcp__matlab__evaluate_matlab_code(code: "currentPath = pwd;")
mcp__matlab__evaluate_matlab_code(
  code: "vmgrHighlightControlVariables(modelName, currentPath, controlVarNames, showUsage)",
  project_path: "SKILL_DIR/scripts"
)
```

| Argument | Type | Description |
|----------|------|-------------|
| `controlVarNames` | char, string, string array, or cellstr | Control variable name(s) to highlight |
| `showUsage` | logical | `true` to show, `false` to hide |

**Single variable:**
```
vmgrHighlightControlVariables('slexVariantManagement', currentPath, 'Ctrl', true)
```

**Multiple variables:**
```
vmgrHighlightControlVariables('slexVariantManagement', currentPath, ["Ctrl", "PlantLoc"], true)
```

Unrecognized variable names are skipped with a warning.

---

## Deprecated

### `getConfigurationData`

Use `Simulink.VariantManager.getVariantConfigurations` instead.

----

Copyright 2026 The MathWorks, Inc.

----

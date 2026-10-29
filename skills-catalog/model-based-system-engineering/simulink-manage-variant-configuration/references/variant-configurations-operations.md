# Variant Configurations Operations

This file defines the safe operation patterns for modifying a Simulink variant configurations object (VCS). Read it when the user asks to add, copy, remove, or update configurations, control variables, constraints, preferred configurations, or referenced-component configuration mappings.

This file assumes the Onboarding section of SKILL.md has already established the target model, MATLAB release, attached VCS name, data source, VCS location, dictionary section name, and VCS class. Read [variant-configurations-data-model.md](variant-configurations-data-model.md) first: its [Variant Configurations Object](variant-configurations-data-model.md#variant-configurations-object) section covers read-only exploration of existing configurations, and its [Model Control Variables](variant-configurations-data-model.md#model-control-variables) section covers operations that need complete model-level control-variable metadata.

## Operating Principles

VCS operations must preserve the model's existing data ownership and value structure.

- Modify the attached VCS at its source; do not edit stale copies returned by `getValue`.
- Use the version-sensitive API names and dictionary section discovered during onboarding.
- Treat data dictionary changes as unsaved work until the user explicitly asks to save them.
- Preserve each control variable's source, activation time, and value wrapping unless the user explicitly asks to change them.
- Run the validation gates in this file before adding or changing configurations.

## Write Pattern: `evalin` Only

All VCS modifications must use `evalin`. Use one operation per MATLAB call.

Examples in this file consistently use `vcs` as the VCS variable or entry name. In real execution, `vcs` must refer to the attached VCS in the target source; otherwise substitute the actual `vcsName` name discovered during onboarding when building the `evalin` command.

| VCS source | Write pattern |
|------------|---------------|
| Base workspace | `evalin('base', "vcs.<operation>(...)")` |
| Data dictionary | `evalin(ddsec, "vcs.<operation>(...)")` |

For a dictionary-backed VCS, create `ddsec` from the section name discovered during onboarding:

```matlab
dd = Simulink.data.dictionary.open(slddFile);
ddsec = getSection(dd, ddSectionName);
```

Base workspace VCS objects are handles and can be modified in place. Dictionary-backed VCS objects must be modified through `evalin(ddsec, ...)` because `getValue` returns a copy. Re-fetch the VCS after a write if more inspection is needed.

A write through `evalin(ddsec, ...)` makes the data dictionary dirty. Do not save the dictionary unless the user explicitly asks to permanently save the changes.

## Control-Variable Metadata Requirement

Before constructing or modifying configuration control-variable assignments, use [Model Control Variables](variant-configurations-data-model.md#model-control-variables) when any of these details are needed:

- Full model-level list of variant control variables
- Current value for a missing or unspecified variable
- Enum members or allowed values
- Per-variable source and source type
- Activation time for `Simulink.VariantControl`
- Wrapper structure needed to reconstruct a value correctly

Existing configurations may specify only a subset of the model's control variables. Do not assume `vcsObj.Configurations` contains every control variable used by the model.

When proposing changes to the user, show the unwrapped value, source, and activation time. Show wrapper structure only when the user asks about value type/wrapping or when it is necessary to explain the proposed write.

## Underspecification Gate

A configuration should specify the control variables needed for the intended model behavior. Some models can simulate with partial configurations because inactive paths may not require every variable, but the agent must not silently invent missing values.

When the user provides fewer values than the model-level control-variable set or fewer values than are needed for the intended behavior:

1. Identify the missing variables.
2. Present allowed enum values when available.
3. Suggest the current value from `findVariantControlVars` as a default candidate.
4. Ask the user to confirm or override the missing values.

If the user intentionally wants a partial configuration, make that explicit. Use `variantConfigActivateModel` only when validation of that partial configuration is needed and the user agrees to the model-state change. See [variant-manager-operations.md](variant-manager-operations.md) for `variantConfigActivateModel` details.

## Duplicate Configuration Gate

Before adding a configuration, compare its proposed control-variable values against all existing configurations.

If an existing configuration has the same values for every compared control variable, regardless of name or description:

1. Identify the existing duplicate configuration by name.
2. Tell the user the proposed configuration has the same value combination.
3. Ask whether to proceed with the new name or cancel.

Do not silently add a duplicate configuration.

---
## Object Functions Reference

### `addConfiguration`

**Introduced:** R2013b. Name=Value syntax added in R2026a.

Creates a new named configuration in the VCS.

**Syntax (R2026a+, Name=Value):**
```matlab
vcs.addConfiguration(ConfigurationName="<name>")
vcs.addConfiguration(ConfigurationName="<name>", Description="<desc>", ControlVariables=<structArray>)
```

**Syntax (R2013b–R2025b, positional):**
```matlab
vcs.addConfiguration('<name>')
vcs.addConfiguration('<name>', '<description>', <structArray>)
```

| Name-Value | Required | Description |
|------------|----------|-------------|
| `ConfigurationName` | Yes | Configuration name |
| `Description` | No | Human-readable description |
| `ControlVariables` | No | Struct array with fields `Name`, `Value`, `Source` |

**ControlVariables struct — Value types:**

| Type | Example |
|------|---------|
| Plain value (numeric, enum) | `Value=ControllerType.Linear` |
| `Simulink.Parameter` | `Value=Simulink.Parameter(2)` |
| `Simulink.VariantControl` wrapping scalar/enum | `Value=Simulink.VariantControl(Value=3)` |
| `Simulink.VariantControl` wrapping `Simulink.Parameter` | `Value=Simulink.VariantControl(Value=Simulink.Parameter(4))` |

### Constructing Values for New Configurations

Use the wrapper chain, activation time, and source discovered with `findVariantControlVars` ([Model Control Variables](variant-configurations-data-model.md#model-control-variables)) to construct values for new configurations.

**User disclosure:** When presenting a proposed configuration, show wrapper type, activation time, and source — not just the enum value.

**Validation after adding:** Suggest running `variantConfigActivateModel` or `variantConfigUpdateModel` on the new configuration to catch inconsistencies or constraint voilations early. Ask for permission first, as they modify model state.

**Example (data dictionary, values wrapped in `Simulink.VariantControl` with `ActivationTime`):**
```matlab
evalin(ddsec, "vcs.addConfiguration(ConfigurationName='Economy', Description='Low cost variant', ControlVariables=struct('Name','Ctrl','Value',Simulink.VariantControl(Value=Simulink.Parameter(ControllerType.Linear),ActivationTime='code compile'),'Source','topData.sldd'))");
evalin(ddsec, "vcs.addControlVariables(ConfigurationName='Economy', ControlVariables=struct('Name','FidType','Value',Simulink.VariantControl(Value=Fidelity.Low,ActivationTime='update diagram'),'Source','plantData.sldd'))");
```

---

### `addControlVariables`

**Introduced:** R2013b. Name=Value syntax added in R2026a.

Adds control variables to an existing configuration. Same struct format as `addConfiguration`.

**Syntax (R2026a+, Name=Value):**
```matlab
vcs.addControlVariables(ConfigurationName="<config>", ControlVariables=<structArray>)
```

**Syntax (R2013b–R2025b, positional):**
```matlab
vcs.addControlVariables('<config>', <structArray>)
```

| Name-Value | Required | Description |
|------------|----------|-------------|
| `ConfigurationName` | Yes | Target configuration |
| `ControlVariables` | Yes | Struct array with fields `Name`, `Value`, `Source` |

**Example:**
```matlab
evalin(ddsec, "vcs.addControlVariables(ConfigurationName='Economy', ControlVariables=struct('Name','Noise','Value',NoiseType.NoNoise,'Source','topData.sldd'))")
```

---

### `addConstraint`

**Introduced:** R2013b. Name=Value syntax added in R2026a. `isConfigActive` in conditions added in R2025a.

Adds a named constraint. A constraint is a boolean expression defining valid control variable combinations.

**Syntax (R2026a+, Name=Value):**
```matlab
vcs.addConstraint(ConstraintName="<name>", Condition="<expr>", Description="<desc>")
```

**Syntax (R2013b–R2025b, positional):**
```matlab
vcs.addConstraint('<name>', '<condition>', '<description>')
```

| Name-Value | Required | Description |
|------------|----------|-------------|
| `ConstraintName` | Yes | Constraint identifier |
| `Condition` | No | Boolean expression over control variable names |
| `Description` | No | Human-readable explanation |

**Operators allowed in `Condition`:**

| Operator | Meaning |
|----------|---------|
| `==` `~=` `>` `<` `>=` `<=` | Comparison |
| `&&` `\|\|` | Logical AND / OR |
| `~` | Logical NOT (prefix) |
| `()` | Grouping |

Enum values referenced as `ClassName.MemberName` (e.g., `ControllerType.Linear`).

**Example:**
```matlab
evalin(ddsec, "vcs.addConstraint(ConstraintName='NoSmartWithGaussian', Condition='~(Ctrl==ControllerType.Smart && Noise==NoiseType.Gaussian)', Description='Smart controller incompatible with Gaussian noise')")
```

---

### `addCopyOfConfiguration`

**Introduced:** R2013b. Name=Value syntax added in R2026a.

Duplicates an existing configuration.

**Syntax (R2026a+, Name=Value):**
```matlab
vcs.addCopyOfConfiguration(ConfigurationName="<existing>", NewConfigurationName="<new>")
```

**Syntax (R2013b–R2025b, positional):**
```matlab
vcs.addCopyOfConfiguration('<existing>', '<new>')
```

| Name-Value | Required | Description |
|------------|----------|-------------|
| `ConfigurationName` | Yes | Existing configuration to copy |
| `NewConfigurationName` | No | Name for the copy (auto-generated if omitted) |

**Example:**
```matlab
evalin(ddsec, "vcs.addCopyOfConfiguration(ConfigurationName='NonLinExterHighFid', NewConfigurationName='NonLinExterHighFid_v2')")
```

---

### `isConfigActive`

**Introduced:** R2025a.

isConfigActive checks whether a named variant configuration (defined in a Simulink.VariantConfigurations object) is currently the active configuration for its model, by comparing that configuration's control variable values against their live values in the data source.

It's primarily used inside variant constraint expressions (e.g., via addConstraint or the Variant Manager UI) to reference the active state of configurations—including referenced component configurations—so you can enforce valid combinations across a model hierarchy .

**Positional argument** (not name-value).

**Syntax:**
```matlab
tf = vcs.isConfigActive('<configName>')
```

**Returns:** `1` if active, `0` if not.

**Example:**
```matlab
evalin(ddsec, "disp(vcs.isConfigActive('LinInterStd'))")
```

---

### `removeConfiguration`

**Introduced:** R2013b. Name=Value syntax added in R2026a.

Removes a named configuration.

**Syntax (R2026a+, Name=Value):**
```matlab
vcs.removeConfiguration(ConfigurationName="<name>")
```

**Syntax (R2013b–R2025b, positional):**
```matlab
vcs.removeConfiguration('<name>')
```

**Example:**
```matlab
evalin(ddsec, "vcs.removeConfiguration(ConfigurationName='NonLinExterHighFid_v2')")
```

---

### `removeConstraint`

**Introduced:** R2013b. Name=Value syntax added in R2026a.

Removes a named constraint.

**Syntax (R2026a+, Name=Value):**
```matlab
vcs.removeConstraint(ConstraintName="<name>")
```

**Syntax (R2013b–R2025b, positional):**
```matlab
vcs.removeConstraint('<name>')
```

**Example:**
```matlab
evalin(ddsec, "vcs.removeConstraint(ConstraintName='NoSmartWithGaussian')")
```

---

### `removeControlVariable`

**Introduced:** R2013b. Name=Value syntax added in R2026a.

Removes a control variable from a configuration. Use `ControlVariableSource` when the same name exists in multiple sources.

**Syntax (R2026a+, Name=Value):**
```matlab
vcs.removeControlVariable(ConfigurationName="<config>", ControlVariableName="<var>")
vcs.removeControlVariable(ConfigurationName="<config>", ControlVariableName="<var>", ControlVariableSource="<source>")
```

**Syntax (R2013b–R2025b, positional):**
```matlab
vcs.removeControlVariable('<config>', '<var>')
vcs.removeControlVariable('<config>', '<var>', '<source>')
```

| Name-Value | Required | Description |
|------------|----------|-------------|
| `ConfigurationName` | Yes | Configuration to modify |
| `ControlVariableName` | Yes | Variable to remove |
| `ControlVariableSource` | No | Source disambiguation |

**Example:**
```matlab
evalin(ddsec, "vcs.removeControlVariable(ConfigurationName='Economy', ControlVariableName='FidType', ControlVariableSource='plantData.sldd')")
```

---

### What the preferred configuration is — and is not

`PreferredConfiguration` is **an informational label, not a behavior.** It records which
configuration is regarded as preferred, and that is all it does. It does not activate
that configuration, does not seed or bias activation, and is not consulted by any variant
operation. Reporting it is the only thing it is for.

Do not describe it as a "default". The property was formerly named `DefaultConfiguration`
(hence `convertDefaultToPreferred` below), and that legacy name is exactly what invites
the wrong reading — that a preferred configuration is somehow the starting point for
selection or activation. It is not.

One related subtlety: `convertDefaultToPreferred` accepts `AddActivateToPostLoadFcn` /
`AddActivateToInitFcn`, which *do* cause a configuration to be activated. That activation
comes from the model callback those options write, not from the preferred label itself.

---

### `getPreferredConfiguration`

**Introduced:** R2022b.

Gets the name of the preferred variant configuration for the VCS.

**Returns:** Configuration name (char) or empty if none set.

**Example:**
```matlab
evalin(ddsec, "disp(vcs.getPreferredConfiguration())")
```

---

### `setPreferredConfiguration`

**Introduced:** R2022b.

Designates a configuration as preferred.

**Example:**
```matlab
evalin(ddsec, "vcs.setPreferredConfiguration(ConfigurationName='LinInterStd')")
```

---

### `convertDefaultToPreferred`

**Introduced:** R2022b.

Migrates legacy `DefaultConfiguration` property to `PreferredConfiguration`. Only relevant for older VCS objects.

| Name-Value | Required | Default | Description |
|------------|----------|---------|-------------|
| `ModelName` | No | — | Model to associate with |
| `AddActivateToPostLoadFcn` | No | `false` | Add activation to PostLoadFcn callback |
| `AddActivateToInitFcn` | No | `false` | Add activation to InitFcn callback |

**Example:**
```matlab
evalin(ddsec, "vcs.convertDefaultToPreferred(ModelName='slexVariantManagement', AddActivateToPostLoadFcn=true)")
```

---

### `addReferencedConfiguration` / `addComponentConfiguration`

**Introduced:** R2022b as `addComponentConfiguration`. Renamed to `addReferencedConfiguration` in R2026b — use the new name on R2026b+.

Associates a top-model configuration with a referenced model's configuration. Use when a model hierarchy contains referenced models that have their own VCS. This populates the top-level configuration with the control variables from the referenced configuration (marked read-only).

**Syntax (R2026b+, Name=Value):**
```matlab
vcs.addReferencedConfiguration(ConfigurationName="<topConfig>", ReferencedComponentName="<refModel>", ReferencedConfigurationName="<refConfig>")
```

**Syntax (R2022b–R2026a, Name=Value):**
```matlab
vcs.addComponentConfiguration(ConfigurationName="<topConfig>", ComponentName="<refModel>", ComponentConfigurationName="<refConfig>")
```

| Name-Value (R2026b+) | Name-Value (R2022b–R2026a) | Required | Description |
|------------|----------|----------|-------------|
| `ConfigurationName` | `ConfigurationName` | Yes | Top-level configuration |
| `ReferencedComponentName` | `ComponentName` | Yes | Referenced model name |
| `ReferencedConfigurationName` | `ComponentConfigurationName` | Yes | Configuration in the referenced model's VCS |

**Example:**
```matlab
% R2026b+
evalin(ddsec, "vcs.addReferencedConfiguration(ConfigurationName='NonLinExterLowFid', ReferencedComponentName='slexVariantManagementExternalPlantMdlRef', ReferencedConfigurationName='LowFid')")

% R2022b–R2026a
evalin(ddsec, "vcs.addComponentConfiguration(ConfigurationName='NonLinExterLowFid', ComponentName='slexVariantManagementExternalPlantMdlRef', ComponentConfigurationName='LowFid')")
```

---

### `getReferencedConfigurationName` / `getComponentConfigurationName`

**Introduced:** R2023b as `getComponentConfigurationName`. Renamed to `getReferencedConfigurationName` in R2026b — use the new name on R2026b+.

Gets the referenced model's configuration associated with a top-level configuration.

**Syntax (R2026b+, Name=Value):**
```matlab
refConfig = vcs.getReferencedConfigurationName(ConfigurationName="<topConfig>", ReferencedComponentName="<refModel>")
```

**Syntax (R2023b–R2026a, Name=Value):**
```matlab
refConfig = vcs.getComponentConfigurationName(ConfigurationName="<topConfig>", ComponentName="<refModel>")
```

**Returns:** Configuration name (char) or empty if no association exists.

**Example:**
```matlab
% R2026b+
evalin(ddsec, "disp(vcs.getReferencedConfigurationName(ConfigurationName='LinExterHighFid', ReferencedComponentName='slexVariantManagementExternalPlantMdlRef'))")

% R2023b–R2026a
evalin(ddsec, "disp(vcs.getComponentConfigurationName(ConfigurationName='LinExterHighFid', ComponentName='slexVariantManagementExternalPlantMdlRef'))")
```

---

### `removeReferencedConfiguration` / `removeComponentConfiguration`

**Introduced:** R2022b as `removeComponentConfiguration`. Renamed to `removeReferencedConfiguration` in R2026b — use the new name on R2026b+.

Removes the association between a top-level configuration and a referenced model's configuration. This also makes the populated control variables writable again.

**Syntax (R2026b+, Name=Value):**
```matlab
vcs.removeReferencedConfiguration(ConfigurationName="<topConfig>", ReferencedComponentName="<refModel>")
```

**Syntax (R2022b–R2026a, Name=Value):**
```matlab
vcs.removeComponentConfiguration(ConfigurationName="<topConfig>", ComponentName="<refModel>")
```

| Name-Value (R2026b+) | Name-Value (R2022b–R2026a) | Required | Description |
|------------|----------|----------|-------------|
| `ConfigurationName` | `ConfigurationName` | Yes | Top-level configuration |
| `ReferencedComponentName` | `ComponentName` | Yes | Referenced model to disassociate |

**Example:**
```matlab
% R2026b+
evalin(ddsec, "vcs.removeReferencedConfiguration(ConfigurationName='NonLinExterLowFid', ReferencedComponentName='slexVariantManagementExternalPlantMdlRef')")

% R2022b–R2026a
evalin(ddsec, "vcs.removeComponentConfiguration(ConfigurationName='NonLinExterLowFid', ComponentName='slexVariantManagementExternalPlantMdlRef')")
```

----

Copyright 2026 The MathWorks, Inc.

----

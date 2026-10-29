# Variant Configurations Data Model

Read this before any task that reads or changes configurations, constraints, or control variable values. It assumes the Onboarding section of SKILL.md has run and defined `modelName`, `vcsName`, `vcsSource`, `slddFile`, and `ddSectionName`.

- [Variant Configurations Object](#variant-configurations-object): explore, compare, or manipulate the configurations and constraints stored in the attached VCS.
- [Model Control Variables](#model-control-variables): discover every variant control variable the model uses, with allowed values, sources, and activation times, and build values for new configurations.

## Variant Configurations Object

### Structure

The variant configurations object has these important properties:

| Property | Meaning |
|----------|---------|
| `Configurations` | Struct array of named configurations |
| `Constraints` | Struct array of validity constraints |
| `PreferredConfiguration` | Preferred configuration name, possibly empty |

Each configuration has these fields:

| Field | Meaning |
|-------|---------|
| `Name` | Configuration name |
| `Description` | Configuration description, possibly empty |
| `ControlVariables` | Struct array of control variable assignments |

Each control variable entry has these fields:

| Field | Meaning |
|-------|---------|
| `Name` | Control variable name |
| `Value` | Stored value, possibly wrapped |
| `Source` | Source of that variable; this is per-variable and must not be assumed uniform |

Each Constraint has these fields:

| Field | Type | Description |
|-------|------|-------------|
| `Name` | char | Constraint name |
| `Condition` | char | Boolean expression using control variable names |
| `Description` | char | Constraint description (may be empty) |

The `Value` field can be a direct MATLAB value, an enum value, a `Simulink.Parameter`, a `Simulink.VariantControl`, or a nested value such as `Simulink.VariantControl(Value=Simulink.Parameter(4), ActivationTime='code compile')`.

### Fetch the Attached VCS

Fetch the attached VCS from the source found during onboarding.

```matlab
if strcmp(vcsSource, 'data dictionary')
    dd = Simulink.data.dictionary.open(slddFile);
    ddsec = getSection(dd, ddSectionName);
    vcsObj = getValue(getEntry(ddsec, vcsName));
elseif strcmp(vcsSource, 'base workspace')
    vcsObj = evalin('base', vcsName);
else
    error('No attached variant configurations object was found during mandatory onboarding.');
end
```

For a dictionary-backed VCS, `getValue` returns a copy. Re-fetch the VCS after any write operation.

### Counts and Preferred Configuration

```matlab
numConfigs = numel(vcsObj.Configurations);
numConstr = numel(vcsObj.Constraints);
prefConfig = vcsObj.PreferredConfiguration;

fprintf('Configurations: %d\n', numConfigs);
fprintf('Constraints: %d\n', numConstr);
fprintf('Preferred configuration: %s\n', string(prefConfig));
```

### Configurations

`Name` and `Description` can be read directly. `ControlVariables` must be inspected by looping over each control variable entry and unwrapping `Value` when needed.

```matlab
for cfgIdx = 1:numConfigs
    cfg = vcsObj.Configurations(cfgIdx);
    numCtrlVarsInConfig = numel(cfg.ControlVariables);

    fprintf('\nConfiguration %d: %s\n', cfgIdx, string(cfg.Name));
    fprintf('Description: %s\n', string(cfg.Description));
    fprintf('Control variables: %d\n', numCtrlVarsInConfig);

    for varIdx = 1:numCtrlVarsInConfig
        ctrlVar = cfg.ControlVariables(varIdx);
        [rawValue, wrapperChain, activationTime] = localUnwrapVariantValue(ctrlVar.Value);
        valueText = localValueToText(rawValue);

        fprintf('  %s = %s | Source=%s | Wrappers=%s | ActivationTime=%s\n', ...
            string(ctrlVar.Name), valueText, string(ctrlVar.Source), ...
            string(strjoin(wrapperChain, ' > ')), string(activationTime));
    end
end
```

Use this helper to unwrap variant configuration values. Model-level [Discovery](#discovery) uses it too.

```matlab
function [rawValue, wrapperChain, activationTime] = localUnwrapVariantValue(value)
    rawValue = value;
    wrapperChain = {};
    activationTime = '';

    while isa(rawValue, 'Simulink.VariantControl') || isa(rawValue, 'Simulink.Parameter')
        if isa(rawValue, 'Simulink.VariantControl')
            wrapperChain{end+1} = 'Simulink.VariantControl'; %#ok<AGROW>
            if isempty(activationTime)
                activationTime = rawValue.ActivationTime;
            end
        else
            wrapperChain{end+1} = 'Simulink.Parameter'; %#ok<AGROW>
        end
        rawValue = rawValue.Value;
    end
end
```

Use this helper when converting unwrapped values to display text:

```matlab
function valueText = localValueToText(value)
    if ischar(value) || isstring(value) || isenum(value)
        valueText = string(value);
    elseif isnumeric(value) || islogical(value)
        valueText = string(mat2str(value));
    else
        valueText = string(strtrim(evalc('disp(value)')));
    end
end
```

### Constraints

Loop over `vcsObj.Constraints` when the user asks about constraints or when a configuration change needs validation.

```matlab
for constrIdx = 1:numConstr
    constr = vcsObj.Constraints(constrIdx);
    fprintf('\nConstraint %d: %s\n', constrIdx, string(constr.Name));
    fprintf('Condition: %s\n', string(constr.Condition));
    fprintf('Description: %s\n', string(constr.Description));
end
```

### Report

Show the user a reasonable summary first. Avoid dumping every value if the object is large; summarize and offer focused details for specific configurations.

For configuration exploration, report:

- Configuration names and descriptions
- Control variable names and unwrapped values
- Per-variable source
- Wrapper chain and activation time when present
- Constraint names, conditions, and descriptions when relevant
- Preferred configuration when present

Recommended table shape:

```text
## Variant Configurations: <vcsName>

Preferred configuration: <prefConfig or none>
Configurations: <numConfigs>
Constraints: <numConstr>

| # | Configuration | Description | Control Variables |
|---|---------------|-------------|-------------------|
| 1 | <name> | <description> | <VarA=value, VarB=value> |
```

When a user asks for one configuration in detail, use this shape:

```text
## Configuration: <configurationName>

| Control Variable | Value | Source | Activation Time |
|------------------|-------|--------|---------------|
| <name> | <unwrapped value> | <source> | <activation time or none> |
```

## Model Control Variables

A configuration can specify only a subset of the variant control variables the model uses, so do not assume the union of control variables in `vcsObj.Configurations` is the complete set. `Simulink.VariantManager.findVariantControlVars` discovers every variant control variable used by variant blocks and variant parameters in the model hierarchy.

Use this section when:

- The user asks what variant control variables exist in the model.
- The user asks for allowed values, enum members, wrappers, activation times, sources, or source types.
- The user wants to add or update a configuration and the agent must know which control variables exist beyond the variables already specified in existing configurations.
- The agent needs to construct `ControlVariables` entries for `addConfiguration` or `addControlVariables` while preserving wrapper structure, activation time, and source.

For configuration creation, combine the values already stored in the VCS ([Configurations](#configurations)) with the complete model-level set from this section.

### Result Shape

`Simulink.VariantManager.findVariantControlVars(modelName)` returns an `N`-by-1 structure array. Each element describes one variant control variable.

| Field | Meaning |
|-------|---------|
| `Name` | Name of the variable used in a variant control expression |
| `Value` | Current value of the variable; this is `0` when the variable is not defined in the model data sources |
| `Exists` | Logical value indicating whether the variable is defined in the model data sources |
| `Source` | Name of the data source where the variable is defined |
| `SourceType` | Kind of source that defines the variable |

`SourceType` can include:

| SourceType | Meaning |
|------------|---------|
| `base workspace` | Variable is defined in the base workspace |
| `data dictionary` | Variable is defined in a data dictionary |
| `model workspace` | Variable is defined in the model workspace |
| `mask workspace` | Variable is defined in a mask workspace |
| `instance specific constant` | Variable is configured as a model argument in a referenced model, and an instance-specific constant value is supplied by a Model block in the parent model |

### Discovery

The raw API result gives the variable value and source metadata. Unwrap each value with `localUnwrapVariantValue` from [Configurations](#configurations) to recover the user-facing value, wrapper chain, and activation time, then read the enum members.

```matlab
vars = Simulink.VariantManager.findVariantControlVars(modelName);

for idx = 1:numel(vars)
    [rawValue, wrapperChain, activationTime] = localUnwrapVariantValue(vars(idx).Value);

    enumMembers = '';
    if isenum(rawValue)
        enumMembers = strjoin(arrayfun(@string, enumeration(class(rawValue))), ', ');
    end

    fprintf('%-16s exists=%d chain={%s} ActivationTime="%s" source=%s sourceType=%s value=%s enumMembers=[%s]\n', ...
        vars(idx).Name, vars(idx).Exists, strjoin(wrapperChain, ' > '), activationTime, ...
        vars(idx).Source, vars(idx).SourceType, string(rawValue), enumMembers);
end
```

### Facts to Preserve

For each model-level control variable, retain these facts:

| Fact | Why it matters |
|------|----------------|
| `Name` | Identifies the variable to assign in a configuration |
| `Exists` | Indicates whether the variable is defined or missing from the model data sources |
| Unwrapped `Value` | Provides the current value and a reasonable default candidate when the user has not specified a value |
| `WrapperChain` | Defines how to reconstruct the value for a new configuration, for example `Simulink.VariantControl > Simulink.Parameter` |
| `ActivationTime` | Must be preserved for `Simulink.VariantControl` values unless the user explicitly changes it |
| `Source` | Must be copied into the configuration control-variable entry; sources are per-variable |
| `SourceType` | Explains where the variable is defined and whether the source is writable in the expected way |
| `EnumMembers` | Gives the valid enum choices when the unwrapped value is an enum |

### Building Configuration Values

When adding or updating configurations, preserve the existing wrapper chain, activation time, and source unless the user explicitly asks to change them.

Use the enriched `findVariantControlVars` result to:

- Identify model control variables missing from a proposed configuration.
- Present allowed enum values when the raw value is an enum.
- Suggest current values as defaults, while asking the user to confirm instead of silently filling them.
- Construct `ControlVariables` entries using the correct value wrappers.
- Detect source differences, such as variables from both `topData.sldd` and referenced-model dictionaries.

Value construction examples:

| Existing structure | Configuration value pattern |
|--------------------|-----------------------------|
| Plain enum or scalar | `struct('Name','Ctrl','Value',ControllerType.Linear,'Source','topData.sldd')` |
| `Simulink.Parameter` | `struct('Name','Ctrl','Value',Simulink.Parameter(2),'Source','topData.sldd')` |
| `Simulink.VariantControl` | `struct('Name','Ctrl','Value',Simulink.VariantControl(Value=3,ActivationTime='update diagram'),'Source','topData.sldd')` |
| `Simulink.VariantControl > Simulink.Parameter` | `struct('Name','Ctrl','Value',Simulink.VariantControl(Value=Simulink.Parameter(4),ActivationTime='code compile'),'Source','topData.sldd')` |

When presenting a proposed configuration, show the unwrapped value, source, and activation time. Include wrapper chain only when the user asks about value type/wrapping or when wrapper details are necessary to explain the proposed write.

### Report

When the user asks to see control variables, keep the default report user-facing. Do not show wrapper chain by default, even though the agent must capture it internally.

Default report shape:

```text
## Variant Control Variables: <modelName>

| Name | Exists | Value | Source | Source Type | Activation Time | Enum Members |
|------|--------|-------|--------|-------------|-----------------|--------------|
| <name> | <true/false> | <unwrapped value> | <source> | <source type> | <activation time or none> | <enum members or none> |
```

Show wrapper chain only when the user explicitly asks questions such as "what type of value is this", "is this wrapped", "is this a Simulink.Parameter", "is this a Simulink.VariantControl", or when the wrapper structure is needed to explain a proposed configuration write.

Wrapper-detail report shape:

```text
## Variant Control Variable Details: <modelName>

| Name | Value | Wrapper Chain | Activation Time | Source |
|------|-------|---------------|-----------------|--------|
| <name> | <unwrapped value> | <wrapper chain or none> | <activation time or none> | <source> |
```

For large models, summarize first and offer focused detail for specific variables.

----

Copyright 2026 The MathWorks, Inc.

----

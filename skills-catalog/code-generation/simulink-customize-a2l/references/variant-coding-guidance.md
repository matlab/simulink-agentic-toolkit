# Variant Coding: Complete Guide

## Element Creation Order

VARIANT_CODING requires multiple supporting elements. Create them in this order to avoid unresolved references:

1. **RecordLayout** — for each CHARACTERISTIC's data type
2. **CompuMethod** (TAB_VERB) — for the selection characteristic's enumeration
3. **Selection Characteristic** — references the RecordLayout and CompuMethod
4. **Variant-dependent Characteristic** — the parameter that varies by variant
5. **VarCriterion** — defines the variant dimension and references the selection characteristic
6. **VarCharacteristic** — links the parameter to the criterion with per-variant addresses

## Type Requirements

These type constraints cause silent failures with no error message:

| Property | Required Type | Example | Wrong Types |
|----------|--------------|---------|-------------|
| `VarCriterion.Value` | String array | `["Diesel","Petrol","Hybrid"]` | Char vector errors; cell array errors |
| `VarCharacteristic.VarAddress` | String array | `["0x6000","0x6008","0x6010"]` | Char vector: silent empty output; string scalar: partial output (no CriterionName) |
| `VarCharacteristic.CriterionName` | String or char | `"Platform"` | Works with both, BUT only emitted if VarAddress is string array |
| `CompuVTabValues.Literals` | String array | `["Park","Drive","Reverse"]` | Cell array `{'Park','Drive'}`: accepted, exports 0 elements |
| `CompuVTabValues.Values` | Numeric array | `[0, 1, 2]` | Must match length of Literals |

## VarAddress Behavior by Type

| VarAddress Value | CriterionName Emitted? | VAR_ADDRESS Emitted? | Valid A2L? |
|-----------------|----------------------|---------------------|------------|
| `'0x5000'` (char vector) | No | No | No — empty block |
| `"0x5000"` (string scalar) | No | Yes (1 address) | Partial — missing criterion |
| `["0x5000"]` (1-element string array) | Yes | Yes | Yes |
| `["0x5000","0x5008","0x5010"]` (multi-element string array) | Yes | Yes | Yes |

**Rule:** Always use a string array with one element per variant value.

## Complete Example

```matlab
load_system(modelName);
slbuild(modelName);
descObj = coder.asap2.getEcuDescriptions(modelName, IncludeVariantCoding=true);

%% 1. Record Layouts
rlSelector = coder.asap2.RecordLayout;
rlSelector.Name = 'Scalar_UBYTE';
rlSelector.Record = struct('Name', 'FNC_VALUES', 'Position', 1, ...
    'DataType', 'UBYTE', 'IndexMode', 'COLUMN_DIR', ...
    'IndexOrder', '', 'AddressType', 'DIRECT');
add(descObj, rlSelector);

rlParam = coder.asap2.RecordLayout;
rlParam.Name = 'Scalar_FLOAT64';
rlParam.Record = struct('Name', 'FNC_VALUES', 'Position', 1, ...
    'DataType', 'FLOAT64_IEEE', 'IndexMode', 'COLUMN_DIR', ...
    'IndexOrder', '', 'AddressType', 'DIRECT');
add(descObj, rlParam);

%% 2. TAB_VERB COMPU_METHOD
compuMethod = coder.asap2.CompuMethod;
compuMethod.Name = 'CM_Platform';
compuMethod.LongIdentifier = 'Platform variant selection';
compuMethod.ConversionType = 'TAB_VERB';
compuMethod.Format = '%3.0';
compuMethod.Units = '';
compuMethod.CompuVTabValues.Values = [0, 1, 2];
compuMethod.CompuVTabValues.Literals = ["Diesel", "Petrol", "Hybrid"];
add(descObj, compuMethod);

%% 3. Selection Characteristic
selChar = coder.asap2.Characteristic;
selChar.Name = 'PlatformSelector';
selChar.LongIdentifier = 'Selects active platform variant';
selChar.Type = 'VALUE';
selChar.EcuAddress = '0x5000';
selChar.RecordLayout = 'Scalar_UBYTE';
selChar.CompuMethodName = 'CM_Platform';
selChar.LowerLimit = 0;
selChar.UpperLimit = 2;
add(descObj, selChar);

%% 4. Variant-dependent Characteristic
varParam = coder.asap2.Characteristic;
varParam.Name = 'BoostPressure';
varParam.LongIdentifier = 'Boost pressure calibration (variant-dependent)';
varParam.Type = 'VALUE';
varParam.EcuAddress = '0x6000';
varParam.RecordLayout = 'Scalar_FLOAT64';
varParam.CompuMethodName = 'CM_double';
varParam.LowerLimit = 0;
varParam.UpperLimit = 500;
add(descObj, varParam);

%% 5. VarCriterion
varCrit = coder.asap2.VarCriterion;
varCrit.Name = 'Platform';
varCrit.LongIdentifier = 'Vehicle platform type';
varCrit.Value = ["Diesel", "Petrol", "Hybrid"];
varCrit.VarSelectionCharacteristic = 'PlatformSelector';
add(descObj, varCrit);

%% 6. VarCharacteristic
varChar = coder.asap2.VarCharacteristic;
varChar.Name = 'BoostPressure';
varChar.CriterionName = "Platform";
varChar.VarAddress = ["0x6000", "0x6008", "0x6010"];
add(descObj, varChar);

%% Export
coder.asap2.export(modelName, CustomEcuDescriptions=descObj);
```

## Checklist

Before exporting variant coding, verify:

- [ ] Number of VarAddress elements matches number of VarCriterion.Value elements
- [ ] VarCriterion.Value is a string array (not char, not cell)
- [ ] VarCharacteristic.VarAddress is a string array (not char, not string scalar)
- [ ] CompuVTabValues.Literals is a string array (not cell array of char)
- [ ] Selection characteristic exists with matching CompuMethodName
- [ ] Variant-dependent characteristic exists with a RecordLayout
- [ ] Both characteristics have RecordLayouts added to descObj
- [ ] `IncludeVariantCoding=true` passed at getEcuDescriptions construction time

----

Copyright 2026 The MathWorks, Inc.

----

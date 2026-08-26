---
name: simulink-customize-a2l
description: >
  Customize A2L (ASAP2) files generated from Simulink models using coder.asap2
  and coder.mapping APIs. Use this skill when adding COMPU_METHODs, creating
  GROUPs, converting STD_AXIS to COM_AXIS, adding BIT_OPERATIONs, creating
  VARIANT_CODING, excluding measurements or struct elements, removing
  DEFAULT_EVENT_LIST, or any A2L customization for calibration
  tool compatibility (INCA, CANape). Also use when the user mentions ASAP2,
  ECU calibration data, A2L export.
license: https://www.mathworks.com/content/dam/mathworks/license/pmrl/license.md
metadata:
  author: MathWorks
  version: "1.0.0"
---

# Customize A2L Files

Customize A2L (ASAP2) files generated from Simulink models using the `coder.asap2` and `coder.mapping` APIs, avoiding silent errors and undocumented pitfalls.

## When to Use

- Adding or modifying COMPU_METHODs (LINEAR, RAT_FUNC, TAB_VERB, IDENTICAL)
- Creating or modifying GROUPs in the A2L file
- Converting STD_AXIS to COM_AXIS for lookup tables
- Adding BIT_OPERATION (LEFT_SHIFT, RIGHT_SHIFT, SIGN_EXTEND) to measurements
- Creating VARIANT_CODING (VarCriterion, VarCharacteristic)
- Excluding inports, outports, or struct elements from the A2L
- Removing DEFAULT_EVENT_LIST or other IF_DATA blocks
- Any customization passed via `CustomEcuDescriptions` to `coder.asap2.export`

## When NOT to Use

- Reading or parsing existing A2L files (use Vehicle Network Toolbox `a2lfile`)
- Configuring XCP/CAN transport layers
- Setting up Simulink model code generation (storage classes, data dictionaries)
- General Embedded Coder build workflows without A2L customization

## Core Workflow

### Decision: Direct export vs. customization workflow

- **No element customization needed** (only configuration like excluding struct elements or DEFAULT_EVENT_LIST): call `coder.asap2.export` directly with name-value options. No `getEcuDescriptions` needed.
- **Element customization needed** (adding/modifying/deleting measurements, characteristics, groups, etc.): use the full `getEcuDescriptions` → customize → export workflow.

```matlab
% === Path A: Config-only (no element changes) ===
load_system(modelName);
slbuild(modelName);
coder.asap2.export(modelName, SupportStructureElements=false, IncludeDefaultEventList=false);

% === Path B: Element customization ===
load_system(modelName);
slbuild(modelName);

% 1. Create ECU descriptions — pass ALL configuration options here
descObj = coder.asap2.getEcuDescriptions(modelName, ...
    SupportStructureElements=false, ...
    IncludeDefaultEventList=false);

% 2. Customize elements
add(descObj, newElement);
set(descObj, 'ElementType', 'Name', Prop=value);
info = get(descObj, 'ElementType', 'Name');
names = find(descObj, 'ElementType');
delete(descObj, 'ElementType', 'Name');

% 3. Export — MUST pass descObj back or all customizations are silently lost
coder.asap2.export(modelName, CustomEcuDescriptions=descObj);
```

**Critical:** When using Path B, omitting `CustomEcuDescriptions=descObj` in the export call silently discards all customizations with no error.

**Critical:** When using Path B, construction-time options (SupportStructureElements, etc.) CANNOT be passed to `export` alongside `CustomEcuDescriptions` — they must be passed to `getEcuDescriptions`.

## Key Functions

| Function | Purpose |
|----------|---------|
| `coder.asap2.getEcuDescriptions` | Create ECU description object (construction-time config) |
| `coder.asap2.export` | Export A2L file with customizations |
| `coder.asap2.CompuMethod` | Create computation method |
| `coder.asap2.Characteristic` | Create characteristic (parameter) |
| `coder.asap2.Measurement` | Create measurement (signal) |
| `coder.asap2.Group` | Create A2L group |
| `coder.asap2.RecordLayout` | Create record layout |
| `coder.asap2.AxisInfo` | Create axis points or axis descriptor |
| `coder.asap2.VarCriterion` | Create variant criterion |
| `coder.asap2.VarCharacteristic` | Create variant characteristic |
| `coder.asap2.Function` | Create FUNCTION object for grouping measurements/characteristics |
| `coder.mapping.api.get` | Get code mapping object (persistent settings) |
| `setInport` / `setOutport` | Control inport/outport A2L export (persistent) |

See `references/object-properties.md` for mandatory fields, valid types, and creation order for each `coder.asap2.*` class.

## Pattern Routing

Match the user's task to the correct reference for detailed guidance:

| Task | Key Rule | Reference |
|------|----------|-----------|
| Add COMPU_METHOD (RAT_FUNC, LINEAR, TAB_VERB) | RAT_FUNC COEFFS direction is **PHYS→INT** — invert the desired formula | `references/compu-method-guidance.md` |
| Convert STD_AXIS to COM_AXIS (shared breakpoints) | Use `ForceShared=true` on the Characteristic — do NOT manually create AXIS_PTS | `references/customization-patterns.md` |
| Add BIT_OPERATION to a measurement | Must set BOTH `BitMask` AND `MaskData` — either alone produces no output | `references/customization-patterns.md` |
| Exclude inports/outports persistently | Use `coder.mapping.api` + `setInport`/`setOutport` + `slbuild` | `references/customization-patterns.md` |
| Create VARIANT_CODING | Must create supporting CHARACTERISTIC objects (selection + variant-dependent) with RecordLayouts and CompuMethods BEFORE VarCriterion/VarCharacteristic. All multi-value properties must be string arrays (not char/cell). | `references/variant-coding-guidance.md` |
| Create Characteristic (CURVE, MAP, CUBOID) | RecordLayout struct array must match axis count for STD_AXIS types | `references/object-properties.md` |
| Create Measurement | Set `DataType='SWORD'`, `EcuAddress='@ECU_Address@name@'`, `CompuMethodName='NO_COMPU_METHOD'` as defaults | `references/object-properties.md` |
| Create Group | See mandatory fields and ROOT constraint | `references/object-properties.md` |
| Create RecordLayout | Struct array required for multi-axis types (MAP, CUBOID); single struct for VALUE/VAL_BLK | `references/object-properties.md` |
| Create AxisInfo / AXIS_PTS | Dual role: `add(descObj, axisInfo)` creates AXIS_PTS; `characteristic.AxisInfo = [...]` creates AXIS_DESCR | `references/object-properties.md` |
| Control construction-time options (SupportStructureElements, IncludeDefaultEventList, etc.) | Must pass at `getEcuDescriptions()` — cannot set after construction or pass to `export` with `CustomEcuDescriptions` | `references/construction-time-properties.md` |

## Release Requirements

| Feature | Minimum Release |
|---------|----------------|
| COMPU_METHOD, Measurement, Characteristic, BIT_OPERATION | R2022b |
| RecordLayout, AxisInfo (STD_AXIS, CUBOID) | R2023a |
| Group (ROOT groups) | R2023b |
| VarCriterion, VarCharacteristic (variant coding) | R2025a |

If the user's release is too old, inform them. Do not attempt workarounds — the APIs do not exist on older releases.

## Common Mistakes

These cause silent failures or incorrect calibration data. Always check before generating code:

| Mistake | Why It's Wrong | Correct Approach |
|---------|---------------|-----------------|
| `coder.asap2.export(modelName)` without `CustomEcuDescriptions=descObj` | Silently discards all customizations — no error, exports default A2L | Always pass `descObj` back when using the customization workflow |
| RAT_FUNC `Coefficients = [0 0.5 -40 0 0 1]` for "PHYS = 0.5×INT - 40" | COEFFS is PHYS→INT, not INT→PHYS — produces the inverse conversion | Invert: INT = 2×PHYS + 80 → `[0 2 80 0 0 1]`. See `references/compu-method-guidance.md` |
| `set(descObj, ..., 'CompuMethodName', name)` before adding the CompuMethod | `set()` auto-creates a placeholder that blocks subsequent `add()` | `delete()` the auto-created placeholder, then `add()` the user's version |
| `MaskData.Shift` without `BitMask` | BIT_OPERATION block is only emitted when both are set | Always set `BitMask` (e.g., `'0xFF'`) alongside `MaskData` |
| `MaskData.Shift = 3` expecting LEFT_SHIFT | Positive = RIGHT_SHIFT; sign is counterintuitive | Use `-3` for LEFT_SHIFT 3 |
| Manually creating AXIS_PTS for STD→COM_AXIS | Unnecessary complexity; error-prone struct array handling | Use `set(descObj, 'Characteristic', name, 'ForceShared', true)` |
| `descObj.SupportStructureElements = false` | Not a settable property after construction | Pass at creation: `getEcuDescriptions(mdl, SupportStructureElements=false)` |
| `VarAddress = '0x5000'` (char vector) | Char vector silently produces empty output — no addresses, no criterion name | Must be string array: `["0x5000","0x5008"]` |
| `CompuVTabValues.Integers = [0,1,2]` | Property does not exist | Use `CompuVTabValues.Values = [0, 1, 2]` |
| `CompuVTabValues.Literals = {'A','B'}` (cell array) | Accepted without error but exports 0 elements | Must be string array: `["A","B"]` |
| Skipping `slbuild` after `setInport`/`setOutport` | Export silently produces stale A2L with old settings | Always `slbuild` after code mapping changes before export |
| Hardcoding `EcuAddress = '0x0000'` | Calibration tools cannot resolve the address at import time | Use `'@ECU_Address@<elementName>@'` for linker resolution |
| Leaving mandatory fields unset on new objects | Blank fields produce invalid A2L — calibration tools reject the file | See `references/object-properties.md` for required fields per class |
| Creating VarCriterion/VarCharacteristic without supporting CHARACTERISTICs | VARIANT_CODING references characteristics that don't exist — calibration tool rejects the file | Create selection CHARACTERISTIC (with TAB_VERB CompuMethod) and variant-dependent CHARACTERISTIC (with RecordLayout) BEFORE VarCriterion/VarCharacteristic. See `references/variant-coding-guidance.md` |

## Conventions

- Verify A2L output with `fileread` after export — use `contains` for additions, `~contains` for deletions/exclusions
- Use string arrays (not char vectors or cell arrays) for all multi-value properties
- Pass all configuration at `getEcuDescriptions()` construction time
- Use `ForceShared=true` for STD→COM_AXIS (never build AXIS_PTS manually for this)
- Use `delete(descObj, 'ElementType', 'Name')` to remove auto-created placeholders — this is the only recovery from the auto-creation trap caused by `set()` on a reference name before the referenced object exists
- Prefer `coder.mapping.api` over `coder.asap2` when settings should persist with the model

----

Copyright 2026 The MathWorks, Inc.

----

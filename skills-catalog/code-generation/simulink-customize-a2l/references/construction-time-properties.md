# Construction-Time Properties

## The Pattern

These properties can be passed directly to `coder.asap2.export` when no element customization is needed. However, when using the customization workflow (`getEcuDescriptions` → add/set → export with `CustomEcuDescriptions`), they must be passed as name-value arguments to `getEcuDescriptions` at construction time. They cannot be set on the object afterward or passed to `export` alongside `CustomEcuDescriptions`.

## Full Property List

Reference: https://www.mathworks.com/help/rtw/ref/coder.asap2.export.html

| Property | Default | Purpose |
|----------|---------|---------|
| `SupportStructureElements` | `true` | Include/exclude struct-based measurements and characteristics |
| `IncludeDefaultEventList` | `true` | Include/exclude IF_DATA/DEFAULT_EVENT_LIST in measurements |
| `IndentFile` | `false` | Add indentation to exported A2L for readability |
| `Support64bitIntegers` | `true` | Include/exclude A_UINT64/A_INT64 type support |
| `IncludeAllRecordLayouts` | `false` | Export all base data type record layouts to `RecordLayouts.a2l` |
| `IncludeReferencedModels` | `true` | Include elements from referenced models |
| `IncludeVariantCoding` | `true` | Export VARIANT_CODING section |
| `IncludeSharedElements` | `true` | Export shared CompuMethods and record layouts (ERT-based targets) |
| `IncludeAutosarRteElements` | `true` | Export AUTOSAR RTE elements (classic AUTOSAR only) |
| `GenerateXCPInfo` | `true` | Include A2ML and IF_DATA blocks (requires Embedded Coder) |
| `FileName` | model name | Custom name for exported .a2l file |
| `Folder` | build folder | Custom output directory |
| `Comments` | `true` | Include comments in A2L output |
| `Version` | `'1.71'` | A2L file version (`'1.31'`, `'1.61'`, or `'1.71'`) |
| `EcuAddressExtension` | — | 16-bit integer for additional address information |
| `CustomizationObject` | default | Custom `coder.asap2.UserCustomizeBase` object |
| `CustomizeGroupsBy` | — | Group parameters/signals by type (SCALAR, MAP, CURVE, etc.) |
| `MapFile` | — | Symbol file (ELF, PDB, DWARF) to replace ECU addresses |
| `ModelClassInstanceName` | — | Custom model class instance name (AUTOSAR adaptive only) |
| `ToggleArrayLayout` | `false` | Switch array layout between ROW_DIR and COL_DIR |
| `UseSavedSettings` | `false` | Use previously saved preferences for generation |

## Correct Usage

```matlab
descObj = coder.asap2.getEcuDescriptions(modelName, ...
    SupportStructureElements=false, ...
    IncludeDefaultEventList=false, ...
    IndentFile=true, ...
    FileName='myModel_custom.a2l', ...
    Folder=pwd);
```

## What Fails

### Attempt 1: Set as property after construction

```matlab
descObj = coder.asap2.getEcuDescriptions(modelName);
descObj.SupportStructureElements = false;
```

**Error:** `Unrecognized property 'SupportStructureElements' for class 'coder.asap2.Data'`

The object returned by `getEcuDescriptions` is of class `coder.asap2.Data`, which does not expose these as settable properties.

### Attempt 2: Pass to export alongside CustomEcuDescriptions

```matlab
descObj = coder.asap2.getEcuDescriptions(modelName);
coder.asap2.export(modelName, ...
    CustomEcuDescriptions=descObj, ...
    SupportStructureElements=false);
```

**Error:** `'SupportStructureElements' must be specified with API coder.asap2.getEcuDescriptions()`

When using `CustomEcuDescriptions`, configuration properties cannot be passed to `export`.

### Correct: Pass at construction time

```matlab
descObj = coder.asap2.getEcuDescriptions(modelName, SupportStructureElements=false);
% Now customize normally
coder.asap2.export(modelName, CustomEcuDescriptions=descObj);
```

## Key Insight

The configuration is "baked in" at construction. Once created, the `descObj` reflects the filtered/configured state. All subsequent customizations (adding groups, modifying elements) operate on the already-configured data.

This means:
- With `SupportStructureElements=false`, struct-based measurements will not appear in `find(descObj, 'Measurement')`
- With `IncludeDefaultEventList=false`, no IF_DATA blocks will be present in the export regardless of other customizations
- `FileName` and `Folder` set where the export writes, overriding default build folder behavior

## Combining Multiple Properties

All construction-time properties can be combined in a single call:

```matlab
descObj = coder.asap2.getEcuDescriptions(modelName, ...
    SupportStructureElements=false, ...
    IncludeDefaultEventList=false, ...
    IndentFile=true, ...
    IncludeAllRecordLayouts=true, ...
    IncludeVariantCoding=true, ...
    FileName='production.a2l', ...
    Folder=fullfile(pwd, 'delivery'));
```

----

Copyright 2026 The MathWorks, Inc.

----

# A2L Customization Patterns

Detailed patterns for specific A2L customization tasks. Consult this reference when the user's task matches one of the patterns below.

## ForceShared: Convert STD_AXIS to COM_AXIS

To convert a lookup table's axes from STD_AXIS to COM_AXIS (shared breakpoints):

```matlab
descObj = coder.asap2.getEcuDescriptions(modelName);
set(descObj, 'Characteristic', 'lutName', 'ForceShared', true);
coder.asap2.export(modelName, CustomEcuDescriptions=descObj);
```

`ForceShared=true` automatically creates separate AXIS_PTS objects and converts all axis descriptors to COM_AXIS. Do NOT manually create AxisInfo objects and change AxisType — use this single property.

## BIT_OPERATION

Adding a BIT_OPERATION requires BOTH `BitMask` AND `MaskData` to be set. Setting `MaskData` alone produces no output.

```matlab
set(descObj, 'Measurement', measName, 'BitMask', '0xFF');
set(descObj, 'Measurement', measName, ...
    'MaskData', struct('Shift', shiftValue, 'SignExtend', 0));
```

**Sign convention:**

| MaskData.Shift | A2L Output | Meaning |
|----------------|-----------|---------|
| `+N` (positive) | `RIGHT_SHIFT N` | Shift bits right |
| `-N` (negative) | `LEFT_SHIFT N` | Shift bits left |
| `[]` (empty) | No shift | No shift applied |

**`MaskData.SignExtend`:** Set to `1` to add `SIGN_EXTEND` keyword inside BIT_OPERATION.

## Persistent Exclusion via Code Mapping API

When the user wants inports/outports excluded **persistently** (across future builds without `CustomEcuDescriptions`), use `coder.mapping.api` instead of `coder.asap2`:

```matlab
cm = coder.mapping.api.get(modelName);
setInport(cm, 'In1', 'Export', false);
setOutport(cm, 'Out1', 'Export', false);
save_system(modelName);
slbuild(modelName);  % REQUIRED — silent failure if skipped
coder.asap2.export(modelName);
```

**When to use which API:**

| Need | API | Persistence |
|------|-----|-------------|
| Per-export customization | `coder.asap2.getEcuDescriptions` + `CustomEcuDescriptions` | None — must pass every time |
| Persistent model setting | `coder.mapping.api.get` + `setInport`/`setOutport` | Saved with model |

**Important:** `slbuild` is required after `setInport`/`setOutport` changes. Skipping it produces stale A2L output with no error or warning.

If the model has no code mappings, create them first: `coder.mapping.utils.create(modelName)`.

## Characteristic Types and Axis Requirements

| Type | Axes | AxisInfo entries needed | Notes |
|------|------|----------------------|-------|
| `VALUE` | 0 | None | Scalar parameter |
| `VAL_BLK` | 0 | None | Array parameter — requires `Dimensions` property (maps to MATRIX_DIM in A2L) |
| `CURVE` | 1 | 1 (X) | 1-D lookup table |
| `MAP` | 2 | 2 (X, Y) | 2-D lookup table |
| `CUBOID` | 3 | 3 (X, Y, Z) | 3-D lookup table |
| `CUBE_4` | 4 | 4 (X, Y, Z, 4) | 4-D lookup table |
| `CUBE_5` | 5 | 5 (X, Y, Z, 4, 5) | 5-D lookup table |

See `references/object-properties.md` for RecordLayout struct array requirements per type.

----

Copyright 2026 The MathWorks, Inc.

----

# A2L Object Properties Reference

Consolidated reference for all `coder.asap2.*` object classes. Each section lists mandatory fields (must be set for valid A2L output) and commonly used optional fields.

## coder.asap2.Characteristic

Represents a calibration parameter (CHARACTERISTIC) in the A2L.

| Property | Mandatory | Type | Default | Notes |
|----------|-----------|------|---------|-------|
| `Name` | **Yes** | string | — | Must match an existing characteristic or be unique |
| `LongIdentifier` | **Yes** | string | — | Description/comments for the parameter |
| `Type` | **Yes** | enum | `'VALUE'` | `VALUE`, `CURVE`, `MAP`, `CUBOID`, `CUBE_4`, `CUBE_5`, `VAL_BLK`, `ASCII` |
| `EcuAddress` | **Yes** | string | `'0x0000'` | Use `'0x0000 /* @ECU_Address@ElementName@ */'` when address unknown |
| `RecordLayout` | **Yes** | string | `""` | Name of a RecordLayout that exists in descObj |
| `CompuMethodName` | **Yes** | string | `'NO_COMPU_METHOD'` | Name of a CompuMethod in descObj |
| `LowerLimit` | **Yes** | numeric | — | Minimum possible value |
| `UpperLimit` | **Yes** | numeric | — | Maximum possible value |
| `Format` | No | string | `""` | Display format (e.g., `'%8.3'`) |
| `CalibrationAccess` | No | enum | `'Calibration'` | `Calibration`, `NoCalibration`, `NotAccessible`, `ReadOnly`, `ReadWrite` |
| `DisplayIdentifier` | No | string | `""` | Display name in calibration tool |
| `BitMask` | No | hex string | `[]` | Bit mask for single-bit handling |
| `AxisInfo` | No | AxisInfo array | `[]` | Required for CURVE/MAP types |
| `ExportArrayAsFixAxis` | No | logical | `false` | Export array as FIX_AXIS lookup table |
| `Transpose` | No | logical | `false` | Transpose axis (lookup tables only) |
| `ComparisonQuantity` | No | string | — | Valid measurement name as reference |
| `Dimensions` | No | numeric | `[]` | Dimensions for array data type |
| `ForceShared` | No | logical | `false` | Converts STD_AXIS to COM_AXIS |
| `Export` | No | logical | `true` | Set `false` to exclude from A2L |
| `EcuAddressComment` | No | string | `""` | Symbols for address replacement |
| `EcuAddressExtension` | No | integer | `[]` | Additional address information |
| `SymbolLink` | No | struct | — | `struct('SymbolName','name','Offset',N)` |
| `MaxRefresh` | No | struct | — | `struct('ScalingUnit',unit,'Rate',N)` |
| `CustomData` | No | string | `""` | Additional description in the characteristic |

**Dependencies:** `RecordLayout` must reference a RecordLayout already added to `descObj`. `CompuMethodName` must reference an existing CompuMethod.

**EcuAddress convention:** When the user has not specified a specific address, use the placeholder format that enables linker-based address replacement:
```
'0x0000 /* @ECU_Address@ElementName@ */'
```
This is the same format MATLAB generates for model-derived elements. The `@ECU_Address@...@` marker is embedded in the `EcuAddress` string itself (not in `EcuAddressComment`).

## coder.asap2.Measurement

Represents a signal/variable (MEASUREMENT) in the A2L.

| Property | Mandatory | Type | Default | Notes |
|----------|-----------|------|---------|-------|
| `Name` | **Yes** | string | — | Must match an existing measurement or be unique |
| `LongIdentifier` | **Yes** | string | — | Description/comments for the variable |
| `DataType` | **Yes** | string | `'UBYTE'` | `UBYTE`, `SBYTE`, `UWORD`, `SWORD`, `ULONG`, `SLONG`, `A_UINT64`, `A_INT64`, `FLOAT32_IEEE`, `FLOAT64_IEEE` |
| `EcuAddress` | **Yes** | string | `'0x0000'` | Use `'0x0000 /* @ECU_Address@ElementName@ */'` when address unknown |
| `CompuMethodName` | **Yes** | string | `""` | Name of a CompuMethod in descObj |
| `LowerLimit` | **Yes** | numeric | — | Minimum possible value |
| `UpperLimit` | **Yes** | numeric | — | Maximum possible value |
| `Format` | No | string | `""` | Display format (e.g., `'%8.3'`) |
| `CalibrationAccess` | No | enum | `'NoCalibration'` | `Calibration`, `NoCalibration`, `NotAccessible`, `ReadOnly`, `ReadWrite` |
| `DisplayIdentifier` | No | string | `""` | Display name in calibration tool |
| `BitMask` | No | hex string | `[]` | Required alongside MaskData for BIT_OPERATION |
| `MaskData` | No | struct | — | `struct('Shift', N, 'SignExtend', 0or1)` — requires BitMask |
| `Dimensions` | No | numeric | `[]` | Dimensions for array data type |
| `Export` | No | logical | `true` | Set `false` to exclude from A2L |
| `EcuAddressComment` | No | string | `""` | Symbols for address replacement |
| `EcuAddressExtension` | No | integer | `[]` | Additional address information |
| `SymbolLink` | No | struct | — | `struct('SymbolName','name','Offset',N)` |
| `MaxRefresh` | No | struct | — | `struct('ScalingUnit',unit,'Rate',N)` |
| `CustomData` | No | string | `""` | Additional description in the measurement |

**BIT_OPERATION dependency:** Both `BitMask` AND `MaskData` must be set together. Setting `MaskData` alone produces no output.

## coder.asap2.RecordLayout

Defines data storage format for characteristics and axis points.

| Property | Mandatory | Type | Default | Notes |
|----------|-----------|------|---------|-------|
| `Name` | **Yes** | string | — | Unique name (e.g., `'Scalar_FLOAT64'`) |
| `Record` | **Yes** | struct or struct array | — | Single struct for scalars/1-D; struct array for multi-dimensional (MAP, CUBOID, etc.) |
| `CustomData` | No | string | `""` | Additional description for the record layout |

**Record struct fields (all required per entry):**

| Field | Type | Valid Values | Notes |
|-------|------|-------------|-------|
| `Name` | string | `'FNC_VALUES'`, `'AXIS_PTS_X'`, `'AXIS_PTS_Y'`, `'AXIS_PTS_Z'`, `'AXIS_PTS_4'`, `'AXIS_PTS_5'` | `FNC_VALUES` for values, `AXIS_PTS_X/Y/Z/4/5` for axis dimensions |
| `Position` | numeric | Sequential (1, 2, 3, ...) | Position in the record layout |
| `DataType` | string | `'UBYTE'`, `'SBYTE'`, `'UWORD'`, `'SWORD'`, `'ULONG'`, `'SLONG'`, `'A_UINT64'`, `'A_INT64'`, `'FLOAT32_IEEE'`, `'FLOAT64_IEEE'` | A2L data type |
| `IndexMode` | string | `'COLUMN_DIR'`, `'ROW_DIR'`, `'INDEX_INCR'` | `COLUMN_DIR` for FNC_VALUES; `INDEX_INCR` only for AXIS_PTS_X/Y/Z |
| `IndexOrder` | string | `''` (empty) | Usually empty |
| `AddressType` | string | `'DIRECT'`, `''` (empty) | `'DIRECT'` for standard layouts |

**IndexMode usage:**

| Record.Name | IndexMode | Use case |
|-------------|-----------|----------|
| `FNC_VALUES` | `'COLUMN_DIR'` | Scalar/array characteristics and measurements |
| `FNC_VALUES` | `'ROW_DIR'` | Row-major array layout |
| `AXIS_PTS_X` / `AXIS_PTS_Y` / `AXIS_PTS_Z` | `'INDEX_INCR'` | Axis point definitions |

**Struct array for STD_AXIS multi-dimensional types:**

For STD_AXIS characteristics (CURVE, MAP, CUBOID, CUBE_4, CUBE_5), `Record` must be a struct array containing axis entries and FNC_VALUES. Each axis dimension gets its own `AXIS_PTS_*` entry at sequential positions, with `FNC_VALUES` last. This applies only to STD_AXIS — COM_AXIS characteristics use `FNC_VALUES` only (axis data lives in separate AXIS_PTS objects).

| Characteristic Type | AxisType | Record entries needed |
|--------------------|----------|---------------------|
| VALUE, VAL_BLK, ASCII | — | `FNC_VALUES` only (single struct) |
| CURVE (STD_AXIS) | STD_AXIS | `AXIS_PTS_X` + `FNC_VALUES` (struct array, 2 entries) |
| MAP (STD_AXIS) | STD_AXIS | `AXIS_PTS_X` + `AXIS_PTS_Y` + `FNC_VALUES` (struct array, 3 entries) |
| CUBOID (STD_AXIS) | STD_AXIS | `AXIS_PTS_X` + `AXIS_PTS_Y` + `AXIS_PTS_Z` + `FNC_VALUES` (struct array, 4 entries) |
| CUBE_4 (STD_AXIS) | STD_AXIS | `AXIS_PTS_X` + `AXIS_PTS_Y` + `AXIS_PTS_Z` + `AXIS_PTS_4` + `FNC_VALUES` (struct array, 5 entries) |
| CUBE_5 (STD_AXIS) | STD_AXIS | `AXIS_PTS_X` + `AXIS_PTS_Y` + `AXIS_PTS_Z` + `AXIS_PTS_4` + `AXIS_PTS_5` + `FNC_VALUES` (struct array, 6 entries) |
| CURVE/MAP/CUBOID/CUBE_4/CUBE_5 (COM_AXIS) | COM_AXIS | `FNC_VALUES` only (axes are separate AXIS_PTS objects) |

**Examples:**

```matlab
% Scalar — single struct (also used for COM_AXIS characteristic values)
rl = coder.asap2.RecordLayout;
rl.Name = 'Scalar_FLOAT64';
rl.Record = struct('Name', 'FNC_VALUES', 'Position', 1, ...
    'DataType', 'FLOAT64_IEEE', 'IndexMode', 'COLUMN_DIR', ...
    'IndexOrder', '', 'AddressType', 'DIRECT');

% Axis points RecordLayout (for COM_AXIS AXIS_PTS objects)
rlAxis = coder.asap2.RecordLayout;
rlAxis.Name = 'Axis_FLOAT64';
rlAxis.Record = struct('Name', 'AXIS_PTS_X', 'Position', 1, ...
    'DataType', 'FLOAT64_IEEE', 'IndexMode', 'INDEX_INCR', ...
    'IndexOrder', '', 'AddressType', 'DIRECT');

% STD_AXIS MAP — struct array with X, Y, and FNC_VALUES
rlMap = coder.asap2.RecordLayout;
rlMap.Name = 'Map_FLOAT32';
rlMap.Record = [
    struct('Name', 'AXIS_PTS_X', 'Position', 1, ...
        'DataType', 'FLOAT32_IEEE', 'IndexMode', 'INDEX_INCR', ...
        'IndexOrder', '', 'AddressType', 'DIRECT'), ...
    struct('Name', 'AXIS_PTS_Y', 'Position', 2, ...
        'DataType', 'FLOAT32_IEEE', 'IndexMode', 'INDEX_INCR', ...
        'IndexOrder', '', 'AddressType', 'DIRECT'), ...
    struct('Name', 'FNC_VALUES', 'Position', 3, ...
        'DataType', 'FLOAT32_IEEE', 'IndexMode', 'COLUMN_DIR', ...
        'IndexOrder', '', 'AddressType', 'DIRECT')];

% STD_AXIS CUBOID — struct array with X, Y, Z, and FNC_VALUES
rlCuboid = coder.asap2.RecordLayout;
rlCuboid.Name = 'Cuboid_FLOAT32';
rlCuboid.Record = [
    struct('Name', 'AXIS_PTS_X', 'Position', 1, ...
        'DataType', 'FLOAT32_IEEE', 'IndexMode', 'INDEX_INCR', ...
        'IndexOrder', '', 'AddressType', 'DIRECT'), ...
    struct('Name', 'AXIS_PTS_Y', 'Position', 2, ...
        'DataType', 'FLOAT32_IEEE', 'IndexMode', 'INDEX_INCR', ...
        'IndexOrder', '', 'AddressType', 'DIRECT'), ...
    struct('Name', 'AXIS_PTS_Z', 'Position', 3, ...
        'DataType', 'FLOAT32_IEEE', 'IndexMode', 'INDEX_INCR', ...
        'IndexOrder', '', 'AddressType', 'DIRECT'), ...
    struct('Name', 'FNC_VALUES', 'Position', 4, ...
        'DataType', 'FLOAT32_IEEE', 'IndexMode', 'COLUMN_DIR', ...
        'IndexOrder', '', 'AddressType', 'DIRECT')];
```

## coder.asap2.CompuMethod

Defines conversion between internal (ECU) and physical values.

| Property | Mandatory | Type | Default | Notes |
|----------|-----------|------|---------|-------|
| `Name` | **Yes** | string | — | Unique name (e.g., `'CM_Temperature'`) |
| `LongIdentifier` | **Yes** | string | — | Description/comments for the computation method |
| `ConversionType` | **Yes** | enum | — | `'LINEAR'`, `'RAT_FUNC'`, `'TAB_VERB'`, `'IDENTICAL'` |
| `Coefficients` | **Yes** (LINEAR/RAT_FUNC) | numeric array | — | `[a b]` for LINEAR, `[a b c d e f]` for RAT_FUNC |
| `Units` | **Yes** | string | — | Physical unit (e.g., `'degC'`, `'kPa'`, `''` for dimensionless) |
| `Format` | **Yes** | string | `""` | Display format (e.g., `'%8.3'`) |
| `CompuVTabValues` | **Yes** (TAB_VERB) | struct | — | See below |
| `CustomData` | No | string | `""` | Additional description for the computation method |

**CompuVTabValues struct (for TAB_VERB):**

| Field | Type | Constraint |
|-------|------|-----------|
| `Values` | numeric array | Integer values (e.g., `[0, 1, 2]`). Must match length of Literals. |
| `Literals` | **string array** | **Must be string array**, not cell array. Cell array silently exports 0 elements. |

**Coefficients direction reminder:**

| ConversionType | Direction | Example |
|----------------|-----------|---------|
| `LINEAR` | INT→PHYS | `[1000 0]` means PHYS = 1000×INT |
| `RAT_FUNC` | **PHYS→INT** | `[0 2 80 0 0 1]` means INT = 2×PHYS + 80 |

**When to use IDENTICAL or NO_COMPU_METHOD:**

If the user has not specified a unit conversion, use `'IDENTICAL'` (no scaling, physical = internal) or reference `'NO_COMPU_METHOD'` on the Characteristic/Measurement. Do not create unnecessary LINEAR or RAT_FUNC CompuMethods with identity coefficients — use IDENTICAL instead.

```matlab
% IDENTICAL — use when no conversion needed but you want a named method
cm = coder.asap2.CompuMethod;
cm.Name = 'CM_NoConversion';
cm.LongIdentifier = 'No conversion';
cm.ConversionType = 'IDENTICAL';
cm.Units = '';
cm.Format = '%8.3';
```

## coder.asap2.Group

Organizes characteristics and measurements into logical groups.

| Property | Mandatory | Type | Default | Notes |
|----------|-----------|------|---------|-------|
| `Name` | **Yes** | string | — | Unique group name |
| `LongIdentifier` | **Yes** | string | — | Description/comments for the group |
| `Root` | Recommended | logical | `false` | Only one ROOT group allowed per A2L |
| `RefCharacteristic` | Recommended | string array | `[]` | Names of characteristics in this group |
| `RefMeasurement` | Recommended | string array | `[]` | Names of measurements in this group |
| `SubGroup` | No | string array | `[]` | Names of child groups |
| `CustomData` | No | string | `""` | Additional description for the group |


## coder.asap2.AxisInfo

Defines axis descriptors for lookup tables (CURVE, MAP, etc.). Per the ASAM standard, AXIS_DESCR has 6 mandatory positional parameters.

| Property | Mandatory | Type | Default | Notes |
|----------|-----------|------|---------|-------|
| `Name` | **Yes** | string | — | Axis object name |
| `AxisType` | **Yes** | enum | — | `'STD_AXIS'`, `'COM_AXIS'`, `'FIX_AXIS'` |
| `InputQuantity` | **Yes** | string | `'NO_INPUT_QUANTITY'` | Measurement name for input (use `'NO_INPUT_QUANTITY'` if none) |
| `CompuMethodName` | **Yes** | string | — | Conversion method name |
| `MaxAxisPoints` | **Yes** | numeric | — | Maximum number of axis points |
| `LowerLimit` | **Yes** | numeric | — | Minimum possible value |
| `UpperLimit` | **Yes** | numeric | — | Maximum possible value |
| `RecordLayout` | Conditional | string | — | Required when used as AXIS_PTS object (added directly to descObj) |
| `EcuAddress` | Conditional | string | `'0x0000'` | Required when used as AXIS_PTS object; use `@ECU_Address@` format |
| `LongIdentifier` | No | string | — | Description/comments for the axis |
| `AxisPointsRef` | No | string | — | For COM_AXIS: reference to AXIS_PTS record |
| `FixAxisType` | No | enum | — | `'FIX_AXIS_PAR'`, `'FIX_AXIS_PAR_DIST'`, `'FIX_AXIS_PAR_LIST'` |
| `Distance` | No | numeric | — | For FIX_AXIS_PAR/FIX_AXIS_PAR_DIST |
| `Offset` | No | numeric | — | For FIX_AXIS_PAR types; also list of values for FIX_AXIS_PAR_LIST |
| `Format` | No | string | — | Display format (e.g., `'%4.2'`) |
| `DisplayIdentifier` | No | string | — | Display name in calibration tool |
| `CalibrationAccess` | No | enum | — | `'Calibration'`, `'NoCalibration'` |
| `EcuAddressComment` | No | string | — | Symbols for address replacement |
| `EcuAddressExtension` | No | integer | — | Additional address information |
| `SymbolLink` | No | struct | — | `struct('SymbolName','name','Offset',N)` |
| `MaxRefresh` | No | struct | — | `struct('ScalingUnit',unit,'Rate',N)` |
| `CustomData` | No | string | — | Additional description for the axis |

**Note:** For converting an existing STD_AXIS to COM_AXIS, prefer `ForceShared=true` on the Characteristic. For creating a new COM_AXIS lookup table from scratch, use AxisInfo objects as described below.

**Dual role of AxisInfo:**

`coder.asap2.AxisInfo` serves two purposes depending on how it is used:

| Usage | AxisType | Result in A2L |
|-------|----------|---------------|
| `add(descObj, axisInfo)` — added directly | Leave empty (`""`) | Creates an **AXIS_PTS** object (shared breakpoints) |
| `characteristic.AxisInfo = [ax1, ax2]` | Set to `'COM_AXIS'` | Creates **AXIS_DESCR** inside the Characteristic |

**Creating a new COM_AXIS MAP from scratch:**

1. Create RecordLayouts (`FNC_VALUES` for values, `AXIS_PTS_X` for axes)
2. Create AXIS_PTS objects: `add(descObj, axisInfo)` with no `AxisType`, setting `Name`, `EcuAddress`, `RecordLayout`, `CompuMethodName`, `MaxAxisPoints`, `LowerLimit`, `UpperLimit`
3. Create axis descriptors with `AxisType='COM_AXIS'` and `AxisPointsRef` pointing to the AXIS_PTS name
4. Assign descriptors to Characteristic: `mapChar.AxisInfo = [axDescX, axDescY]`
5. Add the Characteristic: `add(descObj, mapChar)`

The element type for `find`/`get`/`set` operations on AXIS_PTS is `'AxisPoint'` (not `'AxisPts'` or `'AXIS_PTS'`).

## coder.asap2.VarCriterion

Defines a variant dimension for VARIANT_CODING.

| Property | Mandatory | Type | Default | Notes |
|----------|-----------|------|---------|-------|
| `Name` | **Yes** | string | — | Criterion name (e.g., `'Platform'`) |
| `LongIdentifier` | **Yes** | string | — | Description of the variant criterion |
| `Value` | **Yes** | **string array** | — | Variant values. **Must be string array** `["a","b","c"]`. Values must be unique. |
| `VarSelectionCharacteristic` | Recommended | string | — | Name of selection characteristic |
| `VarMeasurement` | No | string | — | Measurement indicating active variant on ECU |

**Type constraint:** `Value` must be a string array. Char vectors and cell arrays produce errors.

## coder.asap2.VarCharacteristic

Links a parameter to variant criteria with per-variant addresses.

| Property | Mandatory | Type | Default | Notes |
|----------|-----------|------|---------|-------|
| `Name` | **Yes** | string | — | Must match an existing Characteristic name |
| `CriterionName` | **Yes** | string | — | Name of a VarCriterion. String array for multiple criteria. |
| `VarAddress` | **Yes** | **string array** | — | One address per variant value. **Must be string array** `["0x..","0x.."]` |

**Type constraint:** `VarAddress` must be a string array. Char vector silently produces empty output. Number of elements must match `VarCriterion.Value` count.

**Dependencies:** The named Characteristic and VarCriterion must already exist in `descObj`.

## Creation Order for Complex Customizations

When creating elements that reference each other, add them in dependency order:

1. **RecordLayout** — no dependencies
2. **CompuMethod** — no dependencies
3. **Characteristic** — depends on RecordLayout, CompuMethod
4. **Measurement** — depends on CompuMethod (optional)
5. **AxisInfo** — depends on RecordLayout, CompuMethod (but prefer ForceShared instead)
6. **Group** — depends on Characteristic, Measurement names
7. **VarCriterion** — depends on selection Characteristic
8. **VarCharacteristic** — depends on Characteristic, VarCriterion

----

Copyright 2026 The MathWorks, Inc.

----

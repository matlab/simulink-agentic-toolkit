# Fix Recipes

Procedures for resolving raccel incompatibilities. Each recipe corresponds to a category in `incompatibility-catalog.md`.

## Replace Interpreted MATLAB Function (MATLABFcn)

This is the most common blocker. The `MATLABFcn` block calls the MATLAB interpreter at runtime, which is not available during code generation.

**Validated alternatives** (all confirmed raccel-compatible in R2026b):

| Alternative Block | Library Path | Use Case |
|-------------------|--------------|----------|
| **MATLAB Function** | `simulink/User-Defined Functions/MATLAB Function` | Complex logic (Stateflow-based, full codegen) |
| **Fcn** | `simulink/User-Defined Functions/Fcn` | Simple expressions (`sin(u(1))`, `u(1)^2 + 3`) |
| **Trigonometric Function** | `simulink/Math Operations/Trigonometric Function` | `sin`, `cos`, `tan`, `atan2`, etc. |
| **Math Function** | `simulink/Math Operations/Math Function` | `exp`, `log`, `sqrt`, `pow`, etc. |
| **Gain** | `simulink/Math Operations/Gain` | Scalar/matrix multiplication |
| **Lookup Table** | `simulink/Lookup Tables/1-D Lookup Table` | Interpolated data mapping |

Use `replace_block` to swap — this preserves the block name, position, and all existing connections.

## Replace Level-2 MATLAB S-Function

1. **Read the S-function source** to understand what it computes:
   ```matlab
   type('sfcn_name.m')
   ```

2. **Identify the equivalent built-in block** based on the Output method:
   - `output = input * constant` → **Gain** block
   - `output = input + constant` → **Sum** + **Constant** blocks
   - `output = fcn(input)` → **Fcn** or **MATLAB Function** block
   - Table lookup → **Lookup Table** block
   - Delay/memory → **Unit Delay** or **Memory** block

3. **Replace using `model_edit`** with `replace_block` operation:
   ```json
   [{"op": "replace_block", "target": "blk_X", "type": "Gain", "params": {"Gain": "2"}}]
   ```

4. **If the S-function is too complex** to replace with a single built-in block, inform the user that a TLC file is needed and cannot be auto-generated.

## Change Logging Format

Use `model_edit` to change the configuration parameter:

```json
[{"op": "configure", "target": "config:ModelName", "params": {"SaveFormat": "StructureWithTime"}}]
```

## Disable Profiling

Use `model_edit` to change the configuration parameter:

```json
[{"op": "configure", "target": "config:ModelName", "params": {"Profile": "off"}}]
```

## Fix Data Type Issues

Use `model_edit` to change block parameters:

```json
[{"op": "configure", "target": "blk_X", "params": {"OutDataTypeStr": "single"}}]
```

For int64 interpolation:

```json
[{"op": "configure", "target": "blk_X", "params": {"Interpolate": "off"}}]
```

For >64-bit fixed-point, reduce to standard word length:

```json
[{"op": "configure", "target": "blk_X", "params": {"OutDataTypeStr": "fixdt(0, 64, 0.000002, 0.00)"}}]
```

**Note on >64-bit fixed-point:** The raccel RTP serialization pathway cannot represent fixed-point types with word length > 64. This affects blocks like `DataStoreMemory` that carry fixed-point types but have no signal ports. When reducing word length, verify that the reduced precision still meets the model's accuracy requirements.

## Fix ToFile Filename Collision

Use `model_edit` to rename the output file so it does not match the model name:

```json
[{"op": "configure", "target": "blk_X", "params": {"Filename": "ModelName_output.mat"}}]
```

## Fix Working Directory

If the build fails with `RTW:buildProcess:buildDirInMatlabDir`:

```matlab
cd(tempdir);
% or
cd(userpath);
```

## Display/Scope Blocks (No Action Needed)

As of R2026b, Display and Scope blocks are fully functional in Rapid Accelerator mode — they update live during simulation. Do NOT flag these blocks at any severity level.

----

Copyright 2026 The MathWorks, Inc.

----

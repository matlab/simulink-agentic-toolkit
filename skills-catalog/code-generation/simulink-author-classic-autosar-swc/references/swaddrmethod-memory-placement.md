# SwAddrMethod and Memory Placement

Use this reference when assigning AUTOSAR memory-placement intent to generated runnable code, runnable-owned internal data, or IRVs.

Memory-placement APIs and generated artifact shapes vary by release and
modeling style. Use `matlab-read-documentation` to verify signatures and
supported properties before extending these patterns.

---

## Distinguish code, per-runnable internal data, defaults, and IRVs

Do not treat all SwAddrMethod requests as the same operation:

- Runnable code placement controls the memory section for the generated runnable function.
- Per-runnable internal-data placement controls internal data owned by a specific rate-based/exported/global function.
- Component or model defaults affect broad classes of internal data and are not the same as "the internal data of this runnable."
- IRV placement sets the `SwAddrMethod` property on the AUTOSAR property-tree data node for that IRV.

If the user asks "also use it for internal data of the runnable," do not silently change the default for all internal data. Apply a per-function internal-data setting to the specific mapped function when the workflow supports it.

---

## Custom SwAddrMethod preflight

Before mapping a custom method name, inspect the existing methods. In a
generated component model, create an approved missing method in the existing
SwAddrMethods package with the documented section type:

```matlab
arProps = autosar.api.getAUTOSARProperties(modelName);
methodPaths = string(find(arProps, [], "SwAddrMethod", ...
    "PathType", "FullyQualified"));

if ~any(endsWith(methodPaths, "/CODE_ASIL_D"))
    addPackageableElement(arProps, "SwAddrMethod", ...
        "/DataTypes/SwAddrMethods", "CODE_ASIL_D", ...
        "SectionType", "Code");
end
if ~any(endsWith(methodPaths, "/VAR_ASIL_D"))
    addPackageableElement(arProps, "SwAddrMethod", ...
        "/DataTypes/SwAddrMethods", "VAR_ASIL_D", ...
        "SectionType", "Var");
end
```

Keep the empty scope argument `[]` in
`find(arProps, [], "SwAddrMethod", "PathType", "FullyQualified")`; it searches
the full property tree for existing methods.

`/DataTypes/SwAddrMethods` is the standard package in a generated component
model. For an imported or platform-owned package, derive the package from the
fully qualified method paths instead of guessing a new path. Do not use raw
AUTOSAR specification tokens as `SectionType` values.

---

## Runnable mapping recipe

For per-function internal data, configure grouping before mapping:

```json
[{"op":"configure","target":"config:<modelName>","params":{"GroupInternalDataByFunction":"on"}}]
```

Use `model_edit` at `root` with `layout_mode="incremental"`. If this
prerequisite is missing, `autosar.api.validateModel(modelName)` can identify
the configuration error.

Then use the Simulink Mapping API and pass the Simulink entry-point function returned by `find(slMap, "Functions")`, not the AUTOSAR runnable path or short name:

```matlab
slMap = autosar.api.getSimulinkMapping(modelName);

functions = string(find(slMap, "Functions"));
% Example values can include "Initialize" or "ExportedFunction:fc_periodic".
% Select the returned entry that corresponds to the intended non-Initialize
% Simulink function; do not replace this with an AUTOSAR runnable name.
slEntryPointFunction = "ExportedFunction:fc_periodic";
assert(any(functions == slEntryPointFunction), ...
    "Select the target entry point reported by find(slMap,'Functions').");

mapFunction(slMap, slEntryPointFunction, "PeriodicRunnable", ...
    "SwAddrMethod", "CODE_ASIL_D", ...
    "SwAddrMethodForInternalData", "VAR_ASIL_D");
```

Rules:

- `SwAddrMethod` and `SwAddrMethodForInternalData` are separate name-value arguments.
- `SwAddrMethod` applies to the runnable code section.
- `SwAddrMethodForInternalData` applies to internal data for the mapped rate-based/exported/global function.
- Passing the AUTOSAR runnable name where the Simulink entry-point function is expected can fail, especially for export-function models.
- `Initialize` cannot receive `SwAddrMethodForInternalData`; this per-function setting is limited to supported rate-based, exported, or global functions.
- Select the target non-`Initialize` entry from the result of `find(slMap, "Functions")` before calling `mapFunction`. Do not guess the entry-point prefix or pass an AUTOSAR property-tree path.
- When explaining this per-function setting, contrast the IRV exception: IRV placement sets `SwAddrMethod` on its property-tree data node, not `SwAddrMethodForInternalData`.

The default built-in method names commonly include `CODE`, `CONST`, and `VAR`, but do not assume custom method names exist. Use the preflight above to create or verify the exact approved names before mapping to them. Configure `GroupInternalDataByFunction` before setting `SwAddrMethodForInternalData`. Reopen the model only when investigating saved memory-placement state.

---

## IRV placement

IRV placement is not `SwAddrMethodForInternalData`: set the `SwAddrMethod` property on the IRV data node in the AUTOSAR property tree:

```matlab
arProps = autosar.api.getAUTOSARProperties(modelName);
ibPath = "/Components/MyModel/MyModel_InternalBehavior";

set(arProps, ibPath + "/IRV_Data", ...
    "SwAddrMethod", "/DataTypes/SwAddrMethods/VAR_ASIL_D");
```

Create the IRV data node before mapping data transfers to it. See `client-server-and-irv-patterns.md` for the create-before-map sequence and IRV-specific add/find category notes.

---

## Generated artifact expectations

When generated artifacts are requested, inspect placement in the right
artifact:

- Runnable code placement should appear as a runnable `SW-ADDR-METHOD-REF` in ARXML and usually as `START_SEC_<code>` / `STOP_SEC_<code>` MemMap pairs around the generated runnable function in component C.
- IRV and internal-data placement should be verified first in ARXML as the relevant data/prototype `SW-ADDR-METHOD-REF`.
- Do not expect all VAR/internal-data placements to appear as memory sections in `<model>.c`. Data accessed through `Rte_IrvRead_*`, `Rte_IrvWrite_*`, or other RTE-owned storage may be owned by generated RTE code outside the component C file.

----

Copyright 2026 The MathWorks, Inc.

----

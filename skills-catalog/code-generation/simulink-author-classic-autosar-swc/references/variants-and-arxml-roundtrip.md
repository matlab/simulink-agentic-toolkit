# Update a Classic AUTOSAR SWC from ARXML

Use this reference when an existing Classic AUTOSAR software component model
originates from ARXML, must preserve imported component intent, or selects a
predefined variant.

## Import and Update APIs

Use the importer as the entry point for a component description:

```matlab
ar = arxml.importer("myDescriptions.arxml");
updateModel(ar, modelName, OpenReport="off");
updateAUTOSARProperties(ar, modelName, OpenReport="off");
```

Use `updateModel` when external ARXML changes must update the Simulink
component structure, such as ports, runnables, or implementation mappings.
Use `updateAUTOSARProperties` when only component metadata, packages, or
referenced definitions must refresh without rebuilding the block diagram.

## Select Variants Deliberately

When the source defines variant choices, use the documented importer or update
arguments instead of custom post-import filtering:

- `PredefinedVariant`
- `SystemConstValueSets`

Use `matlab-read-documentation` to verify the exact active-release form before
combining variant options with an import or update call.

## Import a Component Model

For a new component import, make the runnable representation intentional:

- Use `ModelPeriodicRunnablesAs="Auto"` unless a specific representation is
  required.
- Use `UseBusElementPorts=true` when the selected component interface should
  be represented with Bus Element ports.
- Use `UseValueTypes=true` when the imported component data types should
  remain modeled as value types.
- Preserve an existing component data dictionary when one is supplied. Do not
  replace it with base-workspace definitions during an update.

For example:

```matlab
ar = arxml.importer("CooltSysDiagcAndCtrl_swc.arxml");
createComponentAsModel(ar, "/AutosarTEPackage/ComponentTypes/CooltSysCtrl", ...
    "DataDictionary", "dCooltSysCtrl.sldd", ...
    "ModelPeriodicRunnablesAs", "Auto", ...
    "UseBusElementPorts", true);
```

## Preserve Supplier-Owned Content

Treat a supplier ARXML file as source material. Preserve it unchanged while
updating the selected component model. Generated component ARXML commonly
differs in schema formatting, UUIDs, package layout, or file partitioning.

When a supplier file contains content outside the selected SWC:

1. Update only the component model that the user identified.
2. Use `updateModel` or `updateAUTOSARProperties` only for a changed upstream
   description, not solely to eliminate a textual difference.
3. Treat incorporation of generated component output into a broader supplier
   delivery as a separate integration activity.

A successful component round trip preserves the requested component semantics;
it does not require byte-for-byte equality with the source ARXML.

----

Copyright 2026 The MathWorks, Inc.

----

# AUTOSAR Property Tree Mutation Rules

Use this reference for the stable mutation rules that prevent destructive
changes and stale-path failures. For a release-specific property or an API
outside these examples, consult `matlab-read-documentation` before mutating
the model.

## Category grammar

`find()` takes a singular category. `add()` normally takes the plural parent
collection:

```matlab
runnables = find(arProps, [], "Runnable");
add(arProps, swcPath, "ClientPorts", portName, ...
    "Interface", interfacePath);
```

The IRV collection is the exception:

```matlab
add(arProps, internalBehaviorPath, "IRV", "IRV_Data");
```

Use [property-tree-categories.md](property-tree-categories.md) for the
supported `find` categories. Do not use `IRV` as a `find` category.

## Manual client ports are for non-library services only

For a peer SWC or custom OEM service, create or reuse the client-server
interface before adding the client port:

```matlab
addPackageableElement(arProps, "ClientServerInterface", ...
    "/Interfaces", "CustomService");
add(arProps, swcPath, "ClientPorts", "CustomService_Port", ...
    "Interface", "/Interfaces/CustomService");
```

This is not the workflow for `Dem`, `FiM`, or `NvM`. Those standard BSW
services own their client port and interface mapping through their library
caller plus `autosar.api.syncModel`. See
[bsw-library-callers.md](bsw-library-callers.md).

## Existing-model safety

Before calling `autosar.api.create`, determine whether the model already has
AUTOSAR properties:

```matlab
hasMapping = false;
try
    arProps = autosar.api.getAUTOSARProperties(modelName);
    slMap = autosar.api.getSimulinkMapping(modelName);
    hasMapping = true;
catch
end
```

If `hasMapping` is true:

- Inspect the existing runnables, events, ports, and interfaces before an
  edit.
- Apply a requested repair to the supplied model in place. A separate backup
  must not replace the requested model with a renamed artifact.
- Use `autosar.api.create(modelName, "incremental")` only to map new
  Simulink elements. Do not use it as a generic repair operation.
- Do not use `autosar.api.create(modelName, "init")` as a generic retry. It
  removes existing interfaces and resets AUTOSAR definitions and mappings;
  explain that impact and ask for user confirmation before a deliberate reset.
- Treat `autosar.api.delete` plus recreation as destructive. Explain the
  loss of mapping customizations and obtain explicit user confirmation before
  recreating the mapping.

If the model was saved in a newer release, report the release mismatch rather
than treating the load failure as an AUTOSAR configuration error.

## Clean up synthesized defaults after remapping

`autosar.api.create(modelName, "default")` can create legal defaults for the
initial model shape. After retargeting events, remapping ports, or changing
communication style, a successful `autosar.api.validateModel` does not prove
that default-created trigger ports, interfaces, and events are still needed.
Inspect them for unused defaults.

1. Identify candidates with no intended references.
2. Confirm they are not user-owned or externally referenced.
3. Delete only confirmed orphan paths with
   `delete(arProps, orphanPath)`; do not reset or recreate the complete
   mapping as cleanup.
4. For a reported configuration problem, `autosar.api.validateModel` can
   surface remaining errors. When the request concerns generated ARXML,
   inspect the relevant files for both absence of removed defaults and
   presence of the intended events, ports, and interface references.

For example, an export-function model can retain trigger ports, trigger
interfaces, and `ExternalTriggerOccurredEvent` objects after the intended
design changes to `TimingEvent` or `DataReceivedEvent`.

## Data-triggered events

Use the generic internal-behavior `Events` collection for event categories
that do not have a dedicated collection:

```matlab
eventPath = internalBehaviorPath + "/On_MyRPort_DE1";
add(arProps, internalBehaviorPath, "Events", "On_MyRPort_DE1", ...
    "Category", "DataReceivedEvent");
set(arProps, eventPath, "StartOnEvent", ...
    internalBehaviorPath + "/OnDataRunnable");
set(arProps, eventPath, "Trigger", "MyRPort.DE1");
```

Create the interface, receiver port, data element, and mapping before the
event. For `DataSendCompletedEvent`, first use `ExplicitSend` or
`QueuedExplicitSend`. When authoring that event, use
`matlab-read-documentation` to determine the installed-release source
property before naming it. If lookup is unavailable, tell the user to use
`matlab-read-documentation` for the installed MATLAB release to identify the
property before calling `set`; a generic reference to documentation does not
give the user that actionable next step. Bind the event only conceptually to
the sender runnable's variable access rather than a bare port name. Do not
write an executable `set` call for the unknown source property, including one
that uses a placeholder such as `SOURCE_PROP`.

When the property cannot be determined now, tell the user: "Use
`matlab-read-documentation` for the installed MATLAB release to identify the
`DataSendCompletedEvent` source property before calling `set`."

## Rename a runnable without invalidating its path

Set lowercase `symbol` before changing `Name`:

```matlab
runnablePath = "/Components/MyModel/MyModel_InternalBehavior/OldRunnable";
set(arProps, runnablePath, "symbol", "LightCtrl_Step");
set(arProps, runnablePath, "Name", "LightCtrl_Step");
```

Changing `Name` changes the property-tree path immediately. Re-query after
every name change before making another mutation.

## Normalize overlong AUTOSAR short names

AUTOSAR short names must be at most 128 characters. Keep a user-facing
Simulink block name when necessary, but shorten its AUTOSAR-side name before
generating AUTOSAR artifacts:

```matlab
shortName = extractBefore(requestedName, 129);
assert(strlength(shortName) <= 128);
```

Re-query the affected paths after the rename, then apply the same
normalization to related interface, port, data-element, or runnable names
when the AUTOSAR artifact requires them to agree.

## Map Data Store Memory to PIM

Map a Data Store Memory block as a PIM through the Simulink mapping:

```matlab
slMap = autosar.api.getSimulinkMapping(modelName);
mapDataStore(slMap, "MyModel/OdmOffset", "ArTypedPerInstanceMemory");
```

If the requirement also includes an NvM service call, implement that caller
with the NvM library block and `autosar.api.syncModel`; do not add or
normalize an NvM client port manually. See
[bsw-library-callers.md](bsw-library-callers.md).

----

Copyright 2026 The MathWorks, Inc.

----

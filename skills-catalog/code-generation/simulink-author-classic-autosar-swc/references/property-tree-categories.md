# Property Tree `find` Categories

Use this reference to choose category strings for
`find(arProps, path, category)`. Category names are singular. Collection
property names can be plural for `add` or `get`; they are not `find`
categories.

Use the paths returned by `find` directly. Do not construct a returned path
from a presumed package layout.

## Categories used by this skill

| Category | Use |
|---|---|
| `"AtomicComponent"` | Find the component path. |
| `"Runnable"` | Find runnable paths. |
| `"TimingEvent"` | Find periodic events and read their period. |
| `"ModeSwitchEvent"` | Find mode-switch triggers. |
| `"DataReceivedEvent"` | Find receiver-data triggers. |
| `"DataSendCompletedEvent"` | Find sender-completion triggers; use `matlab-read-documentation` for the installed MATLAB release when the event source property must be identified. |
| `"DataReceiverPort"` / `"DataSenderPort"` | Find sender-receiver R-ports or P-ports. |
| `"RequiredPort"` / `"ProvidedPort"` | Find all required or provided ports. |
| `"ClientPort"` / `"ServerPort"` | Find client-server ports. |
| `"SenderReceiverInterface"` / `"ClientServerInterface"` | Find interface definitions. |
| `"FlowData"` | Find data elements within a specific interface path. |
| `"IrvAccess"` | Find IRV access entries. |
| `"Data"` | Find IRV data nodes under internal behavior. |
| `"SwAddrMethod"` | Find memory-placement methods. |

## Scope IRV data queries

Do not search `Data` globally when selecting an IRV: that also returns
interface data elements. Discover the component behavior and scope the query:

```matlab
componentPaths = string(find(arProps, [], "AtomicComponent", ...
    "PathType", "FullyQualified"));
behaviorPath = string(get(arProps, componentPaths, "Behavior"));
irvDataPaths = string(find(arProps, behaviorPath, "Data", ...
    "PathType", "FullyQualified"));
```

## Common category mistakes

Do not pass collection names or older shorthand names to `find`:

| Do not use with `find` | Use instead |
|---|---|
| `"RPorts"`, `"RPort"`, `"ReceiverPorts"` | `"DataReceiverPort"` or `"RequiredPort"` |
| `"PPorts"`, `"PPort"`, `"SenderPorts"` | `"DataSenderPort"` or `"ProvidedPort"` |
| `"ClientPorts"`, `"ServerPorts"` | `"ClientPort"`, `"ServerPort"`, `"RequiredPort"`, or `"ProvidedPort"` |
| `"Runnables"`, `"TimingEvents"`, `"ModeSwitchEvents"` | `"Runnable"`, `"TimingEvent"`, or `"ModeSwitchEvent"` |
| `"SenderReceiverInterfaces"`, `"ClientServerInterfaces"` | `"SenderReceiverInterface"` or `"ClientServerInterface"` |
| `"DataElements"` | `"FlowData"` |
| `"IRV"`, `"IRVs"` | `"IrvAccess"` for accesses or `"Data"` for IRV data nodes |

`"IRV"` is an intentional exception for `add`:

```matlab
add(arProps, internalBehaviorPath, "IRV", "IRV_Data");
```

It is not a corresponding `find` category.

## Calling pattern

```matlab
arProps = autosar.api.getAUTOSARProperties(modelName);

runnables = find(arProps, [], "Runnable");
timingEvents = find(arProps, [], "TimingEvent");
flowData = find(arProps, "/Interfaces/AmbientLux", "FlowData");
```

Use `[]` to search the property tree globally. Pass a path only when the
query must be scoped, such as listing data elements in one interface.

----

Copyright 2026 The MathWorks, Inc.

----

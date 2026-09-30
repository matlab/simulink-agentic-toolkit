# Map SWC Root Ports

Use sender-receiver ports for data exchanged between this component and another
component. Choose a root-port representation before creating the AUTOSAR
mapping.

## Choose the Root-Port Shape

Use root `Inport` and `Outport` blocks for one data element per AUTOSAR port.
Use `In Bus Element` and `Out Bus Element` blocks when one AUTOSAR port carries
multiple elements.

For Bus Element blocks, use `PortName.ElementName`:

- The text before the dot is the AUTOSAR port name.
- The text after the dot is the data-element name.
- Blocks with the same `PortName` represent elements of one AUTOSAR port.
- Blocks with different `PortName` values represent different AUTOSAR ports.

Create distinct ports with distinct `PortName` values from the start. Do not
create unnamed Bus Element blocks and try to separate their ports later.

## Add Elements to a Bus Port

Create the first block for a shared port, then copy that existing block and
change only its `Element` value for each additional element. Setting `PortName`
on a second independent Bus Element block to an existing port can fail because
the port already exists.

`Simulink.Bus.addElementToPort` registers an element but does not create a
corresponding Bus Element block.

## Inspect and Map Ports

For root `Inport` and `Outport` blocks, use the full three-output mapping query:

```matlab
[arPortName, arElementName, arAccessMode] = getInport(slMap, slPortName);
[arPortName, arElementName, arAccessMode] = getOutport(slMap, slPortName);
```

Do not request only two outputs and treat the second as an access mode. It is
the data-element name.

`getInport` and `getOutport` can be unreliable for `In Bus Element` and `Out
Bus Element` blocks. For those ports, query the `DataReceiverPort` and
`DataSenderPort` objects in the AUTOSAR property tree, then validate the
component:

```matlab
autosar.api.validateModel(modelName);
receiverPorts = find(arProps, [], "DataReceiverPort", ...
    "PathType", "FullyQualified");
senderPorts = find(arProps, [], "DataSenderPort", ...
    "PathType", "FullyQualified");
```

`mapInport` and `mapOutport` use the same five-argument signature for both
block types:

```matlab
mapInport(slMap, slPortName, arPortName, arElementName, arAccessMode);
mapOutport(slMap, slPortName, arPortName, arElementName, arAccessMode);
```

For Bus Element ports, the arguments identify one element within the shared
AUTOSAR port. For ordinary root ports, the block and AUTOSAR port are
effectively one-to-one.

## Preserve Access Semantics

Keep `ImplicitReceive` and `ImplicitSend` for ordinary periodic
sender-receiver behavior. Use `ExplicitReceive` or `ExplicitSend` only when
the requested SWC behavior requires explicit RTE access.

When adding a root port to an already-mapped component, inspect existing
mappings first and use `autosar.api.create(modelName, "incremental")` only for
the newly added Simulink element. Recheck the pre-existing port mappings after
the extension.

----

Copyright 2026 The MathWorks, Inc.

----

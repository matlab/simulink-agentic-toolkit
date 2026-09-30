# Client-Server and IRV Patterns

Use this reference for peer or custom client-server operations and
inter-runnable variables (IRVs). For `Dem`, `FiM`, or `NvM`, use
[bsw-library-callers.md](bsw-library-callers.md) instead.

## Choose the correct communication boundary

| Requirement | Modeling path |
|---|---|
| Data between components | Sender-receiver ports. |
| Operation on a peer SWC | Client-server `Function Caller`. |
| Custom OEM or non-library service | Explicit service interface and manual client-server setup. |
| `Dem`, `FiM`, or `NvM` service | Preconfigured BSW library caller and `syncModel`. |
| Data between runnables in one component | IRV. |

Do not substitute one path for another merely because the block diagram can
compile.

## Function Caller mapping

Map a `Function Caller` through the Simulink mapping API using its qualified
function name, not its block path:

```matlab
slMap = autosar.api.getSimulinkMapping(modelName);
mapFunctionCaller(slMap, "ClientPortName.OperationName", ...
    "ClientPortName", "OperationName");

[arPortName, arOperationName, serverCallPoint] = ...
    getFunctionCaller(slMap, "ClientPortName.OperationName");
```

Use `ServerCallPoint="Asynchronous"` only for an explicitly asynchronous
operation.

### Peer SWC versus custom service prototype

- A peer SWC call uses a port-scoped dot prototype, such as
  `result = BrakePressurePort.ReadPressure()`.
- A custom OEM or non-library service uses an underscore prototype, such as
  `status = OemLogPort_WriteEntry(logId, severity, code)`, with an explicitly
  configured service interface.
- Do not use an underscore service prototype for a peer SWC request.

### Define the operation contract before mapping

The `Operation` must expose `ArgumentData` that matches the `Function Caller`
prototype exactly: each caller input is an `In` argument, and each caller
output is an `Out` argument with the same name. Define the interface,
operation, arguments, and client port before calling `mapFunctionCaller`.
For example, a caller with `[Data,ERR] = OemStatusPort_WriteStatus(Op)` needs
one `In` argument named `Op` and two `Out` arguments named `Data` and `ERR`:

```matlab
interfacePath = "/Interfaces/OemStatusIf";
operationPath = interfacePath + "/WriteStatus";

addPackageableElement(arProps, "ClientServerInterface", ...
    "/Interfaces", "OemStatusIf");
set(arProps, interfacePath, "IsService", true);
add(arProps, interfacePath, "Operations", "WriteStatus");
add(arProps, operationPath, "Arguments", "Op", "Direction", "In");
add(arProps, operationPath, "Arguments", "Data", "Direction", "Out");
add(arProps, operationPath, "Arguments", "ERR", "Direction", "Out");
add(arProps, swcPath, "ClientPorts", "OemStatusPort", ...
    "Interface", interfacePath);

mapFunctionCaller(slMap, "OemStatusPort_WriteStatus", ...
    "OemStatusPort", "WriteStatus");
```

Reuse an existing interface and port when the component already owns the
service contract. Choose an existing interface package path rather than
assuming `/Interfaces` exists. Do not map a caller to an operation with a
different argument count, direction, or name.

## Add a server operation

For a new server operation, configure the export-function execution domain
before mapping:

```text
model_edit(
  model: "<model>",
  scope: "root",
  operations: [{"op":"configure","target":"config:<model>",
    "params":{"SetExecutionDomain":"on","ExecutionDomainType":"ExportFunction"}}]
)
```

Then:

1. Add a root `Simulink Function`.
2. Configure its trigger as `function-call`.
3. Set `FunctionName` and `ScopeName` before `FunctionVisibility="port"`.
4. Add a root `Function Element` block for the server port.
5. Reuse an existing client-server interface when one is already owned by a
   shared contract; otherwise create the required interface and operation.

## Map a data transfer to an IRV

Create or identify the IRV before mapping the Simulink transfer. Discover the
internal behavior from the mapped component; do not construct this path from
the model name:

```matlab
arProps = autosar.api.getAUTOSARProperties(modelName);
slMap = autosar.api.getSimulinkMapping(modelName);

componentPaths = string(find(arProps, [], "AtomicComponent", ...
    "PathType", "FullyQualified"));
assert(isscalar(componentPaths), ...
    "Select the target AUTOSAR component before creating an IRV.");
behaviorPath = string(get(arProps, componentPaths, "Behavior"));

dataPaths = string(find(arProps, behaviorPath, "Data", ...
    "PathType", "FullyQualified"));
targetIrvPaths = dataPaths(endsWith(dataPaths, "/IRV_Data"));
if isempty(targetIrvPaths)
    add(arProps, behaviorPath, "IRV", "IRV_Data");
elseif numel(targetIrvPaths) ~= 1
    error("Expected at most one IRV data node named IRV_Data.");
end

transferName = "RunnableTransfer";
mapDataTransfer(slMap, transferName, "IRV_Data", "Explicit");
[irvName, accessMode] = getDataTransfer(slMap, transferName);
```

The Simulink-side identifier is a named line or the full path of a supported
`Rate Transition` block. It is never a numeric line handle or Simulink SID.
The fresh-mapping recipe above adds only when `IRV_Data` is absent. On a known
incremental mapping, use `getDataTransfer` first to identify the existing
mapped IRV, then reuse it or rename only that confirmed synthesized node.
Do not add another IRV to a transfer that is already mapped.

Use `IrvAccess` to query access entries and scope `Data` to `behaviorPath` to
query IRV data nodes; a global `Data` search also returns interface elements.
`IRV` is only the `add` exception. A root-level `Rate Transition` is
unsupported in an export-function model; place it in a supported scope.

For a release conflict, use `matlab-read-documentation` to verify
`mapDataTransfer` or `getDataTransfer` rather than probing alternative model
shapes.

----

Copyright 2026 The MathWorks, Inc.

----

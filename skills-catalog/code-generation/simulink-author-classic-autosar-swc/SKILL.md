---
name: simulink-author-classic-autosar-swc
description: >
  Use this skill when authoring, reworking, or validating a Classic AUTOSAR
  software component (SWC) in Simulink, including autosar.api mappings,
  runnables, timing events, sender-receiver ports, client-server operations,
  IRVs, BSW service callers, and component ARXML updates.
license: https://www.mathworks.com/content/dam/mathworks/license/pmrl/license.md
metadata:
  author: MathWorks
  version: "1.2"
---

# Author Classic AUTOSAR SWCs in Simulink

Use this skill to create, extend, repair, and validate one Classic AUTOSAR
Application Software Component (SWC). Keep the work focused on the component
model, its AUTOSAR mappings, and its generated component artifacts.

## When to Use

Use this skill for a Classic AUTOSAR SWC when the work involves:

- Creating or extending an AUTOSAR-mapped Simulink component model.
- Configuring runnables, generated symbols, timing events, init behavior, or
  sender-receiver data access.
- Mapping root ports, client-server operations, BSW service calls, or
  inter-runnable variables (IRVs).
- Repairing an existing component mapping without losing its intended
  interfaces, events, or customizations.
- Importing or updating a component model from changed ARXML.
- Checking generated component ARXML or C code for requested interfaces,
  symbols, events, or memory placement.

## When Not to Use

- Do not use this skill for Adaptive AUTOSAR, `ara::com`, service discovery,
  SOME/IP, or Adaptive service interfaces.
- Do not use this skill for non-AUTOSAR code-interface configuration,
  including `coder.mapping.*` storage classes and code mappings or Embedded
  Coder dictionary Data/Service Interface setup. Use
  `simulink-configure-code-interfaces` for those tasks.
- Do not use this skill to author an AUTOSAR composition, a System Composer
  model, or an architecture-level interface topology.
- Do not use this skill for generic Simulink editing that has no Classic
  AUTOSAR SWC mapping or code-generation concern.

## Start With the Current Component

Answer a request for an API pattern or a modeling decision directly when it
does not require a model change. For a model change, inspect the supplied
component before modifying it:

1. Check the model release. If it was saved by a newer Simulink release, report
   the compatibility constraint instead of diagnosing its AUTOSAR mapping.
2. Check whether the model already has AUTOSAR properties, root-port mappings,
   runnables, and events.
3. Make the narrowest change that satisfies the request, then inspect the
   changed mapping and validate the component when validation is relevant.

Use `model_overview` or `model_read` for model structure, `model_query_params`
for block and configuration values, and `model_edit` for ordinary diagram
changes. Use `model_read_diagnostics` after an update, compilation, simulation,
or build when Diagnostic Viewer output matters. Use `evaluate_matlab_code` for
AUTOSAR APIs that are not exposed as model tools, including `autosar.api`
mapping, property-tree operations, and focused AUTOSAR diagnostics.

Use `matlab-read-documentation` before giving an exact API form that is
release-sensitive, ambiguous, or absent from this skill and its references.

## Protect Existing Mappings

Treat `autosar.api.create(modelName, "init")` as destructive on an existing
mapped model. It removes existing interfaces, mappings, and metadata. Before
calling it, state that consequence and ask: "This reset removes existing
interfaces, mappings, and metadata. Do you want me to proceed?" Wait for
explicit confirmation.

Likewise, before deleting AUTOSAR content and recreating it, explain the
specific loss and obtain affirmative confirmation. A generic repair request is
not permission to reset a component.

For a new model, configure `SystemTargetFile` as `autosar.tlc` and create a
default mapping only after the model structure is ready. For an existing
mapping, inspect and edit it in place. Use `"incremental"` only to map newly
added Simulink elements without resetting the existing AUTOSAR state. Read
[property-tree-mutation-rules.md](references/property-tree-mutation-rules.md)
for the mapping-detection pattern and safe use of `"default"` and
`"incremental"` when deciding whether to create or extend a mapping.

`autosar.api.validateModel(modelName)` throws when it detects a configuration
error. A successful validation does not prove that generated defaults still
represent the requested interface or event behavior; inspect the affected
ports, mappings, and events as well.

## Configure Runnables and Events

Choose the execution style before changing an event:

- Use an atomic subsystem and timing events for periodic rate-based behavior.
- Use function-call subsystems and an export-function execution domain for
  explicit runnable entry points.
- Keep initialization behavior separate from periodic behavior. Do not rename
  or retime an initialization runnable unless the request explicitly changes
  startup behavior.

For an existing multi-rate SWC, query the `Runnable` and `TimingEvent` objects
before renaming or retiming them. When changing both a runnable short name and
its generated C symbol, set lowercase `symbol` on the current runnable path
before changing `Name`; renaming changes the property-tree path.

Use the generic internal-behavior events collection for data-triggered
runnables. For `DataSendCompletedEvent`, first determine the
installed-release source-property form with `matlab-read-documentation`; do
not guess a property name.

Read [property-tree-categories.md](references/property-tree-categories.md)
for valid `find` categories and
[property-tree-mutation-rules.md](references/property-tree-mutation-rules.md)
for safe property-tree edits and runnable rename ordering.

## Map Component Ports

Model inter-component data with sender-receiver ports. Root `Inport` and
`Outport` mappings normally use `ImplicitReceive` and `ImplicitSend`; choose
explicit access only when the requested behavior requires it.

Use `In Bus Element` and `Out Bus Element` ports when a component port carries
multiple data elements. Name blocks as `PortName.ElementName` so the intended
AUTOSAR port and element are unambiguous. Query Bus Element mappings through
the AUTOSAR sender/receiver ports and validation rather than relying only on
`getInport` or `getOutport`.

Do not change a rate-based `ImplicitSend` mapping merely to obtain a
conditional `Rte_Write`. Preserve the model and explain that this behavior has
Export-Function and ExplicitSend prerequisites.

Read [swc-port-mapping.md](references/swc-port-mapping.md) for Bus Element
port rules and mapping API behavior. Read
[conditional-write-prereqs.md](references/conditional-write-prereqs.md)
before implementing conditional writes.

## Map Operations, Services, and IRVs

Choose the communication category before adding blocks:

| Need | Use |
|---|---|
| Data between components | Sender-receiver ports. |
| Operation on another SWC | `Function Caller` mapped to a client port and operation. |
| Custom OEM service | `Function Caller` with an underscore-style `Port_Operation(...)` prototype. |
| Standard Dem, FiM, or NvM service | The corresponding AUTOSAR Blockset library caller. |
| Data between runnables in one SWC | An IRV mapping on the intended data-transfer line or Rate Transition block. |

For a peer SWC operation, retain a dot-style `Port.Operation(...)` caller
prototype and map the qualified caller to the client port and operation. For
a custom OEM service, define the client-server operation arguments to match
the caller signature before mapping it.

Use a Dem, FiM, or NvM library caller instead of hand-authoring a `Function
Caller` for that BSW service. After changing a BSW caller, run
`autosar.api.syncModel(modelName)` before validation. For Dem
`SetEventStatus`, use the `Dem_EventStatusType` supplied by the Diagnostic
Monitor Caller; do not create a project `Dem_EventStatusType.m` class. Feed
an NvM write from a `Data Store Read`.

For an existing IRV transfer, identify the current mapping with
`getDataTransfer` and retarget or rename its IRV instead of adding a duplicate.
Pass a named data-transfer line or a Rate Transition full path to
`mapDataTransfer`, never a numeric line handle.

Read [client-server-and-irv-patterns.md](references/client-server-and-irv-patterns.md)
for operation and IRV mapping mechanics. Read
[bsw-library-callers.md](references/bsw-library-callers.md) for Dem, FiM, and
NvM caller rules.

## Update Component ARXML and Check Artifacts

For changed supplier ARXML, use `updateModel` when the Simulink component
structure must change and `updateAUTOSARProperties` when only AUTOSAR metadata
must refresh. Preserve the supplier source. Do not treat a textual difference
between generated component ARXML and an unchanged supplier package as a
round-trip failure.

Read [variants-and-arxml-roundtrip.md](references/variants-and-arxml-roundtrip.md)
for component import, variant selection, and preservation rules.

Generate code or ARXML only when the user requests artifacts or artifact
evidence. Inspect all generated `*.arxml` files when checking ports, events,
or memory placement, and inspect generated C separately for runnable symbols
and RTE calls. Read
[verify-generated-artifacts.md](references/verify-generated-artifacts.md) for
artifact locations and attribute-tolerant checks.

For `SwAddrMethod` placement, distinguish runnable code, runnable-owned
internal data, and IRV data. Read
[swaddrmethod-memory-placement.md](references/swaddrmethod-memory-placement.md)
for the required mapping arguments and generated-artifact evidence.

----

Copyright 2026 The MathWorks, Inc.

----

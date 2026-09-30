# BSW Library Callers

Use this reference for standard AUTOSAR Basic Software client services. The
library caller block owns the AUTOSAR client port and service-interface
mapping; do not create a parallel manual `Function Caller` or property-tree
client port.

## Workflow

1. Add the preconfigured caller block inside the intended runnable.
2. Configure its documented mask parameters and data flow.
3. Run `autosar.api.syncModel(modelName)`.
4. When the caller configuration needs confirmation, use
   `autosar.api.validateModel(modelName)`.

Repeat `syncModel` after changing a caller. If model validation reports a
stale Basic Software caller mapping, synchronize the mapping before
investigating the reported configuration.

## Caller selection

| Service | Library caller |
|---|---|
| Dem | `autosarlibdem/DiagnosticMonitorCaller` or another appropriate Dem caller |
| FiM permission | `autosarlibfim/Function Inhibition Caller` |
| FiM control availability | `autosarlibfim/Control Function Available Caller` |
| NvM service | `autosarlibnvm/NvMServiceCaller` |

## Sample-time and data-flow rules

- In an export-function or function-call subsystem, set every BSW caller's
  sample time to `st="-1"` so the function-call trigger controls execution.
  Do not assign a finite sample time there, including to an input-free FiM
  permission caller.
- An input-bearing caller, including NvM `WriteBlock` and Dem
  `SetEventStatus`, also uses inherited sample time outside that scope.
- An eligible input-free caller outside a function-call scope can use a
  rate-based execution period when that matches the model architecture.
- For NvM `WriteBlock`, feed the write-data input from a `Data Store Read`
  block.

## Service-specific details

- `autosarlibfim/Function Inhibition Caller` output 1 is `Permission`
  (boolean); output 2 is `ERR` (`uint8`).
- Dem `SetEventStatus` uses the `Enum: Dem_EventStatusType` supplied by the
  Diagnostic Monitor Caller. Do not create or add a project
  `Dem_EventStatusType.m` class, because it can shadow the Blockset-provided
  enum. Preserve the semantic status source instead of choosing an unrelated
  convenient signal.
  For a `Data Valid` boolean, convert the branch into explicit
  `DEM_EVENT_STATUS_PASSED` and `DEM_EVENT_STATUS_FAILED` enum values before
  the caller. Do not drive the caller directly from a `double` or `uint8`
  signal.
- Do not retain a manual `NvM_WriteBlock(...)` `Function Caller` after adding
  an NvM library caller.

Use `matlab-read-documentation` for release-specific mask parameter names or
an unfamiliar caller block. Do not replace the library workflow with manual
client-port authoring when documentation is incomplete.

----

Copyright 2026 The MathWorks, Inc.

----

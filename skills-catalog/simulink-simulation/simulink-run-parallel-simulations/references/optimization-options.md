# Optimization Options: FastRestart and Rapid Accelerator

## Key parsim / batchsim options

Common options (verify exact names/syntax with `help parsim` or `help batchsim` for your release if uncertain):

| Option | Purpose |
|---|---|
| `UseFastRestart` | Reuse compiled model across tunable-only runs (faster) |
| `SimulationMode` | e.g. `"rapid-accelerator"` for repeated fast runs |
| `RapidAcceleratorUpToDateCheck` | `"off"` skips the rebuild check (risks running stale artifacts — see Rapid Accelerator) |
| `SetupFcn` | Function run once per worker before sims (worker init) |
| `CleanupFcn` | Function run once per worker after sims |
| `AttachedFiles` | Files to send to workers |
| `ManageDependencies` | Auto-detect and transfer model dependencies |
| `TransferBaseWorkspaceVariables` | Send client base-workspace variables to workers (avoid — prefer SetupFcn/setVariable) |
| `ShowProgress` | Print run progress — on by default; do not set explicitly |
| `ShowSimulationManager` | `parsim` only — open the Simulation Manager UI; off by default, only if the user asks |
| `Pool` (batchsim) | Number of workers for the batch job |

**FastRestart tunability rules:**
- **Workspace variables**: Tunable if only the scalar value changes (no dimension, data type, or complexity change).
- **Block parameters** (e.g., Gain, Threshold): Tunable if they don't affect signal dimensions, data types, or sample times.
- **Model parameters**: `StopTime`, `RelTol`, `AbsTol` are tunable. `SolverType`, `SolverName`, `FixedStep` changes are not tunable.
- **When uncertain** (e.g., model references, complex parameter dependencies, unfamiliar parameter types): present the options plan point as *`UseFastRestart='on'` — tunability not fully confirmed due to [reason]; the test run will verify it.*

Do not add options beyond `UseFastRestart` and `RapidAcceleratorUpToDateCheck` unless the user explicitly asks — unnecessary options can cause unexpected behavior or mask errors. In particular, never set an option to a value that is already its default (e.g. `'ShowProgress','on'`): it changes nothing and only adds noise.

## Rapid Accelerator

Runs a compiled model — fast per run, but requires a one-time target build.

- Prefer for many tunable-only runs. Use normal mode when individual sims run in under ~1 second (build overhead outweighs the gain).
- Compatibility is not cheaply queryable — the build is the check (it errors if the model is incompatible). Do not build just to test; offer it, note the one-time build cost, let the build surface incompatibility.
- Set `SimulationMode='rapid-accelerator'`. Not compatible with structural changes between runs or non-tunable parameter changes.
- `RapidAcceleratorUpToDateCheck='off'` skips the rebuild check to speed up tunable-only sweeps — but if stale build artifacts exist it will silently run the stale target and give wrong results. Only use it after a known-current build (e.g. a fresh `buildRapidAcceleratorTarget`); do not set it blindly.
- Swept quantity via `setBlockParameter` blocks Rapid Accelerator. Do not edit the model — emit a comment suggesting the user reference a workspace variable and sweep it with `setVariable` instead:

```matlab
% Rapid Accelerator note: this sweep uses setBlockParameter on <block>.
% To use Rapid Accelerator, change the block's expression to a workspace
% variable and sweep it with setVariable instead.
```

----

Copyright 2026 The MathWorks, Inc.

----

# API and Parameter Reference

These are the **only** product APIs and model configuration parameters this skill names. Do not invent variants. Treat entries under **Model Configuration Parameters** as settings to inspect or change through the active environment's model-configuration capabilities; the instructions name the intended state, not a required access API.

## Model Configuration Parameters

Authorized parameter names and value forms:

| Parameter          | Value form                                    |
|--------------------|-----------------------------------------------|
| `SystemTargetFile` | `"speedgoat.tlc"` \| `"speedgoat_aarch64.tlc"` \| `"slrtlinux_x64.tlc"` |
| `SolverType`       | `"Fixed-step"`                                |
| `Solver`           | Any fixed-step solver appropriate for the model; examples include `"FixedStepDiscrete"`, `"ode1"`, `"ode3"`, `"ode4"`, and `"FixedStepAuto"` |
| `FixedStep`        | numeric string, e.g. `"0.001"`               |
| `StopTime`         | numeric string, e.g. `"10"`                  |
| Simulink Real-Time options       | `SLRTLogLevel`, `SLRTForcePollingMode`, `SLRTFileLogMaxRuns`, `BuildConfiguration`, `UseGCCFastMath` |

Inspect each parameter before changing it, and verify its value afterward. Option details and dialog names: `slrt-options.md`.

## Target APIs, Class Checks, and Lifecycle Commands

| Operation                              | Exact form                                                            |
|----------------------------------------|-----------------------------------------------------------------------|
| List defined target names              | `names = getTargetNames(slrealtime.Targets);`                          |
| Create target object by name           | `tg = slrealtime("targetName");`                                       |
| Connect to target (requires consent)   | `connect(tg);`                                                         |
| Resolve correct STF for the target     | `modelSTF = getSTFName(tg);`                                           |
| Configure model for target (preferred) | `configureModelForTargetPlatform(tg, model);`                          |
| Active config set / ref-check          | `cs = getActiveConfigSet(model); isa(cs, "Simulink.ConfigSetRef")`     |
| Update diagram                         | `set_param(model, "SimulationCommand", "update");`                     |
| Upgrade Advisor                        | `upgradeadvisor(model);`                                               |
| Save                                   | `save_system(model);`                                                  |
| Load model                             | `load_system(model);` / `bdIsLoaded(model)`                            |
| Installed products                     | `v = ver; installedNames = string({v.Name});`                          |

Prefer higher-level product APIs when they encode target-specific behavior: use `configureModelForTargetPlatform(tg, model)` instead of manually changing the STF and solver when a confirmed target computer is connected.

## Common Hallucinations to Refuse

- Hard-coding `slrealtime.tlc` for a Speedgoat target. Use `speedgoat.tlc` for most Speedgoat target computers, or `speedgoat_aarch64.tlc` for Speedgoat Pulse.
- A target-object method such as `tg.setSTF(...)`. `SystemTargetFile` is a model configuration parameter, not a target-object method.
- Upgrade Advisor check IDs other than `mathworks.design.slrealtimeUpgrades` and `mathworks.design.slrealtimeLoggingUpgrades` (see `upgrade-advisor.md`).

----

Copyright 2026 The MathWorks, Inc.

----

---
name: simulink-configure-real-time-model
description: Configure a Simulink model for Simulink Real-Time code generation and deployment. Use when setting up a model for Simulink Real-Time, selecting the correct system target file, fixing TLC/STF mismatches, applying fixed-step solver settings, validating target-platform compatibility, or configuring Simulink Real-Time build options before model build.
license: https://www.mathworks.com/content/dam/mathworks/license/pmrl/license.md
metadata:
  author: MathWorks
  version: "1.0"
---

# Configure Simulink Real-Time Models

Prepare an existing Simulink model to build as a Simulink Real-Time application — configuring it consistently with the selected target platform, solver requirements, and Simulink Real-Time build options.

> **Release compatibility:** Designed and validated for MATLAB R2026a and later. Earlier releases differ in APIs, system target files, and workflows — use that release's product documentation instead.

## When to Use

- Setting up a Simulink model for Simulink Real-Time, or preparing it before `slbuild`
- Selecting or correcting the system target file (STF/TLC), including models on `grt.tlc` or `ert.tlc`
- Reviewing or setting fixed-step solver options for real-time execution while preserving the model's intended dynamics and sample-time behavior
- Configuring model parameters for a selected Speedgoat target computer or compatible Linux device — toolchain details, or Simulink Real-Time options (log level, polling mode, max file log runs, GCC `-ffast-math`)
- Handling errors about incompatible target platforms or missing target platform selection
- Running Upgrade Advisor for an older Simulink Real-Time model

## When NOT to Use

If the task crosses one of these lines, **load the named skill before writing that code**, then come back.

- **Defining or editing a target (IP, credentials, `TargetSettings`, `addTarget`), RTOS update, network/SSH setup, or troubleshooting a target that will not connect** → `simulink-configure-real-time-target`. Selecting an already-defined target and calling `connect(tg)` with the user's consent stays in this skill (Step 1).
- **`slbuild`, `tg.load`, `tg.start`, `tg.stop`, `tg.Stimulation`** → `simulink-run-real-time-application`
- **Capturing signal values during a run (`slrealtime.Instrument`, file log, SDI, MATLAB callbacks)** → `simulink-instrument-real-time-application`
- **Test-pointing or canvas-badging signals (`set_param(port, 'TestPoint', ...)`, `markSignalForStreaming`)** → `simulink-instrument-real-time-application` (setup-phase ops, not this skill)
- Editing model structure (blocks, connections), or desktop simulation with `sim` or `parsim`

**STF values** — do **not** hard-code; call `getSTFName(tg)` and let the installed support package decide. Never use `slrealtime.tlc` for Speedgoat hardware in R2026a+. When `tg` is unreachable, see `references/disconnected-workflow.md`; for which value each support package resolves to, see `references/stf-by-target.md`.

## Prerequisites

- MATLAB **R2026a or newer**
- Simulink Real-Time installed (`ver` lists "Simulink Real-Time")
- A relevant support package installed for the target hardware:
  - **Speedgoat hardware** → Speedgoat Add-On (provides `speedgoat.tlc` for standard targets and `speedgoat_aarch64.tlc` for Speedgoat Pulse)
  - **Linux x86-64 devices** → Embedded Coder Support Package for Real-Time Linux (requires Embedded Coder and provides `slrtlinux_x64.tlc`)
- Model is loaded in Simulink (`load_system` or `open_system`)
- **Read `references/api-reference.md` before writing code.** It lists the only APIs and model configuration parameters this skill uses; do not invent variants.

## Workflow

| Step | What | Detail |
|---|---|---|
| 1 | Choose the target — ask before connecting | below |
| 2 | Load the model | below |
| 3 | Inspect the existing configuration | below |
| 4 | Check for a referenced config set | below |
| 5 | Run Upgrade Advisor when the model is legacy | `references/upgrade-advisor.md` |
| 6 | Configure for the target platform (default path) | below |
| 7 | Resolve the STF manually (fallback only) | `references/stf-by-target.md` |
| 8 | Configure solver settings | below |
| 9 | Preserve user intent around stop time | below |
| 10 | Configure Simulink Real-Time options | `references/slrt-options.md`, `references/compiler-options.md` |
| 11 | Validate product and add-on assumptions | below |
| 12 | Validate configuration before saving | below |
| 13 | Run update diagram (ask first) | below |
| 14 | Save only after the user agrees | below |

No reachable target at any point → `references/disconnected-workflow.md`.

### 1. Choose the Target — Ask Before Connecting

**Never call `connect(tg)` without user consent, and never pick a target on the user's behalf.** Even if only one target is defined, surface it and confirm.

1. **User named a target** (e.g., "configure for target `sg`") — `tg = slrealtime("sg")`, then ask permission before `connect(tg)`.
2. **User did not name a target** — list `getTargetNames(slrealtime.Targets)` and ask which one to use. If only one exists, still confirm.
3. **No targets are defined, and the user described their hardware** — give the best STF guess from that description (Speedgoat → `speedgoat.tlc` unless it is a Speedgoat Pulse; Speedgoat Pulse → `speedgoat_aarch64.tlc`; Real-Time Linux x86-64 → `slrtlinux_x64.tlc`) and recommend defining a target with `simulink-configure-real-time-target` for more accurate results. If they proceed without one, follow `references/disconnected-workflow.md` instead of `getSTFName`.
4. **No target is reachable and the user has not described their hardware** — stop before any `SystemTargetFile` write. Name the options (Speedgoat / Speedgoat Add-On, including the Pulse exception; Real-Time Linux x86-64 / Embedded Coder Support Package for Real-Time Linux), ask which applies, then load `simulink-configure-real-time-target` to define the target. **Do not resolve this gate from installed products** — see the Never list.

> The following Simulink Real-Time targets are defined on this machine: `<name1>`, `<name2>`, ...
> Which one should I configure `<model>` for? I will ask before connecting.

**An authorized `connect(tg)` can still fail or block.** Guard the call; when it fails, report `err.identifier` and the cause (never the raw error block) and switch to the disconnected fallback rather than retrying blindly or leaving the model half-configured.

### 2. Load the Model

Run `load_system(model)` and confirm with `bdIsLoaded(model)`. If the model is not on the MATLAB path, locate it or ask the user to confirm the path before changing settings.

### 3. Inspect Existing Configuration

Read `SystemTargetFile`, `SolverType`, `Solver`, and `FixedStep` before changing anything, so the change can be explained before saving. Also read `StopTime` and the Simulink Real-Time options if the user asked about runtime duration, logging, polling mode, or compiler behavior.

A model already on a Simulink Real-Time family target file is not necessarily wrong — verify it against the selected target. A legacy target file (`slrealtime.tlc`, `slrt.tlc`, `slrtert.tlc`, `xpctarget.tlc`, `xpctargetert.tlc`) goes to Step 5 before any STF change. Step 5 does not depend on the target or the support package: run it even when Step 1 or Step 11 stops the STF write.

### 4. Check for External or Referenced Configuration Sets

```matlab
cs = getActiveConfigSet(model);
usesConfigSetRef = isa(cs, "Simulink.ConfigSetRef");
```

A referenced config set can be shared by every model that references it. Do not silently detach or replace it — ask for explicit permission unless the user already requested that behavior.

### 5. Run Upgrade Advisor When Needed

Run `upgradeadvisor(model)` **before** any `SystemTargetFile` write when the model is legacy — created in an older release, reporting migration errors, or on one of the legacy target files above. `references/upgrade-advisor.md` has the trigger list, handling order, and the two valid check IDs. Warn the user that the advisor fixes may migrate or discard legacy settings; upgrade first, then configure, and never build from a legacy target file. The target-selection and support-package stops (Steps 1 and 11) gate the `SystemTargetFile` write, not Upgrade Advisor — run the advisor first, then ask.

### 6. Configure Model for Target Platform (Default Path)

Use this unless the user explicitly asked for manual STF control.

```matlab
model = "myModel";
tg = slrealtime("targetName");
load_system(model);
try
    connect(tg); % only after the user approved this specific target name
    configureModelForTargetPlatform(tg, model);
catch err
    % Report err.identifier + cause; then use references/disconnected-workflow.md
end
```

It sets `SystemTargetFile` to the STF that `getSTFName(tg)` returns **and** switches `SolverType` to `Fixed-step` in one call. Do not also write `SolverType`, and do not call `getSTFName(tg)` first to "confirm" — that adds noise to the narrative.

**It can prompt interactively.** When it cannot resolve the platform it opens the modal **Speedgoat Target Platform Selector**, which blocks a non-interactive session. Call it only against a connected target whose platform resolves; otherwise take the disconnected fallback.

### 7. Resolve the System Target File (Manual Fallback Only)

Only when the user asked to drive `SystemTargetFile` themselves, or another workflow needs the STF string first: `modelSTF = getSTFName(tg);`, write it to `SystemTargetFile`, and verify before saving. Never hard-code an STF without going through the support-package question.

### 8. Configure Solver Settings

After Step 6, `SolverType` is already `Fixed-step` — skip it. After a manual or disconnected STF write, set `SolverType` to `Fixed-step`.

Set `FixedStep` only to a value the user gave; otherwise preserve the current value unless it is invalid. `auto` infers the fundamental sample time from the model. Solver choice depends on the model: `FixedStepDiscrete` for a fully discrete model, `ode1`/`ode3`/`ode4` when continuous states are present, or `FixedStepAuto` to let Simulink choose.

Do not switch continuous to discrete dynamics, change solver order, or change the base rate as a silent cleanup — those change numerical behavior, real-time load, and test results. Involve the user when the tradeoff is not obvious; for structured regression checks, use `testing-simulink-models`.

### 9. Preserve User Intent Around Stop Time

Desktop `StopTime` does not govern target execution; runtime stop-time control (`setStopTime(tg, ...)`, `start(tg, "StopTime", ...)`) belongs to `simulink-run-real-time-application`. Write model-level `StopTime` only when the user wants the saved model to carry that value, then verify the readback.

### 10. Configure Simulink Real-Time Options

The Simulink Real-Time Options pane appears only after a Simulink Real-Time STF is selected. The five option names in `references/api-reference.md` are the **only** ones this skill names. Read an option's current value before writing it; if the active config set does not expose it, report the mismatch instead of writing. Enable `UseGCCFastMath` only on explicit request. Do not override target-managed toolchain, make-command, or target-language parameters. Dialog names and per-option guidance: `references/slrt-options.md`; custom compiler flags: `references/compiler-options.md`.

### 11. Validate Product and Add-On Assumptions

Before diagnosing STF errors, check `v = ver; installedNames = string({v.Name});` for MATLAB, Simulink, Simulink Coder, and Simulink Real-Time. Speedgoat hardware also needs the Speedgoat Add-On for `speedgoat.tlc` and `speedgoat_aarch64.tlc`.

**This check establishes capability, not intent** — never use it to infer which hardware the user is targeting.

**A missing support package stops this workflow.** When the user has named their hardware and the add-on that provides its STF is not installed, name the exact STF value and the add-on, tell the user to install it and come back, and apply no partial configuration — see `references/disconnected-workflow.md` § *Required support package absent*.

### 12. Validate Configuration Before Saving

Read back `SystemTargetFile`, `SolverType`, `Solver`, and `FixedStep`. `SolverType` must be `Fixed-step`; if not, the configure calls did not take effect — do not save, diagnose first. With a target object available, compare the model's STF against `getSTFName(tg)`; on a mismatch, do not save and report it.

### 13. Run Update Diagram

Ask permission, then run `set_param(model, "SimulationCommand", "update");` — a lifecycle command, one of the few `set_param` forms this skill authorizes. On failure, report the diagnostic. Typical causes: variable-step solver settings, blocks unsupported for code generation, continuous states with an incompatible solver, missing sample times, invalid config-set references, missing support packages, or target-file callback failures.

### 14. Save Only After Successful Setup

Ask whether to save and wait for the answer **before** `save_system(model)`. Saving first and asking afterward is not consent. For a dry run or inspection, do not save — return the planned changes.

## Guardrails

Always:

- Derive the target file from a connected target when possible, preferring `configureModelForTargetPlatform` over `getSTFName` plus manual writes.
- Inspect and change the named model configuration parameters through the active environment's model-configuration capabilities; use the product APIs in `references/api-reference.md` for target-object, introspection, and lifecycle operations.
- Run Upgrade Advisor for legacy models, and set or preserve fixed-step behavior explicitly.
- Verify `SystemTargetFile`, `SolverType`, `Solver`, and `FixedStep` after changing configuration.

Ask first:

- **Before calling `connect(tg)`** — always confirm the specific target name, even if only one target is defined.
- Before reconfiguring a model already on a Simulink Real-Time family target file.
- Before changing a model with an external config set.
- Before applying Upgrade Advisor fixes that may alter model behavior.
- Before setting a fixed-step size when the intended base rate is unknown.
- Before enabling performance-affecting compiler options such as `-ffast-math`.
- Before running update diagram after configuration.

Never:

- **Pick a target on the user's behalf or call `connect(tg)` without explicit permission for that specific target name.** Even with a single defined target, list it and confirm.
- **Treat installed products or support packages as evidence of the user's intended hardware.** `ver` output, a present Speedgoat Add-On, and a clean `speedgoat.version` establish capability only. Never write `SystemTargetFile` on the strength of an installed-support probe when the user has not stated their target family — propose and wait instead.
- **Save the model before the user has agreed to it.** Ask, then wait for the answer, then `save_system`. Applying changes and announcing "the model has been saved" alongside a request for confirmation reverses the gate.
- **Invent function names, property names, or parameter values that do not appear in `references/api-reference.md`, this skill's examples, or its reference files.** If a form is not shown, do not use it — for example, hard-coding `slrealtime.tlc` for a Speedgoat target, or calling `tg.setSTF(...)`.
- **Invent internal check IDs for Upgrade Advisor.** The only valid Simulink Real-Time check IDs are `mathworks.design.slrealtimeUpgrades` and `mathworks.design.slrealtimeLoggingUpgrades`. For anything else, open the advisor with `upgradeadvisor(model)` and tell the user which categories to run.
- Change solver type, solver, or fixed-step size without preserving model intent.
- Build the model in this skill unless the user explicitly asks for setup plus build.

---

Copyright 2026 The MathWorks, Inc.

---

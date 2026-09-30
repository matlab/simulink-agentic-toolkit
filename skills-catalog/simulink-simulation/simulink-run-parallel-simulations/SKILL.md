---
name: simulink-run-parallel-simulations
description: >-
  Use this skill to run multiple Simulink simulations in parallel with parsim, batchsim, and DesignStudy.
  TRIGGER when: user asks for parameter sweep, sweeping/varying parameters across simulations, Monte Carlo study, batch simulation, running multiple simulations, parallel simulations, large-scale multiple simulations, any task involving repeated simulations with different parameter values, user mentions having an existing script/function for parameter sweeps, or user wants to migrate from parfor/set_param/for-loop patterns to recommended workflows.
license: https://www.mathworks.com/content/dam/mathworks/license/pmrl/license.md
metadata:
  author: MathWorks
  version: "1.1"
---

# Running Multiple Simulations in Parallel

Set up and run parallel simulations with `parsim`, `batchsim`, or `simulink.multisim.DesignStudy`.

## When to Use

- Parameter sweeps, Monte Carlo studies, batch simulations (local or cluster)
- `parsim` (local parallel), `batchsim` (cluster offload), `DesignStudy` (large-scale combinations)
- `preSimFcn`/`postSimFcn` callbacks for setup or post-processing
- Live visualization as simulations complete (ValueStore pattern)

## When NOT to Use

- Single simulation → `simulating-simulink-models`
- Pass/fail tests → `testing-simulink-models`
- Model editing → `building-simulink-models`


## Prerequisites

If model inspection cannot resolve them, ask the user to provide: the exact model filename, the parameter name and type (workspace variable, block parameter, or model parameter), and the logged signal name(s) to use for metrics. Do not guess any of these values.

## Key Functions

| Function | Purpose | Toolbox | Available From |
|---|---|---|---|
| `Simulink.SimulationInput` | Specify per-run parameter overrides and callbacks | Simulink | R2017a |
| `parsim` | Run a SimulationInput array / DesignStudy on a parallel pool | Simulink | R2017a |
| `batchsim` | Offload a campaign to a cluster as a background job | Simulink | R2018b |
| `simulink.multisim.DesignStudy` | Generate multi-parameter combinations (with `.Variable` / `.ModelParameter` / `.BlockParameter` / `.ExternalInput` / `.Exhaustive` / `.Sequential`) | Simulink | R2024a |
| `parpool` | Create a parallel pool sized to the campaign | Parallel Computing Toolbox | R2013b |
| `parcluster` | Query the cluster profile and worker capacity | Parallel Computing Toolbox | R2012a |

**Match suggestions to the running release.** The "Available From" column is authoritative: before recommending a function, confirm it exists in the release in use (`version('-release')`) and never propose one introduced later.

## Workflow

1. **Project setup** — Before discovery, `cd` to the project folder if provided and open the Simulink project (`openProject`) if a `.prj` exists. This ensures referenced models and supporting files are on the MATLAB path and will be automatically transferred to parallel workers by `parsim`.

2. **Discovery findings** — Read-only inspection (no simulations). Report these as facts (no confirmation needed):
   - **Model**: list `.slx` files to resolve the actual filename. Never guess a model name — resolve it from the filesystem. Ensure the model is open or loaded before inspecting it.
   - **Sweep parameter(s) + type**: workspace variable / block parameter / model parameter (see Discovering Parameter Type). 
   - **Output metrics + how they are accessed**: determine where each metric comes from — this decides the `postSimFcn` accessor before any code is written (see "Getting Metrics Out"):
     - *Logged signals*: use `ModelLoggingInfo.createFromModel(model)` to find the logged set without simulating; check the logging variable name (query the model's `SignalLoggingName` parameter via `model_query_params`) — do not assume `logsout`. Access by name.
     - *Root Outports*: if the model has no logged signals, top-level Outports are the metric source — captured via `SaveOutput`/`yout`. Their `yout` Dataset elements are typically name-less, so `getElement('name')`/`get('name')` will not match — access them by `BlockPath` or positional index. Enumerate the top-level Outport blocks with `model_read` (or `model_overview`).
     - *Signal marked loggable but currently off*: capture it non-destructively with a `DataLoggingOverride` (see "Getting Metrics Out") — no model edit. If the signal is not in the model's loggable set, `verifySignalAndModelPaths` errors; that signal needs a model change (enable logging or add an Outport) — surface it as a consent-required plan point, do not enable it silently.
     Record which mechanism (and therefore which accessor) each metric uses, so the `postSimFcn` is authored correctly from the start.
   - **How the model's data is provisioned**: determine where the model's data comes from and whether it loads *with* the model — a `PreLoadFcn`, a bound data dictionary, or model-workspace variables all load when the model does, so they reach each worker automatically. Only data from a step that does not run on load must be established explicitly per worker (see "Getting Data and Dependencies to Workers").
   - **Pool capacity**: `parcluster` default profile capacity.
   - **Optimization compatibility**: inferred FastRestart tunability (from parameter type) and whether Rapid Accelerator is a candidate.

3. **Simulation plan** — The decisions the user approves. Present as numbered points; end with: *"Shall I proceed? To adjust, reference any point (e.g., 'for point 3, use X instead')."*

   1. **Sweep**: values + count (`linspace` for uniform). For Monte Carlo/uncertainty, ask the sampling method if unspecified and record the seed (client-side — see Reproducibility). For multiple parameters, ask Exhaustive (full grid) vs Sequential (paired).
   2. **How to run**: execution (`parsim` vs `batchsim`) and specification (`SimulationInput` array vs `DesignStudy`) per the comparison tables — state the choice, don't default silently.
   3. **Output signal(s)** for metrics.
   4. **Post-processing**: 
      - If the user described a metric or goal → reduce results by default: `postSimFcn` keeps only that metric and discards all other signals and full time-series. State this in the plan so they can adjust it (e.g. name extra signals to return, which `postSimFcn` appends to the `SimulationOutput`).
      - If no goal was given → estimate the total logged-signal data size (signals × time steps × runs) and ask which signals, if any, they want to keep — full logs from many runs can exhaust memory.
   5. **Live visualization** (optional): ValueStore + `KeyUpdatedFcn` if wanted, and what to plot. Ask yes/no explicitly.
   6. **Pool size**: see "Sizing the pool".
   7. **Options**: `UseFastRestart='on'` if tunable; Rapid Accelerator if applicable (see those sections). Don't add other options unless asked.
   8. **Worker dependencies**: `ManageDependencies='on'` (the default) auto-transfers detected dependencies; ask the user to let you know if any other files need to be manually attached via `AttachedFiles`.
   9. **Script**: propose a `.m` filename in the model's folder, so the sweep script, its callback files, and the model sit together and are on the path when the script runs. If the script must live elsewhere, `addpath` the model's folder when loading the model so the model and its callback files stay on the path.

   **CRITICAL: Do not run simulations until the user explicitly confirms the plan. Always wait for confirmation — even if a reusable script already exists, even if the request seems straightforward. No exceptions.**

4. **Write the script** — Only after the user confirms. Before writing, read the reference file(s) for every topic the task touches (see "References") and follow the patterns they prescribe. Write a `.m` script file with the agent's Write tool.

5. **Test run, then expand** — For large campaigns (N ≥ 500), first run the script on the first 2 `SimulationInput`s (`in(1:2)`) over only a few time steps (set a short `StopTime` for the test) to validate `postSimFcn` correctness and FastRestart/Rapid Accelerator tunability cheaply — the first sim compiles, the second reveals whether the change is tunable. If it succeeds, restore the full `StopTime`, expand to all simulations (`in(1:N)`), and run the campaign with `run_matlab_file`. For small campaigns (N < 500), skip the test and run all N directly (checking `ErrorMessage` afterward catches a broken `postSimFcn`). Do not bake a dry-run/validation-mode/sample-size switch into the deliverable script. Do not use Simulation Manager unless the user asks.

6. **Analyze and visualize** — Use markers + lines for plots.

7. **Always ask for next steps** — After the sweep, suggest plotting, finding optimal values, flagging outliers, checking requirements, or refining the sweep. Only suggest analysis derivable from the available data — do not offer what was discarded during post-processing.

## Discovering Signal Names and Parameter Type

Resolve logged signal names and locate the sweep parameter before writing any code — see `references/signal-and-parameter-discovery.md`.

---

## Choosing How to Run

Two independent choices — pick one from each axis. Both `parsim` and `batchsim` accept either a `SimulationInput` array or a `DesignStudy`, and both run on a local pool or a remote cluster (MATLAB Parallel Server), so the axes compose freely.

### Execution: `parsim` vs `batchsim`

| | `parsim` | `batchsim` |
|---|---|---|
| **How it runs** | Interactive — runs on the pool and blocks the client session | Offloaded — submits a background job (`simjob = batchsim(in)`) |
| **Results** | Returned in-session: `out = parsim(in)` | Retrieved later: `fetchOutputs(simjob)` |
| **Prefer when** | You want results now; short/medium campaigns; iterating on the setup | Long campaigns (hours/days); you want to keep using or close MATLAB; access the job later from another machine |
| **Simulation Manager UI** | Supported (`ShowSimulationManager="on"`) | Not available |
| **Limitation** | Ties up the session until all runs finish | Job-management overhead; results are not immediate |

### Specification: `SimulationInput` array vs `DesignStudy`

| | `SimulationInput` array | `simulink.multisim.DesignStudy` |
|---|---|---|
| **How you define it** | Build and index the array explicitly (`in(k) = ...`) | Declare parameters + a combination (`Exhaustive`/`Sequential`); it generates the run set |
| **Prefer when** | Single-parameter sweeps; full per-run control; custom per-run logic | Multi-parameter combinations; large structured sweeps |
| **Pros** | Simple, transparent; straightforward `preSimFcn`/`postSimFcn` wiring | No manual nested loops; scales to large grids; `OutputLocation` control for large result sets |
| **Limitation** | Manual nested loops get unwieldy for multi-parameter grids | More API surface; `parsim(designStudy)` returns a Future — call `fetchOutputs`; verify syntax with `help simulink.multisim.DesignStudy` |

Decide both axes during discovery and record them in the Simulation plan — do not default to `parsim` + `SimulationInput` without considering the cues above.

## SimulationInput array + parsim

```matlab
model = 'MyModel';
gains = linspace(0.5, 5, 20);
N = numel(gains);

clear in;  % Prevent stale array from prior runs
in(1:N) = Simulink.SimulationInput(model);   % allocate the array once
for k = 1:N
    % Mutate in(k) in place — do not call Simulink.SimulationInput(model) again here.
    in(k) = in(k).setVariable('Kp', gains(k));  % only the run-to-run override
end

out = parsim(in);
```

**Setup once, vary per run.** Build campaign-wide state once — allocate the `SimulationInput` array, load base data (see "Getting data and dependencies to workers"), open the project. Inside the loop do only what changes run-to-run: per-run overrides and callbacks. Never re-allocate the array or re-run initialization inside the loop.

### Sizing the pool

Open a pool of `min(numSims, capacity)` — never more workers than sims. `parsim` opens one automatically, but sizing it explicitly avoids requesting more workers than the profile would otherwise open for a small sweep. Derive the capacity from the profile: `PreferredPoolNumWorkers` is the pool size a plain `parpool` opens, and `NumWorkers` is the profile's maximum — take the smaller, because requesting more than `NumWorkers` errors. `parpool` also errors if a pool already exists, so reuse an adequate one rather than restarting it:

```matlab
c        = parcluster();                              % default profile
capacity = min(c.PreferredPoolNumWorkers, c.NumWorkers);
target   = min(N, capacity);                          % N = number of sims
pool = gcp('nocreate');
if isempty(pool) || pool.NumWorkers < target
    delete(pool);                            % no-op if empty; clears an undersized pool
    parpool(target);
end                                          % else: reuse the existing adequate pool
```

### Setting parameters

Use `setVariable` for workspace variables, `setModelParameter` for model-level settings (e.g., StopTime), `setBlockParameter` for block dialog parameters, and `setExternalInput` for time-varying input signals. For a variable in the **model workspace** or a **data dictionary** (not the base workspace), `setVariable` must name it: `setVariable('Mu', value, 'Workspace', model)` — plain `setVariable('Mu', value)` targets the base workspace and will not reach it. Confirm which workspace the variable lives in via Discovering Parameter Type before writing the call. Use `setVariable` only for values that change run-to-run — see "Getting data and dependencies to workers" for where base initialization belongs.

### Optimization: FastRestart and Rapid Accelerator

`UseFastRestart='on'` reuses the compiled model across tunable-only runs; Rapid Accelerator (`SimulationMode='rapid-accelerator'`) runs a compiled target for many fast runs after a one-time build. Do not add options beyond these unless the user asks. For the full option table, the FastRestart tunability rules, and the Rapid Accelerator build/staleness caveats, see `references/optimization-options.md`.

---

## DesignStudy and batchsim (API notes)

`DesignStudy` specifies values for massive simulations using parameter combinations; `batchsim` offloads a campaign as a retrievable job — see `references/designstudy-and-batchsim.md`.

---

## Getting Data and Dependencies to Workers

Workers do not inherit the client base workspace — decide what transfers automatically, what needs `AttachedFiles`, and when a `SetupFcn` is (and is not) required. For Monte Carlo, seed and record the RNG on the client. See `references/worker-data-transfer.md`.

---

## Migrating Existing Scripts

If the user provides an existing script or mentions they have one, identify which anti-patterns it uses, show the mapping and its benefits, and offer to rewrite using the recommended approach.

| Anti-pattern | Recommended |
|---|---|
| `parfor` + `sim` | `parsim` with `SimulationInput` array |
| `set_param` + `sim` in a loop | `setBlockParameter` / `setVariable` on `SimulationInput` |
| `assignin('base', ...)` + `sim` | `setVariable` on `SimulationInput` |
| `for` loop + `sim` + manual result collection | `parsim` + `postSimFcn` |

Key conversions: `set_param(blk, p, v)` → `in.setBlockParameter(blk, p, v)`, `assignin('base', n, v)` → `in.setVariable(n, v)`, `parfor` → `parsim(in)`. See Setting parameters and postSimFcn sections for full patterns.

When a `set_param` call targets a block dialog parameter whose value is a workspace variable (e.g., a Gain block with `Gain = 'Kq'`), the swept quantity is that variable — migrate to `setVariable('Kq', value)` rather than `setBlockParameter`. Run Discovering Parameter Type on the target first to confirm where the value lives.

---

## Getting Metrics Out

Pick the metric accessor during discovery — logged signal, root Outport, or a signal that is loggable but currently off — so the `postSimFcn` is authored correctly the first time. See `references/output-metrics.md`.

---

## Pre/Post Simulation Functions and Visualization

Use `preSimFcn` to derive dependent parameters and `postSimFcn` to post-process each run — deriving and reducing to the needed metrics — and drive live plots with a ValueStore `KeyUpdatedFcn` — see `references/simulation-callbacks.md`.

---

## Failure Handling

After `parsim` completes, check for failed runs:

```matlab
failedIdx = find(arrayfun(@(o) ~isempty(o.ErrorMessage), out));
for k = failedIdx
    fprintf('Run %d: %s\n', k, out(k).ErrorMessage);
end
```

If failures occur, inspect the error messages to identify the root cause (e.g., config mismatch, missing variable, invalid block path). Present the errors to the user, explain the likely cause, and propose an updated plan to fix the issue before re-running. Do not blindly retry — parsim failures are typically deterministic and will recur without a fix.

- Non-tunable parameter errors (e.g., dimension changes, sample time conflicts): `UseFastRestart` is enabled but the swept parameter is not tunable. Remove `UseFastRestart` and re-run.

---

## Debugging

Profile runs, read worker-side diaries, size output to avoid out-of-memory, and clear stale build artifacts — see `references/debugging.md`.

---

## Guardrails

- **Never** guess model filenames from user descriptions — list `.slx` files in the project directory to resolve the actual name.
- **Never** modify the user's model — not even in memory — without explicit consent. This includes enabling signal logging, changing config parameters, or any `set_param` call on the model. If changes are needed, present them in the plan and use `setModelParameter` on `SimulationInput` for non-destructive application where possible.
- **Never** use `set_param` to drive simulations — use `SimulationInput`/`DesignStudy`.
- **Never** use `try-catch` around signal access in `postSimFcn` — confirm signals via `ModelLoggingInfo` first.
- **Never** guess signal names — verify from model without simulating.
- **Never** run simulations for discovery purposes without user confirmation — models can take hours to simulate.
- **Never** change parameters beyond what user requested.
- **Never** assume `parsim` accepts `sim` options (e.g., `OutputFcn`, `StopFcn`) — `parsim` has its own API. Check `parsim` documentation for the relevant MATLAB release before using any option.
- **Never** add parsim options beyond what the tunability rules prescribe unless the user explicitly requests them.
- **Always** use `in`/`out` as variable names.
- **Always** set parameters with the documented single-call form — `in = in.setModelParameter(Name=Value)`, `in = in.setVariable(name, value)` — one call per statement.
- **Always** set only the parameters a task needs, and only when the model's current setting doesn't already provide it — e.g. set `SaveOutput='on'` only if it is currently off; leave other model parameters at their defaults.
- **Always** use `setExternalInput` with a `Dataset`.
- **Always** check `simOut.ErrorMessage` in `postSimFcn`.
- **Always** use markers + lines for plots (e.g., `'-o'`).
- **Prefer** `DesignStudy` for large exhaustive combinations.
- **Prefer** `postSimFcn` to reduce results over full log transfer.
- **Keep the generated script lean** — only the callbacks the task needs; avoid many small local functions.

## References

Each topic's APIs and code patterns live in its reference file. Read the matching reference before writing code for that topic, and follow the patterns it prescribes.

| When the task involves… | Read before writing code |
|---|---|
| Resolving signal names and sweep-parameter type | `references/signal-and-parameter-discovery.md` |
| Accessing output metrics (logged / Outport / off) | `references/output-metrics.md` |
| Getting data and dependencies to workers | `references/worker-data-transfer.md` |
| preSimFcn / postSimFcn / live visualization | `references/simulation-callbacks.md` |
| DesignStudy and batchsim API | `references/designstudy-and-batchsim.md` |
| FastRestart and Rapid Accelerator options | `references/optimization-options.md` |
| Debugging parallel runs | `references/debugging.md` |

----

Copyright 2026 The MathWorks, Inc.

----

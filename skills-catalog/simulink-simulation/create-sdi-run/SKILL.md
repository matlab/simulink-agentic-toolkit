---
name: create-sdi-run
description: >
  Import data into the Simulation Data Inspector (SDI) from MAT, CSV, or Excel
  files, from workspace variables, or from a Simulink simulation. Use when the
  user wants to view a logged file in SDI, load a bench-test log, or verify
  what a just-completed `Simulink.sdi.createRun` or `sim(model)` produced.
  Covers the `'file'`, `'vars'`, and `'namevalue'` sources of `createRun`, the
  auto-populate behavior after `sim()`, and post-import verification. Not for
  comparing existing runs (use `Simulink.sdi.compareRuns`); not for streaming
  data live during a running simulation (use
  `Simulink.sdi.createRunOrAddToStreamedRun` — a separate API); and not for
  authoring Gherkin or Simulink Test test cases, assertions, or regression
  tests (use `testing-simulink-models`). Do not activate on test-authoring or
  verification prompts even when no test-authoring skill is available — say
  so and stop.
license: https://www.mathworks.com/content/dam/mathworks/license/pmrl/license.md
metadata:
  author: MathWorks
  version: "1.0"
---

# Create SDI Run

Get data into the Simulation Data Inspector using the shortest path that works. Most agents reflexively read files into the workspace and rebuild signals by hand; this skill teaches the direct paths and when each applies.

## When to Use

- User has a `.mat`, `.csv`, or `.xlsx` file of logged data and wants to view it in SDI.
- User just ran `sim(model)` and wants to see the logged signals.
- User has `timeseries`, `timetable`, or `Simulink.SimulationData.Dataset` variables in the workspace and wants an SDI run.
- User asks about `Simulink.sdi.createRun`, `Simulink.sdi.getAllRunIDs`, or `Simulink.sdi.getRun`.

## When NOT to Use

- Comparing two existing runs — that is a distinct workflow (`Simulink.sdi.compareRuns`).
- **Streaming data live during a running simulation** — this is a separate API (`Simulink.sdi.createRunOrAddToStreamedRun`), not a mode of `createRun`. Prompts like "stream data into SDI while my sim is running" belong to that API. Do not activate on those.
- Files in MDF (`.mf4`), ULG, ROS bag, CAN log, or HDF5 formats — see [references/format-support.md](references/format-support.md) for what SDI reads natively vs. what needs a different toolbox.
- Customizing plot layout, cursors, or subplot arrangement beyond opening the SDI window.
- **Authoring Gherkin `.feature` files, Simulink Test cases, `matlab.unittest` classes, or any pass/fail assertions or regression tests** for a model or subsystem — use `testing-simulink-models` (Gherkin-based `model_test`, requires Simulink Test). Prompts like "write a Gherkin test for X", "verify abs(-5) equals 5", "create a regression test for this subsystem", or any request whose deliverable is a test artifact belong there. Do **not** activate this skill on such prompts even when `testing-simulink-models` is unavailable — in that case, tell the user which skill is missing and stop.

## Workflow

Answer these four questions **in order**. The first "yes" tells you what to do.

### 1. Is the data already in SDI?

After `sim(model)` with signal logging enabled, SDI **auto-populates** one run. **Do not call `createRun`** — that produces a duplicate.

```matlab
before = Simulink.sdi.getAllRunIDs;
simOut = sim("myModel");
after  = Simulink.sdi.getAllRunIDs;
if numel(after) > numel(before)
    Simulink.sdi.view;   % done — just open the window
end
```

If no new run appeared, logging is off. Enable it via the Simulink Agentic Toolkit `model_edit` tool with a `configure` op setting `DataLogging` on the target port, then re-simulate — or fall back to Step 3 with `simOut`. As a last resort, ask the user to right-click a signal → **Log Selected Signals** in the Simulink editor themselves; that step is for the user to perform, not the agent.

### 2. Is the data in a file?

Use the `'file'` source. One call handles MAT, CSV, and Excel natively — no `load`, no `readtable`, no `sheetnames` loop.

```matlab
runID = Simulink.sdi.createRun("bench_test","file","logs/bench_test.mat");
```

**Excel with N sheets returns a 1×N `int32` vector** — one run ID per sheet. All returned runs inherit the base `name`; if the user needs sheet-named runs, rename each run in place with `sheetnames()` — do **not** delete and re-import per sheet:

```matlab
runIDs = Simulink.sdi.createRun("cases","file","cases.xlsx");   % [id1, id2, ...]
sheets = sheetnames("cases.xlsx");
for k = 1:numel(runIDs)
    Simulink.sdi.getRun(runIDs(k)).Name = sheets(k);
end
```

**Time-column header rule (CSV and Excel).** SDI's built-in reader requires the time column to be named literally `time` (case-insensitive). Headers like `time_s`, `t`, `Time (s)`, `Timestamp` cause `SDI:sdi:ImportError`. **Try `'file'` first and catch the error** — do not pre-inspect the header row and guess, because SDI's matching rules can differ from your interpretation. On `SDI:sdi:ImportError`, fall back to the `readmatrix` + `array2timetable` + `'vars'` pattern (Step 3 / CSV pattern below). Do **not** rewrite the source file.

**Other `createRun` failures.** `createRun` can also throw for reasons this skill does not enumerate — corrupted files, unsupported data types inside a MAT/Excel, malformed structs, permission errors, unregistered custom readers. When you catch an error identifier that is not `SDI:sdi:ImportError`, do **not** invent a fix or silently retry. Surface the full error identifier and message to the user, list the file or variables involved, and suggest they inspect the source (e.g., `whos("-file",path)` for a MAT, or `sheetnames(path)` plus a per-sheet read for an Excel). Ask before attempting an alternative import path.

### 3. Is the data in workspace variables?

Two sources, different purposes:

- **`'vars'`** — pass variables whose names or `.Name` properties are already correct. This is the default.
- **`'namevalue'`** — pass explicit signal names when the variables have no `.Name` metadata (e.g., bare arrays or unnamed `timeseries`).

Timeseries whose `.Name` is already what you want:

```matlab
% TEMPLATE — not executable
runID = Simulink.sdi.createRun("baseline","vars", speedTS, torqueTS);
```

Timetable — signals inherit the column names:

```matlab
% TEMPLATE — not executable
runID = Simulink.sdi.createRun("baseline","vars", benchTT);
```

Bare arrays needing explicit names:

```matlab
% TEMPLATE — not executable
runID = Simulink.sdi.createRun("baseline","namevalue", ...
    {"velocity","load"}, {velocityData, loadData});
```

**Gotcha (Gap E):** if a `timeseries` passed to `'namevalue'` has its own `.Name` set, `.Name` **wins** over the caller-supplied name. To force the name you want, either set `ts.Name` first and use `'vars'`, or clear it before `'namevalue'`.

### 4. Verify the run

After every `createRun` or auto-populate:

```matlab
ids = Simulink.sdi.getAllRunIDs;
run = Simulink.sdi.getRun(ids(end));
fprintf("Run %d: %s (%d signals)\n", ids(end), run.Name, run.SignalCount);
for k = 1:run.SignalCount
    fprintf("  %s\n", run.getSignalByIndex(k).Name);
end
Simulink.sdi.view;
```

Verify against MATLAB via the MATLAB MCP server's `evaluate_matlab_code` tool. If `SignalCount == 0`, the import silently produced nothing — investigate the source, do not report success.

## Key Functions

All available from R2023a with base Simulink; no additional toolbox required.

| Function | Purpose | Available From |
|---|---|---|
| `Simulink.sdi.createRun(name)` | Empty run — used with `Run.add` for a per-signal build; rarely the right first choice. | R2011b |
| `Simulink.sdi.createRun(name,"file",path)` | Import a `.mat`, `.csv`, or `.xlsx` file. Returns scalar `int32` for MAT/CSV, `1×N int32` vector for N-sheet Excel. | R2011b |
| `Simulink.sdi.createRun(name,"vars",v1,v2,...)` | Import workspace variables whose names/`.Name` are correct. | R2011b |
| `Simulink.sdi.createRun(name,"namevalue",names,values)` | Import with explicit names. See Gap E caveat. | R2011b |
| `Simulink.sdi.view` | Open the SDI window. Safe to call repeatedly; opens only if not visible. | R2011b |
| `Simulink.sdi.getAllRunIDs` | Return `int32` vector of every run's ID. Use before/after `sim` to detect auto-populate. | R2017a |
| `Simulink.sdi.getRun(runID)` | Return the `Simulink.sdi.Run` object for a run ID. | R2011b |
| `Simulink.sdi.clear` | Delete all SDI runs. **Ask the user first** — destructive. | R2011b |

Four `createRun` sources exist: **empty**, **`'vars'`**, **`'namevalue'`**, **`'file'`**. When unsure, run `help Simulink.sdi.createRun`.

## Patterns

### Pattern: MAT file → SDI (one line)

```matlab
runID = Simulink.sdi.createRun("sensor_log","file","data/sensor_log.mat");
Simulink.sdi.view;
```

The variables inside the MAT file may be `timeseries`, `timetable`, `Simulink.SimulationData.Dataset`, or legacy struct-with-time — SDI's reader picks them up automatically.

### Pattern: CSV file → SDI (try `'file'`, catch, fall back)

Attempt the one-liner first. On `SDI:sdi:ImportError`, fall back to the timetable path — do not rewrite the file:

```matlab
try
    runID = Simulink.sdi.createRun("bench_run","file","logs/bench_run.csv");
catch ME
    if strcmp(ME.identifier,"SDI:sdi:ImportError")
        raw     = readmatrix("logs/bench_run.csv");
        headers = string(readcell("logs/bench_run.csv","Range","1:1"));
        tt = array2timetable(raw(:,2:end), ...
                "RowTimes", seconds(raw(:,1)), ...
                "VariableNames", headers(2:end));
        runID = Simulink.sdi.createRun("bench_run","vars", tt);
    else
        rethrow(ME);
    end
end
```

Assumes the time column is column 1 and expressed in seconds — the common case for bench logs. If the time column sits elsewhere or uses different units, adjust the index or wrap it with the appropriate `duration` constructor (`milliseconds`, `minutes`, …) before passing to `RowTimes`.

### Pattern: Excel with multiple sheets → one run per sheet

One `createRun` call per file. Every returned run initially inherits the **base name** you supplied — SDI does not auto-apply sheet names. Rename in place with `sheetnames()`; do **not** delete and re-import per sheet. The same time-column-header rule applies as for CSV — if a sheet's time column is not named `time`, `createRun` throws `SDI:sdi:ImportError`; wrap this call in the same try-then-fallback shown in the CSV pattern, using `readmatrix(...,"Sheet",sheets(k))` and `readcell(...,"Sheet",sheets(k),"Range","1:1")` per sheet.

```matlab
runIDs = Simulink.sdi.createRun("test_matrix","file","data/two_runs.xlsx");
% runIDs is a 1xN int32 vector — one ID per sheet, all named "test_matrix".
sheets = sheetnames("data/two_runs.xlsx");
for k = 1:numel(runIDs)
    run = Simulink.sdi.getRun(runIDs(k));
    run.Name = sheets(k);   % rename in place to the sheet name
    fprintf("Sheet run: %s (%d signals)\n", run.Name, run.SignalCount);
end
```

To restrict to specific sheets, use the `sheets` name-value — the returned vector is trimmed accordingly:

```matlab
runIDs = Simulink.sdi.createRun("cases","file","cases.xlsx", ...
    sheets=["baseline","variant"]);
```

### Pattern: Post-sim — just open SDI

```matlab
before = Simulink.sdi.getAllRunIDs;
simOut = sim("controller_test");
after  = Simulink.sdi.getAllRunIDs;

if numel(after) > numel(before)
    Simulink.sdi.view;             % logged signals already imported
else
    % No auto-populate — logging is off. Enable it and re-simulate, or
    % pass simOut through createRun as a fallback:
    Simulink.sdi.createRun("run_from_simout","vars", simOut);
    Simulink.sdi.view;
end
```

### Pattern: Rename workspace signals

Set `.Name` before `'vars'`. This avoids the `'namevalue'` override trap.

```matlab
data = load("data/speed_torque.mat");
speed  = data.speed;
torque = data.torque;
speed.Name  = "velocity";
torque.Name = "torqueNm";
runID = Simulink.sdi.createRun("baseline","vars", speed, torque);
```

## Conventions

**Always**

- **Check whether SDI already has the data before calling `createRun`.** Use `Simulink.sdi.getAllRunIDs` before and after `sim(model)`. If a new run appeared, `sim` already imported the logged signals — call `Simulink.sdi.view` and stop.
- **Prefer the `'file'` source** for `.mat`, `.csv`, `.xlsx`. It handles the read and the signal-naming for you. Reserve `load`/`readtable`/`sheetnames` for the CSV time-column fallback and for genuinely workspace-first workflows.
- **Verify with `SignalCount`.** After every import, confirm at least one signal exists. Zero signals means the import failed silently.
- **Read `help Simulink.sdi.createRun`** if you are unsure which source applies. The four sources are the entire API surface for import.

**Ask First**

- `Simulink.sdi.clear` — deletes every run. Confirm with the user before running.
- Modifying the source file (e.g., renaming a CSV column to `time`) — prefer the timetable fallback pattern instead of altering user data.
- Attempting an alternative import path after a non-`SDI:sdi:ImportError` failure — surface the error to the user first, then ask which path they want.

**Never**

- Never invent function names. `Simulink.sdi.createRunFromFile` does not exist. Use `Simulink.sdi.createRun(name,"file",path)`.
- Never rebuild a file-side workflow through `load` / `readtable` / manual `timeseries` construction / `Run.add` when the `'file'` source handles the same file natively.
- Never assume `namevalue` names take precedence over `timeseries.Name` — `.Name` wins. See Gap E in Common Mistakes.
- Never claim success without inspecting `SignalCount` and the signal names.

## Common Mistakes

| Mistake | Why It's Wrong | Correct Approach |
|---|---|---|
| Reading MAT/CSV/Excel yourself and calling `createRun(...,"vars",...)` | Duplicates the `'file'` source's work; loses SDI's automatic signal-name handling; scales badly for multi-sheet Excel. | `Simulink.sdi.createRun(name,"file",path)`. |
| Deleting the multi-sheet import and re-calling `createRun` in a per-sheet loop because both runs share the base name | Discards the correct one-call `'file'` import and violates the "single call handles sheet expansion" convention. All runs from one Excel file inherit the base name — they are **not** auto-renamed to sheet names. | Keep the one `createRun(...,"file",xlsx)` call and rename each run in place: `Simulink.sdi.getRun(runIDs(k)).Name = sheets(k)`. |
| Calling `createRun(...,"namevalue",{"SimOut"},{simOut})` after `sim(model)` | With signal logging on, `sim` already imported the run. This adds a duplicate. | `sim(model); Simulink.sdi.view;` (verify with `getAllRunIDs` before/after). |
| Using `Simulink.sdi.createRunFromFile` | Function does not exist. Hallucination. | `Simulink.sdi.createRun(name,"file",path)`. |
| Passing `namevalue` names when the timeseries has its own `.Name` | `.Name` overrides the caller-supplied name silently — Gap E. | Set `ts.Name` first, then use `'vars'`. Or clear `.Name` before `'namevalue'`. |
| Pre-inspecting the header and skipping `'file'` because you *think* the time column is misnamed | Your guess can differ from SDI's actual matching rules; skipping `'file'` costs the automatic signal handling. | Try `'file'` first, catch `SDI:sdi:ImportError`, then use the timetable fallback (Step 3 / CSV pattern). |

## References

- [references/format-support.md](references/format-support.md) — which file formats SDI reads natively, which need a toolbox, which need conversion. Consult when the user has a file extension other than `.mat`, `.csv`, or `.xlsx`.
- [references/createrun-signatures.md](references/createrun-signatures.md) — the four `createRun` sources side-by-side with return-value shapes and name-value options. Consult when picking a source or debugging return values.

----

Copyright 2026 The MathWorks, Inc.

----

> **Release compatibility:** MATLAB R2023a and later.

# Measuring Model Metrics

Unified sub-skill for running SIL/PIL simulations and collecting code metrics. Used in two modes:

- **Baseline mode** (Phase 2 & 2.5): First-ever measurement, lightweight listing, user-directed function targeting, deep analysis.
- **Remeasure mode** (Phase 4): Apply confirmed changes, re-run SIL/PIL, compare against previous metrics.

The calling skill (`simulink-optimizing-embedded-code`) sets the mode via the state object's `NEXT_ACTION`.

---

## Common: Configure Profiling & Run SIL/PIL

These steps are shared by both modes.

### Step C1: Read the `configuring-code-profile` instructions

Read `<skill_root>/references/measuring-model-metrics/configuring-code-profile/reference.md`. The decision framework uses the hardware target, board connectivity, optimization goal, and phase to autonomously decide:
- `verificationMode`: `'SIL'` or `'PIL'`
- `reportLevel`: `'coarse'` or `'detailed'`
- `profilingFocus`: `'time'` or `'stack'` (mutually exclusive — based on optimization goal; if goal is "both", start with `'time'` and switch to `'stack'` in a later re-measure cycle)
- `enableCRL`: `true` or `false` (true when hardware is a real MCU/board — enables Code Replacement Library report)

**Note:** Profiling configuration (step C2) is only used when `verificationMode` is `'SIL'` or `'PIL'`. If `verificationMode = 'codegen'`, skip step C2 and proceed directly to step C3 with `CodeMetricsFetcherCodegen` — it runs a normal simulation (with signal logging enabled for golden reference capture), then generates code via `slbuild` and collects static metrics. Phase 5 still performs a mandatory final SIL verification.

### Step C2: Configure the model

```matlab
addpath(fullfile('<skill_root>', 'scripts'));
configureProfilingMode('<model>', '<verificationMode>', '<reportLevel>', '<profilingFocus>', <enableCRL>);
```

The `enableCRL` flag comes from the state object's `ENABLE_CRL` field. Pass `true` when the model targets a real hardware board, `false` for generic/desktop targets.

### Step C3: Run SIL/PIL to generate code and collect metrics

*If SIL:*
```matlab
addpath(fullfile('<skill_root>', 'scripts'));
[reportText, simOut] = CodeMetricsFetcherSIL('<model>', '<reportLevel>');
```

*If PIL:*
```matlab
addpath(fullfile('<skill_root>', 'scripts'));
[reportText, simOut] = CodeMetricsFetcherPIL('<model>', '<reportLevel>');
```

*If codegen:*
```matlab
addpath(fullfile('<skill_root>', 'scripts'));
[reportText, simOut] = CodeMetricsFetcherCodegen('<model>', '<reportLevel>');
```

SIL/PIL automatically performs code generation, simulation, and metric extraction. PIL execution time reflects actual on-target performance; SIL execution time reflects host-simulated performance. Codegen mode runs a normal simulation (with signal logging) then generates code via `slbuild` for static-only metrics (no execution time). The `simOut` second output contains signal data — in Phase 2 it becomes the golden reference; in Phase 4 it is compared against that golden reference by the Correctness Gate.

If the run fails:
- **Build/codegen errors:** Inspect the error, fix model configuration or unsupported blocks, then retry.
- **Compiler not found:** Run `mex -setup` to configure a C compiler, then retry.
- **PIL connectivity error:** Verify the board is connected, COM port / IP is correct, and the hardware support package is installed.
- **SIL timeout or crash:** Check for algebraic loops, infinite loops in Stateflow, or model initialization errors. Fix and retry.
- **Target build failure:** Check that the cross-compiler for the target is configured (`mex -setup`).
- **Timeout:** The target may be unresponsive — reset the board and retry.

### SIL/PIL Fallback to Codegen (3-strike rule)

If SIL/PIL `sim()` fails **3 times** despite different fix attempts, fall back to codegen mode:

1. **Count:** Only count actual `sim()` failures in SIL/PIL mode (build errors, linker errors, timeouts). Configuration `set_param` failures do not count.
2. **After 3 failures:** Stop retrying SIL/PIL. Inform the user:
   > *"SIL/PIL is failing repeatedly due to [root cause summary]. Falling back to codegen mode — you'll get static metrics (RAM, ROM, stack, complexity) but no execution time. Final SIL verification in Phase 5 will also be skipped since SIL is unavailable for this model."*
3. **Set state flags:**
   - `state.VERIFICATION_MODE = 'codegen'`
   - `state.SIL_FALLBACK = true`
4. **Proceed with `CodeMetricsFetcherCodegen`.**
5. **Log:** `WARN MM-01: SIL/PIL failed 3 times — fell back to codegen. state.SIL_FALLBACK=true. Root cause: <summary>`

**When `state.SIL_FALLBACK = true`:**
- Phase 4 per-iteration correctness gate: skipped (same as normal codegen mode)
- Phase 5 final SIL verification: **skipped entirely** (unlike normal codegen mode which attempts it). Log `SKIP FR-05: SIL_FALLBACK=true — SIL is unavailable for this model; final verification skipped`
- HTML report: verification section omitted (renderer already handles this when `state.VERIFY` is empty)

If SIL/PIL repeatedly fails, you can still collect non-execution-time metrics by reading the generated code and using `rtw.codemetrics.CodeMetrics` directly — but execution time will be unavailable.

---

## Baseline Mode (Phase 2 & 2.5)

Use when `NEXT_ACTION` indicates baseline / first run.

---

### Phase 2: Generate Baseline Code & Metrics

1. **Run common steps C1–C3** above. For baseline, the `configuring-code-profile` sub-skill will use phase `'baseline'` which always yields `reportLevel = 'coarse'` (saves tokens). **Then save the baseline `simOut` as the golden reference:**

   ```matlab
   addpath(fullfile('<skill_root>', 'scripts'));
   goldenRefPath = saveGoldenReference(simOut, '<model>', '<project_path>');
   ```

   - `simOut` is the second output returned by `CodeMetricsFetcherSIL` or `CodeMetricsFetcherPIL` in step C3
   - Save the returned path in `state.GOLDEN_REF_PATH`
   - This captures the baseline SIL/PIL signal outputs — the same signals that Phase 4 will compare against
   - The `.mat` file is reused across all Phase 4 iterations (never re-captured)
   - **Codegen mode:** If `state.VERIFICATION_MODE == 'codegen'`, step C3 already used `CodeMetricsFetcherCodegen` which returns `simOut` from a normal simulation with signal logging enabled. Use that `simOut` directly:
     ```matlab
     goldenRefPath = saveGoldenReference(simOut, '<model>', '<project_path>');
     ```
     Store in `state.GOLDEN_REF_PATH`. This enables the Phase 5 final SIL verification even in codegen mode.
     Log `OK NC-02: Golden reference saved from normal sim (codegen mode) at <path>`.

2. **Extract a lightweight function listing (no heavy sub-task needed).** The coarse report is small enough to extract a quick listing. Delegate a **lightweight** sub-task whose ONLY job is to extract the function names and their top-level numbers from the report — **no code reading, no deep analysis**. This is intentionally cheap.

   **Sub-task prompt template for lightweight listing:**
   ```
   Read the coarse SIL/PIL metrics report for model '<model>' and extract ONLY a lightweight listing.
   Do NOT read any generated code files. Do NOT perform deep analysis.

   STEP 1 — READ THE REPORT:
   Read the metrics report file at: <absolute_path_to_project>/<model>_ert_rtw/function_metrics_report_<sil|pil>.txt.
   Since this is a coarse report, it will be small.

   STEP 2 — EXTRACT LISTING ONLY:
   1. Model-level summary: Total execution time, Global RAM (bytes), Local Static Vars (bytes), Unused Globals (count and bytes).
   2. For EACH function in the report, extract ONLY: function name, execution time (total/self), stack usage (bytes), cyclomatic complexity, data copy count. Present as a compact table.
   3. List ALL function names found (the user will select which ones to target).

   Return ONLY the model-level summary + compact function table. Nothing else.
   ```

3. **Present the lightweight listing to the user and ask for targeting.** Display the model-level summary and the function table. Ask the user: *"Here are the baseline metrics and functions from the coarse run. Which functions do you want to focus on for reducing <time/stack/memory>? (If you're not sure, I can analyze all of them.)"*

   **WAIT for the user's response before continuing to Phase 2.5.**

### Phase 2.5: User-Directed Function Targeting & Deep Analysis

This phase takes the user's input and THEN performs the heavy analysis — scoped to the user's targets if provided, or full if not.

1. **Receive the user's response.** Two possible outcomes:
   - **User specifies target functions** (e.g., *"Focus on `mcb_pmsm_foc_sim_RL_step` and `FOC_Current_Control`"*) → record as `targetFunctions` list. Proceed to step 2.
   - **User does not specify / says "analyze all"** → set `targetFunctions` to empty (full analysis). Skip to step 3.

2. **Check if target functions are visible in the coarse report.** Compare the user's `targetFunctions` against the function names from the lightweight listing (Phase 2, step 2).
   - **All targets found in coarse report** → proceed to step 3 using the existing coarse report. No re-run needed.
   - **Some targets NOT found in coarse report** → the coarse granularity missed those functions. Read the `configuring-code-profile` instructions — it will decide to escalate to `reportLevel = 'detailed'`. Re-configure and re-run:
     ```matlab
     addpath(fullfile('<skill_root>', 'scripts'));
     configureProfilingMode('<model>', '<verificationMode>', 'detailed', '<profilingFocus>', <enableCRL>);
     ```
     Then re-run the appropriate `CodeMetricsFetcher*` with `'detailed'`.

3. **Delegate the heavy analysis to a sub-task — scoped or full depending on user input.** This is where the deep analysis happens (reading code files, identifying patterns, etc.). The scope depends on whether `targetFunctions` is set.

   **If `targetFunctions` is set — delegate a SCOPED sub-task:**
   ```
   Read the SIL/PIL metrics report for model '<model>' and extract data ONLY for these target functions: [<targetFunctions list>].
   Optimization goal: <speed/memory/both>. Profiling focus: <time/stack>. Hardware: <target>.

   STEP 1 — READ THE REPORT (SELECTIVELY):
   Read the metrics report file at: <absolute_path_to_project>/<model>_ert_rtw/function_metrics_report_<sil|pil>.txt.
   Scan for the sections starting with '++Fcn Name: <targetFunction>' for EACH target function. Extract ONLY those sections. Skip all other functions entirely.

   STEP 2 — READ ONLY THE RELEVANT CODE FILES:
   For each target function, the report lists 'In which file does the function occur' and 'Starting line number, ending line number'. Read ONLY those specific files at those specific line ranges. Do NOT read the entire file or other files.

   STEP 3 — FOCUSED ANALYSIS:
   For each target function, provide:
   1. Function name, file, line range
   2. Cyclomatic complexity
   3. Execution time (total, self, calls) — if profiling focus is 'time' or 'both'
   4. Stack usage — if profiling focus is 'stack' or 'both'
   5. Global variables used (names and sizes)
   6. Data copies (count, bytes, locations)
   7. Code-level observations: double-precision math, large local arrays, unnecessary copies, inefficient patterns
   8. Specific optimization opportunities for THIS function

   Return ONLY the focused analysis for the target functions. Do NOT include data for other functions, raw report text, or full code listings.
   ```

   **If `targetFunctions` is empty — delegate a FULL sub-task:**
   ```
   Read and analyze the SIL/PIL metrics report and generated code for model '<model>'. The optimization goal is <speed/memory/both> on <hardware target>.
   Profiling focus: <time/stack>.

   STEP 1 — READ THE REPORT:
   Read the metrics report file at: <absolute_path_to_project>/<model>_ert_rtw/function_metrics_report_<sil|pil>.txt.
   Read it fully to extract all function entries.

   STEP 2 — READ THE GENERATED CODE:
   Read the generated code directory '<absolute_path_to_project>/<model>_ert_rtw/' to list files.
   Then read the main generated C file(s) (<model>.c, <model>_data.c) to understand code structure, identify double-precision math, large arrays, memcpy/memset usage, and other hotspots.

   STEP 3 — ANALYZE AND SUMMARIZE:
   1. Extract a summary metrics table with these rows: Execution Time, Global RAM (bytes), Local Static Vars (bytes), Stack Usage (highest, with function name), ROM / Code Size (from generated files if available), Number of functions, Cyclomatic Complexity (highest, with function name), Total Data Copies (count and bytes), Unused Globals (count and bytes).
   2. Identify the top 5 hotspot functions ranked by impact on <goal>. For each, list: function name, cyclomatic complexity, stack usage, data copy count/bytes, and why it matters.
   3. Note any use of memcpy, large arrays, lookup tables, or double-precision math on single-precision hardware.
   4. Flag key optimization opportunities.

   Return ONLY a concise structured summary (metrics table + hotspot list + notable findings + optimization opportunities). Do NOT include the raw report text or raw code listings.
   ```

4. **Present the analysis to the user.** Show the sub-task's output (scoped or full). Ask: *"Here's the analysis. Ready for optimization suggestions?"*

5. **MANDATORY TRANSITION to Phase 3.** Once the user confirms readiness for suggestions, **(a) append the decision trace** to `<project_path>/.eco_diagnostics/eco_decision_trace.md` (one entry per MM-0x risk — see "Decision Trace Logging" below), **(b) update the token usage report** (include the baseline SIL/PIL run cost), **(c)** construct the state object with baseline metrics and target functions populated, and **(d)** proceed to Phase 3 with `NEXT_ACTION: "Present Stage A optimization suggestions"`. **Refuse to transition if either diagnostic file has not been appended (OR-05/OR-06).**

---

## Remeasure Mode (Phase 4)

Use when `NEXT_ACTION` indicates apply + re-measure.

### Phase 4: Apply Changes & Re-measure

**Checkpointing rule (MANDATORY — do not violate):** Exactly **one checkpoint per accepted version, taken AFTER the Goal-Axis Acceptance Gate passes.** Do NOT create a pre-apply checkpoint. The revert safety net is the *live entry's* `commitSHA` (the element of `state.versionMap` whose `version === state.liveVersion`), which already points at the prior accepted version and is available throughout the apply / re-measure / gate sequence. See `<skill_root>/references/protocols/checkpointing-revert.md` for the full rule.

0.5. **Check customer `never` rules.** Before applying any candidate, read the `never` section from `<PROJECT_PATH>/.custom_optimizations/optimization_preferences.yaml` (if it exists). For each `never` rule, evaluate whether the specific proposed change would violate it. If violated → block the candidate, log `BLOCK EXT-04: <candidate> blocked — violates never rule "<text>"`, and move to the next candidate. If all candidates are blocked, report to the user and return to Phase 3 for new suggestions.

1. **On user confirmation, apply changes:**
   ```matlab
   cs = getActiveConfigSet('<model>');
   set_param(cs, '<ParamName>', '<NewValue>');
   ```

2. **Save the model** after applying all changes:
   ```matlab
   save_system('<model>');
   ```

3. **Run common steps C1–C3** above. For remeasure, the `configuring-code-profile` sub-skill will use phase `'remeasure'` and `targetFunctions` are known. The sub-skill will decide whether to stay coarse or escalate to detailed based on whether the target functions are visible at the current granularity. **Retain the `simOut` returned by `CodeMetricsFetcher*` — it is needed for step 3.5.**

3.5. **Run the Numerical Correctness Gate** (read `<skill_root>/references/protocols/correctness-gate.md`). This gate runs BEFORE the efficiency gate and is non-negotiable.

   ```matlab
   addpath(fullfile('<skill_root>', 'scripts'));
   verdict = checkNumericalCorrectness(simOut, state.GOLDEN_REF_PATH, state.TOLERANCE);
   ```

   **Three outcomes:**
   - **PASS (exact/warn)** → Log `OK NC-01` or `WARN NC-01`. Proceed to step 4.
   - **FAIL** → Auto-reject immediately:
     1. Call `eco_revert(workspacePath, <live entry>.tag, modelName)` — this closes the model, checks out the target commit, and reopens the model.
     2. Append `versionMap` entry with `status: "FAIL rejected — correctness regression on <signal> (err=<maxErr>)"`, `revertCause: "Gate_Rejected"`.
     3. Report to user which signal diverged and by how much.
     4. Do NOT proceed to step 4 or 5 (efficiency gate). Skip directly to step 7 (transition).

   **Skip conditions:**
   - `state.VERIFICATION_MODE == 'codegen'` → `SKIP NC-01: codegen mode — per-iteration gate skipped; final SIL verification deferred to Phase 5`
   - `state.GOLDEN_REF_PATH` is empty or file missing → `SKIP NC-01: golden reference unavailable`
   - `verdict.method == 'none'` (no signals to compare) → `SKIP NC-01: no comparable signals`

4. **Offload report reading to a focused sub-task.** After the correctness gate passes and the SIL/PIL re-run completes, delegate a sub-task scoped to the `targetFunctions`. The sub-task reads ONLY the target function sections from the report and compares against previous metrics. The main thread passes the previous metrics summary — never raw report text.

   **Sub-task prompt template for re-measurement (function-scoped) analysis:**
   ```
   Read the new SIL/PIL metrics report for model '<model>' and compare against previous metrics.
   Target functions: [<targetFunctions list>]. Extract data ONLY for these functions.
   Optimization goal: <speed/memory/both>. Profiling focus: <time/stack>. Hardware: <target>.

   PREVIOUS METRICS (v<N-1>):
   - Execution Time: <value>
   - Global RAM: <value> bytes
   - [paste concise previous metrics for target functions here — NOT raw report text]

   BASELINE METRICS (v0):
   - [paste concise original baseline metrics for target functions here]

   STEP 1 — READ THE REPORT (SELECTIVELY):
   Read the metrics report file at: <absolute_path_to_project>/<model>_ert_rtw/function_metrics_report_<sil|pil>.txt.
   Scan for '++Fcn Name: <targetFunction>' sections for EACH target function. Extract ONLY those sections. Also extract model-level summary metrics (total execution time, global RAM, etc.).

   STEP 2 — READ ONLY THE RELEVANT CODE FILES:
   For each target function, read ONLY the file and line range listed in the report. Do NOT read entire files or other files.

   STEP 3 — COMPARE AND SUMMARIZE:
   1. Extract new metrics for each target function and model-level totals.
   2. Build a before/after comparison table with columns: Metric | v0 Baseline | Previous (v<N-1>) | Current (v<N>) | Change vs Previous | Change vs Baseline. Use OK for improvements, WARN for regressions.
   3. For each target function: show metric changes (time, stack, data copies).
   4. Suggest which optimization stage to continue with next (A/B/C/D) based on remaining opportunities.

   Return ONLY a concise structured summary (comparison table + per-target-function changes + next-stage recommendation). Do NOT include data for non-target functions, raw report text, or full code listings.
   ```

5. **Run the Goal-Axis Acceptance Gate** (read `<skill_root>/references/protocols/goal-axis-gate.md`). **Prerequisite: the Numerical Correctness Gate (step 3.5) must have PASSED before reaching this step.** The gate is auto-executed by the agent on the comparison sub-task's output — it does NOT ask the user. Two outcomes:
   - **PASS** → call `eco_snapshot(workspacePath, 'v<N+1>_<tag>', 'rationale + Δ vs <state.liveVersion>', modelName)`. Capture the returned `commitSHA`, append the new `versionMap` entry with `parentVersion: <state.liveVersion at apply time>`, `status: "OK ACCEPT — …"`, `revertCause: null`, and update `state.liveVersion` to the new entry's `version`. This is the **only** checkpoint taken for this candidate.
   - **FAIL (Scenario 3, Gate_Rejected)** → the gate auto-reverts. Call `eco_revert(workspacePath, <live entry>.tag, modelName)` (the entry whose `version === state.liveVersion`, which is still the pre-apply accepted version because `liveVersion` only advances on PASS). Append a `versionMap` entry with `status: "FAIL rejected — regression on <axis>"`, `revertCause: "Gate_Rejected"`, `parentVersion = state.liveVersion`. Do NOT update `state.liveVersion`.

6. **Present the sub-task's summary and the gate outcome to the user.** Discuss results. If the gate PASSED but the **user** then decides (after seeing the numbers) that they want to roll back to a different historical version, that is **Scenario 5 — User_Requested_Revert** and is handled by `<skill_root>/references/protocols/checkpointing-revert.md` → "Recovery on Bad Apply" section, NOT by re-running the gate. Goal-axis regressions never reach this step — they were already auto-rejected in step 5.

7. **MANDATORY TRANSITION or Wrap-up.**
   - **If the goal is NOT met:** **(a) Append the decision trace** to `<project_path>/.eco_diagnostics/eco_decision_trace.md` (one entry per MM-0x risk exercised — see "Decision Trace Logging" below; include the comparison-table summary), **(b) update the token usage report**, **(c)** construct the state object with updated metrics and the next stage to try, and **(d)** proceed to Phase 3 with `NEXT_ACTION: "Present Stage <X> optimization suggestions"`. **Refuse to transition if either diagnostic file has not been appended (OR-05/OR-06).**
   - **If the goal IS met or the user is satisfied:** If stages remain in `STAGE_SCOPE`, inform the user: *"There are additional optimization stages available: <list remaining stages with what they target>. Would you like to continue, or are you happy to finalize now?"* If the user explicitly confirms they want to stop, proceed to finalize. Then: **(a) Append the decision trace** to `<project_path>/.eco_diagnostics/eco_decision_trace.md`, **(b) update the token usage report**, **(c)** construct the state object with `CURRENT_STAGE = "FINALIZE"` and updated metrics, and **(d)** proceed to Phase 5 with `NEXT_ACTION: "Phase 5 Finalize — (1) READ references/finalizing-results.md, (2) summarize changes + metrics, (3) run final correctness verification MANDATORY, (4) render per-model HTML report MANDATORY, (5) verify diagnostics"`. **Refuse to transition if either diagnostic file has not been appended (OR-05/OR-06).**

## Risk / Alert — Known Failure Modes

| ID | Risk | Symptom | Triggered By | Mitigation |
|----|------|---------|-------------|------------|
| MM-01 | SIL/PIL build failure | `CodeMetricsFetcherSIL`/`PIL` throws compiler or linker errors | Missing C compiler, unsupported blocks, or misconfigured hardware | Run `mex -setup` check before first SIL/PIL; inspect error and fix before retrying |
| MM-02 | Coarse report misses target functions | User's target functions don't appear in baseline listing | Functions are sub-function-level and only visible in detailed mode | Escalate to `reportLevel = 'detailed'` per Phase 2.5 step 2 |
| MM-03 | Report read in main context | Token budget consumed by raw report text | Agent reads report file directly instead of delegating to sub-task | Always delegate report reading to a `Task` sub-agent; never read `function_metrics_report_*.txt` in main context |
| MM-04 | Checkpoint taken at the wrong time | Wrong revert target / orphan snapshot of a not-yet-validated candidate; double-checkpoint per candidate | Taking a pre-apply checkpoint (old behaviour) instead of a single post-gate-PASS checkpoint; or skipping the checkpoint after a PASS | The revert safety net is the *live entry's* `commitSHA` (resolve by `version === state.liveVersion`) — no pre-apply checkpoint needed. Call `eco_snapshot` **only after the Goal-Axis Acceptance Gate PASSES** in Phase 4 step 5. Record the returned `commitSHA` in the new `versionMap` entry and advance `state.liveVersion`. On Gate FAIL, the revert target is already `<live entry>.tag`. |
| MM-05 | Stale previous metrics in comparison | Before/after delta is wrong | Passing incorrect `PREVIOUS METRICS` to comparison sub-task | Always pull previous metrics from the state object, not from memory |
| MM-06 | PIL timeout | Simulation hangs indefinitely | Board unresponsive, bad COM port, or infinite loop in model | Set a reasonable timeout; reset board; fall back to SIL if PIL repeatedly fails |
| NC-01 | Numerical correctness regression | SIL/PIL signal outputs diverge from v0 golden reference beyond tolerance | Optimization changed numerical behavior (data-type narrowing, algorithm rewrite, precision reduction) | Run Correctness Gate (step 3.5) BEFORE efficiency gate; auto-reject on FAIL |
| NC-02 | Golden reference not captured | Correctness gate cannot run in Phase 4 — skipped entirely | Phase 2 golden reference save skipped or SIL/PIL failed | Always save baseline `simOut` via `saveGoldenReference` after Phase 2 SIL/PIL run; verify `state.GOLDEN_REF_PATH` is populated |
| EXT-04 | Customer `never` rule violated | Candidate blocked before apply | Candidate conflicts with user-defined hard constraint | Check `never` rules (step 0.5) before applying; block and log; move to next candidate |

## Decision Trace Logging

After each common-step / phase-step that exercises an MM-0x risk, append the corresponding entry to `<project_path>/.eco_diagnostics/eco_decision_trace.md` under this phase's heading:

| When | Log entry |
|------|-----------|
| After step C3 (SIL/PIL run) succeeds | `OK MM-01: SIL/PIL build & run succeeded with reportLevel=<coarse/detailed>` |
| After step C3 (SIL/PIL run) fails and is retried | `WARN MM-01: <error class> — fixed by <action>; retry succeeded` (or `WARN MM-01: SIL/PIL repeatedly failed — fell back to static rtw.codemetrics.CodeMetrics`) |
| After Phase 2.5 step 2 (target visibility check) | `OK MM-02: All targetFunctions visible in coarse report` (or `WARN MM-02: <funcs> missing — escalated to detailed`) |
| Before delegating any report-reading sub-task | `OK MM-03: Delegated report read to sub-task; main context never read raw report` |
| After Phase 4 step 5 Gate PASS (checkpoint taken) | `OK MM-04: Post-gate snapshot created via eco_snapshot (commitSHA=<sha>, tag=v<N+1>_<tag>); state.liveVersion advanced to v<N+1>` |
| After Phase 4 step 5 Gate FAIL (auto-revert) | `OK MM-04: Gate_Rejected — reverted to <live entry>.tag via eco_revert; state.liveVersion unchanged` |
| Before invoking the comparison sub-task in Phase 4 step 5 | `OK MM-05: Previous metrics pulled from state object (v<N-1>), not from memory` |
| If PIL hangs / is reset | `WARN MM-06: PIL timeout on <board> — reset and retried` (or `WARN MM-06: Fell back to SIL after N PIL failures`) |
| After Phase 2 golden ref save (post-C3) | `OK NC-02: Golden reference saved at <path> from baseline SIL/PIL simOut (<N> signals, method=<logsout/yout>)` |
| After Phase 4 step 3.5 correctness PASS (exact) | `OK NC-01: Correctness gate PASSED — 0 error across <N> signals (method=<method>)` |
| After Phase 4 step 3.5 correctness PASS (warn) | `WARN NC-01: Correctness gate PASSED — maxErr=<value> on <signal> within tolerance=<tol> (method=<method>)` |
| After Phase 4 step 3.5 correctness FAIL | `FAIL NC-01: Correctness gate FAILED — maxErr=<value> on <signal> exceeds tolerance=<tol>. Auto-rejecting v<N+1>. (method=<method>)` |
| Phase 4 correctness gate skipped | `SKIP NC-01: <reason>` (codegen mode — deferred to Phase 5 / golden ref missing / no signals) |
| After Phase 4 step 0.5 (never rules loaded) | `OK EXT-01: Loaded <N> never rules` or `INFO EXT-01: No never rules found` |
| Phase 4 step 0.5 never rule blocks candidate | `BLOCK EXT-04: <candidate> blocked — violates never rule "<text>"` |

If a risk's mitigation is intentionally not exercised (e.g., VERIFICATION_MODE=codegen and per-iteration correctness gate is deferred to Phase 5), log `SKIP MM-0x: <reason skipped>` or `SKIP NC-0x: <reason skipped>`. The diagnostic file MUST contain at least one MM-0x or NC-0x entry per measure phase before transition.

## Subskill Invocation Log (Phase 2 / 4 Routing)

At the start of Phase 2 / 2.5 / 4, append invocation decisions for every child this skill *could* call — whether opened or not — to `<project_path>/.eco_diagnostics/eco_decision_trace.md`:

```markdown
### Subskill Invocation Log
- OK configuring-code-profile/reference.md: Invoked — VERIFICATION_MODE=SIL/PIL requires profiling configuration
  (or SKIP — VERIFICATION_MODE=codegen; profiling bypassed, but golden ref captured via normal sim)
- OK saveGoldenReference: Invoked — Phase 2 baseline; saved SIL/PIL simOut (or normal sim if codegen) as golden reference
  (or SKIP — Phase 4 remeasure; golden ref already cached)
- OK checkNumericalCorrectness (Correctness Gate): Invoked — Phase 4 step 3.5; comparing SIL/PIL outputs vs golden ref
  (or SKIP — Phase 2 baseline; no apply yet)
  (or SKIP — VERIFICATION_MODE=codegen; per-iteration gate skipped, final verification deferred to Phase 5)
  (or SKIP — golden reference unavailable / no comparable signals)
- OK evolutions-checkpoint.md: Invoked — post-gate-PASS snapshot via eco_snapshot in Phase 4 (or revert via eco_revert on Gate FAIL)
  (or SKIP — Phase 2 baseline; no apply yet)
- OK Sub-task (lightweight listing): Invoked — Phase 2 baseline coarse report extraction
  (or SKIP — Phase 4 remeasure; using scoped sub-task instead)
- OK Sub-task (scoped analysis): Invoked — targetFunctions=[<list>] specified
  (or SKIP — targetFunctions empty, using full sub-task)
- OK Sub-task (full analysis): Invoked — user said "analyze all"
  (or SKIP — targetFunctions specified, using scoped sub-task)
- OK Sub-task (comparison): Invoked — Phase 4 remeasure with previous metrics
  (or SKIP — Phase 2 baseline)
```

**Every candidate child gets a line, even if skipped.** This makes "the agent forgot to delegate report reading" (MM-03 violation) distinguishable from "the agent intentionally read directly" — both look the same in the transcript otherwise.


----

Copyright 2026 The MathWorks, Inc.

----
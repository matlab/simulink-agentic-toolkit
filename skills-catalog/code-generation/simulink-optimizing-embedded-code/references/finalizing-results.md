> **Release compatibility:** MATLAB R2023a and later.

# Phase 5: Wrap-up

> **On entry — MANDATORY:** Before starting step 1, confirm that `state.GOLDEN_REF_PATH` is populated and the file exists. Step 5 (final correctness verification) runs for ALL modes — it compares a fresh SIL run of the final optimized model against the Phase 2 golden reference (normal sim for codegen mode, SIL/PIL simOut otherwise). If the golden reference file is missing, emit a "Not run" verification card and log `WARN FR-05`. For report field-mapping reference, see `<skill_root>/assets/per-model-report-template.md`.

> **COMPLETION OBLIGATION:** You MUST execute steps 1 through 8 in order. Do NOT declare the run complete or stop working until step 6 (HTML report rendered and absolute path announced to user) AND step 7 (diagnostics verified) are done. Steps 5 and 6 are the primary deliverables of this phase — they are not optional. If you find yourself about to stop after step 4, you are violating this obligation.

> **TERMINATION GATE (MANDATORY):** Before you present ANY wrap-up message, summary, or final output to the user — and before you stop working for any reason — you MUST run the following check:
>
> ```matlab
> reportPath = fullfile('<project_path>', '.eco_diagnostics', '<MODEL_NAME>_optimization_report.html');
> assert(isfile(reportPath), 'TERMINATION BLOCKED: HTML report does not exist at %s. You must complete step 6 before stopping.', reportPath);
> ```
>
> If this assertion fails, you have NOT completed the phase. Go back and execute step 6 (HTML report generation) before doing anything else. This gate exists because the most common failure mode is: completing step 5 (correctness check), then presenting results and terminating — which skips the customer's primary deliverable (the HTML report).

When the user is satisfied:

1. **Summarize all changes made** — pull the full `versionMap` from the state object (including FAIL reverted entries AND `USER_REVERT` entries).

   **Revert-cause disclosure (MANDATORY):** For each entry whose `revertCause` is non-null, the wrap-up summary MUST state the kind explicitly:
   - `revertCause == "Gate_Rejected"` → render as *"v<N+1> — Gate-Rejected (auto-reverted to v<i>): <axis> regressed by <Δ>"*.
   - `revertCause == "User_Requested_Revert"` → render as *"v<N+1> — User-Requested Revert (restored to v<i>): <one-sentence user rationale, if logged in eco_decision_trace.md>"*.

   This information feeds both the wrap-up message AND the per-model HTML report's evolution tree (which colour-codes the two kinds differently — see `<skill_root>/assets/per-model-report-template.md` → Node classes).

   The per-stage / per-sub-skill breakdown the customer needs is already produced by the iteration table rendered by `renderOptimizationReport` in step 6. Do NOT duplicate that table in the wrap-up text — refer the customer to the iteration table in the HTML report instead.

2. **List final metrics vs. original baseline** — compare against `v1_baseline`, NOT the most recent previous version.
3. **Note any changes that were tried and reverted.**
3.5. **Note customer preferences applied (if any).** If `optimization_preferences.yaml` was active during this run, include a brief summary: how many `never` rules fired (blocked candidates), how many `skip` rules suppressed techniques, and whether any custom optimizations were evaluated. This is a one-line mention, not a full section — the decision trace has the details.
4. **Suggest further manual optimizations the user could explore.**
5. **Run final correctness verification — MANDATORY for ALL modes.**

   Compare the **v0 baseline SIL/PIL outputs** (the golden reference saved in Phase 2 at `state.GOLDEN_REF_PATH`) against the **SIL/PIL outputs of the final/optimized version** (the live workspace, which reflects the entry whose `version === state.liveVersion`). This is the optimization-correctness gate the customer-facing HTML report's `{{VERIFY_*}}` placeholders consume.

   **Relationship to Phase 4 Correctness Gate:** Every Phase 4 iteration already ran a per-iteration correctness check (comparing SIL/PIL outputs against the cached golden reference from Phase 2). This Phase 5 check is a **definitive end-to-end confirmation** using the same golden reference — it serves as a safety net that re-runs SIL/PIL on the final model state in a fresh context. If all Phase 4 iterations passed, this check should also pass. A failure here indicates an environmental drift or a bug in the per-iteration check.

   **Procedure:**

   ```matlab
   addpath(fullfile('<skill_root>', 'scripts'));

   modelName    = state.MODEL;
   projectPath  = state.PROJECT_PATH;
   artifactsDir = fullfile(projectPath, 'bench_results', [modelName '_artifacts']);
   if ~isfolder(artifactsDir), mkdir(artifactsDir); end

   % 1. Run SIL/PIL of vN (final optimized model in the live workspace)
   if strcmp(state.VERIFICATION_MODE, 'SIL')
       [~, simOut_vN] = CodeMetricsFetcherSIL(modelName, 'coarse');
   else  % PIL
       [~, simOut_vN] = CodeMetricsFetcherPIL(modelName, 'coarse');
   end

   % 2. Compare against the golden reference (v0 baseline SIL/PIL outputs
   %    saved in Phase 2 via saveGoldenReference.m)
   verdict = checkNumericalCorrectness(simOut_vN, state.GOLDEN_REF_PATH, state.TOLERANCE);

   maxErr       = verdict.maxErr;
   maxErrSignal = verdict.maxErrSignal;
   perSignal    = verdict.perSignal;

   save(fullfile(artifactsDir, 'final_sil_pil_comparison.mat'), ...
        'simOut_vN', 'verdict', 'maxErr', 'maxErrSignal', 'perSignal');
   ```

   **Verdict classification** (drives `{{VERIFY_CLASS}}` / `{{VERIFY_VERDICT}}` / `{{VERIFY_VERDICT_COLOR}}`):

   | Condition on `maxErr`                                                       | Verdict      | `VERIFY_CLASS`  | `VERIFY_VERDICT_COLOR` |
   |-----------------------------------------------------------------------------|--------------|-----------------|------------------------|
   | `== 0` exactly, across all common signals                                   | `PASS`       | `verify-pass`   | `green`                |
   | `<= state.TOLERANCE` (within numerical-rounding tolerance, e.g. ~1 ulp)     | `PASS (warn)`| `verify-warn`   | `yellow`               |
   | `> state.TOLERANCE`                                                         | `FAIL`       | `verify-fail`   | `red`                  |

   **Populate the state object** so the step-6 HTML renderer can consume the values:

   ```matlab
   state.VERIFY.class          = '<verify-pass|verify-warn|verify-fail>';
   state.VERIFY.verdict        = '<PASS|PASS (warn)|FAIL>';
   state.VERIFY.verdictColor   = '<green|yellow|red>';
   state.VERIFY.verdictSub     = '<short qualifier, e.g. "23/23 signals exact match">';
   state.VERIFY.maxErr         = maxErr;       % scientific notation when rendered
   state.VERIFY.maxErrSub      = '<signal name + units>';
   state.VERIFY.narrative      = '<2–4 sentence plain-language explanation>';
   state.VERIFY.artifacts      = 'bench_results/<MODEL>_artifacts/final_sil_pil_comparison.mat';
   ```

   **Codegen mode — final SIL verification (MANDATORY):**
   When `state.VERIFICATION_MODE == 'codegen'`, run a one-time lightweight SIL pass to verify numerical correctness of the final optimized model against the Phase 2 golden reference (captured from normal sim):

   ```matlab
   % Configure for SIL without profiling (lightweight — correctness check only)
   set_param(modelName, 'SimulationMode', 'Software-in-the-Loop (SIL)');
   set_param(modelName, 'CodeExecutionProfiling', 'off');
   set_param(modelName, 'CodeStackProfiling', 'off');
   simOut_vN = sim(modelName);

   % Compare against golden reference (captured from normal sim in Phase 2)
   verdict = checkNumericalCorrectness(simOut_vN, state.GOLDEN_REF_PATH, state.TOLERANCE);
   ```

   This compares normal-sim baseline outputs (v0) vs SIL outputs of the final optimized model (vN), verifying that the generated code produces the same numerical results as the simulation.

   Populate `state.VERIFY.*` fields the same way as SIL/PIL mode (same verdict classification table applies). The HTML report WILL include the verification section.

   Log: `OK FR-05: Final SIL verification (codegen mode) verdict=<PASS/PASS (warn)/FAIL>, maxErr=<value>`

   **When to SKIP this step:**
   - `state.SIL_FALLBACK == true` — SIL/PIL was unavailable for this model (fell back to codegen after 3 failures). Do NOT attempt SIL here — it will fail again. Leave `state.VERIFY` empty (the renderer omits the verification section). Log `SKIP FR-05: SIL_FALLBACK=true — SIL is unavailable for this model; final verification skipped`.
   - `state.GOLDEN_REF_PATH` is empty or the file does not exist (Phase 2 golden reference was not captured) — write a "Not run" verification card and log `WARN FR-05: final verification skipped — golden reference missing at <path>`.

   **Why this comes BEFORE step 6 (the HTML render):** the renderer pulls `{{VERIFY_*}}` from the `.mat` artifact and `state.VERIFY.*` fields populated here. If the golden reference is missing and the step produces a "Not run" card, the renderer displays that card instead of an empty placeholder.

6. **Generate the per-model HTML report for the customer.**

   Call the pre-built rendering function:

   ```matlab
   addpath(fullfile('<skill_root>', 'scripts'));
   reportPath = renderOptimizationReport(state, projectPath, '<skill_root>');
   ```

   This single call reads the HTML template, replaces all `{{PLACEHOLDER}}` tokens, builds the headline cards, iteration table, evolution tree, token cards, and verification panel from `state` + diagnostic files, writes the output to `<project_path>/.eco_diagnostics/<MODEL_NAME>_optimization_report.html`, runs the pure-ASCII sanity check, and returns the absolute path.

   After the call succeeds, announce the path to the user:

   > *"I've generated your optimization report at `<reportPath>`. Open it in any web browser (Chrome / Edge / Firefox) by double-clicking the file — it's self-contained, no server needed."*

   If `renderOptimizationReport` errors, diagnose and fix (common causes: missing `state.VERIFY` fields, empty `versionMap`, unreadable `state.json`). Do NOT skip the report — it is the primary customer deliverable.

   For field-mapping details, encoding rules, version-tag display conventions, and tree-node format, see `<skill_root>/assets/per-model-report-template.md`.

   **Why this comes before step 7:** the customer report must be produced regardless of whether the diagnostic-trail verification in step 7 passes. If step 7 STOPs, the customer artifact is already written.

7. **VERIFY DIAGNOSTICS WRITTEN — MANDATORY before declaring the run complete.**

   The agent MUST verify that both diagnostic files exist and have one entry per phase in this session. Use the OS file API (or a shell tool):

   ```matlab
   diagDir = fullfile('<project_path>', '.eco_diagnostics');
   reportFile = fullfile(diagDir, 'eco_optimization_report.md');
   traceFile  = fullfile(diagDir, 'eco_decision_trace.md');

   missing = {};
   if ~isfile(reportFile), missing{end+1} = 'eco_optimization_report.md'; end
   if ~isfile(traceFile),  missing{end+1} = 'eco_decision_trace.md'; end
   ```

   - **Both files exist:** Read each and confirm it contains a `## Phase: <N>` heading for every phase in this session. If any phase is missing, **STOP** and tell the user: *"Phase <N> did not append its diagnostic entry. The session is complete but the diagnostic trail is incomplete — bench scoring may be impaired. (Your customer report from step 6 is intact.)"* Then back-fill the missing entries from state if possible.
   - **Either file missing:** **STOP** and tell the user: *"Diagnostic file `<filename>` was never created. Earlier phases skipped the mandatory append step. Bench scoring will be impaired for this run. (Your customer report from step 6 is intact.)"* Create the missing file with whatever entries can be reconstructed from the state object.
   - **Both complete:** Log the final entry: `OK FR-03: Diagnostic files verified complete (<N> phase entries each)`.

8. **Append the final wrap-up entry** to both diagnostic files for this phase, then declare the run complete.

## Risk / Alert — Known Failure Modes

| ID | Risk | Symptom | Triggered By | Mitigation |
|----|------|---------|-------------|------------|
| FR-01 | Incomplete version map | Summary misses reverted changes or intermediate versions; Gate-rejected vs User-requested revert entries indistinguishable in the report | Version map not maintained across phases; `revertCause` / `parentVersion` / `revertTargetVersion` fields not populated | Always pull the full `VERSION_MAP` from the state object; include both `FAIL`-status (Gate_Rejected) and `USER_REVERT`-status entries; render each according to its `revertCause` so the two are visually distinct in the tree and the wrap-up text |
| FR-07 | Tree hierarchy mis-rendered | Evolution tree shows a revert leaf as a parent of further nodes, or alternate routes after a user revert appear off the wrong ancestor | `parentVersion` not maintained when entries are appended; renderer descends into a node with `revertCause != null` | Every versionMap entry except `v0` MUST carry `parentVersion`; `renderOptimizationReport` treats `revertCause != null` as a leaf and refuses to descend. Log `WARN FR-07` if violated. |
| FR-02 | Metrics comparison against wrong baseline | Final improvement percentage is incorrect | Using an intermediate version instead of v1 as the baseline reference | Always compare final metrics against `v1_baseline`, not the most recent previous version |
| FR-03 | Diagnostic files incomplete or missing | Bench scorecard cannot diagnose bad suggestions | Earlier phases skipped the decision-trace / token-report append step | Step 7 above — verify both files exist and have an entry per phase; back-fill if missing |
| FR-04 | Per-model customer report missing | Customer has no consolidated artifact to review the run; only raw diagnostic logs exist | Step 6 skipped, or `renderOptimizationReport` errored, or `.eco_diagnostics/` not writable | Step 6 above — call `renderOptimizationReport(state, projectPath, skillRoot)`, which writes to `<project_path>/.eco_diagnostics/<MODEL>_optimization_report.html` and returns the absolute path. The termination gate blocks stopping if the file is missing. Step 6 runs **before** the step-7 STOP gates so the customer report is intact even if diagnostic verification fails. If the function errors, diagnose and retry — do not declare the run complete with a missing report. |
| FR-05 | Final correctness check skipped or wrong baseline | Customer report shows "Not run" card, or verdict reflects v(N-1)-vs-vN instead of v0-vs-vN; numerical regressions go undetected | Golden reference missing/corrupt, or wrong golden ref used (e.g., a mid-run snapshot instead of the Phase 2 baseline) | Step 5 above — MANDATORY for ALL modes. Always compare the **Phase 2 golden reference** (normal sim for codegen, SIL/PIL simOut otherwise) against a fresh **SIL run of the final vN**. If the golden reference is missing, emit a "Not run" verification card and log `WARN FR-05`. In codegen mode, the Phase 5 SIL run is lightweight (no profiling) — it only verifies numerical correctness. |
| FR-08 | Mojibake in rendered HTML report | Customer-facing report shows garbled glyphs like `â†'` instead of `→`, or `â€"` instead of `—` | Template or replacement strings contained raw non-ASCII bytes | `renderOptimizationReport` runs a post-write pure-ASCII sanity check and warns if any non-ASCII byte is found. If the warning fires, escape the offending strings to HTML entities and re-run. Log `WARN FR-08`. |
| FR-09 | Evolution-tree connectors look floating / disconnected from parent | Tree shows children that don't visually connect to parent | Bug in `renderOptimizationReport`'s `buildEvolutionTree` / `renderSubtree` helpers | `renderOptimizationReport` uses the explicit `.tree-trunk-down` + `.tree-bus` + `.tree-children-flex` + per-child `.tree-drop` DOM structure. If visually broken, inspect the generated HTML and fix the function. Log `WARN FR-09`. |

## Decision Trace Logging

In this final wrap-up phase, append entries to `<project_path>/.eco_diagnostics/eco_decision_trace.md`:

| When | Log entry |
|------|-----------|
| After step 1 | `OK FR-01: Version map pulled from state — <N> versions including <M> reverts` |
| After step 2 | `OK FR-02: Final metrics compared against v1_baseline (not v<N-1>)` |
| After step 5 (final correctness) | `OK FR-05: Final verification verdict=<PASS/PASS (warn)/FAIL>, maxErr=<value>, mode=<SIL/PIL/codegen+SIL>` (or `WARN FR-05: final verification skipped — golden reference missing at <path>`) |
| After step 6 (report render) | `OK FR-04: Per-model report written to <absolute_path> via renderOptimizationReport` (or `WARN FR-04: renderOptimizationReport failed — <error message>`) |
| After step 6 (post-render) | `OK FR-07/FR-08/FR-09: Report rendered successfully (tree hierarchy, ASCII encoding, and fork markup all handled by renderOptimizationReport)` (or log individual `WARN` entries if the function emitted warnings) |
| After step 7 (verification) | `OK FR-03: Diagnostic files verified complete` (or `WARN FR-03: <details of what was missing / back-filled>`) |

----

Copyright 2026 The MathWorks, Inc.

----
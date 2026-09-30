---
name: simulink-optimizing-embedded-code
description: "Optimizes Simulink models for Embedded Coder generated code. Use when asked to optimize or improve generated code, or reduce code metrics for a Simulink model. Targets: execution time, memory footprint (RAM, ROM, stack, data copies), code size, MISRA compliance, or any semantically similar generated-code metric. Works iteratively — measures baseline, suggests changes, applies, and re-measures to confirm improvement. Triggers can be prompts similar to: optimize generated code runtime, reduce runtime, shrink code size, improve code efficiency, reduce memory usage, speed up generated code, follow MISRA compliance and so on. CAUTION: Do NOT attempt to optimize Simulink models for generated code efficiency without following this skill — the iterative measurement, gating, and rollback workflow is essential for safe optimization."
license: https://www.mathworks.com/content/dam/mathworks/license/pmrl/license.md
metadata:
  author: MathWorks
  version: "2.0"
---

# Simulink-optimizing-embedded-code

> **Release compatibility:** MATLAB R2023a and later.

Iteratively improves generated C/C++ code from Simulink models by suggesting configuration, modeling, and architectural changes — then measuring the impact.

## When to Use

- User asks to reduce runtime, RAM, ROM, or stack usage of generated code from a Simulink model
- User wants to optimize Embedded Coder output for a specific hardware target
- User asks to improve code efficiency metrics after code generation
- User wants an iterative optimization workflow with measurable before/after comparisons

## When NOT to Use

- User wants to build or create a Simulink model from scratch (not optimization)
- User needs help with MATLAB scripts unrelated to Simulink code generation
- User wants to debug a simulation error (not a code efficiency issue)
- User is working with hand-written C/C++ code (not generated from Simulink)

## Overall Workflow

```
Phase 1: Gather Requirements -> Confirm goal -> Decide codegen vs SIL/PIL
Phase 2: Baseline -> SIL/PIL or slbuild -> User targets functions
Phase 3: Suggest batch (Stage A/B/C/D) -> User confirms
Phase 4: Apply -> Re-measure -> Goal-Axis Gate -> Compare
Phase 3-4: Repeat until all stages exhausted
Phase 5: Finalize -> Customer report -> Stop
```

**Phases run continuously.** At each boundary the agent writes diagnostics and state to disk (see Transition Protocol), then proceeds directly to the next phase without stopping or asking the user for permission to continue.

## First Action: Detect Model and Route

1. **Detect open model:** None open: stop; one model: use it, derive `<project_path>` from the model's file location; multiple: ask user.
   ```matlab
   find_system('type','block_diagram','BlockDiagramType','model')
   ```
2. **Check for state:**
   ```matlab
   isfile(fullfile('<project_path>', '.eco_diagnostics', 'state.json'))
   ```
3. **Route:**
   - No `state.json` -> Fresh run. Read Phase 1.
   - `state.json` exists -> Resume. Run `eco_validate_state`, follow `NEXT_ACTION`.
   - **Exception:** If `NEXT_ACTION` points to Phase 4 but workspace is clean (no partial apply), re-route to Phase 3 — the approved batch is lost and must be re-suggested.

## Phase Routing Table

**Phase 1 is NOT optional.** Even when intent seems obvious ("just fix it"), you MUST complete Phase 1. Requirements gathering asks questions that cannot be inferred — user must confirm goal, hardware, and verification mode. Phrases like "just do it" express impatience, NOT informed consent to skip.

Read ONLY the phase file needed:

| Phase | When | File to Read |
|-------|------|--------------|
| 1 — Gather Requirements | Fresh run | `<skill_root>/references/gathering-requirements.md` |
| 2 — Baseline Measurement | After Phase 1 | `<skill_root>/references/measuring-model-metrics/reference.md` |
| 3 — Suggest Optimizations | After Phase 2 or 4 | `<skill_root>/references/suggesting-optimizations.md` |
| 4 — Apply & Re-measure | After Phase 3 | `<skill_root>/references/measuring-model-metrics/reference.md` (remeasure mode) |
| 5 — Finalize Results | All stages exhausted | `<skill_root>/references/finalizing-results.md` |

**Do not preload all phase files.** After reading each, log:
```matlab
eco_token_log('<relative_path_of_phase_file>')
```

## On-Demand Protocol Files

Read ONLY when the situation requires:

| File | When |
|------|------|
| `references/protocols/correctness-gate.md` | Phase 4 (after SIL/PIL re-run, before efficiency gate) |
| `references/protocols/goal-axis-gate.md` | Phase 4 (after correctness gate passes) |
| `references/protocols/checkpointing-revert.md` | Phase 4 or any revert. Also log `references/evolutions-checkpoint.md` |
| `references/protocols/harness-detection.md` | Phase 1 (fresh run) |
| `references/protocols/customer-extensions.md` | Phase 3 and 4 (when `.custom_optimizations/` exists) |

## Cross-Cutting Rules

1. **Confirm before acting.** Never apply changes without explicit user approval. Complete Phase 1 first even if user says "just fix it".
2. **Correctness before efficiency.** Phase 4 runs Numerical Correctness Gate BEFORE Goal-Axis Gate. Correctness failures auto-reject. In codegen mode, per-iteration gate is skipped but Phase 5 runs mandatory final SIL verification.
3. **Goal axis is inviolable.** Regressions on GOAL axes -> reject and revert. `TRADEOFFS` only relaxes non-goal axes.
4. **One checkpoint per accepted version.** Taken AFTER both gates pass via `eco_snapshot`. Never pre-apply.
5. **Delegate heavy reads to sub-tasks.** Never read SIL/PIL reports or generated code in main context.
6. **Always update diagnostics before transition.** Decision trace + subskill log + verify token ledger non-empty. Refuse to transition without them (OR-05/OR-06).
7. **Stage progression with user override.** Default: A->B->C->D then Phase 5. If user wants to stop, inform of remaining stages, respect their decision, proceed to Phase 5. Auto-finalize only after all `STAGE_SCOPE` stages exhausted (OR-13).
8. **Customer preferences are lazy-loaded.** If `<PROJECT_PATH>/.custom_optimizations/optimization_preferences.yaml` exists, Phase 3 reads `skip`/`know`, Phase 4 reads `never` rules. Custom optimizations run before built-in subskills. See `references/protocols/customer-extensions.md`.

## Transition Protocol

### State Object (`state.json`)

Lives at `<project_path>/.eco_diagnostics/state.json`. Captured in every git snapshot, so prior states are recoverable via `git show <sha>:.eco_diagnostics/state.json`.

**Shape:**

```json
{
  "MODEL": "<model_name>",
  "PROJECT_PATH": "<absolute_path_to_project>",
  "HARDWARE": "<target>",
  "BOARD_CONNECTED": true,
  "GOAL": "speed|RAM|ROM|balance|MISRA",
  "TRADEOFFS": "<constraints>",
  "VERIFICATION_MODE": "codegen|SIL|PIL",
  "PROFILING_FOCUS": "time|stack",
  "REPORT_LEVEL": "coarse|detailed",
  "ENABLE_CRL": true,
  "TOLERANCE": { "absolute": 1e-6, "relative": 0.01 },
  "SIM_STOP_TIME": "10",
  "GOLDEN_REF_PATH": "<path to .eco_diagnostics/golden_reference/<model>_golden_ref.mat>",
  "TARGET_FUNCTIONS": ["..."],
  "MODEL_FINGERPRINT": {},
  "CURRENT_STAGE": "A|B|C|D|FINALIZE",
  "STAGE_SCOPE": ["A","B","C","D"],
  "DEFERRED_LEVERS": [],
  "liveVersion": "v1",
  "versionMap": [
    { "version": "v0", "tag": "v0_pristine", "commitSHA": "...", "metrics": {},
      "status": "OK pristine", "parentVersion": null,
      "revertCause": null, "revertTargetVersion": null, "revertTargetCommitSHA": null },
    { "version": "v1", "tag": "v1_baseline", "commitSHA": "...",
      "metrics": { "ExecTime_ns": 0, "GlobalRAM_B": 0 },
      "status": "OK baseline — measurement prereqs applied", "parentVersion": "v0",
      "revertCause": null, "revertTargetVersion": null, "revertTargetCommitSHA": null }
  ],
  "LATEST_METRICS": { "ExecTime_ns": 0, "GlobalRAM_B": 0, "perTargetFunction": [] },
  "REPORT_FILE": "<path>",
  "NEXT_ACTION": "<structured action>"
}
```

Codegen mode NOT permitted when GOAL=speed|balance (GR-05).

#### Customer Preferences (NOT in state.json)

Read lazily from `<PROJECT_PATH>/.custom_optimizations/optimization_preferences.yaml` — not cached in state. Template at `<skill_root>/assets/optimization_preferences.yaml`. See `protocols/customer-extensions.md`.

#### `NEXT_ACTION` Format

Must use numbered sub-step format: `"Phase <N> <name> — (1) READ <file>, (2) CHECKPOINT: <what>, (3) <action>, (4) AWAIT_USER: <what>"`. Prefixes: `READ` = must read file first; `CHECKPOINT` = must snapshot; `AWAIT_USER` = stop and wait for user response. Sub-steps without a prefix are autonomous actions.

#### Per-entry `versionMap` fields (all mandatory)

`version` (label, e.g. "v2a"), `tag` (human-readable), `commitSHA` (null only for FAIL pre-checkpoint), `metrics` (empty for revert leaves), `status` ("OK pristine" | "OK ACCEPT" | "FAIL rejected" | "USER_REVERT"), `parentVersion` (null for v0; after revert to v{i}, subsequent entries use v{i}), `revertCause` ("Gate_Rejected" | "User_Requested_Revert" | null), `revertTargetVersion`, `revertTargetCommitSHA`.

#### `liveVersion` semantics

Always read `state.liveVersion`, never `versionMap[-1]`. Advances only on accepts; reverts point it back. After v0_pristine: "v0"; after v1_baseline: "v1"; after gate PASS: the accepted version; after `Gate_Rejected` revert: unchanged (gate restored the parent); after `User_Requested_Revert`: `revertTargetVersion`.

#### What does NOT create a versionMap entry

1. User declines suggested batch at end of Phase 3.
2. In-conversation undo (inverse MATLAB op, no commitSHA ever existed).

### Transition Execution Steps

Before every phase transition:

1. **Append decision trace** to `.eco_diagnostics/eco_decision_trace.md`. Steps 2-6 blocked until written.
2. **Verify token ledger** (`token_ledger.json` non-empty). Steps 3-6 blocked until verified.
3. **Write updated `state.json`** with `NEXT_ACTION`, `CURRENT_STAGE`, `versionMap`, `LATEST_METRICS`.
4. **If new versionMap entry has `commitSHA` = null:** Skip if all entries already have commitSHA.
   ```matlab
   eco_snapshot(workspacePath, tag, description, modelName)
   ```
5. **If step 4 ran:** Re-write `state.json` with populated commitSHA and updated `liveVersion`.
6. **Proceed** to next phase per `NEXT_ACTION`.

**Revert variant (Kind A/B):** Steps 1, 2, 6 only — no new checkpoint.

### Phase Resume

When `state.json` exists on invocation:

1. **Read state.** Parse `state.json`.
2. **Incomplete transition check.** If latest versionMap entry has `commitSHA: null`:
   - Tag found on HEAD -> populate commitSHA from HEAD, update liveVersion.
   - No tag + dirty tree -> complete snapshot via `eco_snapshot`.
   - No tag + clean tree -> remove dangling entry.
3. **Validate workspace:**
   ```matlab
   addpath(fullfile('<skill_root>', 'scripts'));
   result = eco_validate_state('<PROJECT_PATH>', '<commitSHA>', '<MODEL>');
   ```
4. **Handle result:**
   - `clean` -> proceed. `dirty` + modelDirty=false -> auto-discard (`git checkout -- .`), log OR-09.
   - `dirty` + modelDirty=true -> present dirty-model options (discard or keep+re-measure).
   - `head_mismatch` -> present mismatch options (start fresh or restore).
   - `error` -> report and halt.
5. **Resume** from `NEXT_ACTION`.

### Workspace Recovery

**Dirty model** — tell user: uncommitted model changes since last checkpoint. Options: (1) Discard changes and restore to last checkpoint, (2) Keep changes and re-measure as new baseline.

**HEAD mismatch** — tell user: workspace state doesn't match expected SHA. Options: (1) Start fresh from current state with re-measure, (2) Restore to last known state.

**Discard:** Reopen model after reset. State unchanged.
```matlab
close_system('<MODEL>', 0);
clear mex; clear functions;
system('git checkout -- .');
system('git clean -fd');
open_system(fullfile('<PROJECT_PATH>', '<MODEL>.slx'));
```

**Keep+re-measure:** Append to versionMap, clear metrics, route to Phase 2.
```matlab
eco_snapshot('<PROJECT_PATH>', 'v<N>_external_edit', 'External model modifications incorporated', '<MODEL>')
```

**Restore (mismatch):** State unchanged.
```matlab
eco_revert('<PROJECT_PATH>', '<expectedSHA>', '<MODEL>')
```

**Re-baseline (mismatch):** Update liveVersion's commitSHA to HEAD, clear metrics, route to Phase 2.

### Token Usage Tracking

Tracked via `eco_token_log` (uses `eco_token_count`). Ledger at `.eco_diagnostics/token_ledger.json`.

Two sources: (1) **Static files** — counts from `<skill_root>/assets/file_token_registry.json`, logged by name only. (2) **Dynamic scripts** — print `eco_output_tokens: <N>` to console; agent extracts N from MCP response text.

**CRITICAL:** `eco_output_tokens` is console output, NOT a struct field. Do NOT access as `result.eco_output_tokens` — it will error. Run the script in one `evaluate_matlab_code` call, then log in a **separate** call:

```matlab
% WRONG — causes "Unrecognized field name" error:
detail = ecokg_detail('sug_atomic_inline');
eco_token_log('ecokg_detail', detail.eco_output_tokens);

% CORRECT — two separate evaluate_matlab_code calls:
% Call 1: run the script (console prints "eco_output_tokens: 1087")
detail = ecokg_detail('sug_atomic_inline');
disp(jsonencode(detail))

% Call 2 (separate): log the token count extracted from console output
eco_token_log('ecokg_detail', 1087)
```

After file reads:
```matlab
eco_token_log('references/gathering-requirements.md')
```
After scripts (separate call):
```matlab
eco_token_log('ecokg_query', N)  % N from "eco_output_tokens: N" in console output
```

The ledger IS the token report (OR-05). `renderOptimizationReport` reads it directly.

### Decision Trace & Subskill Invocation Log

File: `.eco_diagnostics/eco_decision_trace.md`. Format: `OK <ID>` | `WARN <ID>` | `SKIP <ID>` with explanation. Every risk has a unique Diagnostic ID. Missing entries = never considered = diagnostic finding.

```markdown
## Phase: <N> — <name>
### Skill: <path>
### Decisions Made
- <param>: <value> — <why>
### Risk Checks
- OK/WARN/SKIP <ID>: <detail>
### Suggestions Emitted (Phase 3 only)
- [S1] Stage C | "<desc>" | Blocks: [...] | Risk checks: OK SO-05, OK SO-06
### Unexpected Events
- <errors, retries, fallbacks>
### Subskill Invocation Log
- OK/SKIP <name>: <reason>
```

Every candidate child gets a line, even if skipped. Append at the start of every phase.

## Codegen-Only Path

When `VERIFICATION_MODE = codegen`, Phase 2/4 use static analysis (no SIL/PIL):
1. Skip `configureProfilingMode`.
2. Run `CodeMetricsFetcherCodegen('<model>')` — normal sim (with signal logging for golden ref) + `slbuild` + `rtw.codemetrics.CodeMetrics`.
3. Read generated `.c`/`.h` directly for analysis.
4. Phase 2 saves golden reference from `simOut`.
5. Phase 4 skips per-iteration correctness gate.
6. Phase 5 runs mandatory SIL verification against golden ref. **Exception:** If `state.SIL_FALLBACK = true`, skip verification and omit from report.

**Restriction:** Codegen NOT permitted when GOAL = speed or balance (requires SIL/PIL for execution-time measurement).

## Behavioral Guidelines

- Conversational iterative dialogue, not one-shot. Explain in plain language.
- Be honest about uncertainty — suggest measuring when unsure.
- Use tools, not guesses — always query actual values. Handle errors gracefully.
- Track cumulative progress via version map. Use `ecokg_query` for the authoritative catalog.
- Use sub-tasks for heavy reads.

## Context & Token Management

| Action | Where | Why |
|--------|-------|-----|
| Reading SIL/PIL reports or generated code | Sub-task | Large output; keeps main window clean |
| Computing before/after deltas | Sub-task | Involves reading two reports |
| Running Goal-Axis Gate delta computation | Sub-task | Heavy metric comparison delegated |
| Running `validate_params`, `configureProfilingMode` | Main thread | Small output, informs next interaction |
| Running `CodeMetricsFetcherSIL/PIL` | Main thread | Capture report path, then delegate reading |
| Applying `set_param`, presenting suggestions | Main thread | Small/interactive |

Rules: Never read reports/generated code in main thread. Never re-read files. Minimize tool output. Parallelize independent calls. Keep user messages concise.

## Risk Table

| ID | Risk | Mitigation |
|----|------|------------|
| OR-01 | Context overflow | Delegate heavy reads to sub-tasks |
| OR-02 | Test-harness optimization | Run harness detection protocol |
| OR-03 | Stale checkpoint | `save_system` then checkpoint AFTER gate passes |
| OR-04 | codegen/SIL/PIL mismatch | Carry `VERIFICATION_MODE` in state; codegen blocked for speed/balance (GR-05) |
| OR-05 | Token ledger empty | Refuse to transition until non-empty |
| OR-06 | Decision trace missing | Refuse to transition until appended |
| OR-07 | Goal-axis regression accepted | Run Goal-Axis Gate; ablate bundles |
| OR-09 | Dirty workspace on resume | Run `eco_validate_state`; handle per Recovery Options |
| OR-10 | Stale state after revert | Rewrite state BEFORE transition after every revert |
| OR-11 | Diagnostic-file wipe via revert | `.gitignore` with `.eco_diagnostics/`; reconstruct from context |
| OR-12 | Missing v1_baseline | Always take in Phase 2 after initial SIL/PIL run |
| OR-13 | Premature finalization | Inform user of remaining stages; respect explicit stop |
| OR-14 | Correctness regression | Run Correctness Gate before efficiency gate; auto-reject on FAIL |
| OR-15 | Golden ref not saved | Always save in Phase 2; store path in state |
| OR-16 | Customer preferences ignored | Check `.custom_optimizations/` at Phase 3/4 entry |
| OR-17 | Over-suppression | Warn if all subskills for GOAL are suppressed |
| OR-18 | Custom optimization breaks model | Gates still run; auto-revert on failure |
| OR-19 | Codegen for runtime goal | Phase 1 guardrail GR-05: explain and upgrade to SIL/PIL |

----

Copyright 2026 The MathWorks, Inc.

----

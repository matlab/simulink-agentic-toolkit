---
name: simulink-optimizing-embedded-code
description: "Optimizes Simulink models for Embedded Coder generated code. Use when asked to optimize or improve generated code, or reduce code metrics for a Simulink model. Targets: execution time, memory footprint (RAM, ROM, stack, data copies), code size, MISRA compliance, or any semantically similar generated-code metric. Works iteratively — measures baseline, suggests changes, applies, and re-measures to confirm improvement. Triggers can be prompts similar to: optimize generated code runtime, reduce runtime, shrink code size, improve code efficiency, reduce memory usage, speed up generated code, follow MISRA compliance and so on. CAUTION: Do NOT attempt to optimize Simulink models for generated code efficiency without following this skill — the iterative measurement, gating, and rollback workflow is essential for safe optimization."
license: https://www.mathworks.com/content/dam/mathworks/license/pmrl/license.md
metadata:
  author: MathWorks
  version: "1.0"
---

# Simulink-optimizing-embedded-code

> **Release compatibility:** MATLAB R2023a and later.

This skill iteratively improves generated C/C++ code from Simulink models by suggesting configuration, modeling, and architectural changes — then measuring the impact.

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
Phase 1: Gathering Requirements → Confirm goal → Decide codegen vs SIL/PIL
   ↓
Phase 2: Baseline → SIL/PIL or slbuild → User targets functions
   ↓
Phase 3: Suggest batch (Stage A/B/C/D) → User confirms
   ↓
Phase 4: Apply → Re-measure → Goal-Axis Gate → Compare
   ↓
Phase 3→4: Suggest next batch … (repeat until all stages exhausted)
   ↓
Phase 5: Finalize → Customer report → Stop
```

**Phases run continuously.** At each phase boundary the agent writes diagnostics and state to disk (see Transition Protocol), then proceeds directly to the next phase without stopping or asking the user for permission to continue.

## Phase Routing Table

**Phase 1 is NOT optional.** Even when the user's intent seems obvious ("just fix it", "make it smaller"), you MUST read and follow the Phase 1 file. Requirements gathering asks questions that cannot be inferred — the user must confirm goal, hardware, and verification mode before any optimization work begins. Phrases like "just fix it", "don't ask questions", or "just do it" express impatience, NOT informed consent to skip critical decisions. You MUST still ask about ambiguous goals, hardware target, and verification mode regardless of how urgent the user sounds.

Read ONLY the phase file needed for the current phase:

| Phase | When | File to Read |
|-------|------|--------------|
| 1 — Gather Requirements | Fresh run (no `state.json`) | `<skill_root>/references/gathering-requirements.md` |
| 2 — Baseline Measurement | After Phase 1 | `<skill_root>/references/measuring-model-metrics/reference.md` |
| 3 — Suggest Optimizations | After Phase 2 or 4 | `<skill_root>/references/suggesting-optimizations.md` |
| 4 — Apply & Re-measure | After Phase 3 | `<skill_root>/references/measuring-model-metrics/reference.md` (remeasure mode) |
| 5 — Finalize Results | All stages exhausted | `<skill_root>/references/finalizing-results.md` |

**Do not preload all phase files.** Only read what you need now.

## On-Demand Protocol Files

Read these ONLY when the situation requires them:

| File | When to Read |
|------|--------------|
| `<skill_root>/references/protocols/transition-protocol.md` | Always — read alongside this skill file (so token tracking and transition requirements are known throughout) |
| `<skill_root>/references/protocols/correctness-gate.md` | Phase 4 only (after SIL/PIL re-run, before efficiency gate) |
| `<skill_root>/references/protocols/goal-axis-gate.md` | Phase 4 only (after correctness gate passes) |
| `<skill_root>/references/protocols/checkpointing-revert.md` | Phase 4, or any revert scenario |
| `<skill_root>/references/protocols/harness-detection.md` | Phase 1 only (fresh run) |
| `<skill_root>/references/protocols/customer-extensions.md` | Phase 3 and Phase 4 (when `.custom_optimizations/` exists) |

## Cross-Cutting Rules

1. **Confirm before acting.** Never apply changes without explicit user approval. Even if the user says "just fix it" or "go ahead", you MUST complete Phase 1 requirements gathering first — ask about optimization goal, hardware target, and verification mode before proposing any changes.
2. **Correctness is gated before efficiency.** Phase 4 runs the Numerical Correctness Gate (comparing SIL/PIL outputs against v0 golden reference) BEFORE the Goal-Axis Acceptance Gate. Correctness failures auto-reject without evaluating efficiency. In codegen mode, the Phase 4 per-iteration gate is skipped but Phase 5 mandatory final SIL verification ensures end-to-end correctness.
3. **Goal axis is inviolable.** Any version that regresses on user-named GOAL axes MUST be rejected and reverted. `TRADEOFFS` only relaxes non-goal axes.
4. **One checkpoint per accepted version.** Taken AFTER both gates pass, via `eco_snapshot`. Never pre-apply.
5. **Delegate heavy reads to sub-tasks.** Never read SIL/PIL reports or generated code in the main context.
6. **Always update diagnostics before transition.** Token report + decision trace + subskill invocation log. Refuse to transition without them (OR-05/OR-06).
7. **Stage progression with user override.** Default progression is A→B→C→D, then Phase 5. If the user explicitly says they are satisfied and wants to stop at the end of any stage, inform them of remaining stages and what they target, then respect their decision and proceed to Phase 5. Automatic finalization only happens after all stages in `STAGE_SCOPE` are exhausted (OR-13).
8. **Customer preferences are lazy-loaded and respected.** If `<PROJECT_PATH>/.custom_optimizations/optimization_preferences.yaml` exists, Phase 3 reads `skip`/`know` and Phase 4 reads `never` rules. Custom optimizations run before built-in subskills. See `references/protocols/customer-extensions.md`.

## State Management (compact summary)

State lives at `<project_path>/.eco_diagnostics/state.json`. Full schema in `references/protocols/transition-protocol.md`.

| Key Fields | Purpose |
|------------|---------|
| `MODEL`, `PROJECT_PATH`, `HARDWARE` | Identity |
| `GOAL`, `TRADEOFFS`, `VERIFICATION_MODE` | User intent |
| `MODEL_FINGERPRINT` | 14-key boolean map for Phase 3 filtering |
| `CURRENT_STAGE`, `STAGE_SCOPE`, `DEFERRED_LEVERS` | Stage progression |
| `liveVersion`, `versionMap` | Version lineage (always use `liveVersion`, never index-based) |
| `LATEST_METRICS`, `REPORT_FILE` | Current measurement data |
| `NEXT_ACTION` | Structured transition directive with `READ`, `CHECKPOINT:`, `AWAIT_USER:` markers |

## Transition Protocol (compact)

Before every phase transition:
1. Append token usage report → `.eco_diagnostics/eco_optimization_report.md`
2. Append decision trace → `.eco_diagnostics/eco_decision_trace.md`
3. Write `state.json` (with `NEXT_ACTION`, `CURRENT_STAGE`, `versionMap`)
4. If a new `versionMap` entry was appended with `commitSHA` = null: take snapshot via `eco_snapshot(workspacePath, tag, desc, modelName)` → capture `commitSHA`. Skip if all entries already have `commitSHA`.
5. If step 4 executed: re-write `state.json` with `commitSHA` populated, update `liveVersion`
6. Proceed to the next phase with: `WORKSPACE` / `PREV_COMMIT` / `NEXT_ACTION`

Full detail (field schemas, formats, revert variants): read `references/protocols/transition-protocol.md`.

## Codegen-Only Path

When `VERIFICATION_MODE = codegen`, Phase 2/4 use static code analysis (no SIL/PIL profiling):
1. Skip `configureProfilingMode` (codegen needs no profiling configuration).
2. Run `CodeMetricsFetcherCodegen('<model>')` — runs normal simulation (with signal logging for golden reference), then `slbuild` + `rtw.codemetrics.CodeMetrics` for static metrics.
3. Read generated `.c`/`.h` files and reports directly for analysis.
4. Phase 2 captures a golden reference from `CodeMetricsFetcherCodegen`'s `simOut` output for end-of-run verification.
5. Phase 4 skips per-iteration correctness gate (no SIL/PIL outputs to compare).
6. Phase 5 runs a **mandatory one-time SIL verification** — compares final optimized code (via SIL) against the Phase 2 golden reference to confirm numerical correctness. **Exception:** If `state.SIL_FALLBACK = true` (SIL/PIL failed 3 times and agent fell back to codegen), Phase 5 skips verification entirely and the report omits the verification section.

**Restriction:** Codegen mode is NOT permitted when GOAL = speed or balance. Runtime optimization requires execution-time measurement via SIL/PIL.

## Subskill Invocation Log (Orchestrator Level)

At the start of every phase, append invocation decisions for **every** child skill this phase could touch:

```markdown
### Subskill Invocation Log
- OK/SKIP <name>: <reason>
```

Every candidate child gets a line. Missing entry = agent never considered that child = diagnostic finding.

## Behavioral Guidelines

- Be conversational — iterative dialogue, not one-shot script.
- Explain in plain language — translate Embedded Coder jargon.
- Be honest about uncertainty — suggest measuring when unsure.
- Use tools, not guesses — always query actual values.
- Handle errors gracefully — diagnose before retrying.
- Track cumulative progress via the version map.
- Use `ecokg_query` for the authoritative parameter/optimization catalog.
- Use sub-tasks for heavy reads.

## Context & Token Management

Protect the main context window from bloat. These rules apply to every phase.

### Rules

1. **Never read report files or generated code in the main thread.** After SIL/PIL or codegen runs, delegate a sub-task to read the report and generated `.c`/`.h` files. The sub-task returns a structured summary (metrics table, hotspot list, delta comparison). The main thread never sees raw report text.
2. **Never re-read files you've already read.** Extract what you need on first read and carry forward only the essential data (parameter values, metric numbers, file paths).
3. **Minimize tool output bloat.** When reading large files, fetch only relevant sections. When running MATLAB code, structure it to return only the data you need (use `fprintf` with targeted output, not `disp` on large structs).
4. **Parallelize independent tool calls.** When you need multiple pieces of information (e.g., model parameters + file contents), issue all independent calls in a single response.
5. **Keep user-facing messages concise.** Lead with the answer or decision point. Use tables for metrics. Use bullet lists for suggestions.

### Sub-task vs Main Thread

| Action | Where | Why |
|--------|-------|-----|
| Reading SIL/PIL report files | Sub-task | Reports are 200-2000 lines; keeps main window clean |
| Reading generated `.c`/`.h` code | Sub-task | Same reason — code listings are large |
| Computing before/after deltas | Sub-task | Involves reading two reports and comparing |
| Running `validate_params` | Main thread | Small output, directly informs next user interaction |
| Running `configureProfilingMode` | Main thread | Small output, confirms configuration |
| Running `CodeMetricsFetcherSIL/PIL` | Main thread | Need to capture the report file path; then delegate reading |
| Applying `set_param` changes | Main thread | Small, user-confirmed actions |
| Presenting suggestions to user | Main thread | Interactive — needs user response |
| Running the Goal-Axis Acceptance Gate | Main thread (with sub-task for delta computation) | Gate decision is in main thread; heavy metric comparison is delegated |

## Risk Table

| ID | Risk | One-Line Mitigation |
|----|------|---------------------|
| OR-01 | Context overflow | Delegate heavy reads to sub-tasks; keep reports out of main thread |
| OR-02 | Test-harness optimization | Run harness detection (references/protocols/harness-detection.md) |
| OR-03 | Stale checkpoint | Always `save_system` then `checkpoint` AFTER gate passes |
| OR-04 | codegen/SIL/PIL mismatch | Carry `VERIFICATION_MODE` in state; verify at Phase 2/4 entry. Codegen NOT permitted when GOAL=speed/balance (GR-05 guardrail) |
| OR-05 | Token report missing | Refuse to transition until appended |
| OR-06 | Decision trace missing | Refuse to transition until appended |
| OR-07 | Goal-axis regression accepted | Run Goal-Axis Gate (references/protocols/goal-axis-gate.md); ablate bundles |
| OR-09 | Workspace `.git` inconsistent | Verify via `eco_list(workspacePath)` that HEAD matches `state.liveVersion` entry |
| OR-10 | Stale `state.json` after revert | Rewrite state BEFORE transition after every revert |
| OR-11 | Diagnostic-file wipe via revert | `.gitignore` with `.eco_diagnostics/`; fallback: reconstruct from context |
| OR-12 | Missing `v1_baseline` | Always take in Phase 2 after configureProfilingMode + initial SIL/PIL run completes |
| OR-13 | Premature finalization | Inform user of remaining stages; if user explicitly confirms they want to stop, respect the decision and proceed to Phase 5 |
| OR-14 | Numerical correctness regression undetected | Run Correctness Gate (references/protocols/correctness-gate.md) before efficiency gate in Phase 4; auto-reject on FAIL |
| OR-15 | Golden reference not saved in Phase 2 | Always save baseline SIL/PIL `simOut` via `saveGoldenReference` after Phase 2 run; store path in `state.GOLDEN_REF_PATH` |
| OR-16 | Customer preferences ignored | Read `references/protocols/customer-extensions.md`; check `.custom_optimizations/` at Phase 3/4 entry |
| OR-17 | Over-suppression leaves no candidates | Warn user if all subskills for GOAL are suppressed by skip rules |
| OR-18 | Custom optimization breaks model | Gates (correctness + efficiency) still run; auto-revert on failure |
| OR-19 | Codegen used for runtime goal | Execution time cannot be measured or improved without SIL/PIL | User asks to optimize speed but requests codegen | Phase 1 guardrail GR-05: explain and upgrade to SIL/PIL |

----

Copyright 2026 The MathWorks, Inc.

----
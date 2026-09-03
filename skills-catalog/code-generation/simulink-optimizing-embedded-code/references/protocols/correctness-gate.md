# Numerical Correctness Gate

> **When to read:** Phase 4 only, after SIL/PIL re-run completes, BEFORE the Goal-Axis Acceptance Gate.

## Core Invariant

A new version `v(N+1)` MUST be rejected if its SIL/PIL signal outputs diverge from the v0 golden reference beyond `state.TOLERANCE`. Correctness is non-negotiable and cannot be traded for efficiency gains. No `TRADEOFFS` permission can relax this gate.

**This gate runs BEFORE the Goal-Axis Acceptance Gate.** If correctness fails, the efficiency gate is never evaluated.

## Prerequisites

1. **Golden reference exists** at `state.GOLDEN_REF_PATH` (saved once in Phase 2 from the baseline SIL/PIL `simOut` via `saveGoldenReference.m`).
2. **SIL/PIL `simOut` is available** — the `CodeMetricsFetcher*` script returns it as the second output.
3. **`state.TOLERANCE`** is set (established in Phase 1, consistent with Phase 5's final check).

If `state.GOLDEN_REF_PATH` is empty or the file does not exist, log `SKIP NC-01: golden reference unavailable` and proceed directly to the efficiency gate. Do NOT fail the run.

## Procedure

1. **Load golden reference:**
   ```matlab
   addpath(fullfile('<skill_root>', 'scripts'));
   verdict = checkNumericalCorrectness(simOut_vN, state.GOLDEN_REF_PATH, state.TOLERANCE);
   ```

2. **Evaluate verdict:**

   | `verdict.class` | `verdict.pass` | Action |
   |-----------------|----------------|--------|
   | `'exact'` | `true` | **PASS** — all signals match exactly. Proceed to efficiency gate. |
   | `'warn'` | `true` | **PASS (warn)** — signals differ but within tolerance. Proceed to efficiency gate. Note near-tolerance signals in decision trace. |
   | `'fail'` | `false` | **FAIL** — signals exceed tolerance. Auto-reject immediately. |

3. **On PASS:** Proceed to the Goal-Axis Acceptance Gate (read `protocols/goal-axis-gate.md`).

4. **On FAIL (auto-reject):**
   - Call `eco_revert(workspacePath, <live entry>.tag, modelName)`. The live entry is `state.versionMap` where `version === state.liveVersion`.
   - Reopen model: `open_system('<model>')`.
   - Append `versionMap` entry for v(N+1) with:
     - `status: "FAIL rejected — correctness regression on <verdict.maxErrSignal> (err=<verdict.maxErr>, tol=<state.TOLERANCE>)"`
     - `revertCause: "Gate_Rejected"`
     - `revertTargetVersion: "<state.liveVersion>"`
   - Report to the user: *"v<N+1> failed the correctness gate: signal `<maxErrSignal>` diverged by <maxErr> (tolerance: <TOLERANCE>). The change has been auto-reverted to v<liveVersion>."*
   - Do NOT run the efficiency gate.
   - Follow the same bundle-analysis logic as the efficiency gate's reject path (see `protocols/goal-axis-gate.md` → "On REJECT" steps 4–7): analyze which change likely caused the correctness failure, present analysis to user, let user choose next attempt.

## Interaction with `VERIFICATION_MODE`

| Mode | Correctness Gate Behavior |
|------|--------------------------|
| `SIL` | Run gate — compare v0 baseline SIL outputs vs v(N) SIL outputs |
| `PIL` | Run gate — compare v0 baseline PIL outputs vs v(N) PIL outputs |
| `codegen` | **Skip in Phase 4** — no per-iteration SIL/PIL outputs. Log `SKIP NC-01: codegen mode — per-iteration gate skipped (final verification in Phase 5)`. Phase 5 performs a one-time SIL correctness check against the golden reference. |

## Interaction with Signal Availability

| `verdict.method` | Meaning |
|------------------|---------|
| `'logsout'` | Compared via logged signals (highest fidelity) |
| `'yout'` | Fell back to output port data (acceptable) |
| `'none'` | No signals available in either golden ref or SIL/PIL output |

If `verdict.method == 'none'`: Log `SKIP NC-01: no comparable signals in golden reference or SIL/PIL output`. Proceed to efficiency gate. Do NOT fail.

## What NOT to Do

- Do not skip this gate because efficiency numbers look good.
- Do not weaken `state.TOLERANCE` mid-run to make a failing version pass.
- Do not compare v(N) normal-sim vs v(N) SIL — that only checks codegen equivalence of the current version, not whether the optimization preserved the original behavior. The correct comparison is baseline SIL (v0) vs optimized SIL (v(N)).
- Do not re-run the golden reference sim on every iteration — it is cached from Phase 2.
- Do not treat a correctness FAIL as a "soft" warning that the user can override. Correctness failures are always auto-rejected.
- Do not run the efficiency gate after a correctness FAIL.

## Decision Trace Logging

| When | Log entry |
|------|-----------|
| Correctness gate PASS (exact) | `OK NC-01: Correctness gate PASSED — 0 error across <N> signals (method=<method>)` |
| Correctness gate PASS (warn) | `WARN NC-01: Correctness gate PASSED — maxErr=<value> on <signal> within tolerance=<tol> (method=<method>)` |
| Correctness gate FAIL | `FAIL NC-01: Correctness gate FAILED — maxErr=<value> on <signal> exceeds tolerance=<tol>. Auto-rejecting v<N+1>. (method=<method>)` |
| Golden ref missing | `SKIP NC-01: Golden reference not available at <path> — correctness gate skipped` |
| No signals to compare | `SKIP NC-01: No comparable signals (method=none) — correctness gate skipped` |
| Codegen mode (Phase 4) | `SKIP NC-01: codegen mode — per-iteration gate skipped; final SIL verification deferred to Phase 5` |


----

Copyright 2026 The MathWorks, Inc.

----
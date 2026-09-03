# Goal-Axis Acceptance Gate

> **When to read:** Phase 4 only, after re-measurement completes.

> **Prerequisite:** The Numerical Correctness Gate (`protocols/correctness-gate.md`) MUST have PASSED before this gate runs. If the correctness gate FAILED, this gate is never reached — the version was already auto-rejected.

## Core Invariant

A new version `v(N+1)` MUST be rejected and reverted to `v(N)` if it regresses on **any** axis the user named in `GOAL`. The goal axis is inviolable. `TRADEOFFS` permissions apply ONLY to non-goal axes — they cannot relax the goal axis.

## What `TRADEOFFS` Does (non-goal axes only)

- **No tradeoff stated:** Non-goal regressions require explicit user confirmation. No silent trades.
- **Explicit tradeoff granted** (e.g., "willing to trade some RAM"): The named non-goal axis may regress without re-confirmation. Other non-goal axes still need confirmation.
- **Explicit tradeoff cap** (e.g., "RAM may grow up to 2 KB"): Treat cap as a second gate; if exceeded, ask the user.
- **In all cases:** The goal axis is still gated by the core invariant.

## Acceptance Procedure

1. **Resolve the goal-axis set** from `state.GOAL` and `state.TRADEOFFS`. Build `goal_axes = { metric → noise_floor }`:
   - `GOAL=speed` → `{ exec_time }`
   - `GOAL=RAM` → `{ global_RAM }`
   - `GOAL=ROM` → `{ ROM_bytes }`
   - `GOAL=balance` → `{ exec_time, global_RAM }`
   - Multi-axis goals → include every axis the user named

2. **Compute delta for every axis in `goal_axes`** for `v(N+1)` vs `v(N)`:
   ```
   delta = (v(N+1) - v(N)) / v(N) * 100%
   ```

3. **Apply the per-axis noise-floor filter:**
   - `exec_time` (SIL): host timer = **100 ns**; (PIL): board-dependent
   - `global_RAM`, `stack`, `copies`, `ROM`: integer → noise floor = **0**
   - `cyclomatic`: integer → noise floor = **0**
   - If `|absolute_delta| <= 2 * noise_floor` → treat as noise, not a regression.

4. **Decision matrix:**

   | Delta on **any** goal axis (beyond noise) | Delta on non-goal axis (beyond noise) | `TRADEOFFS` permits? | Action |
   |---|---|---|---|
   | All improved or in noise | All improved or in noise | n/a | **Accept** |
   | All improved or in noise | Regressed | yes (within cap) | **Accept**; document trade |
   | All improved or in noise | Regressed | no / cap exceeded | **Ask user** before accepting |
   | All in noise (no goal improvement) | Improved | n/a | **Accept**; flag `* at noise floor` |
   | All in noise (no goal improvement) | Regressed | yes | **Ask user** — cost for no benefit |
   | **Any** goal axis regressed (beyond noise) | any | **irrelevant** | **REJECT — revert to v(N)** |

   *Aggregation:* A single goal-axis regression beyond noise is sufficient to reject. Goal-axis regressions are NEVER offsettable.

## On REJECT (Scenario 3 — `Gate_Rejected` auto-revert)

1. **Revert:** Call `eco_revert(workspacePath, <live entry>.tag, modelName)`. The live entry is `state.versionMap` where `version === state.liveVersion` (still v(N) because `liveVersion` only advances on accepts).

2. **Reopen model:** `open_system('<model>')` in MATLAB.

3. **Rewrite `state.json` BEFORE transition** (the revert overwrote it). Append a `versionMap` entry for v(N+1) with:
   - `status: "FAIL rejected — regression on <axis_list>"`
   - `commitSHA: null` (no snapshot taken for rejected candidate)
   - `parentVersion: state.liveVersion`
   - `revertCause: "Gate_Rejected"`
   - `revertTargetVersion: "<parent's version label>"`
   - `revertTargetCommitSHA: <parent's commitSHA>`

4. **Analyze the rejected bundle and present options to the user:** If v(N+1) was an N-change bundle (N > 1):
   - Use your judgement and the measurement results to determine which change(s) in the bundle most likely caused the regression. Consider: which changes touch the hottest code paths, which introduce overhead (e.g., loop unrolling on small models, SIMD on scalar code), and which are low-risk config tweaks unlikely to regress.
   - Present your analysis to the user: *"The batch regressed <axis> by <delta>. Based on the results, I believe <change X> is the likely cause because <reasoning>. The remaining changes (<list>) are likely still beneficial."*
   - Let the user choose what to try next: an individual change, a smaller sub-bundle excluding the suspected cause, or skip/move on.
   - A batch rejection does NOT count as rejecting each individual candidate within it. The individual candidates remain live options until the user explicitly declines them.

5. **If no subset satisfies the gate:** Do NOT terminate the run. Retain v(N) and re-prompt the user with:
   - Remaining unevaluated candidates in the current stage
   - Any deferred levers from earlier stages (`state.DEFERRED_LEVERS`)
   - Option to advance to Stage X+1
   - Option to FINALIZE early

   Automatic finalization occurs when every stage in `STAGE_SCOPE` is exhausted. If the user explicitly says they are satisfied and wants to stop early, inform them of remaining stages and what each targets — then respect their decision and proceed to Phase 5.

6. **Log** `WARN OR-07` in the decision trace with: rejected version, offending change, regressed axis, non-goal numbers offered as compensation (and rejected), `commitSHA` (if any).

7. **Only after the gate passes** may you write updated state, delegate checkpoint for v(N+1), and proceed to the next phase. If rejected, follow the reject variant (transition steps 1, 2, 6 only).

## What NOT to Do

- Do not keep v(N+1) because a non-goal axis improved.
- Do not let one goal axis's improvement cancel another goal axis's regression.
- Do not bury a goal-axis regression in a "mixed verdict" badge.
- Do not declare a stage exhausted when a bundle regresses — analyze and re-prompt the user with individual options.
- Do not silently re-run the same bundle hoping for different numbers.
- Do not redefine the goal mid-run without explicit user consent.


----

Copyright 2026 The MathWorks, Inc.

----
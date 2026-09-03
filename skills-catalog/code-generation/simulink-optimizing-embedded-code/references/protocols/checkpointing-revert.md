# Checkpointing & Revert

> **When to read:** Phase 4 (after apply), or any time a revert is needed.

All version snapshots are taken via the **evolutions-checkpoint** sub-skill (`<skill_root>/references/evolutions-checkpoint.md`), which provides MATLAB functions wrapping direct git commands. Do NOT copy `.slx` files manually.

## Three Kinds of Revert

| Kind | Trigger | Mechanism | Creates `versionMap` entry? | `revertCause` |
|------|---------|-----------|----------------------------|---------------|
| **A. Gate_Rejected** | Goal-Axis Gate flags regression | `eco_revert(workspacePath, <live entry>.tag, modelName)`. No user prompt — automatic. | Yes (`status: "FAIL rejected — …"`) | `"Gate_Rejected"` |
| **B. User_Requested_Revert** | User asks to restore earlier version | Confirm target with user, then `eco_revert(workspacePath, <chosen entry>.tag, modelName)`. | Yes (`status: "USER_REVERT — restored to v<i>"`) | `"User_Requested_Revert"` |
| **C. In-conversation undo** | Sub-skill detects apply-time problem BEFORE gate runs | Inverse MATLAB operation directly. **No checkpoint call.** | No — no `commitSHA` ever existed | `null` |

Kinds A and B both call `eco_revert`. Kind C is owned by individual sub-skills.

## Checkpoint Workflow

| When | What to call |
|------|--------------|
| Start of run (Step 0) | `eco_init(workspacePath)` — initializes `.git`, creates `.gitignore`, commits + tags `v0_pristine`. |
| Top of Phase 2 (after `configureProfilingMode` + initial SIL/PIL run completes) | `eco_snapshot(workspacePath, 'v1_baseline', '…', modelName)` — measurement-ready floor (Step 0e). Mandatory even if pristine was already ready. |
| End of Phase 4 (gate PASS) | `eco_snapshot(workspacePath, 'v<N>_<tag>', 'rationale + delta', modelName)` for accepted version. |
| After Phase 4 reject | `eco_revert(workspacePath, <live entry>.tag, modelName)` — restore to most recently accepted version. |
| User asks "show versions" | `eco_list(workspacePath)` |

## Two-Baseline Checkpoints Rule

- **`v0_pristine`** (Step 0d): Preserved for end-of-run "vs original" delta. Never used as a Phase-4 revert target.
- **`v1_baseline`** (Step 0e): Taken after configureProfilingMode AND the initial SIL/PIL run completes. All Phase-3 candidates branch from here. Phase-4 reverts target this before any accept.

After that, take exactly ONE checkpoint per accepted Phase-4 version (do NOT take pre-apply AND post-pass checkpoints).

**What Phase-4 Gate_Rejected reverts target:** Always `<live entry>.tag` — the most recently accepted version. Before any Phase-4 accept → v1_baseline. After v2 accepted → v2. After v3 accepted → v3. The floor moves up on every accept.

## Recovery on Bad Apply / Build Failure (User-Requested Revert — Kind B)

1. Notify user with the problematic metric / build error.
2. Offer revert: *"Shall I restore to v<N> (<tag>)?"*
3. On confirmation, call `eco_revert(workspacePath, '<tag>', modelName)`. This closes the model, checks out the target commit, and reopens the model.
4. **Rewrite `state.json` BEFORE transition:**
   - Append new `versionMap` entry:
     - `version`: fresh tag (next unused index)
     - `tag`: `"v<N+1>_user_revert_to_v<i>"`
     - `status`: `"USER_REVERT — restored to v<i>"`
     - `parentVersion`: `state.liveVersion` (the abandoned version)
     - `revertCause`: `"User_Requested_Revert"`
     - `revertTargetVersion`: `"v<i>"`
     - `revertTargetCommitSHA`: the restored commitSHA
     - `commitSHA`: may be `null` (workspace equals `revertTargetCommitSHA`)
   - **Set `state.liveVersion = "v<i>"`** so subsequent entries use `parentVersion = "v<i>"`.
5. Reroute: suggest alternatives from the same or next stage.

## Transition After Revert

- **Kind A (Gate_Rejected):** `state.liveVersion` unchanged. Perform transition steps 1, 2, 6 only (no new snapshot).
- **Kind B (User_Requested_Revert):** `state.liveVersion` reset to `revertTargetVersion`. Perform transition steps 1, 2, 6 only (no new snapshot).


----

Copyright 2026 The MathWorks, Inc.

----
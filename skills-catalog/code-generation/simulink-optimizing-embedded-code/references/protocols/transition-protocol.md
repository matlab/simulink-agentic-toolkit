# Transition Protocol

> **When to read:** Always — read alongside SKILL.md so token tracking and transition requirements are known throughout.

## State Object (`state.json`)

The full state lives on disk at `<project_path>/.eco_diagnostics/state.json`. It is captured in every git snapshot automatically (the workspace `.git` repo commits everything tracked), so any prior commit's state is recoverable via `git show <sha>:.eco_diagnostics/state.json` from the workspace `.git`.

**Why on disk:** Persisting the state as a file inside the workspace lets the agent read it on resume and provides a durable record of phase transitions.

**Shape of `state.json`:**

```json
{
  "MODEL": "<model_name>",
  "PROJECT_PATH": "<absolute_path_to_project>",
  "HARDWARE": "<target>",
  "BOARD_CONNECTED": true,
  "GOAL": "speed|RAM|ROM|balance|MISRA",
  "TRADEOFFS": "<user's constraints>",
  "VERIFICATION_MODE": "codegen|SIL|PIL",  // codegen NOT permitted when GOAL=speed|balance (GR-05)
  "PROFILING_FOCUS": "time|stack",
  "REPORT_LEVEL": "coarse|detailed",
  "ENABLE_CRL": true,
  "TOLERANCE": 100,
  "SIM_STOP_TIME": "10",
  "GOLDEN_REF_PATH": "<path to .eco_diagnostics/golden_reference/<model>_golden_ref.mat>",
  "TARGET_FUNCTIONS": ["..."],
  "MODEL_FINGERPRINT": {},
  "CURRENT_STAGE": "A|B|C|D|FINALIZE",
  "STAGE_SCOPE": ["A","B","C","D"],
  "DEFERRED_LEVERS": [],
  "liveVersion": "v1",
  "versionMap": [
    { "version": "v0", "tag": "v0_pristine",
      "commitSHA": "...", "metrics": {}, "status": "OK pristine",
      "parentVersion": null, "revertCause": null,
      "revertTargetVersion": null, "revertTargetCommitSHA": null },
    { "version": "v1", "tag": "v1_baseline",
      "commitSHA": "...", "metrics": { "ExecTime_ns": 0, "GlobalRAM_B": 0 },
      "status": "OK baseline — measurement prereqs applied",
      "parentVersion": "v0", "revertCause": null,
      "revertTargetVersion": null, "revertTargetCommitSHA": null }
  ],
  "LATEST_METRICS": {
    "ExecTime_ns": 0,
    "GlobalRAM_B": 0,
    "perTargetFunction": []
  },
  "REPORT_FILE": "<path_to_latest_report_file>",
  "NEXT_ACTION": "<structured action>"
}
```

### Customer Preferences (NOT in state.json)

Customer preferences (`optimization_preferences.yaml`) are read lazily from disk by each phase that needs them — they are NOT cached in state.json. This keeps state lean and lets customers edit preferences between phases.

**Location:** `<PROJECT_PATH>/.custom_optimizations/optimization_preferences.yaml`. A blank template is available at `<skill_root>/assets/optimization_preferences.yaml` for customers to copy.

See `protocols/customer-extensions.md` for full details.

### `NEXT_ACTION` Format (mandatory structured encoding)

The `NEXT_ACTION` field MUST use a numbered sub-step format that encodes checkpoints and user-interaction points explicitly:

```
"Phase <N> <name> — (1) READ <phase_file>, (2) CHECKPOINT: <what>, (3) <action>, (4) AWAIT_USER: <what to present and ask>"
```

- `READ <file>`: The agent MUST read that phase reference.md before doing anything else.
- `CHECKPOINT: <what>`: An evolution snapshot MUST be taken at this step (via `evolutions-checkpoint` sub-skill).
- `AWAIT_USER: <what>`: The agent MUST stop at this point, present the described information to the user, and wait for their response before proceeding.
- Sub-steps without a prefix are autonomous actions.

### Per-entry fields (mandatory on every `versionMap` entry)

| Field | Meaning |
|-------|---------|
| `version` | Short label like `"v0"`, `"v1"`, `"v2a"` (ablation children use suffixes). |
| `tag` | Human-readable descriptor (`"v0_pristine"`, `"v3_user_revert_to_v1"`). |
| `commitSHA` | Git commit SHA for this workspace state (null only for FAIL pre-checkpoint case). |
| `metrics` | Measured metrics at this version (empty for revert leaves). |
| `status` | `"OK pristine"`, `"OK ACCEPT — …"`, `"FAIL rejected — …"`, or `"USER_REVERT — restored to v<N>"`. |
| `parentVersion` | The `version` this one branches from. `null` for `v0`. After a `User_Requested_Revert` to `v{i}`, every subsequent entry uses `parentVersion = "v{i}"`. |
| `revertCause` | `"Gate_Rejected"` / `"User_Requested_Revert"` / `null`. |
| `revertTargetVersion` | The `version` restored to. Non-null only when `revertCause != null`. |
| `revertTargetCommitSHA` | The `commitSHA` restored to. Non-null only when `revertCause != null`. |

### `state.liveVersion` semantics

A single string holding the `version` label of the versionMap entry whose state matches the live workspace. **Always read this, never `versionMap[-1]`.**

| Workflow point | What `liveVersion` equals |
|----------------|---------------------------|
| After Step 0d (pristine snapshot) | `"v0"` (transient) |
| After Step 0e (`v1_baseline` snapshot) | `"v1"` |
| After every accepted checkpoint (Phase 4 gate PASS) | the just-appended entry's `version` |
| After a `Gate_Rejected` revert | unchanged (gate restored the parent) |
| After a `User_Requested_Revert` | the entry's `revertTargetVersion` |

**`liveVersion` only advances on accepts; reverts point it back.**

### What does NOT create a versionMap entry

1. User declines the agent's suggested batch at end of Phase 3 — nothing applied, no checkpoint.
2. In-conversation undo (sub-skill detects apply-time problem, rolls back via inverse MATLAB op) — no `commitSHA` ever existed.

## Transition Execution Steps

Before every phase transition:

1. **Update the token usage report** — append to `<project_path>/.eco_diagnostics/eco_optimization_report.md`. Steps 2–6 MUST NOT proceed until this is written.
2. **Append the decision trace** — log all decisions and risk checks to `<project_path>/.eco_diagnostics/eco_decision_trace.md`. Steps 3–6 MUST NOT proceed until this is written.
3. **Write the updated `state.json`** with `NEXT_ACTION`, `CURRENT_STAGE`, `versionMap`, `LATEST_METRICS`. (Skip `commitSHA` for new version — not known yet.)
4. **If step 3 appended a new `versionMap` entry with `commitSHA` = null:** Take a snapshot via `eco_snapshot(workspacePath, tag, description, modelName)` with `tag` = the new entry's tag. Capture returned `commitSHA`. **Skip this step if all `versionMap` entries already have their `commitSHA` populated.**
5. **If step 4 was executed:** Re-write `state.json` so the just-appended versionMap entry has its `commitSHA` populated, AND update `state.liveVersion`.
6. **Proceed to the next phase** — read the phase file indicated by `NEXT_ACTION` and continue execution.

**Revert variant (Kind A or Kind B):** Perform steps 1, 2, and 6 only — no new checkpoint needed.

A phase boundary without its diagnostics appended is an incomplete transition (OR-05, OR-06).

### Phase Resume (from `state.json`)

When the skill is invoked and `<project_path>/.eco_diagnostics/state.json` already exists, the agent resumes from the persisted state:

1. Read `<project_path>/.eco_diagnostics/state.json` (full state).
2. Sanity-check live entry `commitSHA` matches workspace HEAD.
3. Read the phase file pointed to by `NEXT_ACTION` and resume.

## Token Usage Report

File: `<project_path>/.eco_diagnostics/eco_optimization_report.md`

Append before every phase transition. **This step is MANDATORY — refuse to proceed without it (OR-05).**

**How to estimate tokens:** Use 1 token ≈ 4 characters. For each category below, estimate the character count of all content in that category and divide by 4. Round to the nearest hundred.

### Token categories (mutually exclusive partition)

Every token entering the main conversation context belongs to exactly ONE category. No double-counting.

| # | Category | Source (what counts) |
|---|----------|---------------------|
| 1 | **File reads** | All content returned by the `Read` tool — skill files, protocol `.md`, generated `.c`/`.h`, `state.json`, reports, seed JSON, any file regardless of type |
| 2 | **MCP responses** | All output returned by MCP tool calls (`evaluate_matlab_code`, `run_matlab_file`, `run_matlab_test_file`, `check_matlab_code`, `detect_matlab_toolboxes`, evolutions MCP calls). This includes SIL/PIL simulation output, codegen build logs, and any other MCP-routed response |
| 3 | **Dialogue** | Agent-generated output text only — the reasoning, explanations, and questions the agent writes AFTER consuming file reads, MCP responses, and user input. Does NOT include tool I/O or user messages |
| 4 | **User input** | All user messages (prompts, confirmations, questions) |
| 5 | **Sub-task results** | Summary text returned to the parent context by the `Agent` tool. Internal reads/MCP calls inside sub-tasks consume sub-task context only and do NOT appear in the parent |

**Key rules:**
- The `Read` tool is the ONLY way files enter context → all file content is category 1.
- ALL MCP tools route through category 2 — there is no separate "tool results" category.
- Agent output (category 3) excludes everything the agent *receives* — it counts only what the agent *produces* as text.
- Sub-task internals (category 5) never spill into the parent context; only the returned summary counts.

### Report template

```markdown
## Phase: <N> — <phase_name>
- **Phase:** <phase_name>
- **Files read:** <list of files with line counts>
- **MCP calls made:** <count by tool name>
- **SIL/PIL runs:** <count, mode, report level>
- **Sub-tasks spawned:** <count, purpose>
- **Token estimate** (1 token ≈ 4 chars):
  - File reads (cat 1): ~<tokens>
  - MCP responses (cat 2): ~<tokens>
  - Dialogue — agent output (cat 3): ~<tokens>
  - User input (cat 4): ~<tokens>
  - Sub-task results (cat 5): ~<tokens>
  - **Estimated total: ~<sum of cats 1–5> tokens**
- **Outcome:** <brief summary>
- **Next phase:** <N+1> — <next phase>
```

**Validation check:** Before writing, verify that `sum(cats 1–5) ≈ estimated total`. If any category is 0, confirm it is genuinely unused (e.g., no MCP calls in this phase).

## Decision Trace Log

File: `<project_path>/.eco_diagnostics/eco_decision_trace.md`

Format: `OK <ID>` | `WARN <ID>` | `SKIP <ID>` with explanation.

Every risk in every sub-skill has a unique Diagnostic ID (GR-01, MM-03, SO-02, etc.). Missing entries = the agent never considered that risk = a diagnostic finding.

```markdown
## Phase: <N> — <phase_name>
### Skill: <skill_file_path>
### Decisions Made
- <parameter/setting>: <value chosen> — <why>

### Risk Checks
- OK GR-01: <what was checked>
- WARN GR-04: <what was found, corrective action>
- SKIP GR-03: <reason skipped>

### Suggestions Emitted (Phase 3 only)
- [S1] Stage C | "<description>" | Blocks: [...] | Risk checks: OK SO-05, OK SO-06

### Unexpected Events
- <errors, retries, fallbacks>
```

## Subskill Invocation Log

Appended at the start of every phase — one line per candidate child:

```markdown
### Subskill Invocation Log
- OK <name>: <reason>
- SKIP <name>: <reason>
```

Every candidate child gets a line, even if skipped. A missing entry = agent never considered that child.


----

Copyright 2026 The MathWorks, Inc.

----
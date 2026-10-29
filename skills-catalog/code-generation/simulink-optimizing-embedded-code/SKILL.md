---
name: simulink-optimizing-embedded-code
description: "Routes Embedded Coder workflows for Simulink models. Use when asked to optimize or improve generated code, reduce code metrics, author Code Replacement Libraries, or improve Embedded Coder output. Targets: execution time, memory (RAM, ROM, stack), code size, MISRA compliance. Works iteratively with measurement, gating, and rollback. Triggers: optimize generated code, reduce runtime, shrink code size, improve code efficiency, reduce memory, speed up generated code, MISRA compliance, author CRL. CAUTION: Do NOT optimize generated code without this skill — the gating and rollback workflow is essential."
license: https://www.mathworks.com/content/dam/mathworks/license/pmrl/license.md
metadata:
  author: MathWorks
  version: "3.0"
---

# Simulink Embedded Coder

> **Release compatibility:** MATLAB R2023a and later.

Entry point for Embedded Coder workflows on Simulink models. Detects the model, initializes the workspace, gathers requirements, routes to the matched procedure, and hands off execution.

## When to Use

- User asks to optimize generated code (speed, RAM, ROM, stack, MISRA, code size)
- User asks to author or modify a Code Replacement Library (CRL)
- User wants to improve Embedded Coder output for a specific hardware target
- Any request involving iterative improvement of Simulink-generated C/C++ code

## When NOT to Use

- Building or creating Simulink models from scratch (not optimization)
- MATLAB scripts unrelated to Simulink code generation
- Debugging a simulation error (not a code efficiency issue)
- Working with hand-written C/C++ code (not generated from Simulink)

---

## Communication — User-Facing Language

**This rule applies to every step below (Step 0 through completion) and to all procedure content — not just route matching.** The user should experience a seamless optimization assistant, never the machinery behind it. In everything you say to the user:

- **Never surface internal identifiers.** This includes node IDs (`wf_*`, `ref_*`, `param_*`, `sug_*`, `hw_*`) **and risk-check / gate / log codes** (`OR-NN`, `GR-NN`, `RT-NN`, `NC-NN`, and any `XX-NN` code). `OR-02`, `GR-03`, `RT-01` are internal bookkeeping — they mean nothing to the user. Never write things like *"Not a harness (OK OR-02)"* or *"matches the optimize route (OK RT-01)"*.
- **Never surface state field names or values-as-fields.** `WORKSPACE_HEAD`, `PROCEDURE_STACK`, `PROCEDURE_ID`, `NEXT_ACTION`, `GOAL`, `VERIFICATION_MODE`, `liveVersion`, `versionMap`, etc. Don't say *"WORKSPACE_HEAD is empty"* or *"GOAL is set to RAM (pre-extracted)"* — say *"this is a first run"* or *"I'll optimize for RAM."*
- **Never surface script/function names or step mechanics.** `eco_state_read`/`eco_state_write`, `ecokg_start_procedure`, `ecokg_detail`, `eco_complete`, and narration such as *"add the skill scripts to the path," "write state," "append the decision trace," "load the procedure," "load the measurement reference," "verify the token ledger."* These are agent-side actions — perform them silently.
- **`Log: OK/WARN XX-NN: ...` directives throughout this document and all procedures write to the decision-trace FILE (`.diagnostics/eco_decision_trace.md`). They are NEVER spoken or shown to the user.** Append them to the file; do not report them in chat.
- **Describe actions in task terms the user understands:** *"checking the model," "measuring the baseline," "applying optimizations," "verifying numerical correctness," "execution time improved 12%."* Not the steps, phases, scripts, or state writes that produce them.
- **If a step doesn't apply, silently skip it** — don't explain internal actions or why they were skipped.

Workflow names from the route `id` (e.g., "optimize," "author CRL") are fine to use with the user. Internal node/field/code identifiers are not.

## Step 0 — Detect Model & Determine Run Mode

1. Add skill scripts to the MATLAB path:
   ```matlab
   addpath(fullfile('<skill_root>', 'scripts'));
   ```

2. Find open models:
   ```matlab
   openModels = find_system('type','block_diagram','BlockDiagramType','model');
   ```

3. Branch on result:
   - **None open:** *"No Simulink models are currently open. Please open the model you want to work with and try again."* **Stop.**
   - **One model:** Use it. Derive `<project_path>` = the directory containing the model's `.slx` file (i.e., `fileparts(which('<model>'))`). This is the working directory for all skill operations — `.diagnostics/state.json` and all artifacts live here. Every `<project_path>` placeholder in this document and in procedure content must be substituted with this resolved path.
   - **Multiple models:** Present list, ask which to use. Wait for answer.

4. **Determine run mode.** `state.json` may or may not exist yet. `eco_state_read` returns empty when the file is absent.

   ```matlab
   wsHead = eco_state_read('<project_path>', 'WORKSPACE_HEAD');
   ```

   **a. Never run before** (`WORKSPACE_HEAD` is empty — including first-ever run where `state.json` does not yet exist):
   Continue to Step 1 (full setup: init workspace, harness check, model summary, gather, route). **If you mention run mode to the user at all, say *"this is a first run"* — never name the `WORKSPACE_HEAD` field or report its value (see Communication rule above).**

   **b. Previously run — check workspace and model:**

   ```matlab
   currentHead = strtrim(evalc('system(''git -C "<project_path>" rev-parse HEAD'')'));
   [~, gitStatus] = system(sprintf('git -C "%s" status --porcelain -- "%s.slx"', '<project_path>', '<model>'));
   modelDirty = ~isempty(strtrim(gitStatus));
   ```

   | Condition | Run Mode | Action |
   |-----------|----------|--------|
   | `currentHead ≠ wsHead` | **Stale workspace** | `eco_state_flush('<project_path>')` → Step 1 |
   | `currentHead = wsHead` and `modelDirty` | **Stale model** | `eco_state_flush('<project_path>')` → Step 1 |
   | `currentHead = wsHead` and `~modelDirty` and workflow active | **Resume** | Read `NEXT_ACTION` from workflow scope, load procedure via `ecokg_start_procedure('<project_path>', procId)`, resume from `NEXT_ACTION`. **Skip Steps 1–5.** |
   | `currentHead = wsHead` and `~modelDirty` and no active workflow | **Fresh run, same model** | Common fields valid. Skip to Step 3 (re-confirm model summary), then Steps 4–5. |

   To check whether a workflow is active:
   ```matlab
   procId = eco_state_read('<project_path>', 'PROCEDURE_ID');
   hasActiveWorkflow = ~isempty(procId);
   ```
   If active, read the workflow's `NEXT_ACTION`:
   ```matlab
   nextAction = eco_state_read('<project_path>', procId, 'NEXT_ACTION');
   ```

   **User manual reset:** To abandon a suspended workflow and start fresh:
   ```matlab
   eco_state_flush('<project_path>')
   ```

## Step 1 — Initialize Workspace

1. Initialize version control:
   ```matlab
   result = eco_init('<project_path>');
   ```
   Creates `.git` repo (if absent), `.gitignore` (excluding `.diagnostics/`, `bench_results/`, `slprj/`, `*.mexw64`), and commits + tags initial state as `v0_pristine`. Idempotent — returns `'already_initialized'` with current HEAD SHA on re-entry.

2. Bootstrap the runtime state file:
   ```matlab
   eco_state_init('<project_path>');
   ```
   Reads `assets/state_schema.json` and creates `.diagnostics/state.json` with all fields set to their schema defaults. Idempotent — skips if `state.json` already exists. This ensures a complete, schema-conformant state file exists before any `eco_state_read` or `eco_state_write` calls.

3. Save the model to capture unsaved edits:
   ```matlab
   save_system('<model>');
   ```

4. Record the `v0_pristine` commitSHA from `eco_init` result for the first versionMap entry.

## Step 2 — Harness Check

**Never optimize a test harness directly.** Before any analysis, check:

```matlab
try
    ownerModel = get_param('<model>', 'OwnerModelName');
    isHarness = ~isempty(ownerModel);
catch
    isHarness = false;
end
```

Fallback (requires Simulink Test):
```matlab
try
    isHarness = sltest.harness.isHarness('<model>');
catch
    isHarness = false;
end
```

**If harness detected:**
1. Extract owner:
   ```matlab
   ownerModel = get_param('<model>', 'OwnerModelName');
   ownerComponent = get_param('<model>', 'HarnessOwnerPath');
   ```
2. Close harness, open owner:
   ```matlab
   sltest.harness.close(ownerComponent, '<model>');
   open_system(ownerModel);
   ```
3. Inform user: *"The model `<model>` is a test harness. The model under test is `<ownerModel>`. I'll work with that instead."*
4. If the harness wraps a specific subsystem, note that path as a candidate for target functions.
5. Replace `<model>` and `<project_path>` with the owner's values. Continue.

Log: `OK OR-02: Not a harness` or `WARN OR-02: Harness detected — redirected to <ownerModel>`.

## Step 3 — Model Summary & Fingerprint

1. Query model properties using `evaluate_matlab_code` (use `get_param` calls — do NOT use `model_overview` or `model_query_params` MCP tools):
   - Hardware target (`get_param('<model>', 'ProdHWDeviceType')`, `get_param('<model>', 'TargetHWDeviceType')`)
   - System target file (`get_param('<model>', 'SystemTargetFile')`)
   - Solver type (`get_param('<model>', 'SolverType')`) and sample times (`get_param('<model>', 'FixedStep')`)
   - Top-level subsystems (`find_system('<model>', 'SearchDepth', 1, 'BlockType', 'SubSystem')`)

2. Present a **natural-prose** summary: model name, application domain (if recognizable), architecture, hardware target, solver, sample times.

3. Ask: *"Here's my understanding of the model. Does this look correct?"*

4. **Do NOT proceed until the user confirms.** If corrected, update and re-confirm.

5. Run model fingerprint and write to state immediately (same `evaluate_matlab_code` call):
   ```matlab
   fingerprint = model_fingerprint('<model>');
   eco_state_write('<project_path>', 'MODEL_FINGERPRINT', fingerprint);
   ```
   ```matlab
   eco_token_log('<project_path>', 'model_fingerprint', N)  % N from "eco_output_tokens: N"
   ```

Log: `OK GR-03: Model summary confirmed by user` or `WARN GR-03: Summary corrected — <what changed>`.

## Step 4 — Match Routes

Read `<skill_root>/router.json` (use the Read tool or equivalent — do NOT load it into MATLAB). Route matching is **entirely semantic** — read the JSON, then use each route's `description` (and the `match` object as additional context) to decide which route(s) best fit the user's prompt. Do NOT write code to iterate, parse, or print router fields. One route may match, or multiple routes may match if the user's request spans several workflows.

When presenting the matched workflow(s) to the user, use the route's `id` as the human-readable name (e.g., "optimize", "author_crl") — never expose internal node IDs like `wf_optimize` or `wf_author_crl` (see **Communication — User-Facing Language** above). Those are internal identifiers for state and KG lookups only.

**Stack population rules:**

`PROCEDURE_STACK` is an ordered list of all active (non-terminated, non-abandoned) workflows. The **top** of the stack is `stack{end}` — the currently executing workflow, which always matches `PROCEDURE_ID`. An entry stays in the stack until it completes or is abandoned.

- **Default (single workflow):** `PROCEDURE_STACK` contains one entry — the matched route's `procedure`. `PROCEDURE_ID` = that entry.
- **Multiple workflows:** Only when the user *explicitly* requests ordered execution of multiple workflows (e.g., *"author CRL tables first, then optimize for speed"*), match all relevant routes and populate `PROCEDURE_STACK` with the execution order — first-to-execute at the end (top), last-to-execute at position 1. Present the ordered plan to the user using the route `id` names, and confirm before proceeding.
- **No match:** Use `router.default`.

Log: `OK RT-01: Matched route <id>` or `OK RT-01: Matched routes [<id1>, <id2>] — user-confirmed order`.

## Step 5 — Gather Common Fields & Transition

### Step 5a — Gather Common Fields

Read `router.json`'s `common` section. Gather its `ask_user` fields and derive its `query_model` fields. These apply to **every** workflow, regardless of which route matched.

**Auto-populated** (already set from Steps 2–3 — do not re-ask):
- `PROJECT_PATH`, `MODEL`, `HARDWARE`, `MODEL_FINGERPRINT`

**Ask common fields** (apply the communication rule — only ask the user the question itself; do not narrate field names, derivation logic, or internal state values):

**1. BOARD_CONNECTED** — *"Is the target board currently connected?"*

Only ask when HARDWARE (from model query in Step 3) is a real MCU/board, not generic. When HARDWARE is generic, silently set `BOARD_CONNECTED` to `N/A` — do not tell the user "BOARD_CONNECTED is not applicable" or mention the field name at all. Log: `OK GR-02: HARDWARE=<target>, BOARD_CONNECTED=<value>` or `OK GR-02: HARDWARE=generic — BOARD_CONNECTED not applicable`.

**2. CONSTRAINTS** — *"Any constraints you'd like to mention before I start?"*

Free-form text. Checked at suggestion time and goal-axis gate by the procedure.

**Derive common `query_model` fields** (silently — never tell the user about derived field values):
- **ENABLE_CRL**: `true` when HARDWARE is a real MCU/board (not generic)

### Step 5b — Pre-populate Workflow Fields from Prompt

For **every** matched route (all routes on the `PROCEDURE_STACK`), read its `ask_user` fields from `router.json`. Check whether the user's original prompt already provides a value for any of these fields. If so, write it to state under the workflow scope immediately (e.g., `eco_state_write('<path>', 'wf_optimize.GOAL', 'speed')`).

This ensures workflow-specific values extracted from the prompt survive session interruptions — they are persisted before any workflow starts.

**Do NOT ask workflow-specific questions here.** Only extract values that are explicitly evident from the user's prompt. Remaining fields are gathered when the workflow starts (see Workflow Entry Protocol below).

### Write State

Use `eco_state_write` to persist all common fields plus any pre-populated workflow fields. `PROCEDURE_STACK` is populated from route matching (Step 4). `PROCEDURE_ID` is the top of the stack.

Common fields: MODEL, PROJECT_PATH, PROCEDURE_ID, HARDWARE, CONSTRAINTS, BOARD_CONNECTED, ENABLE_CRL, WORKSPACE_HEAD, PROCEDURE_STACK.

`MODEL_FINGERPRINT` was already written to state in Step 3 — do not re-write here.

### Transition

1. **Append decision trace** for the gathering phase to `.diagnostics/eco_decision_trace.md` (see Decision Trace below).
2. **Write state** via `eco_state_write` (see Write State above).
3. **Load the procedure:**
   ```matlab
   ecokg_start_procedure('<project_path>', '<matched_route.procedure>');
   ```
   ```matlab
   eco_token_log('<project_path>', 'ecokg_start_procedure', N)  % N from "eco_output_tokens: N" in console
   ```
4. **Begin execution.** The procedure content defines all subsequent phases, routing tables, transition protocol, and risk mitigations. Follow it from its Workflow Entry Protocol.

---

## Workflow Entry Protocol

Every procedure starts by gathering its own workflow-specific fields. This runs **before** the procedure's Phase 1.

1. **Read common fields** via `eco_state_read('<project_path>', {'MODEL', 'HARDWARE', ...})`.
2. **Read this route's `ask_user` fields** from `router.json`.
3. **Check which fields are already populated** — either pre-extracted from the user's prompt (Step 5b) or from a previous session. Read each via `eco_state_read('<project_path>', 'wf_<id>', '<field>')`.
4. **Ask remaining unpopulated fields.** Apply any guardrails specific to these fields (e.g., GR-05, GR-06 for `wf_optimize`).
5. **Derive `query_model` fields** from the route definition.
6. **Write all workflow-specific fields** via `eco_state_write('<project_path>', 'wf_<id>.<field>', ...)`.

Guardrails (GR-05, GR-06, etc.) are documented in each procedure's content, not here — they depend on workflow-specific fields that only that workflow knows about.

---

## Workflow Completion Protocol

Every procedure node's content ends with a call to `eco_complete`. The agent does not need to detect completion — it simply follows the procedure's instructions, and the last instruction is always:

```matlab
eco_complete('<project_path>');
```

`eco_complete` handles everything:

1. Flushes the completed workflow's state fields.
2. Pops the completed workflow from `PROCEDURE_STACK`.
3. **Stack non-empty:** Sets `PROCEDURE_ID` to the new top (`stack{end}`). If that workflow has a `NEXT_ACTION` (delegation return), prints resume instructions. If not (sequential), prints instructions to start the workflow fresh from its Workflow Entry Protocol.
4. **Stack empty (all done):** Updates `WORKSPACE_HEAD` to current HEAD, clears `PROCEDURE_ID`, and prints "all workflows complete." The next invocation starts fresh.

This is the **only** place workflow fields are cleared. Individual procedure nodes do not flush their own state.

### Abandoning a Workflow

When the user asks to abandon, skip, or stop the current workflow mid-execution (e.g., *"abandon this workflow"*, *"skip this and move on"*, *"I want to stop CRL authoring and continue with optimization"*), call:

```matlab
eco_complete('<project_path>', 'abandon');
```

This performs the **exact same state operations** as normal completion — flush, pop, transition — but prints "abandoned" instead of "complete." The model state is NOT reverted automatically; it stays as-is. If the user wants to revert model changes made by the abandoned workflow, use `eco_revert` explicitly before calling `eco_complete` with `'abandon'`.

**CRITICAL:** Never manually manipulate `PROCEDURE_STACK` or `PROCEDURE_ID` via `eco_state_write` to skip a workflow. Always use `eco_complete('<project_path>', 'abandon')` — it handles flush, pop, and transition correctly.

---

## Decision Trace — Gathering Phase

Append to `<project_path>/.diagnostics/eco_decision_trace.md` before transition:

```markdown
## Gathering Requirements
### Common Fields
- MODEL: <name> — <how detected>
- HARDWARE: <value> — <from model>
- BOARD_CONNECTED: <value> — <user said or N/A>
- CONSTRAINTS: <value> — <user's exclusions>
- PROCEDURE(S): <id(s)> — <matched route(s)>

### Pre-populated Workflow Fields
- <wf_id>.<field>: <value> — <extracted from user's prompt>
(List only fields that were pre-extracted; omit if none.)

### Risk Checks
- OK/WARN OR-02: <harness check>
- OK/WARN RT-01: <route matching>
- OK/WARN GR-02: <hardware context>
- OK/WARN GR-03: <model summary confirmed>
```

Every ID must have an entry before transition. Missing = never checked = diagnostic finding.

## Token Usage Tracking

Tracked via `eco_token_log('<project_path>', source, N)`. Ledger: `<project_path>/.diagnostics/token_ledger.json`. All three arguments are required.

All token-heavy content flows through KG scripts (`ecokg_start_procedure`, `ecokg_detail`, `ecokg_query`) and instrumented MATLAB scripts (`model_fingerprint`, etc.). Each prints `eco_output_tokens: <N>` to console. Extract N from the MCP response text and pass it to `eco_token_log`.

**CRITICAL:** `eco_output_tokens` is console output, NOT a struct field. Do NOT access as `result.eco_output_tokens`. Run the script in one `evaluate_matlab_code` call, then log in a **separate** call:

```matlab
% Call 1: run the script (console prints "eco_output_tokens: N")
ecokg_start_procedure('<project_path>', 'wf_optimize');
% Call 2 (separate): log the token count read from console
eco_token_log('<project_path>', 'ecokg_start_procedure', N)
```

----

Copyright 2026 The MathWorks, Inc.

----

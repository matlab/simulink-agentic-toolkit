---
name: simulink-check-rapid-accelerator-compatibility
description: >
  Statically analyze a Simulink model for Rapid Accelerator (raccel) mode
  incompatibilities. Identifies unsupported blocks (Interpreted MATLAB Function,
  Level-2 S-Functions without TLC), configuration issues, and data type
  restrictions that prevent code generation. Classifies each issue as BLOCKER
  (build error) or WARNING (build warning). Use BEFORE calling sim() in
  rapid-accelerator mode, when buildRapidAcceleratorTarget fails, or when the
  user asks "why won't my model run in raccel?" TRIGGER: any request
  explicitly involving rapid accelerator mode, raccel, raccel build errors,
  or buildRapidAcceleratorTarget failures.
license: https://www.mathworks.com/content/dam/mathworks/license/pmrl/license.md
metadata:
  author: MathWorks
  version: "1.0"
---

# Checking Rapid Accelerator Compatibility

Statically analyze a Simulink model for all raccel incompatibilities in one pass — without iterative build-fail-fix cycles.

## When to Use

- User wants to simulate a model in Rapid Accelerator mode
- `buildRapidAcceleratorTarget` fails with errors
- User asks "why won't my model run in raccel?"

## When NOT to Use

- Model is only intended for Normal or Accelerator mode — use `simulating-simulink-models` instead
- User is debugging a runtime error (model builds fine but crashes) — **exception**: if the model crashes in raccel, run this check anyway; the root cause may be a static incompatibility that manifests as a runtime crash
- Issue is purely a compiler/toolchain problem (not model content)
- General code generation for GRT/ERT targets (not raccel-specific)
- Model Advisor checks (separate workflow)
- SIL/PIL/HIL or Simulink Real-Time deployment

All script functions are in the skill's `scripts/` directory. Use `evaluate_matlab_code` with `project_path` set to the skill's `scripts/` folder so MATLAB can find them. Never use `addpath`.

## Diagnostic Workflow

Detect **all** incompatibilities statically — by parsing model structure, block parameters, data types, and configuration — **without calling `buildRapidAcceleratorTarget`**. This finds all issues in one pass.

> **Two-phase workflow:** Phase 1 (Steps 1–3a) produces the compatibility report — your response MUST END there. Phase 2 (Steps 3b–3c) applies fixes one at a time, each requiring a separate user confirmation. Never combine both phases in one response.

### Step 1: Static Inspection (primarily MCP tools)

Gather model information using MCP tools in parallel:

**1a. Read block topology** via `model_read`:

```
model_read(model: "ModelName", scope: "root", depth: "inf")
```

From the output, immediately flag blocks with these `BlockType` values:

| BlockType | Severity | Action |
|-----------|----------|--------|
| `MATLABFcn` | **BLOCKER** | Not supported by Simulink Coder |
| `M-S-Function` | Investigate | Query `FunctionName` → check TLC in Step 2 |
| `S-Function` | Investigate | Query `FunctionName` → check MEX/source/TLC in Step 2 |
| `FromWorkspace` | Investigate | Query `Interpolate` + `OutDataTypeStr` |
| `ToFile` | Investigate | Query `Filename` vs model name |
| `FromSpreadsheet` | Investigate | Check against `SaveOperatingPoint` |
| `DataStoreMemory` | Investigate | Check `OutDataTypeStr` for >64-bit fixed-point (Step 2) |
| `TransportDelay` | Investigate | Check if inside ForEach subsystem (Step 2) |
| `ModelReference` | Investigate | Check if inside ForEach with parallel execution |

**Do NOT flag these block types — they are raccel-compatible:**

| BlockType | Why it is compatible |
|-----------|---------------------|
| `MATLABFunction` | Stateflow-based, supports code generation (NOT the same as `MATLABFcn`) |
| `MATLABSystem` | System object with code generation support — fully raccel-compatible |
| `ModelReference` (standalone) | Compatible unless inside ForEach with parallel execution |
| `SubSystem` | Compatible (virtual or atomic) |
| `Scope`, `Display` | Viewer blocks — ignored during code generation |
| `RateTransition` | Compatible — handles rate changes in code generation |
| Dashboard blocks (`LampBlock`, `CircularGaugeBlock`, `LinearGaugeBlock`, etc.) | UI-only — ignored during code generation |

**1b. Query configuration parameters** via `model_query_params`:

```
model_query_params(
  model: "ModelName",
  targets: ["config:ModelName"],
  params: ["SaveFormat", "SaveState", "SaveOperatingPoint",
           "LoadExternalInput", "LoadInitialState", "ArrayLayout",
           "SignalLogging", "SaveFinalState"],
  compile: "false"
)
```

**1c. Query block-level parameters** via `model_query_params` (for flagged blocks):

```
model_query_params(
  model: "ModelName",
  targets: ["blk_X", "blk_Y"],
  params: ["FunctionName", "Interpolate", "OutDataTypeStr", "Filename"],
  compile: "false"
)
```

**Configuration rules (evaluate from 1b results):**

| Parameter Combination | Severity | Issue |
|-----------------------|----------|-------|
| `SaveFormat='Dataset'` AND `SaveState='on'` | **WARNING** | State logging to Dataset not supported — build continues but state logging silently produces no results |
| `SaveOperatingPoint='on'` + `DataStoreMemory`/`FromSpreadsheet` blocks | WARNING | Prevents OP save/restore |
| `LoadInitialState='on'` | WARNING | Must be structure format; variable must exist |
| `LoadExternalInput='on'` | Check | Validate input format (must be double arrays/structs) |
| `ArrayLayout='Row-major'` + S-Function blocks | WARNING | RTPs may not upload correctly |

> **IMPORTANT — SaveFormat+SaveState cross-check:** The `model_query_params` MCP tool can return stale values for `SaveState` because it reads cached configuration parameters rather than querying the model directly. This cross-check uses `evaluate_matlab_code` to call `get_param` which always reads the live model state. When `SaveFormat='Dataset'`, you MUST verify `SaveState` with a direct `evaluate_matlab_code` call:
> ```matlab
> get_param('ModelName', 'SaveState')
> ```
> If the result is `'on'`, flag it as a **WARNING** (`DatasetRapidAccelNoSupported`) — even if `model_query_params` reported `SaveState='off'`. This is the most commonly missed incompatibility.

**FromWorkspace rule:** Flag as BLOCKER if `Interpolate='on'` AND `OutDataTypeStr` contains `int64` or `uint64`.

**ToFile rule:** Flag as BLOCKER if filename (without extension) matches the model name — causes `rapidAccelBuildFailed`.

### Step 2: Deep Analysis (requires `evaluate_matlab_code`)

For checks that need MATLAB runtime APIs. Only run checks relevant to blocks found in Step 1.

Run the deep analysis script via `evaluate_matlab_code` with `project_path` set to the skill's `scripts/` folder:

```matlab
raccel_deep_analysis('ModelName')
```

It checks: TLC/source file existence for S-Functions, model compile for data type resolution (half-precision, variable-size, >64-bit fixed-point), Stateflow signal logging, ForEach structural patterns, and parameters not available via `model_query_params` (`Profile`, `RTWInlineParameters`).

Output is printed as `BLOCKER:` or `WARNING:` lines — parse these into your findings list.

**Additional configuration rules from Step 2:**

| Parameter | Severity | Issue |
|-----------|----------|-------|
| `Profile='on'` | WARNING | Profiling data not collected in raccel |
| `RTWInlineParameters='off'` + workspace variables | WARNING | Parameter tuning restrictions |

### Step 3: Report and Iterative Fix

**3a. Present the compatibility report** with ALL findings in priority order:

```
## Compatibility Report for <ModelName>

### Blockers (must fix before raccel simulation)
1. [Block Path] — Issue description
   - Why: Explanation
   - Fix: Recommended action

### Warnings (should fix for correct behavior)
1. [Config/Block] — Issue description
   - Why: Explanation
   - Fix: Recommended action
```

If **no blockers** are found, the model is raccel-compatible — skip to Step 4.

> **STOP HERE.** Your response MUST END after the compatibility report. Do not save a backup, do not propose fixes, do not call `model_edit` or `evaluate_matlab_code` to modify the model. End your response with: (1) a note that you will save a backup before making any changes, and (2) a question like: *"Would you like me to fix these issues one at a time? I'll save a backup first, then start with [first blocker]."* Then WAIT for the user to reply before continuing to Step 3b.

**3b. Back up the original model before any fixes** (only after user confirms)

Before applying the first fix, save a backup so the user can revert. Use `copyfile` — not `save_system` with a second argument, which renames the in-memory model:

```matlab
copyfile(get_param('ModelName','FileName'), 'ModelName_raccel_backup.slx');
```

Include the backup path in the report:

```
Backup saved to: ModelName_raccel_backup.slx
To revert all changes: open_system('ModelName_raccel_backup')
```

**3c. Fix issues iteratively (MANDATORY user confirmation for EACH fix)**

> **CRITICAL: Never auto-fix. This is a HARD CONSTRAINT — no exceptions.**
>
> The phrases "fix everything", "make it compatible", or "go ahead" are permission to *start* the process — NOT permission to apply all fixes. You MUST still present each fix individually and **end your response** to wait for explicit per-fix confirmation.
>
> **The rule:** Every `model_edit` or `evaluate_matlab_code` call that modifies the model requires a separate, preceding "yes" from the user. If you have not received a user message confirming a specific fix, you do not have permission to apply it.
>
> **Forbidden pattern — do NOT do this:**
> - Present report → "Now saving a backup and applying all fixes" → call model_edit
> - Present report → "I'll start with the first fix" → call model_edit
> - Present report → call save_system → call model_edit
>
> Any response that contains BOTH the compatibility report AND a `model_edit` call is WRONG.
>
> **Required pattern:**
> - Response 1: Present report → "Shall I fix these one at a time?" → **response ends, no tool calls after this point**
> - Response 2 (after user says yes): Save backup → apply first fix → verify → "Shall I proceed to the next fix?"

Fix issues **one at a time**, re-running static analysis after each fix:

1. For the first blocker (highest severity first):
   a. Explain what will change and why
   b. **STOP — your response MUST END here with a question like "Shall I apply this fix?"**
   c. Do NOT call `model_edit` or `evaluate_matlab_code` in the same response as step (b)
   d. Only after the user replies with confirmation, apply the fix
   e. Re-run `model_read` to verify the issue is resolved
   f. Report: issue fixed, remaining issues count
2. Repeat for next blocker until all resolved
3. Then address warnings (same confirm-fix-verify cycle)

See `references/fix-recipes.md` for fix procedures and validated alternative blocks — consult when applying fixes in Step 3c.

### Step 4: Verification Build (REQUIRES user permission)

After all static issues are resolved, ask permission to build:

```
All static incompatibilities have been resolved.
Would you like me to run buildRapidAcceleratorTarget to confirm
the model builds successfully for Rapid Accelerator mode?
```

**Only proceed after explicit confirmation.** Then run via `evaluate_matlab_code` with `project_path` set to the skill's `scripts/` folder:

```matlab
raccel_verify_build('ModelName')
```

It handles working directory checks, builds the target, and reports success or detailed failure information.

If the build fails despite static analysis passing, analyze the error and loop back to Step 3.

After a successful build, offer to clean up the backup:

```
Build succeeded. A backup of the original model is at ModelName_raccel_backup.slx.
Would you like to keep it or delete it?
```

If the user wants it deleted, run:

```matlab
delete('ModelName_raccel_backup.slx');
```

## Script Interface

Both scripts are in the skill's `scripts/` directory. Call via `evaluate_matlab_code` with `project_path` set to the skill's `scripts/` folder. Never use `addpath`.

### `raccel_deep_analysis(mdl)`

Runs runtime checks that require MATLAB APIs: filesystem lookups, model compile, Stateflow introspection, and ForEach detection. Only run after Step 1 static inspection flags relevant blocks.

**Input:**

| Parameter | Description |
|-----------|-------------|
| `mdl` | Name of a loaded Simulink model (string) |

**Output:** Printed lines to stdout. Each finding is prefixed with severity:

| Prefix | Meaning |
|--------|---------|
| `BLOCKER:` | Build-blocking incompatibility — prevents raccel code generation |
| `WARNING:` | Non-blocking issue — build succeeds but runtime behavior is degraded |

Line format: `BLOCKER: <block_path> — <description>` or `WARNING: <block_path> — <description>`. The final line is `--- Deep analysis complete for <mdl> ---` (with skipped check count if any checks failed).

**What it checks:**
- `Profile` and `RTWInlineParameters` parameter values
- `SaveFormat=Dataset` with `SaveState=on` cross-check
- TLC/source file existence for S-Functions (M-S-Function and S-Function blocks)
- Half-precision, variable-size, and >64-bit fixed-point data types (via model compile)
- Bus elements with unbounded dynamic arrays
- S-Function bus I/O struct padding (no TLC + bus-typed ports)
- Stateflow signal logging
- TransportDelay inside ForEach subsystems
- ToFile blocks with SaveOperatingPoint enabled
- ModelReference inside ForEach subsystems

**Example:**
```matlab
raccel_deep_analysis('MyModel')
```

### `raccel_verify_build(mdl)`

Builds the rapid accelerator target and reports success or detailed failure. Requires Simulink Coder.

**Input:**

| Parameter | Description |
|-----------|-------------|
| `mdl` | Name of a loaded Simulink model (string) |

**Output:** Returns a struct and prints a summary to stdout.

| Field | Type | Description |
|-------|------|-------------|
| `status` | string | `'success'` or `'failed'` |
| `identifier` | string | `''` on success, MException identifier on failure |
| `message` | string | `''` on success, error message on failure |
| `causes` | cell array | `{}` on success, cell array of structs with `identifier` and `message` fields on failure |

On success, prints: `Build SUCCEEDED — <mdl> is confirmed raccel-compatible.`
On failure, prints: `Build failed: <identifier>` followed by the message and each cause.

**Example:**
```matlab
result = raccel_verify_build('MyModel')
```

## Static Analysis vs. Build-Based Detection

Static analysis finds **all** issues in one pass. This is superior to build-based detection because:

1. **All issues reported at once** — `buildRapidAcceleratorTarget` only reports the first fatal error then stops
2. **Faster** — static analysis takes seconds; each build takes 10-60+ seconds
3. **No code generation artifacts** — no `slprj` folders
4. **Simulink Coder required only for verify-build** — static analysis (Steps 1-3) uses model compile which needs only Simulink. The verify-build step (Step 4) calls `buildRapidAcceleratorTarget` which requires Simulink Coder. Users checking raccel compatibility will have Coder since running in rapid accelerator mode requires it.

**Fall back to build** when static analysis reports no issues but the build still fails, or for complex S-Function interactions not covered by the catalog.

## Incompatibility Reference

See `references/incompatibility-catalog.md` for all 13 categories with diagnostic error IDs, severity classifications, and fix pointers — consult when classifying issues found in Steps 1-2.

## Guardrails

- **NEVER AUTO-FIX.** The compatibility report and the first `model_edit` call must NEVER appear in the same response. Present the report, end your response, wait for user confirmation. This applies even when the user says "fix everything" — see Step 3c.
- **Always save a backup** before applying the first fix: `copyfile(get_param('ModelName','FileName'), 'ModelName_raccel_backup.slx')`. Include the backup path and revert instructions in the report — see Step 3b.
- **Never delete user logic** — only change configurations or replace incompatible blocks with functional equivalents
- **Always explain WHY** a change is needed before applying it
- **Preserve signal names and logging** when restructuring
- **One fix at a time** — apply, verify, then proceed to next issue
- **Use `replace_block`** instead of delete+add when swapping block types — it preserves connections
- **Check working directory** before build — must not be inside `matlabroot`

----

Copyright 2026 The MathWorks, Inc.

----

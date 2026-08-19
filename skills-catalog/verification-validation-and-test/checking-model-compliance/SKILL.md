---
name: checking-model-compliance
description: "Use this skill when the user asks to check Simulink model compliance against a standard (MISRA, MAB, JMAAB, ISO, DO, IEC, EN, CERT C/CWE, AUTOSAR, Simulink Code Inspector (SLCI)), wants to run Model Advisor checks, or needs a compliance report with fix suggestions. For JMAAB/MAB, supplement deterministic checks with agentic review of uncheckable guidelines."
license: https://www.mathworks.com/content/dam/mathworks/license/pmrl/license.md
metadata:
  author: MathWorks
  version: "0.6"
---

# Checking Model Compliance

Runs Model Advisor checks for a named standard (or default configuration) and delivers a prioritized summary with fix suggestions.

## When to Use

- Checking whether a Simulink model complies with a standard (MISRA, MAB, JMAAB, ISO 26262, DO-178C, etc.)
- Running Model Advisor checks against a named compliance standard
- Generating a compliance report with prioritized findings and fix suggestions
- Running a custom Model Advisor configuration file against a model
- Justifying or waiving specific compliance violations

## When NOT to Use

- **Building or editing model structure** → `building-simulink-models`
- **Writing behavioral tests** → `testing-simulink-models`
- **Structural validation only (unconnected ports)** → `model_check` tool directly
- **General model quality questions** without a named standard (e.g., "is my model well decomposed?") — this requires a different workflow

## Supported Standards

| Standard | Accepted Inputs |
|----------|----------------|
| MISRA C:2023 | `MISRA_C`, `MISRA C`, `MISRA` |
| MISRA Simulink/Stateflow | `MISRA_SLSF`, `MISRA Simulink` |
| MAB | `MAB`, `MAAB` |
| JMAAB v5.1 | `JMAAB` |
| JMAAB v6 | `JMAAB_V6`, `JMAAB06` |
| ISO 26262 | `ISO_26262`, `ISO 26262` |
| ISO 25119 | `ISO_25119`, `ISO 25119` |
| DO-178C/DO-331 | `DO_178C`, `DO-178C`, `DO-178B`, `DO-331` |
| DO-254 | `DO_254`, `DO-254` |
| IEC 61508 | `IEC_61508`, `IEC 61508` |
| IEC 62304 | `IEC_62304`, `IEC 62304` |
| EN 50128/EN 50657 | `EN_50128`, `EN 50128`, `EN_50657` |
| Secure Coding (CERT C, CWE) | `SECURITY`, `CERT_C`, `CWE`, `secure coding` |
| AUTOSAR | `AUTOSAR` |
| Simulink Code Inspector (SLCI) | `SLCI`, `Simulink Code Inspector` |

**Equivalent check sets (run once, report for both):**
- ISO 26262, IEC 61508, IEC 62304, EN 50128/EN 50657, ISO 25119
- DO-178B, DO-178C, DO-331

### Custom Checks and Configurations

Users may have custom Model Advisor checks or custom configuration files (`.json` exported from Model Advisor Configuration Editor). These are not standards — they are handled via:
- **Custom configuration file:** User provides a path → use `model_advisor_run` with `'configuration'` parameter directly (Path B)
- **Custom check IDs:** User provides specific check IDs → use `model_advisor_run` with `'checks'` parameter directly (skip resolution)

## Prerequisites

All script functions are in the skill's `scripts/` directory. Use `evaluate_matlab_code` with `project_path` set to the skill's `scripts/` folder so MATLAB can find them. Never use `addpath`.

**Tools provided** (always use these — never improvise with raw Model Advisor API):

| Function | Inputs | Output | Example |
|----------|--------|--------|---------|
| `model_advisor_resolve_checks` | `'standard', '<NAME>'` | struct with `checks`, `checks_count`, `status` | `model_advisor_resolve_checks('standard', 'JMAAB')` |
| `model_advisor_run` | `system, 'checks', {ids}` or `system, 'configuration', path` | YAML with `findings`, `status`, `check_summary` | `model_advisor_run('MyModel', 'checks', checkIds, 'token_budget', 8000)` |
| `model_advisor_justify` | `model, checkId, blockPath, text` | struct with status | `model_advisor_justify('MyModel', 'mathworks.jmaab.db_0032', 'MyModel/Sub', 'Waived per review')` |
| `detect_default_config` | `modelName` | struct with `config_path` or empty | `detect_default_config('MyModel')` |

## Workflow

### 1. Identify Standard, Model, and Scope

Determine from user request:
- **Standard** — map to supported name (see table). Defaults: "MISRA" → `MISRA_C`. For "JMAAB" without version → ask user (v5.1 or v6)
- **Model** — `.slx` file (ask if ambiguous)
- **Scope** — full model (default) or subsystem path (e.g., `Model/Controller`)

Disambiguation rules:
- "JMAAB" without version specifier → ask (v5.1 or v6 — two distinct check sets)
- "ISO" without specifier → ask (multiple supported)
- "DO" without specifier → ask (178C vs 254)
- Multiple standards requested → resolve each, compare sets, run once if identical

### 2. Choose Path

**Path A — Standard named:** Proceed to step 3.

**Path B — No standard, user says "run Model Advisor" / "check my model":**
Run `detect_default_config(modelName)`. If config found → skip to step 4. If empty → ask which standard (show supported list).

### 3. Resolve Checks (Path A only)

```matlab
model_advisor_resolve_checks('standard', '<STANDARD_NAME>')
```

- `status: success` → note `checks_count`, inform user
- `status: truncated` → use returned config file path in step 4
- `status: error` → report and stop

**Gate:** If `checks_count` > 100, confirm with user before proceeding.

**Shortcut:** If the user already has specific check IDs, call `model_advisor_run` directly with those IDs and skip to step 5.

### 4. Run Checks

```matlab
model_advisor_run('<system>', 'checks', {<check_ids>})          % inline checks
model_advisor_run('<system>', 'configuration', '<config_path>') % config file
```

Use `'token_budget', 8000`. If truncated, read full results from `full_results` path.

### 5. Analyze Findings

Classify from YAML response:
1. **Critical** (Failed) — must fix for compliance
2. **Warnings** (Warning) — should fix, may be justifiable
3. **Informational** — low priority

### 6. Present Compliance Report

For **non-MAB/JMAAB standards**, use this template:

```
## Compliance Summary: <Standard>
Model: <model> [Scope: <subsystem> if scoped]
Result: X passed, Y warnings, Z failures

### Critical Findings (must fix)
| Check | Blocks | Fix Type | Action |
|-------|--------|----------|--------|
| name  | N      | param/insert/config/routing/arch | what to change |

### Warnings (should fix)
| Check | Blocks | Fix Type | Action |
|-------|--------|----------|--------|

### Passed
N checks passed.

### Suggested Next Steps
[5-7 prioritized actions max]
```

For **MAB, JMAAB, or JMAAB_V6 standards**, use this template instead (includes the uncheckable guidelines review as an integral part of the report):

```
## Compliance Summary: <Standard>
Model: <model> [Scope: <subsystem> if scoped]
Result: X passed, Y warnings, Z failures

### Critical Findings (must fix)
| Check | Blocks | Fix Type | Action |
|-------|--------|----------|--------|
| name  | N      | param/insert/config/routing/arch | what to change |

### Warnings (should fix)
| Check | Blocks | Fix Type | Action |
|-------|--------|----------|--------|

### Passed
N checks passed.

---

### Agentic Review of Uncheckable Guidelines (LLM-based — not deterministic)

> **Note:** This is a semantic evaluation performed by an AI agent, not a deterministic Model Advisor check.

**Model:** <model_name>
**Judgment:** PASS | WARNING | FAIL
**Confidence:** 0.XX

#### Critical (must fix)
| Guideline | Blocks | Fix Type | Action | Confidence |
|-----------|--------|----------|--------|------------|

#### Warnings (should fix)
| Guideline | Blocks | Fix Type | Action | Confidence |
|-----------|--------|----------|--------|------------|

### Evidence
[2-3 sentences citing specific model data]

### Recommendation
[Top 3-5 prioritized actions, or "No action required."]

---

### Suggested Next Steps
[5-7 prioritized actions max, combining both deterministic and uncheckable findings]
```

**Fix Type values:** `param` (block parameter), `insert` (add block), `config` (model config), `routing` (reconnect signals), `arch` (restructure — recommend only)

**Conciseness rules:**
- One line per check; max 3-5 block paths shown per check (state total)
- Target 40-60 lines; max ~80
- Offer "I can list all affected blocks for check X" for detail

### 7. Performing the Uncheckable Guidelines Review (JMAAB/MAB only)

This section explains HOW to fill in the "Agentic Review of Uncheckable Guidelines" section that is part of the MAB/JMAAB report template above. **You MUST complete this before presenting the report to the user.**

Skip this step ONLY for other standards (MISRA, ISO 26262, DO-178C, etc.).
For JMAAB, JMAAB_V6, or MAB standards → load and follow `references/uncheckable-guidelines-review.md`.

**What to do:** Evaluate guidelines that Model Advisor cannot fully verify — guidelines where semantic judgment is required or no check exists at all. Load `references/semantic-evaluation-index.md` to get the list of uncheckable guidelines, then:

1. From the Model Advisor results, identify which checked guidelines appear in the semantic evaluation index
2. For those guidelines, extract model data using MCP tools (`model_overview`, `model_read`, `model_query_params`)
3. Apply the Quick Rules from the index for each applicable guideline
4. For borderline cases, use the Semantic Gap column to calibrate judgment

**Judgment:** worst verdict across findings (FAIL > WARNING > PASS). Confidence 0.0-1.0. Do NOT issue FAIL if confidence < 0.5.

### 8. Fix Mode

Ask: "Would you like me to fix these issues?"
- No → stop (report only)
- Yes → load and follow `references/fix-mode.md` workflow

### 9. Justification Mode

If user wants to justify/waive/suppress violations → load and follow the Justification section in `references/fix-mode.md`.

## Guardrails

### Always
- For JMAAB/JMAAB_V6/MAB: ALWAYS perform Step 7 (Uncheckable Guidelines Review) — the report is incomplete without it
- Show standard name + check count before running
- Include block paths in findings
- Follow Fix Order strictly (structural → diagnostic) to prevent cascading false failures
- Summarize, do not echo raw output
- Confirm with user before executing >=100 checks
- Ask the user for justification text before adding any justification — never fabricate rationale
- If a reference tool returns an error, report it verbatim — do not retry with alternative approaches
- Confirm which model to check if multiple `.slx` files are present or the name is ambiguous
- State the resolved standard name and version in the report header
- Report the exact check count from tool output
- When explaining failures, list all distinct root causes

### Ask First
- Fix mode modifications — never modify model without per-batch confirmation
- Justification — always a human decision
- Running >100 checks — confirm scope is intentional

### Never
- Claim "model IS compliant" — only report pass/fail; compliance determination is user's responsibility
- Escalate diagnostics before structural fixes
- Suppress findings without explicit request
- Guess parameter names — use exact `parameter` field from check output
- Modify the MATLAB path permanently (no `savepath`)
- Run `slbuild` or code generation without explicit user permission
- Re-run checks unnecessarily — reuse violation IDs from the most recent run if the model has not been modified since; only re-run to get fresh hashes if the model changed

## Error Recovery

| Error | Action |
|-------|--------|
| `UNKNOWN_STANDARD` | Check for typo/alias (e.g., "MAAB" → MAB). If valid but unsupported standard, acknowledge and show supported list. |
| `LICENSE_FAILED` | Simulink Check license required |
| `MODEL_NOT_FOUND` | Ask for correct model path |
| `CHECK_NOT_FOUND` | Release mismatch — tell user which MATLAB release needed |
| `CONFIG_NOT_FOUND` | Stale path — ask for update or fall back to named standard |
| `EXECUTION_FAILED` | Model may have compilation errors — suggest fixing first |
| Token budget exceeded | Read full results from `full_results` field |
| `HASH_NOT_FOUND` (justify) | Model modified since last run — re-run checks for fresh ids |
| `JUSTIFICATION_FILE_ERROR` | Check file permissions and license |

----

Copyright 2026 The MathWorks, Inc.

----

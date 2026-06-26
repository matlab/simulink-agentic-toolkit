---
name: checking-model-compliance
description: "Checks a Simulink model against a compliance standard (MISRA, MAB, JMAAB, ISO 26262, ISO 25119, DO-178C, DO-254, IEC 61508, IEC 62304, EN 50128, CERT C/CWE, AUTOSAR) using Model Advisor, then summarizes findings and suggests fixes. Use when the user asks whether their model is compliant, wants to run standard checks, or needs a compliance report."
license: MathWorks BSD-3-Clause
metadata:
  author: MathWorks
  version: "0.4"
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

**Equivalent check sets (run once, report for both):**
- ISO 26262, IEC 61508, IEC 62304, EN 50128/EN 50657, ISO 25119
- DO-178B, DO-178C, DO-331

### Custom Checks and Configurations

Users may have custom Model Advisor checks or custom configuration files (`.json` exported from Model Advisor Configuration Editor). These are not standards — they are handled via:
- **Custom configuration file:** User provides a path → use `model_advisor_run` with `'configuration'` parameter directly (Path B)
- **Custom check IDs:** User provides specific check IDs → use `model_advisor_run` with `'checks'` parameter directly (skip resolution)


## Prerequisites


Tools provided (always use these — never improvise with raw Model Advisor API):
- `model_advisor_resolve_checks()` — resolves standard → check IDs
- `model_advisor_run()` — executes checks
- `model_advisor_justify()` — records justifications
- `detect_default_config()` — finds active Model Advisor config

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

Pass `'token_budget', 8000` as a name-value argument to `model_advisor_run` to limit output size. If the response indicates truncation, read the full results from the `full_results` path in the response.

### 5. Analyze Findings

Classify from YAML response:
1. **Critical** (Failed) — must fix for compliance
2. **Warnings** (Warning) — should fix, may be justifiable
3. **Informational** — low priority

### 6. Present Compliance Report

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

**Fix Type values:** `param` (block parameter), `insert` (add block), `config` (model config), `routing` (reconnect signals), `arch` (restructure — recommend only)

**Conciseness rules:**
- One line per check; max 3-5 block paths shown per check (state total)
- Target 40-60 lines; max ~80
- Offer "I can list all affected blocks for check X" for detail

After presenting the report, ask: "Would you like me to fix these issues?"
- No → stop (report only)
- Yes → load and follow `references/fix-mode.md` workflow

### 7. Justification Mode

If user wants to justify/waive/suppress violations → load and follow the Justification section in `references/fix-mode.md`.

## Guardrails

### Always
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

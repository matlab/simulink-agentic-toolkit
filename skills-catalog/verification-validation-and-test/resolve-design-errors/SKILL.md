---
name: resolve-design-errors
description: Use when asked to run Design Error Detection (quick defect scan), find design errors in a Simulink model, perform root cause analysis on DED findings, fix division-by-zero, overflow, dead logic or out-of-bounds defects detected by SLDV, or diagnose why missing coverage cannot be achieved (dead logic blocking coverage objectives). Do NOT use for requirement verification, test generation, Inf/NaN detection, active logic analysis, or coverage measurement.
license: MathWorks BSD-3-Clause
metadata:
  author: MathWorks
  version: "1.3"
  toolbox_dependencies:
    - Simulink Design Verifier
    - Simulink Check
---

# Detecting Design Errors (SLDV DED + Root Cause Analysis)

## When to Use

- User asks to **check a Simulink model for design errors** (division-by-zero, overflow, dead logic, out-of-bounds)
- User asks to **find root causes** of DED findings
- User asks to **fix** or **understand** an analysis finding
- User asks **why there is missing coverage** due to dead logic (dead logic gates prevent coverage objectives from being satisfied)
- User has SLDV artifacts (`.mat` file) and wants analysis without re-running DED

## When NOT to Use

- **Requirement verification** — checking if a model satisfies a requirement
- **Test generation or test authoring** — creating test cases from requirements or for coverage
- **Comprehensive verification** — this skill is a quick defect scan, not an exhaustive proof; a clean result does not guarantee the model is free of all errors
- **Coverage measurement** — this skill does not measure or report model coverage; use Simulink Coverage tools

## Safety Rules

1. **Never patch the original model directly.** Always clone first before applying any fix.
2. **NEVER apply fixes without explicit user approval.** After root cause analysis, present findings and *suggest* a fix strategy — then STOP and wait for the user to say "yes, apply it" or "go ahead." Even if the user's prompt says "suggest a fix" or "fix it," you must present the plan first and wait for confirmation. Do NOT create clone models, set parameters, or run verification until the user explicitly approves.
3. **SLDV results are always sound.** Never assume SLDV returns false positives. If SLDV reports a defect, it is a real defect — treat every finding as a true positive and investigate accordingly.

**Requires:** MATLAB R2023b+, Simulink Design Verifier, Simulink Check / Model Slicer.

## Prerequisites

All script functions live in the skill's `scripts/` directory. Use `evaluate_matlab_code` with `project_path` set to that folder so MATLAB can find them.

---

## Workflow

This skill provides two functions that automate SLDV-driven analysis the agent otherwise gets
wrong when hand-rolling it, then hands you the facts to classify and fix findings. The workflow
is four steps:

```
1. Detect errors      → sldv_run_defect_checker   (use the function; don't hand-roll DED)
2. Root cause errors  → sldv_find_de_root_cause    (use the function; don't hand-roll slicing)
3. Classify errors    → agent step (dead logic: intentional vs. design_error)
4. Fix errors         → agent step (propose, get approval, clone-fix-verify)
```

Steps 1–2 are the two functions. Steps 3–4 are agent judgment based on their output. Full API
detail (return fields, options, caching, sub-functions) is in **`references/api-reference.md`** —
load it when you need exact fields or options.

### Step 1 — Detect errors

Call `sldv_run_defect_checker(model)` instead of writing your own SLDV DED invocation or
parsing objectives by hand — it configures the analysis, runs DED, and auto-loads cached
`*_sldvdata.mat` results when available.

```matlab
result = sldv_run_defect_checker("my_model", OutputDir="artifacts/ded")
```

**If `result.Status == "pass"`: STOP.** Report "No design errors of the checked types were
detected" and end the workflow. Do NOT call `sldv_find_de_root_cause` or investigate further.
DED is a quick scan, not an exhaustive proof — tell the user no defects of the checked types
were found, not that the model is error-free.

Proceed to Step 2 only when `result.Status == "fail"`.

### Step 2 — Root cause errors

Call `sldv_find_de_root_cause(model, DedResult=result.DedResult)` instead of hand-building
slices — it returns backward slices, counterexamples, locality (blast-radius) measures, and
shared-root cascade annotations for every finding.

```matlab
rca = sldv_find_de_root_cause("my_model", DedResult=result.DedResult, OutputDir="artifacts/ded")
```

Then trace each finding to its root cause:
1. Follow the counterexample through `rca.SliceBlocks` to find which block produces the
   defect-triggering value
2. Use `model_overview` / `model_read` to understand each block's role
3. Prefer high-`Locality` blocks (narrow blast radius, safer) and high-`FindingCount` blocks
   (fix resolves more defects); check `rca.Cascades` — a shared-root fix resolves multiple
   findings at once

**When the slice is shallow (< 3 blocks) or stops at a Stateflow / MATLAB Function block:**
the Model Slicer cannot trace through those constructs. Do NOT stop and report only what the
tool returned — fall back to `model_read` / `model_overview` to interpret the finding: read
the defect block and its upstream connections, read the Stateflow chart or MATLAB Function
logic the slice stopped at, and cross-reference counterexample values to see which branch is
active.

---

## Step 3 — Classify errors (dead logic)

Classification happens **after** root cause analysis — you need to see the root cause (which
block, what value) before deciding whether dead logic is intentional.

**Findings arrive pre-enriched.** For every dead logic finding, `sldv_find_de_root_cause`
attaches on the finding struct:

- `finding.ModelContext` — a `model_read` dump of the block's surrounding scope. You do **not**
  need to call `model_read` again for this. (If empty — model_read was unavailable — fall back
  to `model_overview` / `model_read` yourself for that block.)
- `finding.PatternCatalog` — the entire dead-logic pattern library (catalog index + every
  pattern), concatenated. You do **not** need to open the YAML files yourself.
- `finding.Classification` — `"pending"`, awaiting your decision.

**How to classify.** For each dead logic finding, using `ModelContext` and `PatternCatalog`:
1. Look at the root cause block — what value does it produce that makes the branch dead?
2. Compare the model context against the patterns in `PatternCatalog`.
3. Decide: is the block INTENTIONALLY producing this value (safety guard, disabled feature,
   complementary Stateflow guards) or is it a BUG (wrong parameter, cascading error)?

Set the classification:
- `"intentional"` — defensive logic, enable-as-input, negation guard pairs → no fix needed;
  report to the user as expected behavior
- `"design_error"` — wrong parameter, cascading dead logic, short-circuit → fix the root cause
- `"unclassified"` — unclear → ask the user

Only apply fixes for `"design_error"` findings.

---

## Step 4 — Fix errors

The functions provide facts; you identify root causes and decide fixes — there is no hardcoded
defect-to-fix mapping.

When you are ready to propose or apply a fix, **load and follow `references/fix-strategy.md`**.
It covers root-cause identification, the clone-fix-verify procedure, fix principles, and the
blast-radius discussion required for every proposal.

Two rules that always apply (see Safety Rules): present findings and wait for explicit approval
before applying anything, and propose a fix for **every** `design_error` finding — 2–3 ranked
options each when possible — rather than stopping after only some.

---

## Common Mistakes

| Mistake | Fix |
|---------|-----|
| Continuing after `Status == "pass"` | **STOP.** Zero falsified objectives = no defects. Do not call `sldv_find_de_root_cause` or investigate further. Report "no defects found" and end. |
| Calling `sldv_find_de_root_cause` without DedResult or DataFile | Pass one of the two — check `result.DedResult` from the checker |
| Running on an unsaved model | Save first; DED needs a file on disk |
| Applying fixes without presenting findings to user | Always show root cause analysis results first, get approval before fixing |
| Stopping at a shallow slice | Fall back to `model_read` / `model_overview` (Step 2) |
| Running on large models without `OutputDir` | Set `OutputDir` to avoid temp-dir clutter |

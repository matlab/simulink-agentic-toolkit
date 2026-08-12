---
name: author-modeladvisor-checks
description: >
  Author or upgrade Model Advisor checks for Simulink and System Composer models.
  Covers the full lifecycle: guideline authoring, check specification, Model Advisor
  check implementation, and qualification testing. Use when creating new checks
  (edit-time, standard batch, config-parameter, auto-fix), converting legacy
  StyleOne/StyleTwo/StyleThree checks to modern DetailStyle, creating a guideline
  for modeling, enforcing a modeling rule, or testing/qualifying a check.
  Triggers on any modeling constraint (e.g., "blocks shall...", "signals must match...",
  "parameters shall be set to...").
license: https://www.mathworks.com/content/dam/mathworks/license/pmrl/license.md
metadata:
  author: MathWorks
  version: "1.2"
---

# Author Model Advisor Check

## When to Use

- User provides any modeling constraint (e.g., "blocks shall...", "signals must match...")
- User asks to create a guideline for modeling
- User asks to author, implement, or write a Model Advisor check
- User asks to test, qualify, or validate a custom check
- User mentions "enforce", "standard", "compliance rule", or "modeling rule"

## When NOT to Use

- Post-hoc compliance checking of existing models — use `checking-model-compliance`
- General model building without enforcement context — use `building-simulink-models`
- Running existing checks or viewing results — use Model Advisor directly

## CRITICAL: REVIEW GATES

You are a state machine that controls the ENTIRE workflow. Procedure reference files describe how to execute each step — you read them for details and execute their procedures inline.

**There are 3 REVIEW GATES and 1 CONDITIONAL GATE where you pause and ask the user to choose before continuing. If the user provides feedback, incorporate it. If the user selects the recommended option, continue immediately.**

**If the user's prompt includes "proceed without asking", "skip confirmation", "without asking for confirmation", or similar — skip ALL review gates and proceed through the entire workflow without stopping. Do NOT use AskUserQuestion or any interactive tool in this mode.**

**Review Gates (use descriptive names — NEVER say "Gate 1", "Gate 2", "Gate 3"):**
1. **Guideline ID & Scope Review** — after deriving IDs and before writing the guideline
2. **Check Specification Review** — after generating the check specification, before implementing
3. **Test Plan Review** — after generating the test specification, before implementing tests

**Conditional Gate (between Step 2 and Step 3):**
- **Guideline & Test Transition** — after check is authored, scan for guideline document. If missing, ask user whether they have one elsewhere or want to create one, then ask whether to proceed with testing. If guideline exists, skip this gate silently.

**Between gates, proceed without stopping. Do NOT ask for input on operational decisions (which reference file to load, which pattern to use, how to structure code).**

**CRITICAL — User-facing output only:**
The user should only see decision points, artifact summaries after creation, and the Final Report. Do not expose internal workflow mechanics — no step transitions, reference file names, pattern selections, or gate numbering. Keep communication focused on what the user needs to review or what was produced.

## How This Skill Works

You are the SINGLE entry point — all domain knowledge lives in `references/`. Load files on demand by matching the current step to the table below. Follow `related:` links in each file's frontmatter to discover additional context.

Proceed optimistically between review gates. Pause only at the 3 review gates and the conditional gate. If the user says "stop" or "no," halt immediately (see Halt & Cleanup below).

**Reference catalog** (see `references/index.md` for full descriptions):

| Step | Load | Files |
|------|------|-------|
| 1 — Guideline | Procedure | `procedures/author-guideline.md` |
| 2 — Check | Procedure + Pattern + APIs | `procedures/author-check.md`, `patterns/{standard,edittime,config-param,format-template}.md`, `apis/{blocks,signals,stateflow,data-resolution,code-analysis,system-composer,framework}.md` |
| 3 — Test | Procedure + Templates | `procedures/test-check.md`, `templates/{test-spec,test-recipes}.md` |
| Legacy | Workflow | `workflows/legacy-conversion.md` |
| Spec formats | Templates | `templates/{guideline,check-spec}.md` |

## Entry Point: Detect Intent

Match the FIRST row that fits (order matters — check-specific intents take priority):

| User Says | Go To |
|-----------|-------|
| "Test/qualify my check..." | STEP 3 |
| "Author/write/create a check..." / "implement a check" / "Create a Model Advisor check..." | Ask if user wants a guideline first, then STEP 2 |
| "Create a guideline" / "enforce..." / "write a standard" / modeling constraint without the word "check" | STEP 1 (full pipeline) |

**IMPORTANT — Entry for "Author/Create a check" intent:**
When the user mentions "check" (author, write, create, implement), ALWAYS ask first:
```
Would you like me to also create a formal guideline document for this rule, or just the check implementation?
```
Options:
1. "Start with the guideline (full pipeline) (Recommended)" — go to STEP 1
2. "Just the check, skip the guideline" — go to STEP 2 directly

If the prompt explicitly says "Only create the check" or "skip guideline", go to STEP 2 without asking.

If the prompt says "skip guideline and tests" or "Only create the check — skip guideline and tests", go to STEP 2, author the check, then present the Final Report immediately (do NOT proceed to Step 3).

If the prompt includes "proceed without asking" or "skip confirmation", skip this question and go directly to STEP 2.

---

## STEP 1: Author Guideline

**Derive defaults:**
- **Guideline ID**: Use `cust_` prefix + sequential number (+ optional short descriptor), e.g., `cust_0001`, `cust_0002_unitygain`.
- **Output folder**: Use the current working directory. Create a subfolder named after the guideline ID: `./<guideline_id>/`

**Guideline ID & Scope Review — Pause and ask the user:**

Present the derived defaults and ask for confirmation:
```
I've derived: Guideline ID = `<id>`, Check ID = `mathworks.custom.<id>`, Output = `./<id>/`
Scope: <1-line summary of what the guideline will cover>
```

Options:
1. "Use these IDs (Recommended)" — continue with derived defaults
2. "I want to provide my own ID" — user provides custom IDs, incorporate them

If user selects option 2, incorporate their changes. Otherwise proceed immediately.

**Execute:** Follow `references/procedures/author-guideline.md` to produce the guideline.

**Artifact notification (brief, no narration):**

```
Guideline `<id>`: <title>
  → ./<id>/guideline_<id>.md
  → ./<id>/compliant_<short>.slx
  → ./<id>/violating_<short>.slx
  → ./<id>/example_correct.png (or text table if parameter-focused)
  → ./<id>/example_incorrect.png (or text table if parameter-focused)
```

**Immediately continue to STEP 2** — do NOT wait for user input.

---

## STEP 2: Generate Check Specification + Author Check

**Guideline ID & Scope Review — Pause and ask the user:**

If entering directly (not from Step 1), present the ID & Scope review gate before proceeding. If entering from Step 1, the ID was already confirmed — reuse it and skip the gate.

When the gate is needed, derive a default ID using the `cust_` prefix (same format as Step 1) and present for confirmation.

**Execute Spec:** Generate check spec document following `references/templates/check-spec.md`, feeding in the guideline and user's original constraint. Save to `<output_dir>/<id>-check-spec.md`.

**Present the spec** to the user using the summary format defined in `references/templates/check-spec.md` — show key fields (ID, title, type, context, auto-fix) and the requirements table. End with the saved path.

**Check Specification Review — Pause and ask the user:**

Ask the user to review the check spec before implementation:

Options:
1. "Looks good, proceed with implementation (Recommended)"
2. "I have changes to the spec"

If user selects option 2, wait for their feedback, update the spec document accordingly, then proceed. Otherwise proceed immediately.

**Execute Check:** Follow `references/procedures/author-check.md` using the (potentially updated) spec as input. Read the appropriate pattern and API reference files based on the check type. Validate with `check_matlab_code` until 0 warnings/errors.

**Artifact notification (brief):**

```
Check authored: define<Name>.m
Registration: sl_customization.m
  → <path>
```

**Guideline Scan & Transition Gate:**

Before proceeding to tests, scan the output folder for a guideline document (`guideline_*.md`).

- If a guideline already exists (e.g., Step 1 was executed earlier), skip this gate and continue directly to Step 3.

If NO guideline document exists:
1. Pause and ask the user to choose from these options:
   - "Skip guideline, proceed to testing (Recommended)" — continue to Step 3
   - "I have a guideline document elsewhere" — user provides a path, copy/link it to the output folder, then continue to Step 3
   - "Create a formal guideline first" — execute Step 1 (author-guideline procedure) before continuing to Step 3
   - "Skip guideline and skip testing" — present Final Report with check artifacts only

If the user selects "I have a guideline document elsewhere", ask for the path, read it, and use it as the source guideline for test derivation.

If the user selects "Create a formal guideline first", execute Step 1 using the constraint that was used to author the check, then return here and continue to Step 3.

**Continue to STEP 3** after the gate resolves.

---

## STEP 3: Generate Test Spec + Qualify with Tests

**CRITICAL — TDD Independence:** Derive test cases ONLY from the guideline and the user's original constraint. NEVER read the check spec or implementation. See `references/procedures/test-check.md` § TDD Independence Guardrail.

**Execute Test Spec:** Generate test spec document following `references/templates/test-spec.md`, feeding in the guideline and the user's original constraint. Save to `<output_dir>/<id>-test-spec.md`.

**Present the test spec** to the user using the summary format defined in `references/templates/test-spec.md` — show key fields (guideline ID, check ID, check type, auto-fix) and the test cases table. End with the saved path.

**Test Plan Review — Pause and ask the user:**

Ask the user to review the test spec before implementation:

Options:
1. "Looks good, proceed with test generation (Recommended)"
2. "I have changes to the test plan"

If user selects option 2, wait for their feedback, update the test spec accordingly, then proceed. Otherwise proceed immediately.

**Execute Tests:** Follow `references/procedures/test-check.md` using the (potentially updated) test spec as input. Run tests and present results (N passed, N failed).

**CRITICAL — Test Execution Retry Limit:**
If tests fail after the initial run:
- Analyze the failure root cause (model issue vs. check logic vs. test assertion)
- Apply a targeted fix
- Re-run tests
- **Maximum 3 retry attempts.** If tests still fail after 3 retries, STOP and report the status honestly:
  ```
  Tests: X passed, Y failed (after 3 fix attempts)
  Remaining failures: <list with brief description>
  Recommended next steps: <what the user should investigate>
  ```
- Do NOT enter an unbounded fix loop

**After tests complete (or retry limit reached), present the Final Report.** Workflow ends.

---

## Halt & Cleanup

If the user says "stop", "no", "halt", or "don't continue" at ANY point during optimistic execution:

1. **Stop immediately** — do not begin the next step
2. **Delete artifacts from the step currently in progress** (not yet completed):
   - If halted during STEP 2: delete check spec, check definition `.m`, and `sl_customization.m` entries that were being generated
   - If halted during STEP 3: delete test spec, test class `.m`, and test model `.slx` files that were being generated
3. **Keep all completed step artifacts** — guideline stays if Step 1 finished, check stays if Step 2 finished
4. **Present Final Report** showing what was kept and what was removed

---

## Final Report

Present this when the workflow completes (all steps done) or when halted:

```
## Workflow Summary

| Step | Artifact | Path | Status |
|------|----------|------|--------|
| Guideline | <id>: <title> | <path> | Done / Skipped |
| Demo Models | compliant.slx, violating.slx | <path> | Done / Skipped |
| Screenshots | example_correct.png, example_incorrect.png | <path> | Done / Skipped |
| Check Spec | <id>-check-spec.md | <path> | Done / Removed |
| Check | define<Name>.m | <path> | Done / Removed |
| Registration | sl_customization.m | <path> | Done / Removed |
| Test Spec | <id>-test-spec.md | <path> | Done / Removed |
| Tests | Test<Name>.m | <path> | Done / Removed |
| Test Models | <list>.slx | <path> | Done / Removed |

**Status:** <Pipeline completed / Halted at <step description> by user request>
```

----

Copyright 2026 The MathWorks, Inc.

----

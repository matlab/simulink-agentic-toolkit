---
name: slci-inspection-incompatibility-analysis
description: >
  Use when SLCI code inspection has failed due to compatibility issues and you
  need to diagnose the incompatibilities. Traces inspection failures back to
  root-cause incompatibility settings or known limitations by matching failed
  code lines against known incorrect code generation patterns and documented
  limitation scenarios. Hands off to slci-compatibility-analysis for fixes.
  Trigger keywords: inspect, inspection failed, trace inspection errors, why did
  inspection fail, SLCI verification failures, limitation.
license: https://www.mathworks.com/content/dam/mathworks/license/pmrl/license.md
metadata:
  author: MathWorks
  version: "1.0"
---

# SLCI Inspection Incompatibility Analysis

Analyze SLCI code inspection results and trace failures back to compatibility
constraint violations or known limitations by matching failed code lines against
known incorrect code generation patterns and documented limitation scenarios.

## When to Use

- User asks why SLCI inspection failed or has verification errors
- User wants to trace inspection failures to their root-cause settings
- User has an inspection report with Failed/Error/Unverified items
- User asks to diagnose code inspection issues before re-running
- User wants to understand which compatibility settings caused inspection failure

## When NOT to Use

- User wants to check model compatibility *before* running inspection (no
  inspection failure context) — use `slci-compatibility-analysis` instead
- User confirms the inspection failure is not related to a compatibility issue
- User wants general Simulink model building or code generation help

## Workflow

### 0. Clarify Intent

Ask the user whether the inspection failure might be related to a compatibility
issue before taking any other action. Do not search for files or run MATLAB
until the user confirms.

- **Yes** → proceed to Step 1.
- **No** → stop this skill.
- **Unsure** → explain what compatibility issues are and ask again.

### 1. Locate the Inspection Report

Get the report folder from MATLAB:

```matlab
c = slci.Configuration('<model_name>');
reportFolder = c.getReportFolder();
```

Look for `<model_name>_report.html` (or `.pdf`/`.doc`). If found, compare the
model's timestamp against the report's — warn if the report may be stale.

**If the report does NOT exist**, stop and warn the user. Suggest `c.inspect()`.
If the user explicitly asks to run inspection, first check whether generated code
is stale or missing and regenerate if needed before inspecting.

**Code regeneration commands (used throughout this skill):**
- **Top model:** `rtwbuild('<model_name>')`
- **Reference model:** `c.setTopModel(false); slbuild('<model_name>', 'ModelReferenceRTWTargetOnly')`

**Pre-inspection settings:** If the user asks for advanced loop analysis support,
set `c.setApplyAdvancedLoopSupport(true)` before calling `c.inspect()`. This
enables verification of algebraic loop constructs that SLCI skips by default.

### 2. Parse the Inspection Report

Extract the text content and search for items with **Failed**, **Error**, or
**Unverified** status, capturing 2 lines of context before and 5 lines after
each match.

For each failed item, identify:
- The **code file** and **line number** where verification failed
- The **block path** the code maps to (from comments)
- The **failure reason** (e.g., "unable to verify", "no traceability", "ambiguous mapping")

### 3. Read the Failed Code Lines

For each failed code location, read the generated C source file at the failed
line, capturing 5–10 lines of surrounding context to understand the pattern.

Generated code is located at:
- **Top model:** `<model_dir>/<model_name>_ert_rtw/<source_file>.c`
- **Reference model:** `<model_dir>/slprj/ert/<model_name>/<source_file>.c`

For Stateflow failures, consult
[stateflow_failure_patterns.md](references/stateflow_failure_patterns.md) for
traceability comment format, merge junction patterns, and a quick-triage table
before reading full constraint reference files.

### 4. Match Against Incorrect Code Generation Patterns

Read the constraint files from the `slci-compatibility-analysis` skill's
`references/` folder.

See the Constraint Categories table in `slci-compatibility-analysis` for the
full list of constraint files and their categories.

For each failed code line, use the block path from its traceability comment to
identify the block type, then compare the code against the constraint
descriptions and **Why** explanations in the matching constraint files.

**Critical: Verify applicability before declaring a match.** A structural resemblance
alone is NOT sufficient. For each candidate match, verify:

1. **Scope:** Does the constraint apply to the specific block type in the failing model?
2. **Mechanism:** Does the constraint's parameter actually control the observed code
   generation behavior? Read the **Why** section in the constraint entry to confirm.
3. **Contradictions:** Check whether another constraint gives opposing guidance for the
   same scenario.

**If no constraint satisfies all three checks,** report the unmatched failures to
the user and ask whether to proceed to Step 4b (limitation matching). If the user
declines, classify those failures as **UNMATCHED** and include them in the report
with the constraints that were considered and why each was ruled out. Do NOT
check limitations without explicit user approval.

### 4b. Match Against Known Limitations (requires user permission)

Only run this step after the user has approved proceeding from Step 4.

Compare unmatched failures against known limitations in
the `slci-compatibility-analysis` skill's `references/code_inspection_limitations.md`.
Constraint violations take priority — only classify as **LIMITATION** if no
constraint is a better explanation. If the failure matches neither a constraint
nor a limitation, classify as **UNMAPPED** and document why each candidate was
ruled out. Do NOT report a "closest match" as the root cause — an incorrect
mapping is worse than an honest "unmapped."

### 5. Cross-Reference with Compatibility Report

Skip this step if inspection was terminated (e.g., missing headers or compile
errors).

Use `slci-compatibility-analysis` to obtain or verify compatibility results.
Cross-reference the compatibility warnings against the matched constraints to
confirm the mapping. When a warning could map to multiple conditions, check the
model's actual settings to identify the true trigger rather than relying on the
warning text alone.

### 6. Present Results

**In the context window**, show only a brief summary table (columns: #, Location,
Pattern, Root Cause, Type) and summary counts.

**Save detailed results** to:
`<model_dir>/<model_name>_inspection_analysis_YYYY-MM-DD.md`

If constraint violations were found, ask the user if they want to apply fixes.
If yes, delegate to the `slci-compatibility-analysis` skill to apply fixes, then
regenerate code and re-run `c.inspect()`. Do not fix the model yourself — no
`set_param`, no `fixIncompatibilities`, no model modifications of any kind.

If failures remain after fixes, re-run this analysis on the fixed model. If only
UNMATCHED, UNMAPPED, or LIMITATION failures remain, inform the user that
automatic fixing is not possible.

If no failed items are found, inform the user that all checks passed and save a
brief report. If compatibility warnings exist despite passing, include a
**Warning Impact Analysis** explaining why each warning did not cause a failure
and under what conditions it could become one.

## Guardrails

- **NEVER skip Step 0 (Clarify Intent).** You must ask the user whether the
  failure is compatibility-related and receive confirmation before taking any
  diagnostic action. Do not search for files, run MATLAB, or read reports until
  the user confirms.
- **NEVER report a "closest match" as a root cause.** An incorrect mapping is
  worse than an honest "unmapped." All three checks (scope, mechanism,
  contradictions) must pass before declaring a constraint match.
- **NEVER check limitations without explicit user permission.** Step 4b requires
  the user to approve before proceeding.
- **NEVER apply fixes directly.** This skill only diagnoses — it does not
  modify the model. Delegate all fix application to
  `slci-compatibility-analysis`. If that skill is unavailable, stop.

----

Copyright 2026 The MathWorks, Inc.

----

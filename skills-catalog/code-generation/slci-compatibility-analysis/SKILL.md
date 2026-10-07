---
name: slci-compatibility-analysis
description: >
  Use when you need to verify a Simulink model is compatible with SLCI code
  inspection, or to apply fixes for identified incompatibilities. Checks model
  configuration, identifies incompatibilities, and explains why each constraint
  is required for verification. Also invoked by
  slci-inspection-incompatibility-analysis to fix constraints and obtain
  compatibility results. Trigger keywords: checkCompatibility, SLCI
  compatibility, code inspection readiness, Model Advisor compatibility report.
license: https://www.mathworks.com/content/dam/mathworks/license/pmrl/license.md
metadata:
  author: MathWorks
  version: "1.0"
---

# SLCI Compatibility Analysis

Determine whether a Simulink model's configuration and structure meet the
requirements for SLCI (Simulink Code Inspector) code inspection.

## When to Use

- User asks to check model compatibility for SLCI / Simulink Code Inspector
- User asks to run `checkCompatibility` or analyze compatibility results
- User wants to know why a model is incompatible with code inspection
- User wants to understand what must be fixed before inspection can succeed
- Delegated from `slci-inspection-incompatibility-analysis` to apply fixes or obtain compatibility results

## When NOT to Use

- User already has **inspection** results (from `c.inspect()`) and needs to trace
  failures to root causes — use `slci-inspection-incompatibility-analysis` instead
- User wants general Simulink model building or testing — use the core MBD skills

**Boundary note:** This skill covers the pre-inspection compatibility check
(`checkCompatibility`). The `slci-inspection-incompatibility-analysis` skill covers
post-inspection failure analysis (`inspect` results) and delegates back to this
skill for applying fixes and obtaining compatibility results. If a user simply asks
"is my model ready for SLCI?", use this skill.

## Guardrails

1. **Never modify the original model.** Copy to `<model_name>_fixed.slx` first.
   Also copy any associated data dictionary (`.sldd`) or `.mat` files if fixes
   require modifying them. All fixes are applied to the copy only.
   After copying, run `fileattrib('<copy>', '+w')` to ensure the copy is writable.
2. **Always produce a [Post-Fix Change Report](#post-fix-change-report)** after
   fixes are applied, so the user knows exactly what was changed.

## Domain Model: What SLCI Compatibility Means

SLCI verifies **structural equivalence** between a Simulink model and its generated
C code — proving that every signal path, computation, and data flow in the model has
a corresponding construct in the code. The compatibility checker identifies model
configurations and patterns that would make this verification impossible or
unreliable.

For severity levels (FATAL vs. Nonfatal), the full constraint categories table
(mapping check titles to reference files), and error recovery procedures, see
[incompatibility-guide.md](references/incompatibility-guide.md). For per-block
parameter constraints indexed by block type, see
[block_support_constraints.md](references/block_support_constraints.md).

## The `slci.Configuration` API

### Running the Check

```matlab
c = slci.Configuration('<model_name>');
results = c.checkCompatibility();
```

Prefer this API over parsing the HTML report — it returns structured results.

### Querying Results Programmatically

`checkCompatibility()` returns a cell array of `ModelAdvisor.SystemResult` objects:

```matlab
results = c.checkCompatibility();

% Strip HTML tags/entities from Description and RecAction text
stripHtml = @(s) strtrim(regexprep(regexprep(char(s), '<[^>]*>', ''), ...
    {'&gt;', '&lt;', '&amp;'}, {'>', '<', '&'}));

% Iterate over individual check results
for i = 1:numel(results{1}.CheckResults)
    cr = results{1}.CheckResults(i);
    if ~strcmp(cr.Status, 'Passed')
        fprintf('CHECK: %s\n  Status: %s\n', cr.CheckName, cr.Status);
        rd = cr.getResultDetails;   % struct array: one entry per issue
        for k = 1:numel(rd)
            fprintf('  - %s\n    Fix: %s\n', stripHtml(rd(k).Description), ...
                stripHtml(rd(k).RecAction));
        end
    end
end
```

If the System target file check fails, fix it first and re-run — many other
checks report it as their fix until it is resolved.

**Result object properties:**

| Property | Type | Description |
|----------|------|-------------|
| `System` | char | Model/system name checked |
| `Summary` | struct | Pass/warn/fail counts |
| `CheckResults` | array | Individual check results (CheckName, Status, getResultDetails().Description) |
| `VersionInfo` | struct | MATLAB/Simulink version info |

Each `CheckResults` entry has:
- `CheckName` — check name (maps to constraint category)
- `Status` — `'Passed'`, `'Warning'`, `'Failed'`, etc. (anything other than
  `'Passed'` needs attention)
- `getResultDetails()` — struct array, one entry per issue, with
  `Description` (what is checked) and `RecAction` (recommended fix)

### Fixing Incompatibilities

```matlab
c.fixIncompatibilities();
```

**Scope:** This fixes configuration parameter settings only (e.g., setting
`TargetLang` to `'C'`, enabling required diagnostics). It does NOT fix:
- `SystemTargetFile` — even though an incorrect value (e.g., `grt.tlc`) is a FATAL
  incompatibility, `fixIncompatibilities()` will not change it. Set it before
  calling `fixIncompatibilities()`:
  ```matlab
  set_param('<model>', 'SystemTargetFile', 'ert.tlc');
  ```
- Structural issues (unsupported blocks, multi-rate enable signal crossings)
- Block-level parameter violations (data type mismatches, rounding modes)
- Model architecture problems (model reference parameter behavior)

**When safe:** Call it for batch config-param fixes when you've reviewed the list and
confirmed all flagged items are parameter settings. **When unsafe:** If FATAL
structural issues exist, fix those manually first — `fixIncompatibilities` may mask
the real problem by changing settings without addressing the underlying design issue.

**Important:** `fixIncompatibilities()` modifies the model in place — see
[Guardrails](#guardrails).

### Handling Remaining Issues After `fixIncompatibilities()`

`fixIncompatibilities()` only resolves configuration parameter issues. After running
it, re-run `checkCompatibility()` and check for remaining non-passing checks. For any issues
that `fixIncompatibilities()` did not resolve:

1. **Map the failing check to its reference file** using the Check Title Keywords
   column in [incompatibility-guide.md](references/incompatibility-guide.md).
2. **Follow the suggested fix** from the reference file. Each constraint entry
   documents the required value or model change needed. **Always use the exact
   parameter name from the reference file** — check titles may differ from parameter
   names (e.g., Stateflow diagnostics use an `SF` prefix and `Diag` suffix like
   `SFTransitionOutsideNaturalParentDiag` that the check title omits).
3. **Apply fixes.** See
   [fixing-incompatibilities.md](references/fixing-incompatibilities.md) for the
   bulk-set procedure for code generation parameters.
4. **Re-run `checkCompatibility()`** after applying manual fixes to confirm they
   resolved the issues.

### Post-Fix Change Report

Always produce a change report when fixing incompatibilities so the user knows
exactly what was modified. The report compares the before and after states:

| Parameter | Previous Value | New Value | Constraint Category |
|-----------|---------------|-----------|---------------------|
| `TargetLang` | `'C++'` | `'C'` | Code Generation |
| `SolverType` | `'Variable-step'` | `'Fixed-step'` | Solver |

Include:
- Count of issues fixed vs. issues remaining
- Whether the model is now ready for inspection or still has outstanding issues

Save the change report as `<model_name>_fix_report_YYYY-MM-DD.md` in the model
directory.

## Model Reference Hierarchies

`checkCompatibility` on a top model does NOT automatically check referenced models.
For models with model references:

1. **Identify referenced models:** Use `model_overview` to discover the model
   reference hierarchy and store the referenced model names in a cell array
   `refs` (excluding the top model). If `model_overview` is unavailable, fall
   back to:
   ```matlab
   refs = find_mdlrefs('<top_model>');
   refs = refs(1:end-1);  % Top model is last; it is already checked
   ```
2. **Check each referenced model individually and keep every result:**
   ```matlab
   allResults = struct('model', {}, 'results', {});
   for i = 1:numel(refs)
       c = slci.Configuration(refs{i});
       allResults(end+1) = struct('model', refs{i}, ...
           'results', {c.checkCompatibility()}); %#ok<AGROW>
   end
   ```
3. **Aggregation considerations:**
   - Each referenced model must independently pass compatibility
   - `DefaultParameterBehavior` at the reference boundary affects how parameters
     are resolved — `'Inlined'` is required for SLCI traceability
   - Protected model references cannot be inspected (SLCI cannot see inside them)

## Workflow

### 1. Run the Compatibility Check

Use the programmatic API above. If no MCP connection exists, run MATLAB in batch
mode with a 600-second timeout. For large models, run the check as a background
task to avoid blocking.

**Important:** If reusing an existing report at
`slprj/modeladvisor/<model>/report.html`, verify the report is not stale — compare
the report timestamp against the model's last-modified time. If the model is newer,
re-run the check.

### 2. Interpret Results

For each non-passing check:
1. Identify the **constraint category** from the check title
2. Look up the constraint in the appropriate reference file
3. Note its **severity** (FATAL vs. Nonfatal) from the reference file
4. Determine whether `fixIncompatibilities()` can resolve it (config param) or
   whether manual model changes are needed (structural)

### 3. Present Results

Provide the user with:
- A summary: counts of passed and non-passing checks, and of FATAL and Nonfatal
  issues
- Category breakdown (e.g., "3 Code Generation, 2 Solver, 1 Structural")
- For each incompatibility: the parameter name, current vs. required value, and why
  SLCI needs it (from reference files)
- A clear distinction between issues fixable by `fixIncompatibilities()` and those
  requiring manual intervention

Scale the detail level to what the user asked for. A quick "is it ready?" gets the
summary. A "why is X failing?" gets the full constraint explanation.

### 4. Fix and Report Changes

If the user requests fixes (or agrees to apply them), follow the
[Fixing Incompatibilities](#fixing-incompatibilities) and
[Handling Remaining Issues](#handling-remaining-issues-after-fixincompatibilities)
procedures above.

Bulk-set model-root config parameters upfront per
[fixing-incompatibilities.md](references/fixing-incompatibilities.md) to minimize
round-trips.

### 5. Save Results

If any warnings or failures are found, always save results to a markdown file in the
model directory (`<model_name>_compatibility_results_YYYY-MM-DD.md`). Include the
model name, date, results table, and remediation guidance. If all checks pass, no
file is needed — just inform the user.

## Explaining Individual Constraints

When asked to explain a specific constraint, read the relevant reference file and
present:

1. **What SLCI requires** — the parameter/setting and its required value
2. **Why** — what breaks in structural equivalence verification if violated
3. **Fix** — the parameter value or model change needed

For constraints where the failure mode is non-obvious (multi-rate data races,
constant folding across blocks, hidden auto-inserted blocks), include a code example
showing the problematic generated code pattern. See
[references/explain-constraint.md](references/explain-constraint.md) for an example
of this deeper treatment.

For simple config-param constraints (e.g., `TargetLang` must be `C`), a one-line
explanation and fix command is sufficient — don't force unnecessary detail.

## Error Recovery

See [incompatibility-guide.md](references/incompatibility-guide.md) for the full
error recovery table.

----

Copyright 2026 The MathWorks, Inc.

----

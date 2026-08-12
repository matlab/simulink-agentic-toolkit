---
type: procedure
triggers: [author_check, write_check, implement_check, create_check]
tags: [check, implementation, step-2, lifecycle, model-advisor]
related:
  - patterns/standard.md
  - patterns/edittime.md
  - patterns/config-param.md
  - apis/framework.md
  - procedures/author-guideline.md
  - procedures/test-check.md
---
# Procedure: Author Model Advisor Check

Create or upgrade Model Advisor checks to use modern DetailStyle callbacks and ResultDetail reporting. This procedure prevents common authoring mistakes: using deprecated StyleOne/StyleTwo patterns, incorrect registration, missing result formatting, and wrong callback contexts.

## Scope

- Creating a new Model Advisor check (standard, edit-time, or config-parameter)
- Converting a legacy StyleOne/StyleTwo/StyleThree check to modern DetailStyle with ResultDetail
- Adding an edit-time canvas warning for a naming or style rule
- Validating configuration parameters programmatically with auto-fix
- Enforcing a modeling convention with auto-fix actions
- Checking System Composer architecture models (components, ports, connectors, interfaces, stereotypes)

## Steps

### 1. Choose the Check Pattern

| If the constraint mentions... | Use Pattern | Reference |
|-------------------------------|-------------|-----------|
| On-demand check, batch check, or nothing specific | Standard check (Default) | [patterns/standard.md](../patterns/standard.md) |
| "edit-time", "live", "real-time", "canvas warning" | Edit-time check | [patterns/edittime.md](../patterns/edittime.md) |
| Config parameters, solver settings, diagnostics, model settings | Config parameter check | [patterns/config-param.md](../patterns/config-param.md) |
| "custom table", "formatted report", "custom columns" | + FormatTemplate | [patterns/format-template.md](../patterns/format-template.md) |
| "convert", "upgrade", "legacy", "StyleOne", "StyleTwo", "StyleThree" | Legacy conversion | [workflows/legacy-conversion.md](../workflows/legacy-conversion.md) |

FormatTemplate is an add-on, not standalone.

### 2. Choose the API Pattern(s) for Check Logic

| If the check inspects... | Reference |
|--------------------------|-----------|
| Blocks (properties, types, names, positions, masks) | [apis/blocks.md](../apis/blocks.md) |
| Signals (line names, labels, propagation, connections) | [apis/signals.md](../apis/signals.md) |
| Stateflow (charts, states, transitions, junctions, data) | [apis/stateflow.md](../apis/stateflow.md) |
| Data types, workspace, variables (resolution, data dictionary) | [apis/data-resolution.md](../apis/data-resolution.md) |
| MATLAB code analysis (checkcode, codeIssues, mtree) | [apis/code-analysis.md](../apis/code-analysis.md) |
| System Composer (components, ports, connectors, interfaces) | [apis/system-composer.md](../apis/system-composer.md) |

All check types can also use [apis/framework.md](../apis/framework.md) — consult for input parameters, auto-fix actions, exclusion filtering, and result formatting.

- Config parameter checks use `get_param(system, paramName)` — refer to the config parameter pattern and framework API.
- System Composer checks must use `'None'` callback context (architecture models do not compile).
- A single check can combine multiple API patterns (e.g., blocks + signals).

### 3. Read Reference Files

Load the selected pattern and API reference files from `references/`. These contain the exact templates and code patterns to follow.

### 4. Present Plan (unless obvious from prompt)

State chosen pattern, API(s), check ID, and file names. If the pattern choice is obvious from the prompt, proceed without waiting.

### 5. Write Check Definition

Generate the `.m` file(s) following the conventions below. Use `evaluate_matlab_code` with MATLAB file I/O (fopen/fwrite/fclose), passing `project_path`, to write the file — do NOT use Write/Edit tools.

### 6. Write Registration

Create or append to `sl_customization.m` using `evaluate_matlab_code` with MATLAB file I/O (fopen/fwrite/fclose), always passing `project_path` — do NOT use Write/Edit tools.

### 7. Validate

Run `check_matlab_code` on each generated `.m` file — zero warnings required.

### 8. Report and Continue

Show output file locations, placement instructions, and test command. **Do NOT end your turn here.** Continue with the orchestrator's next step immediately.

## Conventions

- Always: Use `'DetailStyle'` callback style — legacy styles cannot use ResultDetail reporting
- Always: Include `sl_customization.m` registration — checks are invisible without it
- Always: Use `ModelAdvisor.ResultDetail` for reporting — only API that populates results pane correctly
- Always: Use `ModelAdvisor.Check(id)` constructor — never use `ModelAdvisor.Registration`
- Never: Use `'StyleOne'`/`'StyleTwo'`/`'StyleThree'` — deprecated and incompatible with ResultDetail
- When Ambiguous: Default to standard check unless prompt clearly indicates edit-time — state your assumption inline
- When Ambiguous: Default package name to `+checks` for edit-time classes — state your choice inline

## Code Generation

### Naming
- Check ID: reverse-domain style, e.g. `com.company.checkarea.checkname`
- Check definition function: `define<CheckName>.m`
- Edit-time class: PascalCase, e.g. `SignalLabels.m`, placed in `+PackageName/`

### Files to Generate
- Always: check definition file (`.m`)
- Always: `sl_customization.m` — create new or append to existing (only one per folder)
- Edit-time checks: both registration function and class file in `+PackageName/`
- Standard checks with auto-fix: include `ModelAdvisor.Action` setup and action callback

### Verification
After generating all files:
1. Run `check_matlab_code` on each `.m` file — zero warnings required
2. Report file locations, placement instructions (must be on MATLAB path), and test command: `Advisor.Manager.refresh_customizations`

## Review Gate

After generating check code, verify:

- [ ] Callback uses `'DetailStyle'` (not `'StyleOne'`/`'StyleTwo'`/`'StyleThree'`)
- [ ] Context is correct: `'None'` for structural checks, `'PostCompile'` for compiled properties
- [ ] Pass case sets `ViolationType = 'Passed'` with a status message
- [ ] Violations use correct `setData` type: `'SID'` for blocks, `'Signal'` for lines
- [ ] `sl_customization.m` registers the check with correct function handle
- [ ] For edit-time: `finishedTraversal` is implemented, execution is lightweight
- [ ] For System Composer: uses `'None'` context, reports component SID (not port/connector)
- [ ] No `checkcode` warnings in generated files

----

Copyright 2026 The MathWorks, Inc.

----

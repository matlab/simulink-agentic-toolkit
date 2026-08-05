---
name: author-modeladvisor-checks
description: >
  Author or upgrade Model Advisor checks for Simulink and System Composer models.
  Use when creating new checks (edit-time, standard batch, config-parameter, auto-fix)
  or converting legacy StyleOne/StyleTwo/StyleThree checks to modern DetailStyle.
  Covers DetailStyle callbacks, ResultDetail reporting, sl_customization registration,
  and edit-time EdittimeCheck classes.
license: https://www.mathworks.com/content/dam/mathworks/license/pmrl/license.md
metadata:
  author: MathWorks
  version: "1.1"
---

# Check Authoring

Create or upgrade Model Advisor checks to use modern DetailStyle callbacks and ResultDetail reporting. This skill prevents common authoring mistakes: using deprecated StyleOne/StyleTwo patterns, incorrect registration, missing result formatting, and wrong callback contexts. When upgrading legacy checks, read the existing code, identify the legacy pattern, and rewrite using the modern patterns below.

## When to Use

- Creating a new Model Advisor check (standard, edit-time, or config-parameter)
- Converting a legacy StyleOne/StyleTwo/StyleThree check to modern DetailStyle with ResultDetail
- Adding an edit-time canvas warning for a naming or style rule
- Validating configuration parameters programmatically with auto-fix
- Enforcing a modeling convention with auto-fix actions
- Checking System Composer architecture models (components, ports, connectors, interfaces, stereotypes)

## When NOT to Use

- Running or debugging existing checks — use Model Advisor UI
- Writing Simulink Test test cases
- Querying model structure without creating a check — use `model_query_params`
- Modifying Model Advisor configuration or preferences

## Workflow

### New Check Workflow
1. **Determine check pattern** — Choose the check type based on user intent (see Step 1 below)
2. **Determine API pattern** — Identify which model elements the check inspects (see Step 2 below)
3. **Read reference files** — Load the selected pattern and API reference files from `references/`
4. **Present plan to user** — State chosen pattern, API(s), check ID, and file names. If the pattern choice is obvious from the prompt, proceed without waiting.
5. **Write check definition** — Generate the `.m` file(s) following the Code Generation section below
6. **Write registration** — Create or append to `sl_customization.m`
7. **Validate** — Run `check_matlab_code` on each generated `.m` file
8. **Report** — Show output file locations, placement instructions, and test command

### Legacy Conversion Workflow
When converting existing StyleOne/StyleTwo/StyleThree checks to DetailStyle, follow `references/workflow-legacy-conversion.md`.

This skill covers check authoring only. To run checks on a model, use the `checking-model-compliance` skill.

## Step 1: Choose the Check Pattern

| If the user mentions... | Use Pattern | Reference |
|-------------------------|-------------|-----------|
| On-demand check, batch check, or nothing specific | Standard check (Default) | `references/pattern-standard.md` — full template with DetailStyle callback and ResultDetail reporting |
| "edit-time", "live", "real-time", "canvas warning" | Edit-time check | `references/pattern-edittime.md` — EdittimeCheck class with blockDiscovered/finishedTraversal |
| Config parameters, solver settings, diagnostics, model settings | Config parameter check | `references/pattern-config-param.md` — get_param/set_param with auto-fix action |
| "custom table", "formatted report", "custom columns" | + FormatTemplate | `references/pattern-format-template.md` — combine with standard or edit-time pattern for custom tables |
| "convert", "upgrade", "legacy", "StyleOne", "StyleTwo", "StyleThree" | Legacy conversion | `references/workflow-legacy-conversion.md` — infrastructure mapping, strategy choice, and result-layer replacement |

FormatTemplate is an add-on, not standalone.

## Step 2: Choose the API Pattern(s) for Check Logic

| If the check inspects... | Reference |
|--------------------------|-----------|
| Blocks (properties, types, names, positions, masks) | `references/api-blocks.md` — find_system patterns and block property access |
| Signals (line names, labels, propagation, connections) | `references/api-signals.md` — line handle queries and signal tracing |
| Stateflow (charts, states, transitions, junctions, data) | `references/api-stateflow.md` — Stateflow.find and chart traversal |
| Data types, workspace, variables (resolution, data dictionary) | `references/api-data-resolution.md` — workspace variable resolution and storage class |
| MATLAB code analysis (checkcode, codeIssues, mtree) | `references/api-code-analysis.md` — static analysis of .m files |
| System Composer (components, ports, connectors, interfaces) | `references/api-system-composer.md` — architecture model queries |

All check types can also use `references/api-framework.md` — consult for input parameters, auto-fix actions, exclusion filtering, and result formatting.

- Config parameter checks use `get_param(system, paramName)` — refer to the config parameter pattern and framework API.
- System Composer checks must use `'None'` callback context (architecture models do not compile).
- A single check can combine multiple API patterns (e.g., blocks + signals).

## Conventions

- Always: Use `'DetailStyle'` callback style — legacy styles cannot use ResultDetail reporting
- Always: Include `sl_customization.m` registration — checks are invisible without it
- Always: Use `ModelAdvisor.ResultDetail` for reporting — only API that populates results pane correctly
- Always: Use `ModelAdvisor.Check(id)` constructor — never use `ModelAdvisor.Registration`
- Never: Use `'StyleOne'`/`'StyleTwo'`/`'StyleThree'` — deprecated and incompatible with ResultDetail
- Never: Generate checks without test instructions — untestable checks waste user time
- Ask First: Choose edit-time vs. standard when ambiguous — wrong choice requires a full rewrite
- Ask First: Choose package name for edit-time classes — affects namespace, hard to rename later

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

Test model creation and functional testing are out of scope for this skill (handled separately). Static analysis via `check_matlab_code` is the default verification step.

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

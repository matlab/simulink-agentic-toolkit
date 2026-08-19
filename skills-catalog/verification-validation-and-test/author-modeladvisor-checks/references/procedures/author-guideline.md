---
type: procedure
triggers: [create_guideline, author_guideline, write_standard, enforce, modeling_constraint]
tags: [guideline, authoring, step-1, lifecycle]
related:
  - templates/guideline.md
  - procedures/author-check.md
---
# Procedure: Author Modeling Guideline

Converts a natural-language modeling constraint into a formal guideline document following the MathWorks modeling guideline format.

## Key Principle: Guidelines are HIGH-LEVEL

A guideline states WHAT the rule is and WHY — not HOW to implement or check it. Maximum 2-3 rules. Everything else (configurable params, edge cases, block subtypes, auto-fix behavior) goes in the check spec.

See [templates/guideline.md](../templates/guideline.md) for format rules, exclusion list, and examples of correct filtering.

## Steps

### 1. Derive Defaults and Present at Gate

**Do NOT proceed without presenting the ID to the user.** Derive automatically:

- **Guideline ID**: Infer from constraint domain using prefix convention below + sequential number + short descriptor
- **Output folder**: Current working directory, subfolder named after guideline ID
- **Scope**: Infer from the constraint. If truly ambiguous, state your assumption inline and proceed.

**ID prefix:** Always use `cust_` prefix for custom checks.

**Guideline ID format:** `cust_NNNN` or `cust_NNNN_descriptor` (e.g., `cust_0001`, `cust_0002_unitygain`).

Present at the Guideline ID & Scope Review gate with two options: use the derived `cust_` ID (recommended) or let the user type their own.

### 2. Decompose the Constraint

Identify the guideline type:

| Type | Rule Format |
|------|-------------|
| Block/Signal behavior | Bullet list with optional Exceptions subsection |
| Prohibited usage | Bullet list of prohibitions |
| Multi-aspect | Separate ### sub-sections (only when truly distinct facets) |

Extract the CORE principle — strip away implementation details:
- **Core rule**: ONE high-level principle (2-3 rules max for multi-aspect)
- **Rationale**: Why this matters (readability, traceability, code generation, safety)
- **Implementation details -> check spec**: Note configurable params, edge cases, block subtypes — these feed into Step 2

### 3. Create Demo Models and Examples

Create two minimal Simulink models (2-5 blocks each) demonstrating the rule — one compliant (`compliant_<short>`), one violating (`violating_<short>`). Save as `.slx` in the output directory.

For screenshots vs text tables, follow the criteria in [templates/guideline.md](../templates/guideline.md) § Examples. **Never create placeholder images.**

### 4. Write the Guideline Document (via MATLAB file I/O)

Follow the template in [templates/guideline.md](../templates/guideline.md). Use `evaluate_matlab_code` with MATLAB file I/O (fopen/fwrite/fclose), passing `project_path`, to save the file — do NOT use Write/Edit tools. Rationale: MATLAB file I/O ensures files land in the correct project directory with proper encoding, and keeps all artifacts co-located with the MATLAB session's working folder — Write/Edit tools cannot reliably target the `project_path` context.

**Optional:** Exceptions subsection — ONLY when the user explicitly states exceptions in their input. NEVER invent or infer exceptions.

**Image references in guideline:**
- If PNGs were generated: reference them with `![Compliant model](example_correct.png)`
- If text tables were used instead: do NOT include any `![...]()` image markdown — only the text table

### 5. Save and Present

Save using `evaluate_matlab_code` with MATLAB file I/O (fopen/fwrite/fclose), always passing `project_path`, to: `<working_dir>/<id>/guideline_<id>.md`

Present a brief artifact list (file paths only). **Do NOT end your turn here.** This procedure is complete — continue with the orchestrator's next step immediately.

## Reference Files

- [templates/guideline.md](../templates/guideline.md) — template with format variants

----

Copyright 2026 The MathWorks, Inc.

----

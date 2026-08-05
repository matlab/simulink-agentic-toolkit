---
name: manage-safety-analysis
description: "Create, populate, and manage safety analysis spreadsheets (FMEA, FHA, HARA, custom) and fault trees (FTA) in Safety Analysis Manager. Use when the user asks to perform FMEA, hazard analysis, fault tree analysis, safety analysis, or work with Safety Analysis Manager documents. Requires Simulink Fault Analyzer."
license: https://www.mathworks.com/content/dam/mathworks/license/pmrl/license.md
metadata:
  version: "2.1"
  author: MathWorks
---

# Safety Analysis Manager

Use `evaluate_matlab_code` with the `safetyAnalysisMgr` package to create, populate, query, and export safety analysis documents. Requires **Simulink Fault Analyzer** (R2023b+).

> **Version enforcement:** APIs are annotated with the MATLAB release they were introduced. Do NOT use an API unless the user's MATLAB release is equal to or newer than the annotated version. If the user's release is unknown, assume R2023b and restrict to R2023b APIs only until confirmed. Check the reference files for per-API version annotations.

Safety Analysis Manager supports two document formats:
- **Spreadsheets** — tabular, row-based analysis (FMEA, FHA, HARA, HAZOP, custom)
- **Trees** — hierarchical, node-based analysis (Fault Tree Analysis, Attack Trees)

## When to Use

### Spreadsheet-based analysis
- Creating FMEA, FHA, HARA, HAZOP, or custom tabular documents
- Populating spreadsheets with failure modes, effects, and risk ratings
- Reviewing existing spreadsheets for consistency, completeness, and correctness
- Editing, searching, or flagging items in an existing spreadsheet
- Adding derived columns, callbacks, or custom logic to a spreadsheet
- Exporting spreadsheet results to Excel
- -> read `references/spreadsheet-api.md` and `references/common-api.md`

### Tree-based analysis (R2026b+)
- Creating Fault Tree Analysis (FTA) documents
- Building fault trees with gates (AND/OR), basic events, and intermediate events
- Computing minimal cut sets and top-event probability
- Importance analysis and quantitative assessment
- -> read `references/tree-api.md` and `references/common-api.md`

### Common operations (both formats)
- Opening, saving, closing `.mldatx` documents
- Adding callbacks (AnalyzeFcn, PreSaveFcn, custom)
- Flagging elements for review (error, warning, check)
- Detecting changes in linked artifacts
- Creating traceability links to model blocks or requirements
- Document attributes and metadata
- -> read `references/common-api.md`

## When NOT to Use

- Building or editing Simulink model structure -> use `building-simulink-models`
- Running simulations or tests -> use `simulating-simulink-models` or `testing-simulink-models`
- Fault injection and simulation-based fault analysis -> use `inject-faults`
- Requirements traceability only -> use `generate-requirement-drafts`

## Workflow

### Creating a New Spreadsheet (FMEA/FHA/HARA)

1. **Understand the source.** Either:
   - **From a model:** Always use `model_overview` to inspect the model structure first. Use `model_read` for deeper subsystem details. Identify subsystems, signal paths, feedback loops, sensors, and actuators. These become FMEA rows or hazard entries.
   - **From requirements:** Read the requirements (via Requirements Toolbox or user-provided text) and derive functional elements, failure modes, and hazards from the specified system behavior.
2. **Choose a document structure.** Design columns appropriate for the specific system and analysis type. Use a built-in template only if the user explicitly requests one.
3. **Create and populate.** Build the spreadsheet programmatically using the API.
4. **Open the manager.** Call `safetyAnalysisMgr.openManager` so the user can see results.
5. **Save.** Always save to `.mldatx` when the user confirms the content.

### Creating a Fault Tree (R2026b+)

1. **Identify the top event.** The undesired system-level failure (e.g., "Loss of Aircraft Control").
2. **Decompose with gates.** Use OR gates for single-point failures, AND gates for redundant systems.
3. **Add basic events.** Leaf nodes representing individual component failures or human errors.
4. **Set probabilities.** Assign failure probabilities to basic events from reliability data or engineering estimates.
5. **Analyze.** Compute minimal cut sets and top-event probability.
6. **Save and review.** Save to `.mldatx` and open the manager for visual inspection.

### Reviewing an Existing Document

1. **Open the document.** Use `safetyAnalysisMgr.openDocument` to load the `.mldatx` file.
2. **Read and analyze content.** For spreadsheets, iterate over rows; for trees, traverse nodes. Check for:
   - Grammar and spelling issues in text
   - Inconsistencies between data and the model or requirements
   - Duplicate entries or near-duplicate failure modes
   - Missing information (empty cells, events without probabilities)
   - Calculations that don't match their inputs
3. **Flag issues.** Use `addFlag` to mark problematic elements for user review.
4. **Report findings.** Summarize issues found and suggest corrections.

## FMEA Generation Conventions

- **One row per failure mode**, not per block — a single block can have multiple failure modes.
- **Map model structure to functions:** subsystems → functional groups; individual blocks → functions within those groups.
- **Use requirement IDs** in the Subsystem/Function column when working from requirements (no model).
- **Detection methods** must reference observable signals (model-based) or testable acceptance criteria (requirements-based).
- Flag entries for review once a model becomes available — model-based analysis may reveal additional failure modes not apparent from requirements alone.



## Guardrails

### Always
- Use `evaluate_matlab_code` with `project_path` set to the skill's `scripts/` folder so MATLAB can find helper scripts (e.g., `fileType`). Never use `addpath`.
- Verify `.mldatx` files with `fileType(filePath)` before opening — the extension is shared with other tools. Only proceed if it returns `"document"` or `"template"`; if it throws, the file is not a Safety Analysis Manager document.
- When a model is available, read it with `model_overview` or `model_read` before writing failure modes — ground the analysis in actual structure. When working from requirements alone, derive failure modes from the requirements text instead.
- **Always call `safetyAnalysisMgr.openManager` as the final step** after creating, modifying, or reviewing a document — never skip this. The user cannot see results until the manager is open.
- Remind the user to save (or save programmatically with confirmation) — new documents have no file until explicitly saved

### Never
- Use `close(doc, Force=true)` or `safetyAnalysisMgr.closeAllDocuments(Force=true)` without asking — this discards unsaved work
- Delete rows, columns, or nodes from an existing document without user confirmation

### Ask First
- Before overwriting an existing `.mldatx` file
- Before adding flags (`addFlag`) that mark elements as errors or warnings
- Before deleting rows, columns, or nodes from an existing document

## Review Gates

### After Creating/Populating a Spreadsheet

> Review this safety analysis spreadsheet for:
> - Rows with empty detection methods, severity, or occurrence ratings
> - Failure modes that don't trace back to a model element or requirement
> - Duplicate or near-duplicate entries (same failure mode, different wording)
> - Column values that are inconsistent with each other (e.g., high severity + no detection + low RPN)
> - Missing common failure modes for the system type (sensors without bias/drift, actuators without stuck)

### After Creating a Fault Tree (R2026b+)

> Review this fault tree for:
> - Basic events without assigned failure models or with placeholder probabilities
> - Cut sets containing a single basic event (indicates missing redundancy or analysis gap)
> - Common-cause failures not modeled (shared power supply, shared sensor, common software)
> - Gates with only one input (redundant gate — simplify)
> - Circular or illogical decomposition (effect listed as its own cause)

### After Reviewing an Existing Document

> Verify the review findings for:
> - False positives (flagged items that are actually correct in context)
> - Missed issues in rows/nodes that were not inspected
> - Consistency of flag severity (errors vs warnings vs checks)

## Domain-Specific References

- **Spreadsheet operations** (rows, columns, cells, formulas, search) -> `references/spreadsheet-api.md`
- **Tree operations** (nodes, gates, cut sets, quantitative analysis) -> `references/tree-api.md`
- **Common operations** (save, callbacks, flags, links, change detection) -> `references/common-api.md`

----

Copyright 2026 The MathWorks, Inc.

----

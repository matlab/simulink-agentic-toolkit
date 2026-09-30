---
name: simulink-sanitize-model
description: Sanitize and anonymize a Simulink model for external sharing. Use when stripping proprietary content, anonymizing block/signal names, removing metadata, or creating a shareable reproduction model for bug reports. Do NOT use for simply copying or sharing a model internally.
license: https://www.mathworks.com/content/dam/mathworks/license/pmrl/license.md
metadata:
  author: MathWorks
  version: "1.0"
---

# Sanitize Model

Produces a self-contained, anonymized copy with all proprietary content removed.

## When to Use

- Anonymize a model before sharing externally
- Strip proprietary content from a model
- Create a shareable reproduction model for bug reports or support cases

## When NOT to Use

- Simply sharing a model internally — no sanitization needed
- Model editing/building — use `building-simulink-models`
- Model testing/simulation — use `testing-simulink-models` or `simulating-simulink-models`

---

## Model Selection

If the user named a model, use it directly. Otherwise, determine the model from the workspace context, asking the user to confirm only if it is ambiguous. Do NOT use `find_system` to detect open models.

---

## Scope Selection

Five areas: **Names & types** (blocks, signals, Stateflow, masks, bus/enum types) · **MATLAB code** (MATLAB Function blocks, `.m` files, callbacks, mask init) · **Configuration** (config set, codegen, custom code, hardware) · **Workspace** (parameters, variables, SLDD entries, codegen identifiers) · **Metadata** (descriptions, annotations, requirements, properties, DocBlocks, mask display).

By default run **all areas**. When the user targets specific content, select only relevant areas. Additional context (e.g., "make sure bus references stay consistent") is NOT a scope limitation. Before starting work, state which areas are selected (e.g., "Scope: **Names & types**, **MATLAB code**, **Metadata**"). Skip areas with no content after enumeration. Steps 1 (copy), 2 (enumerate), 8 (compile), and 9 (report) always run. All other steps run only when the selected scope requires them.

**Dependencies**: Renaming types requires propagating to all references — always include type propagation when renaming types. MATLAB code dot-notation bus accesses require type renames. Include dependencies automatically and tell the user why.

---

## Complexity Triage (do this first)

Before any other work, run `model_overview(model, 'root', 'tree')` **once** — pass the model name directly, do NOT use `find_system` to discover loaded models — and choose a path:

- **Fast Path** — NO Model References, NO Subsystem References, NO custom Library links. Single self-contained model. This is the common case.
- **Full Path (Steps 1–9)** — the model references other models, subsystems, or custom libraries.

---

## Fast Path (single self-contained model)

Skip all multi-model machinery: no `sanitize_tracker.mat`, no dependency gate, no recursion. Same output contract: `sanitized_bundle/` with `artifacts/` + `mappings/` + `sanitized_model_data.sldd`.

Follow Steps 2–9 with these differences:
- **Copy** to `sanitized_bundle/artifacts/sanitized_model.slx` with MATLAB `copyfile` (never the original name, whatever the scope). Create both bundle subdirectories.
- **Mapping** in `mappings/sanitized_model.md` only — no `globalTypeMap`, no `.mat`. Give the user the path with a short summary; do NOT print the full mapping inline.
- **Self-contain** (Step 7): ONE `sanitized_model_data.sldd` in `artifacts/` with `sanitized_config` + sanitized workspace variables, attached by **filename only**.

Minimize MATLAB calls — combine Steps 5–7 into as few calls as the model's complexity warrants. Step 8 (compile verification) must be its own call.

---

## Full Path

## Step 1: Discover Hierarchy & Create Working Copies

Never modify the original model. Copy using the **final output name** directly (`sanitized_model.slx`, `sanitized_ref_NNN.slx`, `sanitized_lib_NNN.slx`) — never the original name, whatever the scope. The working copy IS the output artifact.

### Initialize Global Tracker

Create `sanitize_tracker.mat` **before copying** with four `containers.Map` fields: `processedArtifacts` (originalName → sanitizedFilename), `globalTypeMap` (originalTypeName → sanitizedName), `filenameMap` (originalFilename → sanitizedFilename), and `configName` (string, empty). Only pull targeted values — do not dump full contents into context.

### Bundle Structure

Create `sanitized_bundle/artifacts/` and `sanitized_bundle/mappings/`. The `.mat` tracker is temporary and does NOT go in the bundle.

### Discover Model Reference Hierarchy

Discover all Model References in **leaf-to-root** order. Copy each with a sanitized filename, record in `filenameMap`. Diamond dependencies: copy once, map all references to the same file.

### Dependency Gate (before processing each model)

Before running Steps 2–7, confirm ALL Subsystem Reference and custom Library children are in `processedArtifacts`. Not yet processed → copy, record in `filenameMap`, and recursively sanitize first (Steps 2–7). Only proceed when ALL children are confirmed.

---

## Step 2: Enumerate Elements

Enumerate only what the selected areas require. Every element enumerated is a sanitization target — it must be renamed or cleared in Steps 4–6, or explicitly listed in the Unsanitized Items Report if it falls under a documented exclusion. Nothing enumerated may be silently left unchanged.

Query each source **once** and reuse throughout later steps — do NOT re-query. Extend `globalTypeMap` in `sanitize_tracker.mat` with newly discovered shared types; if a type is already in the tracker (from a previously processed child), keep its existing sanitized name.

### Source 1: Read the model

Use `model_read` as the primary map — use in place of `find_system`. Tailor the read to the selected scope. Do NOT also produce a hierarchy overview or call `find_system`/`get_param`.

### Source 2: Exceptions sweep

The read omits data types, object definitions, masks, callbacks, and config. Use `model_query_params` for block/config parameters from Source 1 IDs — do NOT use `find_system` or `get_param`. Reserve `evaluate_matlab_code` only for definitions no MCP tool surfaces.

**`model_query_params`** over Source 1 block IDs: `OutDataTypeStr` type refs (`Bus:`/`Enum:`) on Inport/Outport/DataStoreMemory/Constant/SignalSpecification [Names & types], masks and `MaskInitialization` [Names & types], block callbacks [MATLAB code], `CoderInfo.Identifier`/`HeaderFile` [Workspace]. For the config set [Configuration], query **only** parameters in `references/config-sanitization-params.md` — never query `"all"`.

**ONE MATLAB call** batching all items no MCP tool surfaces:
- **Model-level callbacks** [MATLAB code]: `InitFcn`, `StartFcn`, `StopFcn`, `PreLoadFcn`, etc. on the model itself — distinct from block callbacks; always query.
- workspace/SLDD object definitions (class, value, DataType, storage class, bus elements, enum members) [Workspace]
- Stateflow Data `Props.Type.BusObject` strings (including stale/ghost refs) [Names & types]
- DSM-scope Stateflow Data resolving to `Simulink.Signal` in SLDD [Names & types]

### MATLAB Code and External Functions Discovery [MATLAB code]

Sources to scan: MATLAB Function block code from Source 1; model callbacks, mask `Initialization`, and block dialog parameter expressions from Source 2; and any external `.m` files.

From these sources, identify two kinds of rename targets: (1) each MATLAB Function block's own function name, inputs, outputs, and local variables; and (2) all customer-defined function calls — distinguish **local** (defined in the same script) from **external** (separate `.m` files). External → global mapping (`ext_mlfcn_NNN`); local → per-model.

The MATLAB Function block's function name is MATLAB code — rename it when MATLAB code is in scope even if block names are out of scope (Simulink auto-renames the block to match).

---

## Step 3: Resolve Links

Break external links before modifying — editing linked blocks without breaking the link first fails silently or modifies the source.

Update Model References, Subsystem References, and custom Library links to point to sanitized child filenames. Preserve reference architecture — do NOT convert to local subsystems. Only break custom library links if the **user explicitly requests** it. Never modify official MathWorks libraries (`simulink/`, `sflib/`, `eml_lib/`, `hdllib/`).

---

## Step 4: Build Rename Mapping [Names & types, MATLAB code, Workspace]

Build the rename mapping from Step 2 data for the selected areas only — no MATLAB call needed.

Default naming: `<prefix>_NNN` (zero-padded). The user may specify alternatives — names must be generic and non-proprietary. Prefixes: Blocks → `<BlockType>` (e.g. `Gain_001`), Charts → `Chart`, Signals → `sig`, Bus objects → `BusType`, Bus elements → `field`, Enum types → `EnumType`, Enum values → `Val`, Parameters → `param`, Workspace vars → `var`, Stateflow states → `State`, Stateflow functions → `fcn`, Stateflow data → `sfData`, MATLAB Functions → `mlfcn`, External MATLAB functions → `ext_mlfcn`, MATLAB Function inputs/outputs/locals → `in`/`out`/`local`, Mask params → `maskParam`. Models → `sanitized_model`, `sanitized_ref_NNN`, `sanitized_lib_NNN`.

**Exception**: MATLAB Function inputs/outputs must use `in_NNN`/`out_NNN`/`local_NNN` (not `sig_NNN`) — backing Stateflow Data objects must match the function signature.

### Mapping Output

Update `globalTypeMap` in `sanitize_tracker.mat` for shared types. Write model-specific renames to `mappings/<sanitized_name>.md` as explicit `Original → Sanitized` entries for every renamed element. Give the user the file path with a **short summary** (do NOT print the full mapping inline).

---

## Step 5: Apply Renames

Apply renames to the current model. Query `globalTypeMap` from `sanitize_tracker.mat` for shared type names. Type and variable renames are global — apply identically in every model. Clear the metadata (e.g. `Description`) on every object you rename or copy.

**Minimize MATLAB calls**: Combine Steps 5–7 into as few calls as the model's complexity warrants. Step 8 (compile verification) must be its own call. Do NOT define local or anonymous helper functions inside a MATLAB call — inline the logic instead.

### Ordering Constraints

**Critical**: Rename types FIRST → propagate references → rename blocks deepest-first → remaining categories (order-independent). All renames target the **working copy only** — never clear or modify original workspace objects; create the renamed copy and leave the old intact. Track new variable names (`sanitizedVarNames`) for the SLDD in Step 7.

### Rename Data Types [Names & types]

Rename each bus object and its elements. Create the renamed copy — do NOT clear the original.

### Rename Blocks [Names & types]

Sort by path depth (deepest first). Do NOT rename internal blocks inside a Stateflow chart — they are not user content and renaming them breaks the chart.

### Propagate Type Renames to All References [Names & types]

Update everywhere the old type name appears. Most commonly impacted: `OutDataTypeStr` on Inport/Outport/DataStoreMemory/Constant/SignalSpecification, Bus Selector/Assignment `OutputSignals`, BusCreator `InputSignalNames`, Stateflow Data `Props.Type.BusObject`, and `Simulink.Parameter`/`Simulink.Signal` `DataType`.

### Remaining Renames (order-independent)

- **Signals** [Names & types]: Rename all named signal lines.
- **Data store names** [Names & types]: Keep `DataStoreMemory`/`DataStoreRead`/`DataStoreWrite` block name, `DataStoreName` param, and DSM-scope Stateflow data name identical — a mismatch breaks chart resolution at compile.
- **Workspace Variables** [Workspace]: Update block dialog parameters that reference the old variable name. When sanitizing a `Simulink.Parameter`/`Simulink.Signal` object, reset its code-gen settings by setting `CoderInfo.StorageClass = 'Auto'`.
- **Stateflow Elements** [Names & types]: States, functions, data objects. **Critical**: Scope every lookup to the working copy's machine (`chart.Machine.Name == model`), never `sfroot.find(...,'Name',<name>)`. Rename states and functions via the `Name` property.
- **Mask Parameters** [Names & types]: Rename via `Simulink.Mask.get(block)` — update `.Parameters(p).Name` and clear `.Prompt`.
- **MATLAB Code** [MATLAB code] (expanded below)

### MATLAB Code Anonymization [MATLAB code]

Anonymize all MATLAB code sources from Step 2. Rules:

1. Remove all comments
2. Update backing Stateflow Data objects (inputs/outputs) to match renamed arguments
3. Rename the MATLAB Function block name *after* updating its script — Simulink auto-renames the block to match the function name
4. For external functions not on the path, create an anonymized `.m` stub — never modify originals or inline the body. Stubs do NOT exempt the function from the Unsanitized Items Report.
5. Update all dot-notation bus field accesses (e.g., `sensorData.throttlePosition` → `in_001.field_003`) to match renamed elements.

---

## Step 6: Remove Metadata & Proprietary Content

**Metadata** [Metadata] — clear descriptions, annotations, requirements, model properties, DocBlocks, and mask display. `rmi('clearAll', model, 'noPrompt')` — ALWAYS pass `'noPrompt'`. `ModifiedBy`/`LastModifiedBy`/`ModifiedComment` are read-only. Model callbacks are MATLAB code, NOT metadata — sanitize in Step 5, never clear.

**Proprietary content** [Configuration, Workspace] — test harnesses (`sltest.harness.find`/`delete`), config `cs` per `references/config-sanitization-params.md`, code gen (config-set custom header/source code), file-referencing blocks (`FromFile`/`ToFile` → `'data_file.mat'`, `FromSpreadsheet` → `'data_file.xlsx'`), model workspace external `DataSource` (switch to self-contained).

### Proprietary Numeric Data (NOT replaced by default)

Lookup table data, block parameter values, workspace numeric data — **reported in the Unsanitized Items Report** for manual review. Replace with safe defaults only **if the user explicitly requests** it.

---

## Step 7: Resolve External References

Make the model fully self-contained. All models share ONE `sanitized_model_data.sldd` with sanitized variables and a shared config set.

**Config set** [Configuration]: Create ONE `sanitized_config` from the first model processed (resolve `ConfigSetRef` if needed). Store in the SLDD's **configuration section** using `addEntry(getSection(dd, 'Configurations'), 'sanitized_config', configCopy)`. Record in `sanitize_tracker.mat`. Subsequent models reference via `ConfigSetRef`.

**SLDD creation** [Workspace]: Create in `sanitized_bundle/artifacts/`. Add only sanitized/renamed variables. Merge if models had distinct SLDDs.

**Critical**: Call `Simulink.data.dictionary.closeAll('-discard')` before creating the SLDD — stale handles cause "already open" errors. Attach via `set_param(model, 'DataDictionary', ...)` with **filename only**, not a full path. For `Simulink.Signal` objects used as global data stores, set `Dimensions = 1` and `Complexity = 'real'` — these cannot be `-1` or `'auto'`.

After each model completes Steps 2–7, update `processedArtifacts` in `sanitize_tracker.mat`.

---

## Step 8: Qualification Gate

The sanitized model MUST compile in isolation. After ALL models are processed, generate `mappings/globals.md` from `sanitize_tracker.mat`, then delete the `.mat` file.

Run as its OWN MATLAB call after Step 7 save: `cd` into `artifacts/`, `Simulink.data.dictionary.closeAll('-discard')`, `bdclose('all')`, reload top-level model fresh and compile. Compiling transitively validates all child models and flushes stale cached names.

**Critical**: Save the model after compiling so propagated signal names are written to the shipped file.

After a successful compile, print exactly: `Compile verification: PASSED`

If compile fails due to a sanitization error, fix and retry. If structural or ambiguous, present the error to the user first.

The compile IS the verification — no SLDD re-inspection, no original-model diff, no unzipping. Only `exist`/`which` for stubs is permitted.

---

## Step 9: Report

### Change Table

Append remaining changes to mapping files — global changes to `globals.md`, per-model changes to `mappings/<sanitized_name>.md`.

### Unsanitized Items Report

Always produce — even if partially mitigated. Print a summary of all unsanitized items. Common categories include: S-Function/FMU blocks (binary, cannot rename/inspect), lookup table data and numeric values (not replaced unless user requested), external function dependencies (recipient must supply real implementation).

### Files When Sharing

Share `sanitized_bundle/`: `artifacts/` (`.slx`, `.sldd`, `.m` stubs) + `mappings/` (`globals.md` + per-model files).

---

## Guardrails

- **Never modify the original model** — always work on a copy
- **Never close or overwrite models already open**
- **Use MATLAB for all file operations** — never Bash `rm`/`mv`/`cp`
- **Escape `%` in `fprintf`** — use `%%` (e.g., `fprintf(fid, '%%#codegen')`). Unescaped `%` silently corrupts output.
- **Never use `clear all`** — destroys the MCP server channel. Use `bdclose('all')` and `Simulink.data.dictionary.closeAll('-discard')` instead.

----

Copyright 2026 The MathWorks, Inc.

----

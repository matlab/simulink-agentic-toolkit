---
name: finding-simulink-examples
description: Search the full catalog of shipped MathWorks example models with the invokeModelFinder helper script. Use when asked to find, show, or open a shipped example model, or to point someone at an example that demonstrates a concept.
license: https://www.mathworks.com/content/dam/mathworks/license/pmrl/license.md
metadata:
  author: MathWorks
  version: "1.0"
---

# Finding Simulink Examples

Use the `invokeModelFinder` helper script to search the **full catalog of shipped MathWorks example models**, then report the match.

`invokeModelFinder` searches a **database of every example MathWorks ships** across all products — well over 10,000 models. It is a database search, **not** a scan of the local disk: a hit means the example exists in the MathWorks database and comes with the command to open it, regardless of what is currently open or saved locally. Opening a match requires the owning product to be installed; the returned `open_command` (e.g. `openExample(...)`) handles that.

`invokeModelFinder` is a helper script that ships with this skill in its `scripts/` folder. It exists because the customer-facing `modelfinder` function is **interactive** — it opens a `Selection:` menu in the terminal and blocks, so it cannot be driven programmatically. `invokeModelFinder` is a thin, non-interactive wrapper that returns results directly. Call it with `evaluate_matlab_code`, setting `project_path` to the skill's `scripts/` folder so MATLAB can resolve the function (never use `addpath`):

```matlab
invokeModelFinder('<query>', '<filters_json>', '<max_results>', '<view>')
```

- `query` — free-text search. Examples: `'motor control'`, `'PID'`, `'battery'`; `'*'` lists everything.
- `filters_json` — JSON object of optional filters. Fields: `match`, `product`, `location`, `block`, `reference`. Use `'{}'` for no filters. Example: `'{"product": "Simscape Electrical", "block": "PID Controller"}'`.
- `max_results` — max results to return, as a string. Default `'20'`, clamped to `100`.
- `view` — result layout. `'Categorized'` (default) groups examples with their supporting models and surfaces the example-level `openExample(...)` command — best when the user wants **an example to open**. `'Models'` lists the underlying model files individually — use it when the user wants a specific **model file** rather than the example that contains it. Omit it to get `'Categorized'`.

It returns a YAML string with each match's `name`, `open_command`, and `description`. Use the `open_command` to open a result for inspection.

Treat the search behavior as a black box: don't assume how it ranks or combines terms.

**Refining your search.** If a query returns too many or off-target matches, narrow it rather than scanning a long list — re-run with a more specific `query`, or add `filters_json` fields to scope the results (`product` to a single product, `block` to a specific block, `reference` to models that reference a given model). Conversely, if a query returns nothing, loosen it: drop filters or use fewer, more general terms.

> **Older releases:** the `filters` and `view` options were added in R2025a. Before R2025a the helper ignores both and runs a plain keyword search — still pass all four arguments; the helper degrades gracefully on its own.

## When to Use

- The user asks you to **find, show, or open** a shipped example model
- The user wants you to **point them at an example that demonstrates a concept** or domain
- You need to identify which shipped example matches a description before doing anything with it

This skill searches **shipped MathWorks examples**, not the user's own project models. It does not find, list, or open models in the user's working directory or open project.

## Using the Result

- **Present the matches as a table** with three columns:
  - **Name** — the example/model name.
  - **Open command** — the returned `open_command`, verbatim, so the user can run it as-is.
  - **Description** — a short, concise summary (roughly one sentence) of what the example does; trim the returned `description` down rather than pasting it in full.
- Offer to open a match with its `open_command` if the user wants to view it.
- **Treat every match as read-only.** Inspect it, but never edit, delete, or `save_system` onto a shipped example. If the user wants to change one, save it under a new filename first and work on the copy.

----

Copyright 2026 The MathWorks, Inc.

----

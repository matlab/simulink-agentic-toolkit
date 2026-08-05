---
name: setup-custom-libraries
description: Register, add, or update existing custom Simulink block libraries and configure block policy and knowledge index. Use when a user wants to register, set up, configure, or add existing .slx library files for agent-assisted model building. Do NOT use when the user wants to create or author a new library from scratch — that requires building-simulink-models.
license: https://www.mathworks.com/content/dam/mathworks/license/pmrl/license.md
metadata:
  author: MathWorks
  version: "1.2"
---

# Setup Custom Libraries

Register or update custom Simulink block libraries so the agent prefers them over built-in blocks during model building.

## When to Use

- User asks to set up, register, add, or configure custom libraries
- User wants to add new `.slx` files to an existing library configuration
- User says "setup custom libraries", "add my library", "configure libraries", "add a new library file"
- `building-simulink-models` routes here via the policy gate (`gatePass: false`)
- **Never** invoke when `found: false` — that means no custom libraries are configured and the user hasn't asked for them

## When NOT to Use

- User wants to **create** a custom library from scratch (author new blocks, build a new `.slx` library file) → use `building-simulink-models` skill with `model_edit` directly. This skill only *registers* existing libraries; it cannot create library content.
- Only configuring block exclusions or parameter protection (libraries already declared) → `configuring-block-policy`
- Only curating block descriptions/categories (libraries already declared) → `curating-library-kg`

## Workflow

**Do this FIRST and ALONE — no other tool calls in the same message.**

Call `library.settingsLookup()` — returns a struct with resolved absolute paths:
- `found` — whether a libraries file was located (satk-libraries.json or legacy reuse-libraries.json)
- `enabled` — whether custom libraries are configured
- `gatePass` — whether the gate is satisfied
- `dataRoot` — absolute path to the directory containing `.satk/`
- `kgIndexPath`, `librariesPath`, `policyPath` — absolute paths to data files

**Interpret the result:**

- **`found: false`** → no custom libraries configured. Do NOT proceed with setup unless the user explicitly asked. Return control to the calling skill.
- **`gatePass: true, found: true`** → all data files present and KB populated. Offer management menu (below).
- **`gatePass: false, found: true`** → libraries declared but KB needs population. **Skip Gate 1** (libraries already exist). Start from Gate 2 below using `dataRoot` as the target.

Follow `references/library-setup.md` for all gate API details — it is the single source of truth for API calls, examples, and options at each gate.

**Gate 1 — Library declaration:** Only when the user explicitly asked to set up custom libraries and no libraries file exists yet. STOP and ask the user about reusable libraries. Present two options: **Yes** (declare libraries) or **None** (no libraries right now). Do not read reference files, open models, or plan blocks until they respond.

- If user provides libraries (**Yes**) → save to `prefdir` via `library.LibraryConfig.save(prefdir(), libraries)`.
- If user says **"none"** → do not create any files. The gate remains open (no config = use standard blocks).

**Gate 2 — Block policy:** If `.satk/block-policy.json` is missing, STOP and ask the user about policy setup by following `references/library-setup.md`. Do not proceed until policy is resolved.

**Gate 3 — Library blocks knowledge index:** If the KB is empty (index.md contains `populated: false`) or missing, STOP and ask the user whether to index their library blocks so the agent knows which blocks are available during model building. Offer two options: **Automatic** (agent infers categories/descriptions autonomously) or **Guided setup** (interactive curation). Both invoke the `curating-library-kg` skill. Follow `references/library-setup.md` for details. Do not proceed until KG generation completes.

### Management menu (config already complete)

Retrieve and display the user's current configuration status using the APIs in `references/library-setup.md` § "Status Display (Management Menu)". Show library names/paths, policy mode with fallback, and KG block/category counts. Then offer:

- **(a) Add or remove libraries** — load existing config via `library.LibraryConfig.load(dataRoot)`, append/remove entries, save via `library.LibraryConfig.save(dataRoot, allLibs)`, then invoke `curating-library-kg` skill (automatic mode) to regenerate KG.
- **(b) Update block policy** — load `configuring-block-policy` skill.
- **(c) Promote config to prefdir** — only show if tier is `project` or `legacy`. Copy `.satk/` folder to `prefdir/.satk/` (expand relative paths to absolute). See `references/library-setup.md` § "Gate 1" for the promote API.
- **(d) Regenerate knowledge index** — load `curating-library-kg` skill.

### Adding files to existing config

When `satk-libraries.json` already exists with declared libraries: read the existing config, append the new library entries, save via `library.LibraryConfig.save()`, then invoke the `curating-library-kg` skill (automatic mode) to infer categories/descriptions for the new blocks and regenerate the knowledge index.

## Guardrails

- **Never write config files or `.satk/` JSON manually.** Always follow the instructions and APIs in `references/library-setup.md` for each case.
- **Do not use `find_system`, `load_system`** to discover, validate, or enumerate library contents. All library operations must go through the specified APIs in `references/library-setup.md`.
- **Each gate requires explicit user input before proceeding.** Do not assume anything, wait for the response before moving to the next gate.
- **Paths at prefdir must be absolute.** (Project-level paths can be relative to project root.)

----

Copyright 2026 The MathWorks, Inc.

----

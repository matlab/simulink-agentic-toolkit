---
name: setup-custom-libraries
description: Declare, add, or update custom Simulink block libraries and configure block policy and knowledge index. Use when a user wants to register, set up, configure, or add new files to their custom libraries for agent-assisted model building.
license: MathWorks BSD-3-Clause
metadata:
  author: MathWorks
  version: "1.1"
---

# Setup Custom Libraries

Register or update custom Simulink block libraries so the agent prefers them over built-in blocks during model building.

## When to Use

- User asks to set up, register, add, or configure custom libraries
- User wants to add new `.slx` files to an existing library configuration
- User says "setup custom libraries", "add my library", "configure libraries", "add a new library file"
- `building-simulink-models` routes here via the policy gate

## When NOT to Use

- Only configuring block exclusions or parameter protection (libraries already declared) → `configuring-block-policy`
- Only curating block descriptions/categories (libraries already declared) → `curating-library-kg`

## Workflow

**Do this FIRST and ALONE — no other tool calls in the same message.**

Check all three files: `.satk/reuse-libraries.json`, `.satk/block-policy.json`, `.satk/library-kg/index.md`.

- **All three exist → setup already complete.** If they want to add new libraries, proceed to "Adding files" below.
- **`.satk/reuse-libraries.json` exists with `confirmedNone: true` → no custom libraries configured.** Ask the user if they want to change that. If not, setup is complete — skip Gates 2 and 3.
- **Any missing → run gates sequentially:**

Follow `reference/library-setup.md` for all gate resolution details — it is the single source of truth for API calls, examples, and options at each gate.

**Gate 1 — Library declaration:** If `.satk/reuse-libraries.json` is missing, STOP and ask the user about reusable libraries. Do not read reference files, open models, or plan blocks until they respond.
**Gate 2 — Block policy:** If `.satk/block-policy.json` is missing, STOP and ask the user about policy setup by following `reference/library-setup.md`. Do not proceed until policy is resolved.
**Gate 3 — Library knowledge index:** If `.satk/library-kg/index.md` is missing, STOP and ask the user about curating the library knowledge index by following `reference/library-setup.md`. Do not proceed until they respond.

If user confirms no libraries in Gate 1, save with `confirmedNone: true` and skip Gates 2 and 3.


### Adding files to existing config

When `.satk/reuse-libraries.json` already exists with declared libraries: read the existing config, append the new library entries, save via `library.LibraryConfig.save()`, then regenerate the knowledge index with `library.kg.Populate.run(projectRoot)` so new blocks are indexed.

## Guardrails

- **Never write `.satk/` JSON files manually.**  Always follow the instructions and APIs in `reference/library-setup.md` for each case.
- **Do not use `find_system`, `load_system`** to discover, validate, or enumerate library contents. All library operations must go through the specified APIs in `reference/library-setup.md`.
- **Each gate requires explicit user input before proceeding.** Do not assume anything, wait for the response before moving to the next gate.
  
----

Copyright 2026 The MathWorks, Inc.

----

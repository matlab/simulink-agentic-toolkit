<!-- Copyright 2026 The MathWorks, Inc. -->

# Library Reuse & Block Policy

Custom library blocks take priority over building equivalent logic from primitives. This reference covers the three prerequisite gates and how to use library blocks once configured.

## Gate 1: Library Config

Check if `.satk/reuse-libraries.json` exists in the project root (directory containing `.satk/`).

- **Exists:** proceed — libraries are already configured.
- **Missing:** ask the user if they have any reusable Simulink block libraries. They can provide either a **folder path** (containing `.slx` files) or **specific `.slx` file paths** or say none. Do not continue until the user responds.
 **Exists with `confirmedNone: true`:** no custom libraries — skip Gates 2 and 3
 
If a folder is provided , save each of the file seperately.

Example — saving user-provided libraries:

```matlab
projectRoot = '/path/to/project';
libraries(1).name = 'MotorLib';
libraries(1).path = 'libs/MotorLib.slx';
libraries(1).description = 'Motor control blocks';
library.LibraryConfig.save(projectRoot, libraries);
```

Example — user says "none":

```matlab
library.LibraryConfig.save(projectRoot, [], struct('confirmedNone', true));
```

## Gate 2: Block Policy

If libraries are declared and `.satk/block-policy.json` does not exist, ask the user whether to configure a policy.

- **Yes** — load the `configuring-block-policy` skill.
- **No / skip** — save defaults i.e prefer Custom Libraries over built-in, so the question isn't asked again, Always create this file via the below API and don't write it manually.

```matlab
policyData = library.BlockPolicy.defaults();
library.BlockPolicy.save(projectRoot, policyData);
```

If `.satk/block-policy.json` already exists, proceed directly.

Policy must be configured before the Knowledge Index.

## Gate 3: Knowledge Index

If libraries are declared and `.satk/library-kg/index.md` does not exist, provide the user with options to index and wait until the user responds:

If the KG generation produces zero blocks, inform the user and ask for the **folder path** containing all `.slx` sub-library files. Update `reuse-libraries.json` with the discovered files and regenerate.

- **Guided setup** — load the `curating-library-kg` skill and follow its interactive workflow (common blocks, categories, descriptions). The skill collects curation data, saves it to `.satk/library-curation.json`, and generates the KG in one pass. Do NOT proceed until the curation workflow completes.
- **Auto-generate** — single call that parses, caches, and generates the KG:

```matlab
library.kg.Populate.run(projectRoot);
```

The index is cached — it only regenerates when the library `.slx` or block policy changes. Skip this gate if `.satk/library-kg/index.md` already exists.

## Using Library Blocks

Before your first `model_edit` call in a session, read the Knowledge Index:

1. `.satk/library-kg/index.md` — library overview, policy mode, commonly used blocks
2. Category pages (e.g., `.satk/library-kg/control.md`) — blocks in a domain
3. Detail pages (e.g., `.satk/library-kg/blocks/SpeedController.md`) — use/avoid guidance

Use the exact block name from the KG in the `type` field of `add_block`. Do not invent names not listed in the KG. If no library block fits, fall back to built-in Simulink blocks.

## Block Policy Rules

The `policyMode` in `.satk/block-policy.json` is the source for fallback behavior:

| Mode | Behavior |
|------|----------|
| `approved_blocks_only` | Only use blocks in the KG. If nothing fits, ask the user. |
| `prefer_customer_libraries` | Prefer library blocks, fall back to built-ins when no match. |

- **Off-limits parameters** (marked with a warning in block detail pages) — the agent will not modify these values.
- **Excluded blocks** — removed from the KG entirely; the agent will never place them.

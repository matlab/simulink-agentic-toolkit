<!-- Copyright 2026 The MathWorks, Inc. -->

# Library Reuse & Block Policy

Custom library blocks take priority over building equivalent logic from primitives. This reference covers the three prerequisite gates and how to use library blocks once configured.

## Save Locations

| What | Where | How to get path |
|------|-------|-----------------|
| `satk-libraries.json` (library declarations) | `prefdir` (default) or project root | `prefdir()` |
| `.satk/block-policy.json` | Same directory as libraries file | — |
| `.satk/library-kg/` (Knowledge Index) | Same directory as libraries file | — |

Paths saved to prefdir must be absolute. Project-level paths can be relative.

The presence of `satk-libraries.json` is the signal that custom libraries are configured.

## Gate 1: Library Config

If no library config exists and the user explicitly asks to set up custom libraries, ask for their reusable Simulink block libraries. They can provide either a **folder path** (containing `.slx` files) or **specific `.slx` file paths**. Do not continue until the user responds.

If a folder is provided, save each `.slx` file as a separate library entry.

**User provides libraries:**

```matlab
dataRoot = prefdir();
libraries(1).name = 'MotorLib';
libraries(1).path = 'D:/SharedLibs/MotorLib.slx';
libraries(1).description = 'Motor control blocks';
library.LibraryConfig.save(dataRoot, libraries);
```

**User says "none":**

Do not create any files. The agent will proceed with standard Simulink blocks.

**Project-specific override (self-contained):**

```matlab
projectRoot = '/path/to/project';
library.LibraryConfig.save(projectRoot, libraries, struct('allowParentRelative', true));
```

**Promote project config to prefdir:**

```matlab
sourceRoot = '/path/to/project';
dataRoot = prefdir();

sourceSATK = fullfile(sourceRoot, '.satk');
destSATK = fullfile(dataRoot, '.satk');
if isfolder(destSATK)
    rmdir(destSATK, 's');
end
copyfile(sourceSATK, destSATK);
```

## Gate 2: Block Policy

If libraries are declared and `.satk/block-policy.json` does not exist, ask the user which block source to apply. Do not continue until the user responds.

| User's answer | `blockSource` value |
|---------------|---------------------|
| Only use blocks from my libraries | `library_blocks_only` |
| Prefer my libraries, built-ins when nothing fits (default) | `prefer_library_blocks` |

Write the answer with the below API — never hand-write the file. A skip or no answer means the default value; write it anyway, so the question isn't asked again.

```matlab
satk.Configuration.setPolicy('blockSource', 'library_blocks_only', Location=dataRoot);
```

Blocked blocks and protected parameters are optional; ask only if the user raises them. Each is a separate `setPolicy` call. Substitute the user's own library, block, and parameter names — the placeholders below are not real blocks. Note the double braces: `struct` needs them to store a cell array in a field.

```matlab
satk.Configuration.setPolicy('blockedBlocks', {'<libName>/<blockName>'}, ...
    Location=dataRoot);
satk.Configuration.setPolicy('protectedParams', ...
    {struct('block', '<libName>/<blockName>', 'params', {{'<paramName>'}})}, ...
    Location=dataRoot);
```

If `.satk/block-policy.json` already exists, proceed directly.

Policy must be configured before the Knowledge Index.

## Gate 3: Library Blocks Knowledge Index

If libraries are declared and the Knowledge Index is empty or missing, provide the user with options to index their library blocks and wait until the user responds:

- **Automatic** — load the `simulink-curating-library-kg` skill. The agent reads `.satk/library-cache/*.json`, infers categories and descriptions from block metadata, saves curation to `.satk/library-curation.json`, and generates the Knowledge Graph — all without asking the user for input. Present the results to the user for review after generation.
- **Guided setup** — load the `simulink-curating-library-kg` skill and follow its interactive workflow (categories, descriptions). The skill collects curation data with user input at each step, saves it to `.satk/library-curation.json`, and generates the Knowledge Graph. Do NOT proceed until the curation workflow completes.

Both paths use the `simulink-curating-library-kg` skill. The difference is whether the agent proposes and commits autonomously (automatic) or pauses for user confirmation at each step (guided).

Do not use `find_system`, `load_system`, or `get_param` on library `.slx` files to build or populate the index.

If the Knowledge Index generation produces zero blocks, inform the user and ask for the **folder path** containing all `.slx` sub-library files. Update `satk-libraries.json` with the discovered files and regenerate.

The index is cached — it only regenerates when the library `.slx` or block policy changes. Skip this gate if `library.settingsLookup()` returns `gatePass: true`.

## Status Display (Management Menu)

When all gates are satisfied (`gatePass: true, found: true`), display current configuration status before offering menu options.

**Retrieve status data:**

```matlab
% 1. Library names and paths (from settingsLookup dataRoot)
config = library.LibraryConfig.load(dataRoot);
% config.libraries(i).name, .path, .description
numLibraries = numel(config.libraries);

% 2. Block source and fallback
policyData = satk.Configuration.getPolicy(Location=dataRoot);
% policyData.blockSource — 'prefer_library_blocks' | 'library_blocks_only'
% policyData.fallbackToBuiltins — logical

% 3. KG categories and block counts — one line per category, "(N blocks)"
kgIndex = fileread(fullfile(dataRoot, '.satk', 'library-kg', 'custom', '<lib>', 'index.md'));
```

## Using Library Blocks

Before your first `model_edit` call in a session, read the Knowledge Index:

1. `.satk/library-kg/index.md` — overview
2. `custom/<lib>/index.md` or `toolboxes/<kb>/index.md` — the library's category pages
3. Category pages (e.g., `.satk/library-kg/custom/motorlib/control.md`) — all blocks in a domain with intent

Use the exact block name from the Knowledge graph in the `type` field of `add_block`. Do not invent names not listed in the Knowledge graph. If no library block fits, fall back to built-in Simulink blocks.

## Block Policy Rules

The `blockSource` policy in `.satk/block-policy.json` decides fallback behavior:

| `blockSource` | Behavior |
|------|----------|
| `library_blocks_only` | Only use blocks in the Knowledge graph. If nothing fits, ask the user. |
| `prefer_library_blocks` | Prefer library blocks, fall back to built-ins when no match. |

- **Off-limits parameters** (protected in block policy) — the agent will not modify these values.
- **Excluded blocks** — removed from the Knowledge graph entirely; the agent will never place them.

----

Copyright 2026 The MathWorks, Inc.

----

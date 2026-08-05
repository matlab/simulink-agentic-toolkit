---
name: curating-library-kg
description: Guide users through curating the library knowledge index — reviewing block categories, marking common/important blocks, and improving block descriptions via agent inference for better agent block selection.
license: https://www.mathworks.com/content/dam/mathworks/license/pmrl/license.md
metadata:
  author: MathWorks
  version: "2.1"
---

# Curating the Library Knowledge Index

Curate `.satk/library-kg/` for better agent block selection. Infer categories and descriptions from block metadata in `.satk/library-cache/*.json`, save curation to `.satk/library-curation.json`, then regenerate the KG.

## When to Use

- User wants to mark blocks as commonly used or important
- User wants to correct auto-assigned categories
- User wants to improve block descriptions for better selection
- User asks "how do I make the agent prefer certain blocks?"
- Called from `building-simulink-models` Gate 3.

## When NOT to Use

- Blocking, deprecating, or protecting blocks → `configuring-block-policy`
- Actively building a model → `building-simulink-models`
- Declaring which libraries exist → Library Setup gate in `building-simulink-models`

## Prerequisites

- `satk-libraries.json` or  `.satk/reuse-libraries.json`  must exist with libraries declared

## Curation Rules

1. **Custom descriptions are mandatory for ALL `metadataQuality: "low"` and `"medium"` blocks across ALL declared libraries.** These blocks have no useful information. Write a short intent-focused description for every such block to help with agent block selection. Do not skip blocks because a file is large or because they seem unrelated to the current task.
2. **Custom descriptions for `"high"` quality blocks are encouraged but optional.** 
3. **Write custom descriptions for as many blocks as possible.** After covering low/medium, covering high blocks too improves the KG.
4. **Process in batches by category.** Group blocks, infer descriptions together, present to user in digestible chunks.
5. **Never write template or mechanical descriptions.** Descriptions like "Mathematical operation: gain" or "Signal routing utility: mux" are useless — they just restate the category and name. Every description MUST be thoughtful, intent-focused description explaining *when* to use the block and *what modeling problem* it solves (e.g., "Scale a signal by a constant factor — use for unit conversion, controller gains, or applying physical constants" instead of "Mathematical operation: gain").

## Modes

- **Automatic** (from Gate 3 "Automatic" option) — infer everything, commit without pausing per step, present final result for review.
- **Guided** (from Gate 3 "Guided setup" or direct user invocation) — propose at each step, wait for user confirmation before proceeding.

Determine mode before starting. Do not proceed without mode selection.

## Workflow

If `.satk/library-kg/index.md` already exists, start at step 1 (review existing state). If not, start at step 2.

1. **Review** (only if KG exists) — Read `index.md` and `common.md`, summarize current state to user (libraries, block count, categories, common blocks).
2. **Mode selection** — Determine Automatic or Guided. Do not proceed without completing this step.
3. **Descriptions** — Ensure cache exists (see API), then read ALL `.satk/library-cache/*.json` files **in full**. If a file exceeds read limits, read it in chunks until every block has been processed. Apply Curation Rules above — write custom descriptions for blocks, prioritizing low/medium quality. Do NOT proceed to Step 4 until descriptions exist for every low/medium quality block across ALL cache files. Save to `customDescriptions`.
4. **Common blocks** — Propose which blocks should be marked as commonly used. Consider blocks covering diverse categories and frequent modeling workflows. Save to `commonBlocks`.
5. **Categories** — Finalize category definitions (names, descriptions, 3-5 keywords each). Allow user to correct individual block assignments via `categoryAssignments`.
6. **Completeness check** — Before saving, count total low/medium quality blocks across ALL cache files and count how many have custom descriptions. Report coverage to the user (e.g., "275/275 low/medium blocks described, 120/285 high blocks described"). Do NOT proceed if coverage of low/medium blocks is below 100%.
7. **Save and generate** — Save all curation data via `library.LibraryCuration.save(projectRoot, curation)`, then run `library.kg.Populate.run(projectRoot)`. Present the output summary to the user.

## API

### Ensuring cache exists

```matlab
libConfig = library.LibraryConfig.load(projectRoot);
library.LibraryCatalog.getOrCreate(libConfig, projectRoot);
```

### Reading block metadata

Read `.satk/library-cache/*.json` directly. Each file:
```json
{
  "libraryName": "MotorLib",
  "description": "Motor control library",
  "blocks": [
    {
      "name": "SpeedController",
      "maskType": "SpeedCtrl",
      "blockType": "SubSystem",
      "maskDescription": "Closed-loop speed regulation with anti-windup",
      "description": "",
      "pathCategory": "Controllers",
      "metadataQuality": "high",
      "referenceBlock": "MotorLib/Controllers/SpeedController"
    }
  ]
}
```

### Saving curation data

```matlab
projectRoot = prefdir();
curation = library.LibraryCuration.load(projectRoot);
curation.commonBlocks = {'Speed Controller', 'Torque Estimator'};
curation.categories = struct('name', 'motors', 'description', 'Electric motors', 'keywords', {{'motor', 'drive'}});

% Use containers.Map — supports any block name as key
curation.customDescriptions = containers.Map('KeyType', 'char', 'ValueType', 'char');
curation.customDescriptions('Unit Delay') = 'Delay signal by one sample period';
curation.customDescriptions('1-D Lookup Table') = 'Interpolate output from breakpoint-value pairs';

curation.categoryAssignments = containers.Map('KeyType', 'char', 'ValueType', 'char');
curation.categoryAssignments('DC Current Controller') = 'motor-control';

library.LibraryCuration.save(projectRoot, curation);
library.kg.Populate.run(projectRoot);
```

**Important:** Use `containers.Map` (not struct) for `customDescriptions` and `categoryAssignments`. Struct field names cannot contain spaces or hyphens, which most Simulink block names have.

### JSON format on disk

```json
{
  "customDescriptions": [
    {"block": "Unit Delay", "value": "Delay signal by one sample period"},
    {"block": "1-D Lookup Table", "value": "Interpolate output from breakpoint-value pairs"}
  ],
  "categoryAssignments": [
    {"block": "DC Current Controller", "value": "motor-control"}
  ]
}
```

## Curation Fields

| Field | Type | Effect |
|-------|------|--------|
| `commonBlocks` | cell array of strings | Always shown in `common.md` regardless of quality score |
| `categories` | struct array with `.name`, `.description`, `.keywords` | Defines categories with keyword matching for assignment |
| `categoryAssignments` | `containers.Map` (blockName → categoryName) | Per-block category assignment |
| `customDescriptions` | `containers.Map` (blockName → description) | Per-block custom description (intent) |

## Guardrails

- **Never call `find_system`, `get_param` on library `.slx` files.** Read `.satk/library-cache/*.json` for metadata, use `library.kg.Populate.run()` to generate the KG, and `library.kg.Query.search()` for lookups.
- Never modify `.satk/library-cache/*.json` or `.satk/library-kg/*.md` directly — they are auto-generated.
- Persist curation via `library.LibraryCuration.save()` only.
- Confirm changes with the user before saving.
- In user-facing output, do not use the term 'override'. Use 'custom description' or 'category assignment' instead.
anges with the user before saving
- For progress tracking during curation, do not mention the term 'override' in user-facing output. Use 'custom description' or 'category assignment' instead.

----

Copyright 2026 The MathWorks, Inc.

----

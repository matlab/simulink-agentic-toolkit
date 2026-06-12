---
name: curating-library-kg
description: Guide users through curating the library knowledge index — reviewing block categories, marking common/important blocks, and improving block descriptions for better agent block selection.
license: MathWorks BSD-3-Clause
metadata:
  author: MathWorks
  version: "1.0"
---

# Curating the Library Knowledge Index

Guide users through curating `.satk/library-kg/` for better agent block selection. Users can mark common blocks, define categories, and improve descriptions. Curation data is saved to `.satk/library-curation.json` and applied when the KG is generated — no pre-existing KG is required.

## When to Use

- User wants to mark blocks as commonly used or important
- User wants to correct auto-assigned categories
- User wants to improve block descriptions for better selection
- User asks "how do I make the agent prefer certain blocks?"
- Called from `building-simulink-models` Gate 3 when user chooses "Guided setup"

## When NOT to Use

- Blocking, deprecating, or protecting blocks → `configuring-block-policy`
- Actively building a model → `building-simulink-models`
- Declaring which libraries exist → Library Setup gate in `building-simulink-models`

## Prerequisites

- `.satk/reuse-libraries.json` must exist with libraries declared

## Workflow

If `.satk/library-kg/index.md` already exists, start at step 1 (review existing state). If not, start at step 2 (collect curation data first, generate at the end).

1. **Review** (only if KG exists) — Read `index.md` and `common.md`, summarize current state to user (libraries, block count, categories, common blocks).
2. **Common blocks** — Ask which blocks the user wants prioritized. To help them decide, list the library's block categories using `LibraryCatalog` (see API below). Save to `commonBlocks` field.
3. **Categories** — Show default or auto-assigned categories. User can correct individual blocks via `categoryOverrides` or define entirely custom categories.
4. **Descriptions** — For blocks with weak metadata, ask user for better descriptions. Save to `descriptionOverrides`.
5. **Save and generate** — Save all curation data to `.satk/library-curation.json` via `library.LibraryCuration.save(projectRoot, curation)`, then run `library.kg.Populate.run(projectRoot)`. The KG is generated with all curation applied in one pass. Confirm the output with the user.

## API

### Listing library blocks (for step 2)

Use `LibraryCatalog` to load and display all available blocks from declared libraries. The constructor parses `.slx` libraries (or loads from cache) and `getContextSummary()` returns a formatted summary of all blocks grouped by category:

```matlab
libConfig = library.LibraryConfig.load(projectRoot);
catalog = library.LibraryCatalog(libConfig, projectRoot);
summary = catalog.getContextSummary();
disp(summary);
```

### Saving curation data

All curation state is persisted to `.satk/library-curation.json` via `LibraryCuration.save()`:

```matlab
curation = library.LibraryCuration.load(projectRoot);
curation.commonBlocks = {'SpeedController', 'TorqueEstimator'};
curation.categories = struct('name', 'motors', 'description', 'Electric motors', 'keywords', {{'motor', 'drive'}});
curation.categoryOverrides = struct('OldBlock', 'motors');
curation.descriptionOverrides = struct('MyBlock', 'Better description here');
library.LibraryCuration.save(projectRoot, curation);
library.kg.Populate.run(projectRoot);
```

## Curation Fields

| Field | Type | Effect |
|-------|------|--------|
| `commonBlocks` | string array | Always shown in `common.md` regardless of quality score |
| `categories` | array of `{name, description, keywords}` | Replaces hardcoded categories when present |
| `categoryOverrides` | object `{blockName: categoryName}` | Per-block category correction |
| `descriptionOverrides` | object `{blockName: description}` | Per-block custom description |

## How Common Block Selection Works

1. **User-specified** (`commonBlocks`): always first, regardless of quality
2. **Algorithmic**: fills remaining slots up to 30 total — high-quality preferred, max 5 per category for diversity

## Guardrails

- Never modify `.satk/library-cache/*.json` or `.satk/library-kg/*.md` directly — they are auto-generated
- Persist curation via `library.LibraryCuration.save()` (writes `.satk/library-curation.json`)
- Always regenerate KG after saving changes
- Confirm changes with the user before saving

----

Copyright 2026 The MathWorks, Inc.

----

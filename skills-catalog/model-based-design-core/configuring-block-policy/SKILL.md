---
name: configuring-block-policy
description: Guide users through creating and managing .satk/block-policy.json for controlling which blocks the agent can use, which are excluded, and which block parameters the agent should not modify. Use when setting up block usage policy for a project.
license: MathWorks BSD-3-Clause
metadata:
  author: MathWorks
  version: "1.0"
---

# Configuring Block Policy

Create or update `.satk/block-policy.json` — the file that controls which blocks (library or built-in) the agent can use, which are excluded, and which block parameters the agent should not modify.

## When to Use

- User asks to set up, create, or configure block policy
- User asks to restrict or exclude blocks
- User wants to prevent the agent from modifying certain block parameters
- `building-simulink-models` routes here via the policy gate

## When NOT to Use

- Actively building a model → `building-simulink-models`
- Improving block descriptions or categories → `curating-library-kg`
- Declaring which libraries exist → Library Setup gate in `building-simulink-models`

## Prerequisites

None. Block policy can be configured independently — for custom library blocks, built-in blocks, or both.

## Workflow

1. **Check state** — Does `.satk/block-policy.json` exist? If yes, load and summarize. If no, start fresh.
2. **Policy mode** — (skip if no libraries specified) Ask: prefer libraries with built-in fallback, or custom libraries blocks only (no fallback)?
3. **Excluded blocks** (optional) — Are there any blocks (library or built-in) that should never be placed in your models? Collect `referenceBlock` + `reason`.
4. **Off-limits parameters** (optional) — Are there any block parameters you don't want the agent to modify? Collect `referenceBlock` + `protectedParams[]`.
5. **Save** — Validate and write with `library.BlockPolicy.save()`.

## API

```matlab
policyData = struct();
policyData.policyMode = 'approved_blocks_only';
policyData.fallbackToBuiltins = false;
% Excluded — agent will never place these blocks
policyData.blockedBlocks = struct('referenceBlock', 'LegacyLib/OldCtrl', 'reason', 'Superseded');
% Protected params — agent won't modify these values
policyData.blockRules = struct('referenceBlock', 'Lib/SpeedCtrl', ...
    'protectedParams', {{'Kp', 'Ki', 'Kd'}});

library.BlockPolicy.save(projectRoot, policyData);
```

For defaults (no restrictions):

```matlab
policyData = library.BlockPolicy.defaults();
library.BlockPolicy.save(projectRoot, policyData);
```

## Schema

```json
{
  "schemaVersion": 1,
  "policyMode": "approved_blocks_only | prefer_customer_libraries",
  "fallbackToBuiltins": false,
  "blockedBlocks": [
    { "referenceBlock": "LegacyLib/OldController", "reason": "Superseded" }
  ],
  "blockRules": [
    { "referenceBlock": "Lib/SpeedController", "protectedParams": ["Kp", "Ki", "Kd", "SampleTime"] }
  ]
}
```

## Validation Rules

- `policyMode`: must be `prefer_customer_libraries` or `approved_blocks_only`
- `approved_blocks_only` + `fallbackToBuiltins: true` → rejected (contradictory)
- `protectedParams` must be a non-empty array of strings
- Malformed policy → error (never silently ignored)

## Updating an Existing Policy

When `.satk/block-policy.json` already exists:

1. Load with `library.BlockPolicy.loadRaw(projectRoot, libConfig)`
2. Summarize current state — do NOT re-run the full wizard
3. Ask what to change, apply to existing struct, save

Common updates: exclude a block, mark params as off-limits, change mode, remove an entry.

## Guardrails

- Never write `block-policy.json` without user confirmation
- Always validate before saving (`library.BlockPolicy.validate(policyData)`)
- If user provides a block name without the full library path, look it up in the KG to resolve the `referenceBlock`

----

Copyright 2026 The MathWorks, Inc.

----

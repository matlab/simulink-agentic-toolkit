# Coverage Filter Authoring API (`.cvf`, programmatic)

Programmatic authoring API for a coverage filter (`.cvf`), for an outcome the analysis
judged **intentional dead logic** (or an intentionally-unused block). Justifying an outcome
is an audit action — only write a filter on explicit user approval, and record the user's
rationale, never a fabricated one.

Source: Simulink Coverage User's Guide, "Filter Coverage Results Using a Script."
Enum values below are verified against `enumeration('slcoverage.MetricSelectorType')`.

## Classes

| Class | Role |
|---|---|
| `slcoverage.Filter` | Container; holds rules, saves to a `.cvf`. `setFilterName` / `setFilterDescription` / `addRule` / `save`. |
| `slcoverage.FilterRule` | One rule: selector + rationale + mode. |
| `slcoverage.MetricSelector` | Selects a specific **outcome** (fine-grained) — the tool for intentional dead logic. |
| `slcoverage.BlockSelector` | Selects a block / subsystem (block-level). |
| `slcoverage.Selector` | Base class; static `allSelectors` discovers selectors without hand-indexing. |

## Enumerations (verified)

- `slcoverage.MetricSelectorType`: `DecisionOutcome`, `ConditionOutcome`,
  `RelationalBoundaryOutcome`, `SaturationOverflowOutcome`, `MCDCOutcome`.
- `slcoverage.FilterMode`: `Justify`, `Exclude`.
- `slcoverage.BlockSelectorType`: `BlockInstance`, `SubsystemAllContent`, `Subsystem`,
  `BlockType`, `MaskType`, `Chart`, `State`, `StateAllContent`, `Transition`, etc.

## Justify vs. Exclude

- **Justify** — the outcome/block **stays in the report** but no longer counts as
  unsatisfied; it is shown with its rationale and counted as satisfied in the percentage
  (`(covered + justified)/possible`). Use for individual dead outcomes. **This is the mode
  for intentional dead logic.**
- **Exclude** — the element is removed from analysis entirely (block + descendants
  ignored). Use only to drop a genuinely out-of-scope block/subsystem.

Guide guidance: "Use justify mode to filter individual coverage objective outcomes... Use
exclude mode to filter entire model elements or blocks."

## Selecting a specific outcome

```matlab
% Preferred: discover selectors for the block, then pick the right outcome —
% avoids hand-guessing objective/outcome indices.
sels = slcoverage.Selector.allSelectors('model/Saturation');   % heterogeneous array
% each MetricSelector carries ObjectiveIndex / OutcomeIndex / Type / Description

% Or construct directly (type, blockPathOrID, objectiveIndex, outcomeIndex; 1-based):
sel = slcoverage.MetricSelector( ...
        slcoverage.MetricSelectorType.DecisionOutcome, 'model/Saturation', 1, 1);
```

Map the extractor's Tier-2 detail to the constructor: the owning block path is `node.path`;
`objectiveIndex` / `outcomeIndex` are the 1-based positions within that block's objectives /
outcomes. When unsure of the indices, prefer `allSelectors` and match on the outcome
`Description`.

## End-to-end: justify one dead outcome

```matlab
filt = slcoverage.Filter;
setFilterName(filt, 'intentional_dead_logic');
setFilterDescription(filt, 'Outcomes proven unreachable and confirmed intentional');

rule = slcoverage.FilterRule(sel, USER_RATIONALE, slcoverage.FilterMode.Justify);
filt.addRule(rule);

filt.save('myfilter');           % writes myfilter.cvf (extension added automatically)

covData.filter = 'myfilter';     % apply to the cvdata — no resimulation
decisioninfo(covData, 'model/Saturation')   % re-query: justified outcome now counts satisfied
```

`USER_RATIONALE` must come from the engineer. Do not invent it. Applying the filter is
non-destructive (assigns `cvdata.filter`); it does not modify the model.

----

Copyright 2026 The MathWorks, Inc.

----

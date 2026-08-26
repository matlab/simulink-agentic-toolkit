# Script Output Contracts

The exact return shape of each `scripts/` producer — field names, nesting, and what an
absent field means. Consume the structs by these contracts; do not probe `fieldnames` and
guess paths, and do not read script source at runtime.

## resolveCoverageData(source) → candidates

`candidates` is a struct array, one element per distinct cvdata found (a `cvsim` result, a
`Simulink.SimulationOutput`, a Simulink Test result object, or a `.cvt` path). When a source
yields more than one unit (Simulink Test array, multi-entry `.cvt`, sim run + cumulative), it
returns them ALL — choosing and asking is the orchestrator's job.

| Field | Type | Meaning |
|---|---|---|
| `.cvdata` | object | the `cvdata` / `cv.cvdatagroup` itself |
| `.model` | char | analyzed model name |
| `.kind` | char | provenance: `cvsim` \| `cvt` \| `sim_run` \| `sim_cumulative` \| `simulinktest` |
| `.label` | char | short human-readable label for disambiguation |

Errors (actionable message) only when a source carries no coverage at all.

## getCoverageSummary(cvd) → covSummary

Pure read of one `cvdata` (single unit) or `cv.cvdatagroup` (one member per referenced
model). `sim_mode` / `enabled_metrics` are read BACK from the result, not set.

**Metric-key rule (applies everywhere):** a metric key is PRESENT iff it has objectives on
that unit/node — test with `isfield`, never `covered == []`. Keys are ENGINE names, not
display names: `decision`, `condition`, `mcdc`, `tableExec`,
`cvmetric_Structural_relationalop`, `cvmetric_Structural_saturate`, `cvmetric_Sldv_proof`.

| Field | Type | Meaning |
|---|---|---|
| `.run.model` | char | analyzed model name |
| `.run.container_kind` | char | `cvdata` \| `cvdatagroup` |
| `.run.sim_mode` | char | read back (e.g. `Normal`) |
| `.run.enabled_metrics` | cellstr | THE list to iterate (engine keys above) |
| `.members(k)` | struct array | one per coverage unit (`N == 1` for a single-model `.cvt`) |

Each `.members(k)`:

| Field | Type | Meaning |
|---|---|---|
| `.name` | char | this unit's model |
| `.root_id` / `.top_slsf` | ids | internal engine cvIds (rarely needed) |
| `.rollup.by_metric.<metric>` | struct | model-root rollup, DEEP (subtree-inclusive): `.covered` / `.total` (double), `.percent` (double, `[]` when `total == 0`) |
| `.nodes(i)` | struct array | one row per hierarchy node (below) |
| `.reduced_blocks(r)` | struct array | optimizer-eliminated blocks `{ssid, path, rationale}`. NOT gaps — never instrumented, cannot be covered by adding tests |

Each `.nodes(i)`:

| Field | Type | Meaning |
|---|---|---|
| `.kind` | char | `system` (DEEP rollup) \| `block` (that block alone). System and block rollups OVERLAP by design — walk via `.parent`, NEVER sum across kinds |
| `.cv_id` / `.parent` | ids | `.parent` is the parent system's `cv_id`, `0` at the model root |
| `.ssid` / `.path` | char | Simulink SID / full block path |
| `.excluded` | logical | whole-block coverage-filter exclusion |
| `.exclude_rationale` | char | filter text (empty unless excluded) |
| `.by_metric.<metric>` | struct | rollup shape above, PLUS optional `.detail` on nodes that own objectives (leaf blocks) |

`.by_metric.<metric>.detail`:

- `.objectives(o)` — `.text`; `.achieved` (`[]` except mcdc: per-condition independence
  flag); `.coverage_point` / `.predicate` (SLDV join keys); `.filtered` / `.justified` /
  `.rationale`.
  - `.outcomes(j)` — `.text`; `.covered` (logical — **the gap test**); `.count` (`[]` if
    metric exposes none); `.outcome_value` (SLDV join key); `.filtered` / `.justified` /
    `.rationale`.

## detectDeadLogicObjectives(model, metrics) → [dead, status]

Runs SLDV dead-logic detection; returns proven-dead objectives, each carrying the identity
`getCoverageSummary` stamped so the join is a text-free exact match. Only
decision/condition/mcdc drive detection; other metric keys are ignored.

`dead` — struct array, one element per dead objective:

| Field | Type | Meaning |
|---|---|---|
| `.ssid` | char | Simulink SID of the owning object (e.g. `model:13`, or Stateflow `model:2:8`). PRIMARY join key — stable across block diagrams and Stateflow |
| `.slPath` | char | normalized block path (newline → space). Display only — not a join key (ambiguous for Stateflow) |
| `.metric` | char | `decision` \| `condition` \| `mcdc` |
| `.coverage_point` | double | SLDV coveragePointIdx |
| `.predicate` | double | SLDV predicateIdx, or `[]` when -1 (dec/cond) |
| `.outcome_value` | double | SLDV outcomeValue |
| `.label` / `.descr` | char | SLDV objective label / description (verbatim) |

`status` — `ran` \| `timeout` \| `skipped_no_license` \| `no_applicable_metrics` \| `error`.
`timeout` (sldvrun status -1) is a VALID partial result: proven-dead objectives are still
returned; it is NOT a completeness proof.

## markSldvDeadLogic(covSummary, dead) → covSummary

Pure deterministic marker — exact key match `(ssid, metric, coverage_point, predicate,
outcome_value)`, no SLDV/model/IO/heuristics. Adds to `covSummary`:

- Every decision/condition/mcdc **outcome** gets a logical `.dead` (default `false` — an
  affirmative "SLDV says reachable"). A matched dead outcome gets `.dead = true` plus
  `.dead_label` / `.dead_descr` (verbatim SLDV text).
- Each such **objective** gets `.has_dead_outcome` (rollup of its outcomes).
- `covSummary.dead_analysis`:

| Field | Type | Meaning |
|---|---|---|
| `.matched` | double | count of dead objectives placed onto an outcome |
| `.unmatched` | struct array | dead objectives that matched NO outcome (empty when none; same fields as `dead`). Never silently dropped — surface them |
| `.contradictions` | struct array | dead objectives that matched a COVERED outcome (empty when none). SLDV proved dead yet coverage shows hit — surface loudly |

The `.dead` field is added ONLY to decision/condition/mcdc. For other metric families
(relationalop/overflow/tableExec/designverifier) the field is ABSENT — meaning "not analyzed
for dead logic", distinct from an affirmative `dead = false`.

## traceObjectiveInputs(model, blockPaths[, maxDepth]) → [traces, status]

Model Slicer trace of the upstream cone driving each block. Each `blockPaths` entry is an
objective identifier — a full block path (`node.path`) OR a coverage ssid (`node.ssid`);
both accepted because a Stateflow state/transition objective has an empty `node.path`.
`maxDepth` caps the dependency chain (default 10); the chain is feedback-safe regardless.
Pure producer — it runs the slicer and returns evidence; it makes NO intent judgment and
performs NO fallback of its own.

`traces` — struct array, one per `blockPaths` entry, in order:

| Field | Type | Meaning |
|---|---|---|
| `.slPath` | char | the identifier, verbatim as passed |
| `.controllable_inputs` | struct array | `{path, type, port_number, signal_name}` — Inport/FromWorkspace/FromFile blocks in the upstream cone (from the RAW slice, so real leaf inputs report their true type) |
| `.dependency_chain` | struct array | `{path, type, depth, expression}` — BFS backward, depth 0 = the block itself, only through blocks the slice kept active |
| `.method` | char | `slicer` (this block was traced) \| `unavailable` (this block did not trace) |

`status` — `ran` \| `skipped_no_license` \| `error`. When `skipped_no_license` / `error`,
every trace is `method == 'unavailable'`.

**Fallback contract — act on `method == 'unavailable'`.** A block reports `unavailable`
when the Model Slicer has no Simulink Check license or that block failed to slice; its
`controllable_inputs` and `dependency_chain` come back empty. This producer does not
recover — the orchestrator MUST fall back to reading the block's structure with the SATK
`model_read` / `model_overview` tools and reason from there. Do not treat an `unavailable`
trace as "no inputs found."

----

Copyright 2026 The MathWorks, Inc.

----

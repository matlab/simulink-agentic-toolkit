---
name: simulink-explain-missing-coverage
description: "Use this skill when the user asks to summarize, or asks why Simulink Coverage objectives are missing, unsatisfied, or uncovered on a coverage result they already have — why specific decision, condition, MCDC, relational-boundary, or saturation/overflow outcomes weren't exercised, whether uncovered logic is dead code, or how to close the gap (a test, a coverage filter, or a design change). It reads an existing cvdata, .cvt file, sim-with-coverage output, or Simulink Test result; it never runs cvsim to collect coverage."
license: https://www.mathworks.com/content/dam/mathworks/license/pmrl/license.md
metadata:
  author: MathWorks
  version: "0.1"
  toolbox_dependencies:
    - Simulink Coverage
    - Simulink Design Verifier
    - Simulink Check
---

# Explaining Missing Simulink Coverage

Explain *why* coverage objectives are missing on a coverage result the user **already
has**, and *what to do* about each one — across **all** objective types (decision,
condition, MCDC, relational boundary, saturation/overflow, lookup-table execution).
Works from an existing `cvdata` / `cvdatagroup`, a `.cvt` file, a
`Simulink.SimulationOutput` with coverage on, or a Simulink Test result set.

It keeps two questions separate:

- **Is this outcome reachable?** — for decision/condition/MCDC objectives, answered by
  formal proof (SLDV dead-logic detection) joined to the coverage result deterministically.
  A provably-dead outcome is a *fact*.
- **If reachable, why wasn't it tested — and if dead, was that intended?** — answered by
  the agent, reasoning over an input trace (Model Slicer) plus model structure. This is
  judgment, always presented as a recommendation.

**Requires:** MATLAB R2023a+, Simulink Coverage, Simulink Design Verifier (dead-logic
detection), Simulink Check / Model Slicer (input tracing). The skill
**never collects coverage** — it reads a result that already exists. When SLDV or the Model
Slicer is unavailable, the affected step degrades honestly (see Guardrails), never
fabricating evidence.

## When to Use

- User asks **why** an objective — of any metric — or a specific true/false outcome is
  missing, unsatisfied, or uncovered.
- User asks whether uncovered logic is **dead code** (unreachable) or just **untested**.
- User asks **how to close** a coverage gap on a result they already collected — what test
  to add, what to filter, or what to change.
- User needs **audit-ready triage**: provably-dead vs. still-to-test, each traced to its
  inputs.
- User points at an existing coverage artifact and asks to explain it.

## When NOT to Use

- **Collecting coverage / simulating to measure coverage** → this skill reads a result, it
  does not collect one; tell the user to collect coverage first, then return here.
- **Authoring or generating tests** → `testing-simulink-models`. This skill recommends a
  scenario in words; it does not build a harness or generate vectors.
- **Design-error detection / fixing runtime defects** (divide-by-zero, overflow) →
  `resolve-design-errors`.
- **Model compliance against a standard** (MISRA, MAB, JMAAB) → `checking-model-compliance`.
- **Requirement verification** → not this skill (it only *queries* existing links, read-only).

## Coverage Sources

All four sources resolve to the one object the analysis consumes — a `cvdata` /
`cvdatagroup`. `resolveCoverageData` normalizes them and makes **no** decisions; when a
source carries more than one unit, the agent asks which to explain.

| Source | Holds | Resolves via |
|---|---|---|
| `cvsim` result | `cvdata` / `cvdatagroup` | pass through |
| `.cvt` file | path | `cvload` (cell of `cvdata`) |
| `sim` w/ coverage | `SimulationOutput` | embedded cvdata var, else `cvresults(model)` (per-run + cumulative) |
| Simulink Test | `ResultSet` | `getCoverageResults` (cvdata object array) |

Rules the agent applies: **multiple units → always ask** which to explain (never merge or
pick silently); **`cvresults` per-run vs. cumulative → cumulative by default**, mention the
single-run view exists.

## Prerequisites

All script functions live in the skill's `scripts/` directory. Call them with
`evaluate_matlab_code` and `project_path` set to that folder. **Never `addpath`,
`restoredefaultpath`, or `savepath`** — altering the session path breaks the coverage tooling.

Use these functions; do not hand-roll resolution, extraction, the SLDV run, the join, or the
trace. The Step-2 join in particular matches SLDV verdicts to outcomes on an exact key — the
agent must **never** do that matching itself.

| Function | Inputs → Output | Role |
|---|---|---|
| `resolveCoverageData(source)` | source → `{cvdata,model,kind,label}[]` | Normalize sources to a list of units |
| `getCoverageSummary(cvd)` | one `cvdata` → covSummary | Rollups + outcome detail + filter/reduced info |
| `detectDeadLogicObjectives(model, metrics)` | model + metrics → `[dead, status]` | SLDV dead-logic (decision/condition/MCDC only) |
| `markSldvDeadLogic(covSummary, dead)` | covSummary + dead → covSummary | **Deterministic join** — stamp `dead`, record unmatched/contradictions |
| `traceObjectiveInputs(model, blockPaths, maxDepth)` | model + paths → `[traces, status]` | Slicer: controllable inputs + dependency chain |

The scripts return MATLAB structs. Their exact output contracts — field names, nesting,
what an absent field means — are documented in **`references/script-outputs.md`**; consume
the returns by that reference rather than probing `fieldnames` and guessing paths. Deeper
method detail lives in references (load on demand): SLDV recipe + join semantics in
**`references/dead-logic-analysis.md`**; classification + scenario composition in
**`references/explaining-and-resolving.md`**; filter authoring in
**`references/coverage-filter-api.md`** (load after filter approval, Step 3); read-only
requirement traceability in **`references/requirements-tracing.md`** (load when prioritizing
by requirement linkage, Step 3).

---

## Workflow

Three steps. Step 1 is cheap and always safe; Steps 2–3 run the expensive engines and are
**gated** — do not run them for a plain "summarize" request.

```
1. Summarize coverage       → resolveCoverageData + getCoverageSummary
2. Locate missing objectives → collect uncovered outcomes; if any decision/condition/MCDC
                              are uncovered, detectDeadLogicObjectives + markSldvDeadLogic
3. Explain and resolve      → traceObjectiveInputs on the owning blocks; agent explains
```

### Step 1 — Summarize coverage

1. `cands = resolveCoverageData(source)`. The source's model must be loaded first — if it
   isn't open or on the path, `load_system` it (not `addpath`). If `numel(cands) > 1`, **ask**
   which unit(s) to explain. For a `sim` yielding per-run and cumulative, default to cumulative
   and say so.
2. `covSummary = getCoverageSummary(cands(k).cvdata)`.
3. Render a summary: total satisfied / total, then a **worst-first** table of systems by
   unsatisfied count (`kind == 'system'` nodes — the model root and each subsystem/chart, not
   subsystems only; omit fully-covered ones). Name the enabled metrics.

**Gate.** Stop here unless the user asked *why* coverage is missing or *how* to improve it.

### Step 2 — Locate missing objectives

1. Collect the uncovered Tier-2 outcomes (`covered == false`). **If none, STOP** — report
   full coverage on the enabled metrics.
2. Run SLDV **only if** at least one uncovered outcome is decision / condition / MCDC (the
   metrics SLDV dead-logic covers). Otherwise skip it and go to Step 3.
3. If running it:
   ```matlab
   [dead, status] = detectDeadLogicObjectives(model, metrics);   % dead-eligible metrics present
   covSummary = markSldvDeadLogic(covSummary, dead);                    % exact-key join; do NOT match by hand
   ```
4. Present the outcomes in their reachability states (detail in
   `references/dead-logic-analysis.md`):
   - **Provably dead** — SLDV `ran` and the join stamped `dead == true` (fact).
   - **Reachable, stated cautiously** — decision/condition/MCDC, SLDV `ran`, not stamped
     dead: "SLDV found no dead logic here, so it needs a test." Not a completeness proof.
   - **Deadness not established** — SLDV `skipped_no_license` / `error`, or a
     non-SLDV-analyzable metric (relational / saturation / lookup-table). State the reason.

### Step 3 — Explain and resolve

Trace the owning blocks of the uncovered outcomes in one batch, then reason over the
evidence (full method in `references/explaining-and-resolving.md`):
```matlab
[traces, status] = traceObjectiveInputs(model, blockPaths);
```

- **Judge intent from the traced evidence — the controllable inputs and what each block in
  the chain computes.** A control pinned by a `Constant`/configuration, or a defensive guard
  the trace shows can't be reached in this context (a range clamp, a divide-by-zero guard) →
  likely *intentional* (recommend a coverage filter, Justify mode —
  `references/explaining-and-resolving.md`, `references/coverage-filter-api.md`). A dead
  branch tracing to controllable inputs → likely *unintentional* (recommend a design review).
  When the trace leaves intent unclear, use `model_read` / `model_overview` for more context.
- **Compose a test scenario** for testable outcomes: invert the required condition from the
  chain (Switch `y = (u2 >= 5) ? …`, false uncovered → drive `u2 < 5`), stated in the
  controllable inputs. **Group** outcomes sharing inputs — one test often closes several.
- **When a trace is `method == "unavailable"`**, fall back to `model_read` /
  `model_overview` on that block; never fabricate inputs or a chain.
- **When prioritizing which outcomes to test first — or whenever the user asks what to
  address first — check requirement linkage** (read-only,
  `references/requirements-tracing.md`) if Requirements Toolbox is available: a
  linked + uncovered outcome is "untested but required" (cite the requirement ID) and
  outranks an unlinked one; an unlinked outcome is lower priority (a hint the logic may be
  unrequired — surface it, do not conclude it). If Requirements Toolbox is unavailable, say
  so and prioritize without it.

Writing a `.cvf` filter or editing the model is **Ask First** (Guardrails).

---

## Guardrails

### Always
- State the resolved unit (model, label, per-run vs. cumulative) and enabled metrics in the
  summary header.
- Report covSummary counts verbatim; the two coverage tiers agree by construction — do not
  recompute them.
- Separate **fact** from **judgment** in every finding ("SLDV proved this unreachable" vs.
  "this appears intentional because the control is a constant").
- Signal honestly when an engine did not run: `status == "skipped_no_license"` / `"error"`
  and per-block `method == "unavailable"` mean *not performed* — say so.
- Group testable outcomes by shared inputs and note when one test closes several.

### Ask First
- **Which unit** to explain, whenever the source resolves to more than one.
- **Writing a coverage filter** (`.cvf`) — present the rule and rationale; write only on
  explicit approval, using the engineer's rationale (never fabricated).
- **Editing the model** — present the change; apply only on explicit approval, never
  silently to the original.

### Never
- **Never declare an outcome "dead code, safe to filter" as fact.** SLDV proves
  unreachability; whether dead logic is intentional and filterable is the engineer's
  audit call. Present evidence + a recommendation.
- **Never index-match SLDV verdicts to outcomes by hand** — `markSldvDeadLogic` owns the join.
- **Never call a completed-SLDV "no dead logic" result a completeness proof** — a timeout
  (`status == -1`) can hide deadness.
- **Never modify the MATLAB path** (`addpath` / `restoredefaultpath` / `savepath`).

## Common Mistakes

| Mistake | Fix |
|---|---|
| Running SLDV / Slicer for a "summarize" request | Step 1 only; gate on wanting the *why* |
| Running SLDV when no decision/condition/MCDC outcome is uncovered | SLDV covers those three metrics only; skip otherwise |
| Reporting "provably dead" when SLDV was skipped/errored | Nothing is provably dead without a completed SLDV run |
| Calling non-D/C/MCDC gaps "reachable" | SLDV can't analyze them; state deadness as *not established* |
| Matching SLDV results to outcomes in the agent | Call `markSldvDeadLogic`; consume `dead_analysis` |
| Classifying dead logic from block names | Classify from the dependency chain + `model_read` |
| Fabricating a chain when `method == "unavailable"` | Fall back to `model_read` / `model_overview` |
| Silently picking one cvdata from many | Ask which unit to explain |

----

Copyright 2026 The MathWorks, Inc.

----

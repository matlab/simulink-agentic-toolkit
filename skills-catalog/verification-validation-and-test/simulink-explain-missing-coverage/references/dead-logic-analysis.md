# Dead-Logic Analysis — SLDV Detection and the Join

How the skill decides, as a **fact**, that an uncovered outcome is unreachable, and how
that verdict is attached to the coverage result. Two scripts own this; the agent consumes
their output and never reproduces it.

The skill explains **every** coverage objective type the extractor produces (decision,
condition, MCDC, relational boundary, saturation/overflow, lookup-table execution,
designverifier). This step — and only this step — is metric-gated, because SLDV dead-logic
detection reasons about a subset of them.

## What SLDV dead-logic covers — and what it does not

SLDV dead-logic detection applies to **decision, condition, and MCDC** objectives only.
Relational-boundary, saturation-overflow, and lookup-table outcomes are **not
SLDV-analyzable** — their deadness cannot be formally proven here. An uncovered outcome of
those metrics gets **no** dead/reachable verdict from this step; it goes straight to
tracing and explanation (see `explaining-and-resolving.md`) labeled *not SLDV-analyzable*.

So: run detection only when at least one uncovered outcome is decision / condition / MCDC.
Pass exactly the dead-eligible metrics that are actually present.

## Running detection — `detectDeadLogicObjectives(model, metrics)`

```matlab
[dead, status] = detectDeadLogicObjectives(model, metrics);
```

The script configures SLDV in DesignErrorDetection mode, disables the DED defect checks
(dead-logic only), runs it UI-off, and returns each dead objective stamped with the exact
identity key the coverage summary uses. It cleans its own `sldv_output/<model>/` subfolder.

`status`:
- `'ran'` — detection completed. Note `status == -1` inside SLDV means a **timeout /
  partial** run: any dead objectives returned are valid, but the *absence* of a verdict is
  not a completeness guarantee.
- `'skipped_no_license'` — no SLDV license; `dead` is empty. **Nothing is provably dead.**
- `'error'` — detection failed; treat as "not analyzed," not as "no dead logic."

## The join — `markSldvDeadLogic(covSummary, dead)`

```matlab
covSummary = markSldvDeadLogic(covSummary, dead);
```

A **deterministic exact-key join**. It matches each dead objective to a coverage outcome on
`(ssid, metric, coverage_point, predicate, outcome_value)` — MCDC on the
predicate axis, decision/condition on `outcome_value`. (`ssid` is the join key, not `slPath`:
slPath is ambiguous for Stateflow, where states and transitions share the chart's path, so it
is display-only.) It stamps `dead=true` on matching
Tier-2 outcomes and records bookkeeping under `covSummary.dead_analysis`:

- `matched` — dead objectives that landed on an uncovered outcome (the provably-dead set).
- `unmatched` — dead objectives with no corresponding outcome. **Never drop these** —
  surface them; they usually mean a scope or metric mismatch worth reporting.
- `contradictions` — SLDV called an outcome dead that the result shows **covered**. A real
  anomaly (`Slvnv:explainMissingCoverage:deadButCovered`). Flag it; do not hide it.

**Do not attempt this matching in the agent.** The agent's job begins after the stamp.

## The three reachability states (for honest reporting)

Each uncovered outcome falls into exactly one:

1. **Provably dead** — decision/condition/MCDC, SLDV `ran`, stamped `dead == true`. A fact
   about reachability. (Whether it is *intentional* is a separate judgment.)
2. **Reachable, stated cautiously** — decision/condition/MCDC, SLDV `ran`, not stamped
   dead. Report as reachable-but-untested: "SLDV found no dead logic here, so it needs a
   test." Do **not** call this a completeness proof (a timeout could hide deadness).
3. **Deadness not established** — either SLDV was skipped/errored (D/C/MCDC, unknown), or
   the metric is not SLDV-analyzable (relational/saturation/lookup-table). Trace and
   explain; recommend a test. State the reason deadness could not be checked.

In all three the outcome still flows into Step 3 tracing — the difference is only in how its
reachability is stated.

## Never hand-derive unreachability

When SLDV `ran`, its per-outcome stamp is the **entire** reachability verdict. An
uncovered decision/condition/MCDC outcome it did not stamp `dead` is **reachable-untested**
(State 2) — full stop. Do not argue it is actually unreachable or unsatisfiable by any
line of reasoning. If SLDV left an outcome unstamped, that outcome is reachable and your
job is to hand it to Step 3 tracing for a test — never to a filter.

----

Copyright 2026 The MathWorks, Inc.

----

# Explaining and Resolving Uncovered Objectives

The agent's reasoning step. Inputs: the marked coverage summary (the three reachability states from
`dead-logic-analysis.md`) and the `traceObjectiveInputs` traces for the owning blocks.
Output: for each uncovered outcome, an explanation and a recommendation. Everything here is
**judgment presented as a recommendation** — the engineer owns the justify / filter /
redesign decision. This applies to **all** objective types; SLDV status only changes how
firmly reachability is stated, not whether the outcome is explained.

## The trace evidence

`traceObjectiveInputs(model, ids)` takes each objective's identifier — pass the node's
`ssid` (always present) rather than its `path`, because a Stateflow state/transition
objective has an **empty** `path`; the tracer resolves an ssid to the sliceable block (for
a Stateflow objective, its enclosing chart) internally. It returns, per objective:
- `controllable_inputs` — the Inport / FromWorkspace / FromFile blocks that drive the
  objective. Authoritative even through masked/library subsystems.
- `dependency_chain` — the intervening active blocks, each with a short `expression`
  (a Switch's criteria, a Gain, a Constant, a relational operator, …).
- `method` — `'slicer'` (traced) or `'unavailable'` (no Simulink Check license, or the
  block failed to slice). On `'unavailable'`, fall back to `model_read` / `model_overview`
  on the owning block and reason from its structure. Never fabricate inputs or a chain.

## Judge intent from the traced evidence, not from block names

Whether an uncovered outcome is **intentional** is decided from the traced evidence — the
controllable inputs and what each block in the chain computes — **not from what a block is
named** ("Saturation" → intentional is exactly the fragile heuristic to avoid).
The reading works for any metric. Three evidence signatures, each with a different lean:

- **Pinned control → likely intentional.** The deciding *control signal itself* is held at a
  fixed value by a `Constant` or configuration value, so the outcome can never be exercised
  by design (or it guards a disabled feature). → Recommend a **coverage filter (Justify)**;
  see `coverage-filter-api.md`. Two recurring shapes fall under this lean:
  - *Redundant defensive check in a reused subsystem.* When you can tell the owning block is a
    library or masked subsystem, its defensive guard (a range clamp, a divide-by-zero guard)
    may be redundant *in this instantiation* because the caller's context constrains the input
    range. The deadness comes from the upstream context, not from a control port pinned inside
    the subsystem — the trace shows the guarded input driven by a chain that cannot reach the
    guarded value here, though the same block is exercised elsewhere. Lean intentional; the
    guard is deliberate defensive programming.
  - *Complementary Stateflow guards (negation guard).* A state has two outgoing transitions
    evaluated in order, guarded `g` then `!g`. The second is reached only when `g` is false, so
    `!g` is always true when evaluated — its guard-false outcome is unreachable by construction.
    This is the Stateflow-transition analogue of a pinned control: intentional, and the
    recommended action is a Justify filter, not a redesign.
- **Contradictory guard on a controllable input → likely a DEFECT.** The outcome is provably
  dead, yet it traces to a *controllable* input — the deadness comes from the guard's own
  logic being mutually exclusive, not from a pinned control. Classic shape: two
  sub-conditions on the **same free input** that can never hold together, e.g.
  `AND(x > 10, x < 5)` (an `AND` where an `OR` was meant, or wrong thresholds). SLDV proves
  *dead*; it does **not** prove *intended*. A contradiction on inputs that a test could
  otherwise drive is the fingerprint of a logic error. → **Default to recommending a design
  review, NOT a filter.** Filtering here would silently bless a possible bug; a review either
  confirms the guard is a deliberate never-fires check (then filter, with that rationale) or
  catches the defect. Only after the engineer confirms intent should a Justify filter be
  offered.
- **Controllable, not proven dead → testable.** The outcome traces to controllable inputs
  with no pinning constant and SLDV did not prove it dead → it is simply untested → compose a
  scenario (below).

**Same shape, opposite intent.** A `Constant` feeding a Switch/If control that kills a branch
is *intentional* when the constant is by-design and a *defect* when it is a stale or wrong
parameter — and the same shape can also be an analysis artifact, where the value should be made
tunable rather than filtered. Identical structure, different verdict. This is exactly why every
reading here is a **recommendation the engineer confirms**, never a fact; a confirmed defect is
resolved by the design-review or model-edit actions below, not by a filter.

**Do not confuse a comparison-operand constant with a pinned control.** A `Constant` in the
dependency chain does not by itself mean "fixed control": in `x > 10`, the `10` is a
threshold and `x` is the (controllable) deciding input. Ask *what drives the control signal*,
not merely *whether any constant appears in the chain* — the pinned case has the **control
port itself** fed by a `Constant`; the defect case has the control fed by a free **Inport**
with constants only as comparison operands.

State the fact and the judgment separately, e.g.: "SLDV proved this unreachable (fact); the
control input is a `Constant` = 0 (evidence), so this appears intentional (recommendation)"
versus "SLDV proved this unreachable (fact); the guard `x > 10 && x < 5` is a contradiction on
the controllable input `x` (evidence), so this looks like a design defect — recommend review
before any filter (recommendation)." When there is no SLDV proof (non-analyzable metric or
SLDV not run), still surface a pinned-control observation — as a *flag* ("this looks
intentional"), explicitly without a proof behind it.

## Compose a test scenario for testable outcomes

Invert the required condition from the dependency chain and state it in terms of the
controllable inputs. Example: a Switch `y = (u2 >= 5) ? u1 : u3`, false outcome uncovered →
the test must drive `u2 < 5`. For a relational-boundary outcome, state the boundary value the
input must hit. Name inputs by their signal names from `controllable_inputs`.

**Group** outcomes that share the same controllable inputs — one scenario often satisfies
several — and say which outcomes a single scenario would close. This grouping is the agent's
job (the producers do not group); derive it from the shared `controllable_inputs` sets.

Optionally check requirement linkage (`requirements-tracing.md`, read-only) to prioritize:
linked + uncovered = "untested but required."

## Resolve actions (all Ask First)

- **Coverage filter** for **confirmed-intentional** outcomes (pinned control, or a
  contradictory guard the engineer has confirmed is deliberate) → `coverage-filter-api.md`.
  Present the rule and rationale; write the `.cvf` only on explicit approval. Do **not** offer
  a filter as the first move for a contradictory-guard outcome — recommend the review first.
- **Design review** for a contradictory guard on a controllable input → present the
  contradiction and the SLDV proof as evidence; the review decides defect-vs-deliberate before
  any filter or edit.
- **Model edit** for confirmed-unintentional dead logic (e.g. fix a wrong constant or an
  `AND` that should be `OR`) → present the change and its intent; apply only on explicit
  approval, never silently to the original.
- **New test** for testable outcomes → this skill *recommends the scenario in words*; it
  does not author the test. Hand off to `testing-simulink-models` to build it.

----

Copyright 2026 The MathWorks, Inc.

----

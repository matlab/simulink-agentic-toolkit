> **Release compatibility:** MATLAB R2023a and later.

# Protocol: Customer Extensions

This protocol governs how the agent discovers, validates, and applies customer-provided optimization preferences and custom optimization techniques.

## Discovery

Extensions live in the customer's project directory:

```
<project>/.custom_optimizations/
├── optimization_preferences.yaml
└── optimizations/
    ├── <technique-name>/
    │   └── reference.md
    └── ...
```

**Template:** A blank template is available at `<skill_root>/assets/optimization_preferences.yaml`. Customers copy it to `<project>/.custom_optimizations/optimization_preferences.yaml` and edit the copy.

**Out-of-the-box:** If no `.custom_optimizations/` folder exists in the project, the agent proceeds with defaults (no preferences active).

## Loading Strategy: Lazy

Preferences are **NOT** stored in `state.json`. Each phase reads the file directly from disk when it needs it:

- **Phase 3** reads `skip` + `know` sections and discovers custom optimizations
- **Phase 4** reads `never` rules before each candidate apply

**Resolution at read time:**
1. Check `<PROJECT_PATH>/.custom_optimizations/optimization_preferences.yaml`
2. If not found → proceed with defaults (no preferences active)

Same resolution for the `optimizations/` folder.

This means customers can edit their preferences between phases and changes take effect immediately.

## `optimization_preferences.yaml` — Schema

All sections are plain English. The customer does NOT need to know internal subskill paths, IDs, or naming conventions.

```yaml
# optimization_preferences.yaml
# Place in: <project>/.custom_optimizations/
# Guides the optimization workflow. All entries are plain English.

# ─── NEVER ──────────────────────────────────────────────────────────
# Hard rules the agent MUST obey. If a candidate violates any of these,
# it is blocked immediately. These are non-negotiable constraints.
never:
  - "Do not inline any subsystem with 'Safety' in the name"
  - "Do not change data types on signals connected to CAN blocks"
  - "Never exceed 5% ROM increase in a single change"
  - "Do not modify the MotorControl subsystem"

# ─── SKIP ───────────────────────────────────────────────────────────
# Categories of optimization the agent should not suggest at all.
# These suppress entire technique areas (not gates — gates always run).
skip:
  - "Do not suggest data type changes"
  - "Skip lookup table optimizations"
  - "Do not suggest SIMD or parallel changes"

# ─── KNOW ───────────────────────────────────────────────────────────
# Domain knowledge and soft guidance. The agent considers these when
# ranking suggestions and explaining rationale, but may proceed
# differently if a better option exists.
know:
  - "ControlLoop subsystem is the hot path — prioritize optimizations there"
  - "We compile with -Os on this target, speed flags may not help"
  - "Our models heavily use For Each subsystems"
  - "The CAN_Rx and CAN_Tx blocks must keep their exact signal types"
```

### How the agent uses each section

| Section | Enforcement | Timing | Effect |
|---------|-------------|--------|--------|
| `never` | Hard — violations block the candidate | Phase 4, before each apply | Candidate is blocked and logged; agent moves to next |
| `skip` | Hard — matched subskills excluded from pipeline | Phase 3, at filter entry | Subskill is never loaded or suggested |
| `know` | Soft — influences ranking and rationale | Phase 3, during suggestion generation | Agent weighs these; never hard-blocks |

### Validation rules

- Unknown top-level keys → warn, ignore
- Empty sections → valid (section has no effect)
- Entire file malformed YAML → warn user, proceed with defaults
- Missing file → proceed with defaults, log `INFO EXT-01`

## Custom Optimizations — Discovery and Evaluation

Custom optimizations are full `reference.md` files authored by the customer.

### Differences from built-in subskills

| Aspect | Built-in | Custom |
|--------|----------|--------|
| Location | Skill tree (`suggesting-optimizations/`) | `<project>/.custom_optimizations/optimizations/<name>/` |
| Index entry | Required | Not needed |
| Four-gate filter | Applied (stage/goal/hardware/model_needs) | Bypassed — always evaluated |
| Applicability | Index gates + Skip Conditions | Skip Conditions only |
| Priority | After custom optimizations | Runs first (customer gets priority) |

### Evaluation rules

1. **Always-run:** Custom optimizations bypass the four-gate filter. Their own Skip Conditions section determines whether they apply.
2. **Priority:** Evaluated BEFORE built-in subskills. Customer techniques appear first in the suggestion table.
3. **Cap:** Maximum 5 custom optimizations. If more exist, load the first 5 alphabetically and log `WARN EXT-04`.
4. **Gates still apply:** After any custom optimization is applied, the Correctness Gate and Goal-Axis Gate run as normal. A breaking custom optimization is auto-reverted like any other.

### Evaluation timing in Phase 3

```
1. Read custom optimization reference.md files (from .custom_optimizations/optimizations/)
2. For each: check Skip Conditions against current model/goal
3. If applicable: add candidates to suggestion table (these appear FIRST)
4. Proceed to built-in subskills (normal four-gate filter pipeline)
```

## Phase 3: Skip Gate (Suppress via `skip` rules)

After the four-gate filter produces a list of built-in subskills to evaluate, the agent applies the skip gate:

1. Read `skip` entries from `optimization_preferences.yaml`
2. For each `skip` entry, semantically match against each remaining subskill's **Purpose** section
3. If a subskill's purpose matches a skip rule → exclude it from the pipeline
4. Log: `SKIP EXT-03: <subskill> suppressed — matches skip rule "<text>"`

**Semantic matching:** The agent reads the skip rule as plain English and determines if a subskill's stated purpose aligns. Example: "Do not suggest data type changes" matches `data-types/precision-reduction` because its Purpose section describes changing data types.

## Phase 4: Never Gate (Hard constraint enforcement)

Before applying any candidate (built-in or custom):

1. Read `never` entries from `optimization_preferences.yaml`
2. For each `never` rule, evaluate whether the specific proposed change would violate it
3. If violated → block the candidate, log `BLOCK EXT-04: <candidate> blocked — violates never rule "<text>"`, move to next candidate
4. If no violation → proceed with apply + gates as normal

**Important:** `never` rules are evaluated against the **specific candidate action** (e.g., "inline subsystem Safety_Braking"), not the subskill as a whole. A subskill may produce 10 candidates, and only 2 are blocked by a `never` rule — the other 8 proceed normally.

## Decision Trace Logging

| When | Log entry |
|------|-----------|
| Phase 3: preferences loaded | `OK EXT-01: Loaded preferences — <M> skip rules, <K> know entries` |
| Phase 3: preferences not found | `INFO EXT-01: No optimization_preferences.yaml found — using defaults` |
| Phase 3: validation warning | `WARN EXT-02: optimization_preferences.yaml: <issue>` |
| Phase 3: subskill suppressed | `SKIP EXT-03: <subskill> suppressed — matches skip rule "<text>"` |
| Phase 3: custom optimization loaded | `OK EXT-05: Custom optimization <name> loaded (priority)` |
| Phase 3: custom optimization skipped | `SKIP EXT-05: Custom optimization <name> — Skip Conditions met` |
| Phase 4: never rules loaded | `OK EXT-01: Loaded <N> never rules` |
| Phase 4: never rule blocks candidate | `BLOCK EXT-04: <candidate> blocked — violates never rule "<text>"` |
| Phase 3/4: cap exceeded | `WARN EXT-04: <N> custom optimizations exceed cap of 5 — loading first 5 alphabetically` |

## Risk / Alert — Known Failure Modes

| ID | Risk | Symptom | Triggered By | Mitigation |
|----|------|---------|-------------|------------|
| EXT-01 | Malformed preferences file | Agent ignores all preferences or crashes | Invalid YAML syntax | Schema validation at read; warn + proceed with defaults |
| EXT-02 | Over-suppression | No subskills remain for user's stated GOAL | Too many skip rules | Warn user: "Your skip rules exclude all techniques for your GOAL. Proceeding with custom optimizations only (if any)." |
| EXT-03 | Custom optimization breaks model | Applied change causes build failure or correctness regression | Poorly authored custom optimization with inadequate Skip Conditions | Correctness Gate + Goal-Axis Gate still apply — auto-revert on failure |
| EXT-04 | Too many custom optimizations | Context window bloat | User adds >5 custom optimizations | Cap at 5; warn if exceeded |
| EXT-05 | Ambiguous skip/never rule | Agent misinterprets vague plain-English rule | Imprecise wording (e.g., "skip changes" — which changes?) | Log which subskills/candidates matched each rule so customer can verify in decision trace |
| EXT-06 | Never rule too broad | All candidates blocked, no optimizations possible | Rule like "Never change anything" | Warn user if all candidates in a stage are blocked by never rules |

## What This Protocol Does NOT Allow

- **Suppressing gates:** Correctness Gate and Goal-Axis Gate always run. No preference can disable them.
- **Changing tolerance:** `state.TOLERANCE` is set in Phase 1 and cannot be overridden by preferences.
- **Modifying phase sequencing:** The A→B→C→D stage order is fixed.
- **Overriding gate verdicts:** If a gate says FAIL, the version is rejected regardless of preferences.


----

Copyright 2026 The MathWorks, Inc.

----
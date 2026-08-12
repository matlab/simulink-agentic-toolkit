# Test Configuration Template

Use this format when proposing test configuration to the engineer (Phase 5).

```markdown
# Test Configuration — {Project / Model Name}

**Test File**: `{path/to/TestFile.mldatx}`
**Date**: {YYYY-MM-DD}

## Test Case Summary

| Test Case | Scope | Harness / Model | Inports | Outports / Logged Signals |
|-----------|-------|-----------------|---------|---------------------------|
| {name} | unit | `{HarnessName}` | {count} ({names}) | {count} ({names}) |
| {name} | model | `{ModelName}` | N/A | {signals via BlockPath} |

## Test Case: {Name} [unit scope]

**Requirement**: {REQ-ID} — {summary}
**Harness**: `{HarnessName}` on `{Component}`
**StopTime**: {seconds}

### Design Analysis

| Step | Finding |
|------|---------|
| Requirement parse | {Extract behavior, subject signal, and criterion from "shall" text} |
| Implement link | {Block path and block type from the requirement's Implement link} |
| Parameter resolution | {Use `model_read` to get block parameters. If workspace vars, resolve via `model_resolve_params`. Report actual numeric values.} |
| Unit check | {Compare resolved values vs requirement text. If mismatch (e.g., 0.5236 vs 30°), identify unit (radians vs degrees). State which units the signal operates in.} |
| Signal path | {Trace from harness inport through relevant blocks to assessed outport} |
| Test pattern | {Category: saturation, tracking, timing, threshold, state transition, etc.} |
| Signals to log | {Which outports to log and why} |
| Assessment derivation | {How the requirement maps to a concrete assessment expression. Use requirement text values if units match the model; convert if they differ.} |

### Logged Signals

| Alias | Outport | PortIndex | Purpose |
|-------|---------|-----------|---------|
| {dA} | {Aileron cmd} | {1} | {assessed signal — saturation check} |
| {dR} | {Rudder cmd} | {2} | {monitor — confirm no cross-coupling} |

### Assessments

| # | Name | Type | Expression | Condition |
|---|------|------|------------|-----------|
| 1 | {AileronLimit} | always | `abs(dA) <= 30` | — |
| 2 | {SaturationEngaged} | conditional | `abs(dA) == 30` | `abs(cmd_in) > 30` |

---

## Test Case: {Name} [model scope]

**Requirement**: {REQ-ID} — {summary}
**Model**: `{ModelName}`
**Target Component**: `{Implement link path}` (for traceability)
**StopTime**: {seconds}

### Design Analysis

| Step | Finding |
|------|---------|
| Requirement parse | {Same as above} |
| Implement link | {Same — but note: model-scope was chosen because...} |
| Parameter resolution | {Same} |
| Unit check | {Same} |
| Signal path | {Trace through model — may cross subsystem boundaries} |
| Test pattern | {Same} |
| Signals to log | {Which signals, specified by BlockPath — may include downstream signals} |
| Assessment derivation | {Same} |

### Logged Signals

| Alias | BlockPath | PortIndex | Purpose |
|-------|-----------|-----------|---------|
| {q_safe} | `{Model/Subsys/Block}` | {1} | {assessed signal} |
| {IAS} | `{Model/Downstream/IAS_calc}` | {1} | {downstream requirement intent} |

### Assessments

| # | Name | Type | Expression | Condition |
|---|------|------|------------|-----------|
| 1 | {MitigationActive} | conditional | `q_safe >= 1` | `t >= 16` |
| 2 | {AirspeedAboveStall} | conditional | `IAS >= 25` | `t >= 16` |

---
(Repeat "## Test Case: {Name}" section for each test case)
---

## Open Questions

- {Ambiguous requirement wording}
- {Missing tolerances or expected values}
- {Unknown nominal bus values — need engineer to confirm}
- {Signals that may not be logged by default}
```

## Guidelines

- For unit-scope TCs: inspect the harness after creation to discover outport structure.
- For model-scope TCs: use `BlockPath` to identify signals anywhere in the model hierarchy.
- Every signal alias referenced in an assessment must appear in Logged Signals.
- If a pass/fail value cannot be determined from requirement text or model analysis, list it in Open Questions — do not guess.

----

Copyright 2026 The MathWorks, Inc.

----

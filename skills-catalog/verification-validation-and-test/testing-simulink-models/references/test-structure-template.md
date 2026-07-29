# Verification Plan Template

Use this format when proposing the verification plan to the engineer (Phase 3).

```markdown
# Verification Plan — {Project / Model Name}

**Requirements**: `{req_file.slreqx}` ({N} Functional, {M} skipped)
**Test File**: `{path/to/TestFile.mldatx}` (to be created | existing)
**Date**: {YYYY-MM-DD}

## Verification Activities

| # | Test Case Name | Suite | Scope | Requirement | Property | Scope Rationale | Component | Type |
|---|----------------|-------|-------|-------------|----------|-----------------|-----------|------|
| 1 | {short descriptive name} | {Unit / Integration} | unit | {REQ-ID}: {summary} | {what must be true} | {why this scope} | `{Model/Subsys}` | simulation |
| 2 | {short descriptive name} | {Unit / Integration} | model | {REQ-ID}: {summary} | {what must be true} | {why this scope} | `{Model/Subsys}` | simulation |

## Skipped Requirements

| Requirement | Reason |
|-------------|--------|
| {REQ-ID}: {summary} | {Container / Informational / no Implement link / ...} |

## Open Questions

- {Anything that needs clarification before creating the test cases}
```

## Guidelines

- One requirement may decompose into 1–4 verification activities (test cases). Don't force multiple if the requirement is narrow.
- Test case name: short and descriptive — NOT the full requirement text. E.g., "q_raw fault mitigation" not the full shall-statement.
- Suite grouping: group by scope — `Unit` for unit-scope TCs, `Integration` for model-scope TCs. Alternative grouping by feature area is acceptable if the engineer prefers.
- Component comes from the requirement's Implement link; flag if missing.
- Default test type is `simulation` unless engineer specifies otherwise.
- Scope decision must be justified in "Scope Rationale" — one sentence explaining why unit or model.

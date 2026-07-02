# Fix Mode

Enter this mode when the user says "yes" to fixing compliance violations.

## Fix Loop

```
stall_counter = 0

WHILE violations > 0:
    1. Analyze current violations
    2. Categorize and prioritize by Fix Order (below)
    3. Select the highest-priority fixable category
    4. Present ALL planned changes as a numbered list to user
    5. Wait for user confirmation
       - If user declines → EXIT, report current state
    6. Apply fixes
    7. Re-run the same checks
    8. Compare violation count:
       - If decreased → reset stall_counter, report progress, continue
       - If same or increased → stall_counter++
       - If stall_counter >= 3 → EXIT, report remaining issues
       - If violations == 0 → EXIT, report success
```

## Fix Order (Priority)

| Priority | Category | Description | Tool |
|----------|----------|-------------|------|
| 1 | Toolbox/License prerequisites | Check `license('test', '<feature>')` before fixes requiring specific toolboxes. If unavailable, skip category. | `model_edit` |
| 2 | Structural fixes | Remove orphaned/dead blocks, add missing blocks, fix unconnected lines/ports. Must resolve before escalating diagnostics. | `model_edit` |
| 3 | Compile & verify | After structural fixes, compile ONLY if at least one check requires post-compile context. If all remaining checks are pre-compile, skip to priority 4+. If compilation fails, stop and report. | `eval_system` |
| 4 | Config parameter fixes | Change model configuration parameters (diagnostics, solver, code gen). Use `parameter` field from check output. | `model_edit` |
| 5 | Block parameter fixes | Change individual block parameters (names, data types, port properties, display). | `model_edit` |
| 6 | Routing/connection fixes | Reroute signals, reconnect lines, fix signal label propagation. | `model_edit` |
| 7 | Architecture fixes | Restructure subsystems, split/merge components. Requires explicit user confirmation with impact explanation. | `model_edit` |

## Fix Rules

1. **Present changes before applying** — list every modification, wait for user confirmation
2. **Toolbox gate** — verify toolbox availability before fixes requiring one; if missing, inform user and skip
3. **Compile gate** — compile after structural fixes only if post-compile checks exist in the run; if fail, stop
4. **Use exact parameter names** — use the `parameter` field from check output, never guess
5. **One priority level per iteration** — isolates which changes helped
6. **Structural before diagnostic** — never escalate a diagnostic to `'error'` until the structural issue is resolved
7. **Graceful value fallback** — attempt `'error'` first; if rejected, fall back to `'warning'`; report which params could not reach max strictness
8. **Pre-existing vs new failures** — if compilation fails after fixes, verify whether failure existed before your changes; if pre-existing, proceed; if new, revert
9. **Code generation prerequisite** — if a check fails with "Code has not been generated", ask user permission before running `slbuild` (heavyweight operation)

## Termination

| Condition | Action |
|-----------|--------|
| All violations resolved | "All checks now pass." |
| Stall for 3 consecutive iterations | Report remaining issues and what they require (missing toolbox, manual architecture, etc.) |
| User declines a fix batch | Stop fix mode, report current state |
| Compilation fails after structural fix | Revert, report, ask user how to proceed |

## Revert Strategy

- Before applying any batch, record current parameter values via `model_query_params`
- If a batch causes compilation failure or increases violations → revert all changes in that batch
- For structural changes: use `model_edit` to undo (delete added blocks, restore deleted blocks)

---

# Justification Mode

Enter when user wants to justify/waive/suppress/accept violations rather than fix them.

## Workflow

1. **Identify violations** — user selects by check name, block path, or id. Each must have an `id` field from `model_advisor_run` output. If no `id`, inform user manual justification via GUI is required.
2. **Collect rationale** — ask user for justification message (must be non-empty and meaningful)
3. **Determine file** — ask where to store; recommend `<model>_justifications.json` alongside model
4. **Call tool** — `model_advisor_justify(model, ids, message, file)`
5. **Report result** — confirm count justified, file path, and message stored

## Grouping Rules

- Same rationale → single call (batch by check_id when possible)
- Different rationales → separate calls

## Constraints

- **Never justify without explicit user request** — always a human decision
- **Never fabricate rationale** — message must come from user
- **Violations without `id` cannot be justified** — inform user of GUI fallback
- **Model changes invalidate hashes** — re-run checks first to get fresh ids
- **Justification file is version-controllable** — recommend committing alongside model

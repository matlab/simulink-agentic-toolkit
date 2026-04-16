---
name: generate-requirement-drafts
description: "Generates draft requirements from Simulink models. Use when drafting or updating requirement artifacts from a model. Prefers Requirements Toolbox (.slreqx) when available; falls back to structured YAML."
license: MathWorks BSD-3-Clause
metadata:
  version: "2.0"
---

# Generate Requirement Drafts

Generate draft requirements from Simulink models using the richest artifact the environment supports. All outputs are **drafts** requiring human review and approval before baselining.

## When to Use
- Drafting or updating requirements from a Simulink model
- Creating `.slreqx` or `.yaml` requirements artifacts
- Establishing model-to-requirement traceability

## When NOT to Use
- Importing requirements from an existing source of truth (ReqIF, DOORS, Word, Excel) — use Requirements Toolbox import APIs directly
- Writing or running tests — use the `testing-simulink-models` skill
- Free-form prose notes with no saved artifact
- User explicitly wants a different text format (markdown, Word)

## Output Conventions
- Default file names: `<Model>_Requirements.slreqx` or `<model>_requirements.yaml`
- Stable IDs: `REQ_<SYSTEM>_001`, `REQ_<SYSTEM>_002`, …
- Follow repo conventions if `.slreqx` or `.yaml` files already exist
- When updating an existing artifact, preserve existing IDs — append new IDs, never renumber
- Every generated requirement must be marked as draft — use `"draft"` in Keywords (slreq) or `status: Draft` + `keywords: [draft]` (YAML)

## Writing Good Requirements

Requirements must express **behavioral intent** (WHAT the system shall do), not restate model topology (HOW it is implemented). Put the WHY in `Rationale`. Use **EARS (Easy Approach to Requirements Syntax)** patterns:

### EARS Patterns

Choose the pattern that best fits the model behavior:

| Pattern | Template | When to Use |
|---------|----------|-------------|
| **Ubiquitous** | The \<system\> shall \<response\>. | Always-on behavior, invariants |
| **Event-driven** | When \<trigger\>, the \<system\> shall \<response\>. | Triggered subsystems, Stateflow transitions, input events |
| **State-driven** | While \<state\>, the \<system\> shall \<response\>. | Stateflow states, mode-dependent behavior |
| **Unwanted behavior** | If \<condition\>, then the \<system\> shall \<response\>. | Error handling, safety limits, saturation |
| **Optional feature** | Where \<feature\>, the \<system\> shall \<response\>. | Variant subsystems, configurable features |
| **Combined** | While \<state\>, when \<trigger\>, the \<system\> shall \<response\>. | State + event combinations |

### Examples — Model Concepts to EARS Requirements

| ❌ Bad — restates implementation | ✅ Good — EARS pattern |
|---|---|
| "Saturation block limits output to [0,1]" | "If throttle command exceeds ThrottleMax (1.0) or falls below ThrottleMin (0.0), then the controller shall clamp the output to the valid range." |
| "BrakeLogic subsystem disengages controller" | "When brake pedal input exceeds BrakeThreshold (0.0), the controller shall disengage cruise control." |
| "Gain block multiplies by 2.5" | "While cruise control is active, the controller shall amplify speed error by Kp (2.5) to compute proportional correction." |
| "Stateflow chart transitions to Idle" | "When the driver presses the off button, the system shall transition to the Idle state." |
| "Variant subsystem selects Algorithm A" | "Where the adaptive mode is enabled, the controller shall use the predictive algorithm." |

### Rules

- Write requirements using **EARS patterns** — pick the pattern that matches the model behavior
- Use block/subsystem names only in `Rationale` or provenance notes, not in the requirement `Summary`
- When referencing a numeric value, include the **workspace variable name and resolved value**: `VarName (value)`. If the model uses a literal with no variable, record the numeric literal directly
- Put the **WHY** in `Rationale`, not in the requirement statement
- One subsystem may support zero, one, or several behavioral requirements — don't force a 1:1 mapping

## Backend Decision Gate

Choose once at the start, then stay on that path.

| Situation | Backend |
|-----------|---------|
| User explicitly asks for `.slreqx`, traceability views, or repo already uses `.slreqx` | **Requirements Toolbox** — if probe fails, **inform the user** that Requirements Toolbox is unavailable; do NOT silently fall back |
| User explicitly asks for `.yaml`, or repo already uses `.yaml` requirements | **Structured YAML** |
| No format specified — probe for Requirements Toolbox | **Requirements Toolbox** if probe succeeds |
| No format specified and probe fails | **Structured YAML** (silent fallback is OK here since user had no preference) |

**Probe** (run via `evaluate_matlab_code`):
```matlab
hasSlreq = ~isempty(which('slreq.new'));
if hasSlreq, try, slreq.find(Type="Link"); catch, hasSlreq = false; end, end
disp(hasSlreq)
```

## Workflow

1. **Understand the model** — use `model_overview` and `model_read` to understand subsystems, interfaces, control logic.
2. **Extract parameters** — use `model_query_params` / `model_resolve_params` for thresholds, gains, sample times that should appear in requirement text. Record both variable names and resolved values.
3. **Build a capture table** (backend-neutral):

   | Id | ParentId | Summary | Description | SourceBlock | Rationale | ASIL | Priority | Keywords |
   |----|----------|---------|-------------|-------------|-----------|------|----------|----------|

4. **Run the backend path** (A or B below).
5. **Review** using the gate below.

### Path A — Requirements Toolbox (`.slreqx`)

Use when probe succeeds. For full API patterns see `reference/slreq-patterns.md`.

```matlab
model = "CruiseControl";
load_system(model);
rs = slreq.new(model + "_Requirements");

% Add requirements with hierarchy — note behavioral "shall" statements
req = add(rs, Id="REQ_CC_001", ...
    Summary="If throttle command exceeds ThrottleMax (1.0) or falls below ThrottleMin (0.0), then the controller shall clamp the output to the valid range.", ...
    Description="Derived from CruiseControl/ThrottleCmd.");
req.Rationale = "Prevents invalid actuator commands that could damage the throttle body.";
req.Keywords = ["draft","auto-generated","control","safety"];

child = add(req, Id="REQ_CC_002", ...
    Summary="When brake pedal input exceeds BrakeThreshold (0.0), the controller shall disengage cruise control.", ...
    Description="Derived from CruiseControl/BrakeLogic.");
child.Keywords = ["draft","auto-generated","safety","brake"];

% Create traceability links: source=block, dest=requirement → auto Implement
lnk = slreq.createLink(model + "/ThrottleCmd", req);
slreq.createLink(model + "/BrakeLogic", child);

save(rs);
% Save all link sets
linkSets = slreq.find(Type="LinkSet");
for i = 1:numel(linkSets), save(linkSets(i)); end
```

**Link rules:**
- Source = model element, destination = requirement → link type is automatically `Implement`
- Prefer subsystem-level links; use block-level only when the requirement is block-specific
- Every model-derived requirement **must** have at least one traceability link
- The model **must** be loaded (`load_system`) before creating links with block paths

### Path B — Structured YAML fallback

Use when Requirements Toolbox is unavailable. For schema and field rules see `reference/yaml-requirements.md`.

1. Generate a `<model>_requirements.yaml` file from the capture table
2. Set `status: Draft` and include `draft` in `keywords` for every requirement
3. Self-review: all required fields set, `asil`/`status`/`priority` use valid values, IDs sequential, `derived_from` references valid IDs or is `null`
4. Validate:
```bash
python -c "import yaml, sys; yaml.safe_load(open(sys.argv[1])); print('OK')" path/to/requirements.yaml
```

## Guardrails

| Always | Never |
|--------|-------|
| Mark every generated requirement as **DRAFT** | Emit markdown or ad hoc text when `.slreqx` is available and no text format was requested |
| Write requirements using EARS patterns | Restate block topology as the requirement summary |
| Include parameter name + value: `VarName (value)` | Create both `.slreqx` and `.yaml` unless user asks for both |
| Link direction: model element → requirement | Reverse the link direction (requirement → block) |
| `load_system` before creating traceability links | Over-link every primitive block — prefer subsystem links |
| Use only R2023a+ APIs | Silently fall back to YAML when user explicitly requested `.slreqx` |
| Stay consistent with existing repo format | Renumber existing requirement IDs on regeneration |

## Review Gate

Before finishing, verify (both backends):
- [ ] Every requirement has `Id`, `Summary`, and `Description`
- [ ] Every requirement is marked as **DRAFT** (via Keywords or status field)
- [ ] Summaries use EARS patterns, not block-topology restatements
- [ ] Numeric values include parameter name + value where a workspace variable exists
- [ ] IDs are stable and sequential; existing IDs preserved on regeneration

**slreq path only:**
- [ ] Model-derived requirements have a traceability link to the source model element
- [ ] Link direction is model element → requirement (not reversed)
- [ ] Subsystem-level linking preferred over block-level
- [ ] Requirement set and all link sets are saved

**YAML path only:**
- [ ] File parses without errors
- [ ] `asil` and `priority` use valid enum values (or `Unset` when unknown)

## References
- `reference/slreq-patterns.md` — Requirements Toolbox API cookbook
- `reference/yaml-requirements.md` — Structured YAML schema and field rules
- `reference/examples/slreq_from_model.m` — End-to-end slreq example
- `reference/examples/requirements.yaml` — Structured YAML example

---
name: specifying-mbd-algorithms
description: "Specify algorithms for Model-Based Design: system specs, architecture specs, implementation plans, test plans. Use when creating specifications for controllers, signal processing, diagnostics, estimators, or other algorithms authored in Simulink, Stateflow, System Composer, or MATLAB Function blocks."
license: MathWorks BSD-3-Clause
metadata:
  version: "1.0"
---

# MBD Algorithm Specs

Structured specification of algorithms for Model-Based Design. Adapts the `specifying-software` templates for the MBD algorithm domain.

## When to Use

- Specifying a controller, estimator, signal processor, diagnostic, or supervisory logic algorithm
- The algorithm will be authored in Simulink, Stateflow, System Composer, or as a MATLAB Function block
- The algorithm is part of a model-based design workflow (simulation, code generation, or both)
- Creating, updating, or reviewing algorithm specification documents

## When NOT to Use

- **Building** the algorithm model → use `building-simulink-models`
- **Testing** an existing model → use `testing-simulink-models`
- **Plant/environment models** → use `specifying-plant-models`
- **Traditional software** (C, C++, Python, standalone MATLAB scripts) → use `specifying-software`
- **Full closed-loop system** → use this skill for the algorithm side, `specifying-plant-models` for the plant side

## Output Conventions

Store specs per algorithm. **Prefix every filename with the algorithm name:**

```
docs/specs/algorithms/<algorithm-name>/
├── <algorithm-name>-system.md
├── <algorithm-name>-architecture.md
├── <algorithm-name>-implementation-plan.md
└── <algorithm-name>-test-plan.md
```

## Mode Selection

> Is this a single-function algorithm with <3 operating modes, single-rate, and will be built by one person/agent?
> - **Yes** → Quick spec: 2 documents (system+architecture combined, implementation+test combined)
> - **No** → Full spec: 4 separate documents

## Workflow

### Step 1: Establish External Interface

Identify what this algorithm connects to. If an existing system exists, read it with `model_overview` and `model_read`. If greenfield, define the boundary from requirements.

Classify every signal crossing the algorithm boundary:
- **Inputs**: measurements, commands, bus signals from other subsystems
- **Outputs**: actuator commands, processed signals, status/diagnostic flags
- **Parameters**: tunable (calibratable) vs. fixed (design-time)

### Step 2: Define Algorithm Objectives

Establish what the algorithm must achieve — tracking performance, bandwidth, disturbance rejection, detection thresholds, processing latency, etc. These are the acceptance criteria that drive architecture decisions and test plan design.

### Step 3: Domain Verification *(if equations, standards, or domain conventions are referenced)*

Use `web_search` to confirm key equations, standards, or conventions referenced in the spec. Record confirmed sources in Appendix B: Research Notes.

Skip when: algorithm is purely logic-based, domain is well-known, or no equations are involved.

### Step 4: Write System Spec

Template: `reference/system-spec-template.md`

**Review gate** before proceeding — verify:
- Clear algorithm objectives with quantitative acceptance criteria
- Complete external interface contract (all inputs, outputs, parameters with units and sign conventions)
- Operating mode completeness — are all modes defined, including startup, fault, and degraded?
- Actuator/effector mapping correctness — which output drives which actuator, and is the sign correct?
- Boundary behavior — what happens at saturation, zero-crossing, enable/disable thresholds?

### Step 5: Write Architecture Spec

Template: `reference/architecture-spec-template.md`

**Review gate** before finalizing — verify:
- Dimensional consistency — units match across all interfaces end-to-end
- Feedback polarity — negative feedback for stabilizing loops, correct sign through the entire loop
- Anti-windup and reset behavior specified for every integrator
- Mode transition logic — bumpless transfer, initialization on mode entry, no unguarded transitions
- Rate transitions — multi-rate interfaces handled correctly
- Saturation and limiting at actuator outputs and per-channel levels
- Algebraic loops — every feedback path has an explicit delay element with documented IC and DFT status annotated in the Component Catalog
- Code generation constraints addressed (data types, scheduling, memory) if applicable

**Required:** API Verification for any API, function, or block behavior not already used in neighboring code. Test actual signatures and behavior using `evaluate_matlab_code`, `web_search`, or existing codebase usage. Record in Appendix B of the architecture spec.

### Step 6: Write Implementation Plan + Test Plan

Templates: `reference/implementation-plan-template.md`, `reference/test-plan-template.md`

**Review gate — Implementation Plan** — verify:
- Phase 0 interface freeze gates all parallel work
- Build order respects data flow dependencies (leaf components first)
- Tightly coupled components assigned to same agent or coordinated
- Each checkpoint has concrete verification steps (model_read, model_query_params, test)
- Parameter table complete with sources

**Review gate — Test Plan** — verify:
- Staged validation: component MIL → integrated MIL → system-in-loop MIL → robustness → SIL/PIL (if code-generated)
- Every operating mode tested, including startup and fault
- Mode transition scenarios with bumpless transfer checks
- Saturation and anti-windup recovery tests
- Quantitative acceptance criteria with design basis for each test
- Input signal definitions reusable across stages

Get user approval before implementation begins.

### Updating Existing Specs

When updating specs: check affected sections, update them, update "Last Updated" date, review for consistency with other specs.

## Guardrails

### Always
- Verify feedback polarity before finalizing any control loop architecture
- Verify units and sign conventions end-to-end across all interfaces
- Freeze interfaces (Phase 0) before parallel subsystem work begins

### Ask First
- Adding operating modes not in the system spec
- Changing interface signals after Phase 0 freeze
- Deviating from the plant's or system's sample time alignment

### Never
- Implement control without specifying anti-windup / saturation behavior for integrators
- Hardcode tuning parameters that should be calibratable
- Skip mode transition specification for multi-mode algorithms
- Break an algebraic loop with a Memory block in a continuous-time path (use Unit Delay for discrete, Transfer Fcn with small time constant for continuous)

## Spec Types

For guidance on when to create optional specs (detailed spec, component spec), see `reference/spec-types.md`. Create a detailed spec when architecture is blocked by: control law definition, state machine definition, or interface contract.

## References

- `reference/system-spec-template.md` — System spec template (what & why)
- `reference/architecture-spec-template.md` — Architecture template (functional decomposition)
- `reference/implementation-plan-template.md` — Build sequence template
- `reference/test-plan-template.md` — Validation plan template
- `reference/algorithm-guidance.md` — Optional domain research checklist
- `reference/detailed-spec-template.md` — Control law, state machine, or interface contract (use when architecture is blocked)
- `reference/component-spec-template.md` — Complex component internals (rarely needed)

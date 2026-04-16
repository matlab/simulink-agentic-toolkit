---
name: specifying-plant-models
description: "Specify plant models for closed-loop simulation: system specs, architecture, build plans, validation plans. Use when creating, updating, or reviewing plant model specifications, planning plant model architecture, or planning plant model validation."
license: MathWorks BSD-3-Clause
metadata:
  version: "1.0"
---

# Plant Model Specs

Structured specification of plant models for closed-loop simulation. Adapts the `specifying-software` templates for the physics-modeling domain.

## When to Use

- Creating a plant model to close the loop with an existing controller
- Updating or extending an existing plant model spec
- Specifying a plant model before building it
- Deciding on model architecture (subsystem decomposition, fidelity level)
- Planning validation of a plant model

## When NOT to Use

- **Building** the plant model → use `building-simulink-models`
- **Testing** an existing plant model → use `testing-simulink-models`
- **Specs for controller algorithms or MBD algorithms** → use `specifying-mbd-algorithms`
- **Specs for traditional software** (C, C++, Python, MATLAB scripts) → use `specifying-software`
- **Specifying a full closed-loop system** → use `specifying-mbd-algorithms` for the algorithm side, this skill for the plant side

## Output Conventions

Store specs per plant model. **Prefix every filename with the plant name** so files are self-identifying in editor tabs, search results, and flat listings:

```
docs/specs/plant-models/<plant-name>/
├── <plant-name>-system.md              # What & why
├── <plant-name>-architecture.md        # Subsystem decomposition
├── <plant-name>-implementation-plan.md # Build sequence
└── <plant-name>-test-plan.md           # Validation plan
```

Example for a plant called `motor`:
```
docs/specs/plant-models/motor/
├── motor-system.md
├── motor-architecture.md
├── motor-implementation-plan.md
└── motor-test-plan.md
```

## Mode Selection

> Does this plant have <5 states, single-rate dynamics, no strong nonlinearities, and will be built by one person/agent?
> - **Yes** → Quick spec: 2 documents (system+architecture combined, implementation+test combined)
> - **No** → Full spec: 4 separate documents

### Document Boundaries

| Spec | Answers | Does NOT Contain |
|------|---------|------------------|
| **System** | What are we building and why? | Subsystem decomposition, equations |
| **Architecture** | How is it structured? | Simulink block details, parameter values |
| **Implementation Plan** | How do we build it? | Actual model_edit commands |
| **Test Plan** | How do we validate it? | Test execution results |

In quick mode, combine system+architecture and implementation+test into two documents.

## Workflow

### Step 1: Analyze Controller Interface

Read the controller model with `model_overview` and `model_read`. Classify every signal as:
- **u** (commanded inputs from controller), **w** (exogenous disturbances),
- **y** (measured outputs to controller, with sensor effects), **z** (truth outputs for debugging)

Define the plant boundary and document sample times.

### Step 2: Assess Validation Evidence

**Before researching the domain**, establish what evidence exists: test data, datasheets, standard maneuvers, analytic expectations, reference models.

Fidelity must be justified by available evidence — no point modeling dynamics you can't validate. Intended use matters: MIL rapid iteration → lower fidelity acceptable; HIL/code generation → fixed-step, real-time constraints.

### Step 3: Research the Physics Domain

Use `web_search` and `read_web_page` for standard modeling approaches, reference parameters, and authoritative sources. Consult `reference/plant-model-guidance.md` for cross-domain patterns if needed.

### Step 4: Write System Spec

Use `reference/system-spec-template.md`. Key plant-model sections: operating scenarios, physical model requirements, controller interface contract (u/w/y/z with sample times, data types, units), initialization & operating points, rate & timing alignment, validation evidence, reference sources.

**Review gate** before proceeding — verify:
- Completeness of interface requirements (u, y signals covered)
- Appropriate fidelity given intended use AND available validation evidence
- Coverage of controller's operating envelope in operating scenarios
- Operating points / initialization strategy specified and feasible
- Rate/sample time alignment with controller defined
- Clear validation reference for each major requirement

Get user review before proceeding.

### Step 5: Write Architecture Spec

Use `reference/architecture-spec-template.md`. Key plant-model sections: component catalog with physics domain and port interfaces, equations of motion per subsystem, nonlinearities & constraints, numerical considerations (solver, stiffness, algebraic loops), parameter management, uncertainty hooks.

**Review gate** before finalizing — verify:
- Correct physics decomposition — subsystem boundaries at natural domain boundaries
- Complete signal flow from u through dynamics to y
- Disturbances w entering at the right points
- Consistent interfaces: units, sign conventions, coordinate frames end-to-end
- DAE / algebraic loop risks addressed; conservation laws respected
- Missing dynamics that affect the controller (actuator limits, sensor noise, transport delays)

Get user review before proceeding.

### Step 6: Write Implementation Plan + Test Plan

Use `reference/implementation-plan-template.md` and `reference/test-plan-template.md`.

**Implementation plan essentials:**
- Phase 0 (interface contract & stubs) gates all parallel work — freeze ports/units/sign conventions first
- Loosely coupled subsystems (sensors, actuators, load, environment) can be built by separate agents concurrently after Phase 0; tightly coupled splits (inverter↔motor, tire↔chassis) need coordination
- Model References enable the strongest parallel development (separate .slx files)
- Parameter table: every parameter with name, value, unit, source, block path
- Sync points use `model_read` verification and `model_query_params` spot-checks

**Test plan essentials:**
- Three-stage validation: subsystem open-loop → integrated open-loop → closed-loop
- Input signal definitions with parameters (step, ramp, sine sweep)
- Gherkin scenarios mapped to `model_test` format
- Quantitative acceptance criteria with physical justification

**Review gate — Implementation Plan** — verify:
- Realistic bottom-up build order (leaf subsystems first)
- Phase 0 interface stubs gate parallel work
- Correct Simulink block types for the physics
- Solver choice matches stiffness + discrete elements
- Complete parameter table with sources and units

**Review gate — Test Plan** — verify:
- Validation staging: subsystem open-loop → integrated open-loop → closed-loop (MIL)
- Real-time execution feasibility assessed if plant is HIL-targeted
- Each maneuver specifies: input, outputs, comparison method, acceptance criteria
- Parameter sensitivity checks included
- Numerical robustness test (solver tolerance, step size)
- Gherkin scenarios executable via model_test

Get user approval before building begins.

## Guardrails

### Always
- Classify signals as u/w/y/z at every interface
- Cite sources for every parameter (value, unit, source, uncertainty, conditions)
- Assess validation evidence before choosing fidelity level
- Decompose into subsystems at natural domain boundaries (actuator, dynamics, sensor, environment, load)

### Ask First
- Fidelity level changes after system spec is approved
- Adding subsystems not in the architecture spec
- Deviating from the controller's sample time alignment

### Never
- Reproduce textbook derivations in specs — cite authoritative sources instead; use `web_search` for domain-specific research
- Model dynamics you cannot validate against available evidence
- Skip Phase 0 interface stubs when parallel building is planned
- Use `web_search` results from unvetted sources — prefer standards, textbooks, MathWorks docs, and peer-reviewed papers

## References

- `reference/system-spec-template.md` — System spec template (what & why)
- `reference/architecture-spec-template.md` — Architecture template (subsystem decomposition)
- `reference/implementation-plan-template.md` — Build sequence template
- `reference/test-plan-template.md` — Validation plan template
- `reference/plant-model-guidance.md` — Optional domain reference (decomposition examples, validation maneuvers, solver guide). Human-facing; do not copy verbatim into specs.

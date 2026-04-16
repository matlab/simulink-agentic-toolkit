# Plant Model System Spec Template

# [Plant Model Name]

## Status: Draft
**Last Updated:** [Date]  
**Author:** [Name]  
**Reviewers:** [Names]

---

## 1. Executive Summary

*1-2 paragraphs: What plant model is being created and why? What controller does it close the loop with? Write for someone unfamiliar with the project and domain.*

---

## 2. Problem Statement

### Current Situation

*What exists today? Is there no plant model, or an existing one that's inadequate? What controller needs this plant?*

1. **[Issue]** — [Description and impact on controller development]
2. **[Issue]** — [Description]

### Opportunity

*What becomes possible with this plant model? How does it enable controller development, testing, or validation?*

---

## 3. Goals & Success Metrics

### Goals

*Focus on outcomes relevant to closed-loop simulation fidelity.*

| Goal | Description |
|------|-------------|
| **G1: [Name]** | [Measurable outcome — e.g., "Plant model reproduces step response within 5% of reference data"] |
| **G2: [Name]** | [Measurable outcome — e.g., "Closed-loop simulation runs at 10× real-time or faster"] |
| **G3: [Name]** | [Measurable outcome] |

### Success Metrics

*Quantitative validation metrics with per-project justification. Define what 'good enough' means for this specific plant model.*

- **[Metric]**: [Definition] (target: [value] — e.g., R² > 0.95 against test data)
- **[Metric]**: [Definition] (target: [value] — e.g., settling time error < 10%)

---

## 4. Non-Goals (v1)

*Explicit scope boundaries. What physics, fidelity levels, or use cases are excluded?*

| Non-Goal | Rationale |
|----------|-----------|
| **[Thing not modeling]** | [Why excluded — e.g., "Thermal effects negligible at operating frequencies"] |
| **[Fidelity not targeting]** | [Why not in this version] |

---

## 5. Operating Scenarios

*2-4 concrete scenarios describing physical conditions and maneuvers the plant model must represent. These are the "use cases" for the plant model — driven by what the controller needs to be tested against.*

### Scenario 1: [Scenario Name]

**Operating Conditions:** *Physical conditions — e.g., nominal supply voltage, ambient temperature, nominal load*

**Maneuver/Excitation:**
1. [Initial condition / steady state]
2. [Input change — e.g., "Step change in duty cycle from 0.3 to 0.7"]
3. [Expected physical response — e.g., "Output voltage rises to new setpoint within 2ms"]
4. [Duration and what should be observable]

**Controller Behavior:** *How the controller responds during this scenario*

### Scenario 2: [Scenario Name]

**Operating Conditions:** *[Conditions — e.g., edge of operating range]*

**Maneuver/Excitation:**
1. [Steps...]

**Controller Behavior:** *[How controller responds]*

---

## 6. Physical Model Requirements

*What physics the model must capture. Driven by fidelity decisions from validation evidence assessment.*

### 6.1 States & Governing Equations

*List the physical states and the type of equations governing them. Do not write the equations themselves — that belongs in the architecture spec.*

| State | Physical Meaning | Equation Type |
|-------|-----------------|---------------|
| [x₁] | [Description — e.g., "Inductor current"] | [ODE / algebraic / lookup table] |
| [x₂] | [Description] | [Type] |

### 6.2 Key Assumptions

*Physical assumptions that bound model fidelity. Each assumption should have a justification.*

| Assumption | Justification |
|------------|---------------|
| [Assumption — e.g., "Rigid body (no structural flex)"] | [Why valid — e.g., "Frequencies of interest < 10 Hz, first flex mode at 50 Hz"] |
| [Assumption] | [Justification] |

### 6.3 Fidelity Level

*State the chosen fidelity level and justify it based on intended use and available validation evidence.*

**Chosen fidelity:** [Low / Medium / High]

**Justification:** *Justify based on intended use, controller bandwidth, and available validation evidence.*

### 6.4 Coordinate Frame & Sign Conventions

*Define the reference frame and positive directions used throughout the model. Critical for multi-domain models.*

| Convention | Definition |
|------------|------------|
| [Frame / axis / direction] | [Definition — e.g., "Positive current flows from source to load"] |

---

## 7. Controller Interface Contract

*The primary constraint on plant model design. Every signal crossing the plant-controller boundary.*

### 7.1 Plant Inputs (from Controller)

| Signal | Symbol | Unit | Data Type | Sample Time | Description |
|--------|--------|------|-----------|-------------|-------------|
| [Name] | u₁ | [unit] | [double/single/boolean] | [Ts or continuous] | [What the controller commands] |

### 7.2 Plant Outputs (to Controller)

| Signal | Symbol | Unit | Data Type | Sample Time | Description |
|--------|--------|------|-----------|-------------|-------------|
| [Name] | y₁ | [unit] | [type] | [Ts] | [What the controller measures] |

### 7.3 Exogenous Inputs (Disturbances)

| Signal | Symbol | Unit | Source | Description |
|--------|--------|------|--------|-------------|
| [Name] | w₁ | [unit] | [Constant / signal / scenario-dependent] | [Disturbance or ambient condition] |

### 7.4 Truth Outputs (Debug/Validation Only)

| Signal | Symbol | Unit | Description |
|--------|--------|------|-------------|
| [Name] | z₁ | [unit] | [Internal state exposed for validation, not available to controller] |

---

## 8. Initialization & Operating Points

*How the model starts and what steady-state conditions it must support.*

### 8.1 Nominal Operating Point

*The default initial condition for simulation.*

| State | Initial Value | Unit | How Determined |
|-------|--------------|------|----------------|
| [x₁] | [value] | [unit] | [Analytic / trim / measured] |

### 8.2 Operating Range

*Range of operating points the model must support.*

| Parameter | Min | Nominal | Max | Unit |
|-----------|-----|---------|-----|------|
| [Operating parameter] | [min] | [nom] | [max] | [unit] |

### 8.3 Initialization Strategy

*How initial conditions are set: hardcoded, computed from trim, loaded from workspace, etc.*

---

## 9. Rate & Timing Alignment

*Sample time and rate transition strategy between plant and controller.*

| Component | Rate | Type | Notes |
|-----------|------|------|-------|
| Plant dynamics | [Ts or continuous] | [Continuous / discrete] | [Solver dependency] |
| Controller | [Ts] | [Discrete] | [Given, not designed here] |
| Sensor model | [Ts] | [Discrete / continuous] | [Must match controller input rate] |
| Actuator model | [Ts or continuous] | [Type] | [Notes] |

**Rate transition strategy:** *How mismatched rates are handled (Rate Transition blocks, ZOH, etc.)*

---

## 10. Validation Evidence

*What data or benchmarks exist to validate the plant model against. This drives fidelity decisions.*

| Evidence Type | Available? | Description | Covers |
|---------------|-----------|-------------|--------|
| Hardware test data | [Yes/No] | [Description of data] | [Which behaviors] |
| Component datasheets | [Yes/No] | [What parameters] | [Which subsystems] |
| Reference model | [Yes/No] | [Description] | [Which dynamics] |
| Analytic expectations | [Yes/No] | [Known transfer functions, time constants] | [Which responses] |
| Standard maneuvers | [Yes/No] | [ISO or industry standard tests] | [Which operating scenarios] |

---

## 11. Reference Sources

*Literature, standards, and examples used for domain research. Every modeling decision should be traceable.*

| Source | Type | Used For |
|--------|------|----------|
| [Author (Year), Title] | [Textbook / paper / standard / MathWorks example] | [What it informed] |

---

## 12. Open Questions

*Decisions not yet made. Move to Architecture "Key Decisions" when resolved.*

| # | Question | Options | Decision |
|---|----------|---------|----------|
| 1 | [Question] | (a) [option], (b) [option] | 🟡 Pending |

---

## 13. Future Considerations

*Explicitly parked for later versions — higher fidelity, additional physics, etc.*

- **[Feature/fidelity]**: [Why deferred, when might revisit]

---

## Appendix A: Related Documents

- [Architecture Spec](architecture.md)
- [Implementation Plan](implementation_plan.md)
- [Test Plan](test_plan.md)

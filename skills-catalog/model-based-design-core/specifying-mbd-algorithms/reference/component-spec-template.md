# MBD Algorithm Component Spec Template

**Rarely needed.** Only create when architecture §4 Component Details isn't sufficient for a complex component — e.g., a Stateflow chart with 10+ states, a multi-physics subsystem with coupled dynamics, or a component with complex initialization/reset behavior.

**Skip when:** Architecture §4 can capture the component's behavior adequately.

---

# [Component Name] Specification

## Status: Draft
**Last Updated:** [Date]  
**Architecture Spec:** [Link — §4.N for this component]

---

## 1. Overview

*Why this component needs a separate spec beyond architecture §4. What makes it complex enough to warrant this document.*

---

## 2. Interface

*Full port and parameter specification (expanded from architecture §4).*

### 2.1 Ports

| Port | Direction | Signal Name | Unit | Data Type | Sample Time | Valid Range |
|------|-----------|-------------|------|-----------|-------------|------------|
| u1 | Input | [name] | [unit] | [type] | [rate] | [min, max] |
| y1 | Output | [name] | [unit] | [type] | [rate] | [min, max] |

### 2.2 Parameters

| Name | Description | Unit | Default | Range | Tunable | Storage |
|------|-------------|------|---------|-------|---------|---------|
| [name] | [description] | [unit] | [value] | [min, max] | [yes/no] | [workspace / data dictionary] |

### 2.3 States

| State Variable | Type | Initial Condition | Reset Condition | Description |
|---------------|------|-------------------|-----------------|-------------|
| [name] | [continuous/discrete] | [value or strategy] | [when reset occurs] | [what it represents] |

---

## 3. Internal Behavior

*Detailed behavior too complex for architecture §4.*

### 3.1 Dynamics / Equations

*Governing equations, transfer functions, or algorithmic steps. Use parameter symbols defined in §2.2.*

### 3.2 State Machine *(if applicable)*

**States:**

| State | Description | Entry Action | During Action | Exit Action |
|-------|-------------|-------------|---------------|-------------|
| [name] | [meaning] | [action] | [action] | [action] |

**Transitions:**

| From | To | Condition | Priority | Action |
|------|----|-----------|----------|--------|
| [state] | [state] | [guard] | [1=highest] | [action] |

**Temporal Logic:**
*Debounce timers, persistence counters, delay patterns.*

### 3.3 Nonlinearities & Constraints

| Nonlinearity | Location | Behavior |
|-------------|----------|----------|
| [Saturation] | [where] | [limits, what happens at limit] |
| [Dead zone] | [where] | [threshold, behavior within zone] |
| [Lookup table] | [where] | [dimensions, interpolation method, extrapolation] |

### 3.4 Boundary Conditions

| Case | Input Condition | Expected Behavior |
|------|----------------|-------------------|
| [First execution] | [no prior state] | [initialization behavior] |
| [Saturation] | [signal at limit] | [output behavior, integrator behavior] |
| [Enable/disable] | [enable signal transitions] | [initialization on enable, hold on disable] |
| [NaN/Inf input] | [invalid data] | [protection strategy] |

---

## 4. Initialization & Reset

*How this component starts and recovers — critical for bumpless transfer and mode transitions.*

| Event | Behavior |
|-------|----------|
| **First execution** | [How states initialize — zero, preloaded from parameter, from operating point] |
| **Mode entry** | [What happens when this component is enabled mid-simulation — bumpless transfer strategy] |
| **Mode exit** | [What happens when disabled — hold last output, reset, ramp to zero] |
| **Fault recovery** | [How states are restored after a fault clears] |

---

## 5. Solver & Code Generation

*Skip sections that don't apply.*

| Concern | Specification |
|---------|--------------|
| **Algebraic loops** | [Whether this component participates in algebraic loops, mitigation strategy] |
| **Stiffness** | [Whether dynamics are stiff, solver implications] |
| **Fixed-step compatibility** | [Whether component works with fixed-step solver, required step size] |
| **Atomic subsystem** | [Whether this must be atomic for code generation — function packaging] |
| **Data types** | [single/double/fixed-point requirements for this component] |

---

## 6. Testing Notes

*Special testing considerations for this component.*

- [Key scenarios that exercise the complexity warranting this spec]
- [State combinations that must be tested]
- [Numerical edge cases to verify]

---

## Appendix: Design Rationale

*Why the component is designed this way.*

| Aspect | Decision | Rationale |
|--------|----------|-----------|
| [Aspect] | [What was chosen] | [Why] |

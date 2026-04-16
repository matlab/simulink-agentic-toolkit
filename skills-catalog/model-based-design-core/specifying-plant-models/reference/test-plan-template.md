# Plant Model Test Plan Template

# [Plant Model Name] Test Plan

## Status: Draft
**Last Updated:** [Date]  
**Architecture Spec:** [Link]

---

## 1. Overview

*Validation approach and staging.*

**Validation Stages:**
- **Subsystem Open-Loop** — Validate individual subsystem physics against known responses
- **Integrated Open-Loop** — Validate complete plant with known inputs (no controller)
- **Closed-Loop** — Validate plant + controller system-level behavior

**Validation Philosophy:** Each stage must pass before proceeding to the next. Failures at higher stages are debugged by dropping back to lower stages.

---

## 2. Subsystem Open-Loop Validation

*Per-subsystem validation against known physical behavior.*

### 2.1 [Subsystem Name]

**What is validated:** *Which physical behavior — e.g., "LC filter step response dynamics"*

#### Steady-State Tests

| Test | Input | Expected Output | Acceptance Criterion | Physical Basis |
|------|-------|-----------------|---------------------|----------------|
| [Test name] | [Constant input values] | [Expected steady-state] | [Criterion — e.g., "Within 1% of V_out = D × V_in"] | [Why this is the expected value] |

#### Transient Tests

| Test | Excitation | Expected Response | Acceptance Criterion | Physical Basis |
|------|-----------|-------------------|---------------------|----------------|
| [Test name] | [Step / ramp / pulse description] | [Expected transient — overshoot, settling time, time constant] | [Criterion — e.g., "Settling time within 10% of τ = L/R"] | [Physical basis] |

#### Edge Cases

| Test | Condition | Expected Behavior | Acceptance Criterion |
|------|-----------|-------------------|---------------------|
| [Test name] | [Boundary condition — e.g., "Input at saturation limit"] | [Expected — e.g., "Output clamps, no windup"] | [Criterion] |

### 2.2 [Subsystem Name]

*Continue for each subsystem...*

---

## 3. Integrated Open-Loop Plant Validation

*Complete plant with known inputs — no controller in the loop.*

### 3.1 [Validation Maneuver Name]

**Operating Conditions:** *[Conditions from system spec operating scenarios]*

**Input Signals:**

| Signal | Type | Parameters | Duration |
|--------|------|-----------|----------|
| [u₁ name] | [Step / ramp / sine / chirp] | [Amplitude, timing, frequency] | [seconds] |
| [w₁ name] | [Constant / profile] | [Value or profile description] | [seconds] |

**Expected Outputs:**

| Signal | Expected Behavior | Acceptance Criterion | Comparison Method |
|--------|-------------------|---------------------|-------------------|
| [y₁] | [Physical description] | [Quantitative — e.g., "R² > 0.95 vs reference"] | [Analytic / reference data / transfer function] |
| [z₁] | [Physical description] | [Criterion] | [Method] |

### 3.2 [Validation Maneuver Name]

*Continue for each maneuver...*

---

## 4. Closed-Loop Validation

*Plant + controller — system-level performance.*

### 4.1 [Closed-Loop Scenario Name]

**Setup:** *[Controller configuration, setpoints, operating conditions]*

**Scenario:**
1. [Initial steady state]
2. [Command change or disturbance]
3. [Expected system response]
4. [Duration]

**Acceptance Criteria:**

| Metric | Target | Physical Justification |
|--------|--------|------------------------|
| [Settling time] | [value] | [Why this target — e.g., "Controller bandwidth implies < 5ms"] |
| [Overshoot] | [value] | [Why] |
| [Steady-state error] | [value] | [Why] |
| [Stability] | [value] | [Why — e.g., "Gain margin > 6 dB per design spec"] |

### 4.2 [Closed-Loop Scenario Name]

*Continue for each scenario...*

---

## 5. Simulation Configuration

*Settings that apply to all validation tests.*

| Setting | Value | Rationale |
|---------|-------|-----------|
| Solver | [ode45 / ode15s / etc.] | [From architecture spec] |
| Step size / tolerance | [value] | [Based on fastest dynamics] |
| Stop time | [varies by test] | [Per scenario] |
| Initial conditions | [reference to system spec §8] | [Operating point] |
| Signal logging | [which signals] | [For post-processing] |

---

## 6. Input Signal Definitions

*Reusable test input specifications.*

| Signal ID | Type | Parameters | Used In |
|-----------|------|-----------|---------|
| STEP_01 | Step | Amplitude: [val], Time: [val] | [Test IDs] |
| RAMP_01 | Ramp | Slope: [val/s], Start: [val], Duration: [s] | [Test IDs] |
| SINE_01 | Sine | Amplitude: [val], Frequency: [Hz], Duration: [s] | [Test IDs] |
| CHIRP_01 | Chirp | Amp: [val], f_start: [Hz], f_end: [Hz], Duration: [s] | [Test IDs] |

---

## 7. Gherkin Scenario Templates

*Map validation maneuvers to executable model_test scenarios.*

### 7.1 [Maneuver Name]

```gherkin
Feature: [Plant Model Name] - [Maneuver Name]

  Scenario: [Descriptive scenario name]
    # Simulation setup
    Given the model "[ModelName].slx" is loaded
    And the solver is "[solver]" with step size [value]
    And parameter "[param]" is set to [value]

    # Input excitation
    When a step input of [value] [unit] is applied to "[input_port]" at t=[time]s

    # Steady-state validation
    Then at t=[time]s, "[output_port]" shall be [value] [unit] within [tolerance]

    # Transient validation
    And "[output_port]" shall settle to within [band] of [value] [unit] by t=[time]s
    And "[output_port]" overshoot shall be less than [value] [unit]
```

### 7.2 [Maneuver Name]

*Continue for each maneuver...*

---

## 8. Parameter Sensitivity Tests

*Verify the model degrades gracefully when key parameters vary.*

| Parameter | Nominal | Range | Test | Acceptance Criterion |
|-----------|---------|-------|------|---------------------|
| [param] | [value] | [±X%] | [Which maneuver re-run] | [e.g., "Settling time stays within 2× nominal"] |
| [param] | [value] | [±X%] | [Maneuver] | [Criterion] |

**Method:** For each parameter, run the specified maneuver at nominal, +X%, and -X% values. Model must remain stable and produce physically reasonable results across the range.

---

## 9. Numerical Robustness Tests

*Verify the model isn't tuned to a specific solver configuration.*

| Test | Variation | Acceptance Criterion |
|------|-----------|---------------------|
| Solver tolerance | [10× tighter, 10× looser] | [Results within X% of baseline] |
| Step size | [2× larger, 2× smaller] | [Results within X% of baseline] |
| Different solver | [Alternative solver] | [Results within X% of baseline] |

---

## Appendix A: Test Execution Commands

*Commands to run validation tests via model_test.*

```
# Subsystem validation
Use model_test with: model="[ModelName].slx", gherkin_file="[path/to/feature].feature", scenarios='["scenario_name"]'

# Integrated open-loop validation
Use model_test with: model="[ModelName].slx", gherkin_file="[path/to/feature].feature", scenarios='["scenario_name"]'

# Closed-loop validation
Use model_test with: model="[ModelName].slx", gherkin_file="[path/to/feature].feature", scenarios='["scenario_name"]'
```

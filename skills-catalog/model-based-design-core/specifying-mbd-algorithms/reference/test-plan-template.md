# Algorithm Test Plan Template

# [Algorithm Name] Test Plan

## Status: Draft
**Last Updated:** [Date]  
**Architecture Spec:** [Link]

---

## 1. Overview

*Validation approach and staging.*

**Validation Stages:**
- **Component Validation (MIL)** — Test individual algorithm components in isolation with scripted inputs
- **Integrated Algorithm Validation (MIL)** — All components wired together, scripted inputs, no plant or system
- **System-in-Loop Validation (MIL)** — Algorithm connected to plant model or representative environment
- **Robustness & Sensitivity** — Parameter variation, noise, boundary conditions
- **Implementation Equivalence** *(optional)* — SIL (compiled code on host) / PIL (on target processor) back-to-back against MIL baseline

**Validation Philosophy:** Each stage must pass before proceeding to the next. Failures at higher stages are debugged by dropping back to lower stages.

---

## 2. Component Validation

*Per-component tests in isolation with scripted inputs.*

### 2.1 [Component Name]

**What is validated:** *Which algorithmic behavior — e.g., "PI controller tracks step reference," "Stateflow chart enters fault mode on threshold crossing"*

#### Steady-State Tests

| Test | Input | Expected Output | Acceptance Criterion | Basis |
|------|-------|-----------------|---------------------|-------|
| [Test name] | [Constant input values] | [Expected steady-state output] | [Criterion — e.g., "Output within 1% of setpoint"] | [Design equation or requirement] |

#### Transient / Dynamic Tests

| Test | Excitation | Expected Response | Acceptance Criterion | Basis |
|------|-----------|-------------------|---------------------|-------|
| [Test name] | [Step / ramp / pulse description] | [Expected transient — rise time, overshoot, settling] | [Criterion — e.g., "Settling time < 50 ms"] | [Design basis] |

#### Edge Cases

| Test | Condition | Expected Behavior | Acceptance Criterion |
|------|-----------|-------------------|---------------------|
| [Test name] | [Boundary condition — e.g., "Input saturated at upper limit"] | [Expected — e.g., "Output clamps, integrator does not wind up"] | [Criterion] |

#### Stateflow-Specific Tests *(if applicable)*

| Test | Trigger | Expected Transition | Exit State | Temporal Constraint |
|------|---------|--------------------|-----------|--------------------|
| [Test name] | [Event or condition] | [Source → Destination state] | [Final state] | [e.g., "Transition within 1 sample," "After 5 s dwell"] |

#### Control Law Characteristics *(if applicable)*

| Test | Excitation | Metric | Acceptance Criterion |
|------|-----------|--------|---------------------|
| [Step response] | [Step input] | [Rise time, overshoot, settling time] | [Design spec values] |
| [Frequency response] | [Chirp / sine sweep] | [Bandwidth, gain margin, phase margin] | [Design spec values] |

#### Signal Processing Characteristics *(if applicable)*

| Test | Excitation | Metric | Acceptance Criterion |
|------|-----------|--------|---------------------|
| [Filter response] | [Impulse / step / sweep] | [Cutoff frequency, roll-off, group delay] | [Design spec values] |
| [Detection accuracy] | [Signal + noise profiles] | [Sensitivity, specificity, false alarm rate] | [Design spec values] |

### 2.2 [Component Name]

*Continue for each component...*

---

## 3. Integrated Algorithm Validation

*All components wired together, scripted inputs — no plant or external system.*

### 3.1 Operating Mode Tests

| Mode | Entry Condition | Input Signals | Expected Behavior | Acceptance Criterion |
|------|----------------|---------------|-------------------|---------------------|
| [Mode name] | [Condition to enter mode] | [Signal IDs from §8] | [Steady-state behavior in mode] | [Criterion] |

### 3.2 Mode Transition Scenarios

| Transition | From → To | Trigger | Expected Behavior | Bumpless Transfer Check |
|-----------|-----------|---------|-------------------|------------------------|
| [Name] | [Mode A → Mode B] | [Condition or event] | [Output during transition] | [e.g., "Output discontinuity < 1% of range"] |

### 3.3 Saturation / Anti-Windup Recovery

| Test | Condition | Recovery Input | Expected Behavior | Acceptance Criterion |
|------|-----------|---------------|-------------------|---------------------|
| [Test name] | [How saturation is reached] | [Input that should cause recovery] | [Recovery dynamics] | [e.g., "Recovers to tracking within 100 ms, no overshoot > 5%"] |

### 3.4 Multi-Rate Interaction Tests *(if applicable)*

| Test | Fast Rate | Slow Rate | Expected Behavior | Acceptance Criterion |
|------|-----------|-----------|-------------------|---------------------|
| [Test name] | [Rate and component] | [Rate and component] | [Correct data transfer and timing] | [Criterion] |

---

## 4. System-in-Loop Validation

*Algorithm connected to plant model or representative environment.*

> **Note:** Adapt staging to algorithm type — not all algorithms close a loop. For open-loop signal processors, "system-in-loop" means connecting to a representative upstream signal source. For diagnostics, it means connecting to a system with fault injection capability.

### 4.1 [Scenario Name]

**Setup:** *[Plant model or signal source, operating conditions, controller/algorithm configuration]*

**Scenario:**
1. [Initial steady state or quiescent condition]
2. [Command change, disturbance, or fault injection]
3. [Expected algorithm response]
4. [Duration]

**Acceptance Criteria:**

| Metric | Target | Basis |
|--------|--------|-------|
| [Tracking error / detection latency / estimation accuracy] | [value] | [Design requirement or physical justification] |
| [Disturbance rejection / false alarm rate / convergence time] | [value] | [Basis] |
| [Stability / robustness / accuracy] | [value] | [Basis] |

### 4.2 [Scenario Name]

*Continue for each scenario...*

---

## 5. Robustness & Sensitivity

*Parameter variation, noise, and boundary conditions.*

### 5.1 Parameter Sensitivity Sweeps

| Parameter | Nominal | Range | Test | Acceptance Criterion |
|-----------|---------|-------|------|---------------------|
| [param] | [value] | [±X%] | [Which scenario re-run] | [e.g., "Performance stays within 2× nominal"] |
| [param] | [value] | [±X%] | [Scenario] | [Criterion] |

**Method:** For each parameter, run the specified scenario at nominal, +X%, and -X% values. Algorithm must remain stable and meet degraded-but-acceptable performance across the range.

### 5.2 Noise Injection Tests

| Test | Noise Type | Injection Point | Amplitude | Acceptance Criterion |
|------|-----------|----------------|-----------|---------------------|
| [Test name] | [White / colored / quantization] | [Signal path] | [SNR or amplitude] | [e.g., "Output SNR > 20 dB," "No false detections"] |

### 5.3 Boundary / Fault Condition Tests

| Test | Condition | Expected Behavior | Acceptance Criterion |
|------|-----------|-------------------|---------------------|
| [Test name] | [Operating envelope corner — e.g., "Max speed + min temperature"] | [Algorithm behavior] | [Criterion] |
| [Test name] | [Fault condition — e.g., "Sensor dropout for 100 ms"] | [Graceful degradation] | [Criterion] |

---

## 6. Implementation Equivalence *(Optional)*

*Fixed-point vs float, SIL/PIL, generated code verification.*

> **Note:** Skip if simulation-only — this stage applies only when the algorithm is destined for code generation.

### 6.1 Back-to-Back Comparison

| Test | Reference Config | Implementation Config | Comparison Criterion |
|------|-----------------|----------------------|---------------------|
| [Scenario from §4] | [Float, normal mode] | [Fixed-point / SIL / PIL] | [e.g., "Max absolute error < 1 LSB," "Relative error < 0.1%"] |

### 6.2 Fixed-Point Specific *(if applicable)*

| Signal | Word Length | Fraction Length | Overflow | Acceptance Criterion |
|--------|-----------|----------------|----------|---------------------|
| [Signal name] | [bits] | [bits] | [Saturate / Wrap] | [e.g., "No overflow events in any test scenario"] |

---

## 7. Simulation Configuration

*Settings that apply to all validation tests.*

| Setting | Value | Rationale |
|---------|-------|-----------|
| Solver | [ode45 / ode15s / Fixed-step discrete] | [From architecture spec] |
| Step size / tolerance | [value] | [Based on fastest sample rate or dynamics] |
| Stop time | [varies by test] | [Per scenario] |
| Initial conditions | [reference to system spec] | [Operating point] |
| Signal logging | [which signals] | [For post-processing and acceptance checks] |

---

## 8. Input Signal Definitions

*Reusable test input specifications.*

| Signal ID | Type | Parameters | Used In |
|-----------|------|-----------|---------|
| STEP_01 | Step | Amplitude: [val], Time: [val] | [Test IDs] |
| RAMP_01 | Ramp | Slope: [val/s], Start: [val], Duration: [s] | [Test IDs] |
| SINE_01 | Sine | Amplitude: [val], Frequency: [Hz], Duration: [s] | [Test IDs] |
| CHIRP_01 | Chirp | Amp: [val], f_start: [Hz], f_end: [Hz], Duration: [s] | [Test IDs] |
| NOISE_01 | White noise | PSD: [val], Bandwidth: [Hz], Seed: [val] | [Test IDs] |
| PULSE_01 | Pulse | Amplitude: [val], Width: [s], Period: [s] | [Test IDs] |

---

## 9. Gherkin Scenario Templates

*Map validation tests to executable model_test scenarios.*

### 9.1 [Component / Scenario Name]

```gherkin
Feature: [Algorithm Name] - [Scenario Name]

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

    # Mode transition validation (if applicable)
    And at t=[time]s, "[mode_signal]" shall be "[expected_mode]"
    And "[output_port]" discontinuity at mode change shall be less than [value] [unit]
```

### 9.2 [Component / Scenario Name]

*Continue for each scenario...*

---

## Appendix A: Test Execution Commands

*Commands to run validation tests via model_test.*

```
# Component validation
Use model_test with: model="[ModelName].slx", gherkin_file="[path/to/feature].feature", scenarios='["scenario_name"]'

# Integrated algorithm validation
Use model_test with: model="[ModelName].slx", gherkin_file="[path/to/feature].feature", scenarios='["scenario_name"]'

# System-in-loop validation
Use model_test with: model="[ModelName].slx", gherkin_file="[path/to/feature].feature", scenarios='["scenario_name"]'

# Robustness sweep (run scenario with parameter variation)
Use model_test with: model="[ModelName].slx", gherkin_file="[path/to/feature].feature", scenarios='["scenario_name"]', sweep_param="[param]", sweep_values="[nominal, +X%, -X%]"
```

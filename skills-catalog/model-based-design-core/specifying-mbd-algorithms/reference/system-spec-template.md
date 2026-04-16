# MBD Algorithm System Spec Template

*Template for algorithms authored in Simulink, Stateflow, System Composer, or MATLAB Function blocks — controllers, estimators, signal processors, diagnostics, supervisory logic. Skip sections that don't apply.*

# [Algorithm Name]

## Status: Draft
**Last Updated:** [Date]  
**Author:** [Name]  
**Reviewers:** [Names]

---

## 1. Executive Summary

*1-2 paragraphs: What algorithm is being developed, why is it needed, and what system does it integrate with? Name the plant/vehicle/process being controlled or monitored. State the algorithm class (feedback controller, state estimator, diagnostic monitor, signal filter, mode manager, etc.).*

---

## 2. Problem Statement

### Current Pain Points

*Numbered list of specific problems. Be concrete about impact.*

1. **[Pain point name]** — [Description of the problem and its impact]
2. **[Pain point name]** — [Description]
3. **[Pain point name]** — [Description]

### Opportunity

*How this algorithm addresses the problems. What performance or capability becomes possible?*

---

## 3. Goals & Success Metrics

### Goals

*Focus on algorithm performance outcomes — tracking accuracy, bandwidth, detection rate, response time, robustness.*

| Goal | Description |
|------|-------------|
| **G1: [Name]** | [Measurable algorithm performance outcome] |
| **G2: [Name]** | [Measurable outcome] |
| **G3: [Name]** | [Measurable outcome] |

*Examples: "Tracking error < 2% of setpoint under nominal load", "Fault detection within 50 ms of onset", "Bandwidth ≥ 10 Hz with ≥ 45° phase margin".*

### Success Metrics

*Quantitative targets. How will you verify the algorithm meets its goals?*

- **[Metric name]**: [Definition] (target: [value], method: [simulation / analysis / test])
- **[Metric name]**: [Definition] (target: [value], method: [simulation / analysis / test])

---

## 4. Non-Goals (v1)

*Explicit scope boundaries. Prevents scope creep.*

| Non-Goal | Rationale |
|----------|-----------|
| **[Thing not doing]** | [Why not in this version] |
| **[Thing not doing]** | [Why not] |

---

## 5. Operating Scenarios

*Concrete scenarios tracing input conditions to expected algorithm behavior. Cover startup, nominal, and fault/degraded conditions. These serve as acceptance criteria.*

| ID | Scenario | Input Conditions | Expected Algorithm Behavior | Performance Criteria |
|----|----------|-----------------|----------------------------|---------------------|
| S1 | [Scenario name] | [Initial/operating conditions] | [What the algorithm does] | [Quantitative criterion] |
| S2 | [Scenario name] | [Conditions] | [Expected behavior] | [Criterion] |

*Add or remove rows as needed. Each row should be verifiable in simulation without inspecting internal states.*

*Choose scenarios appropriate to the algorithm type. Examples by domain:*
- *Controller: startup/initialization, nominal tracking, disturbance rejection, saturation/anti-windup recovery*
- *Estimator: convergence from cold start, tracking under noise, response to sensor dropout*
- *Diagnostic: fault present (detection latency, correct classification), fault absent (no false alarms), intermittent fault*
- *Signal processor: nominal input spectrum, out-of-band rejection, response to overload/clipping*

---

## 6. External Interface Contract

*The algorithm's boundary definition. All signals crossing the subsystem boundary are defined here. Use the exact names, units, and types that will appear in the Simulink model.*

### 6.1 Inputs

*Measurements, commands, and bus signals entering the algorithm.*

| Name | Description | Unit | Data Type | Sample Time | Sign Convention | Source |
|------|-------------|------|-----------|-------------|-----------------|--------|
| [name] | [description] | [unit] | [double/single/uint16/boolean/Bus:Name] | [e.g., 1 ms] | [positive direction / meaning] | [source subsystem] |

### 6.2 Outputs

*Actuator commands, processed signals, and status flags leaving the algorithm.*

| Name | Description | Unit | Data Type | Sample Time | Sign Convention | Destination |
|------|-------------|------|-----------|-------------|-----------------|-------------|
| [name] | [description] | [unit] | [type] | [rate] | [positive direction / meaning] | [destination subsystem] |

*For bus signals (Data Type = `Bus:Name`), define bus elements here or reference a shared bus dictionary:*

| Bus Name | Element | Unit | Data Type | Description |
|----------|---------|------|-----------|-------------|
| [BusName] | [element] | [unit] | [type] | [description] |

### 6.3 Parameters

#### Calibratable Parameters *(tunable post-deployment)*

| Name | Description | Unit | Default | Range | Tuning Guidance |
|------|-------------|------|---------|-------|-----------------|
| [name] | [description] | [unit] | [value] | [min, max] | [how to tune, what to watch for] |

#### Fixed Parameters *(set at design time, not tunable in deployment)*

| Name | Description | Unit | Value | Source / Rationale |
|------|-------------|------|-------|--------------------|
| [name] | [description] | [unit] | [value] | [why this value] |

---

## 7. Operating Modes

*Skip if single-mode algorithm.*

*Top-level state/mode definition. Each mode represents a distinct algorithm behavior. Detail the transitions and initialization. This maps directly to a top-level Stateflow chart or enabled-subsystem structure.*

| Mode | Entry Condition | Exit Condition | Active Behavior | Initialization on Entry |
|------|----------------|----------------|-----------------|------------------------|
| [Mode name] | [Condition] | [Condition] | [What the algorithm does in this mode] | [State initialization on entry — integrator reset, output preload, etc.] |

---

## 8. Code Generation & Execution Constraints

*Skip if simulation-only.*

*Constraints that affect model architecture when the algorithm will be deployed via Embedded Coder, HDL Coder, or similar.*

### Target Hardware

- **Processor:** *[e.g., ARM Cortex-M4, TI C2000, Infineon AURIX]*
- **Word size:** *[e.g., 32-bit]*
- **Floating-point unit:** *[Yes / No — drives fixed-point decision]*

### Fixed-Point Strategy

*[Not required / Manual scaling / autoscaling with design ranges / shared fixed-point dictionary]*

### Memory & Timing Budget

| Resource | Budget | Notes |
|----------|--------|-------|
| RAM | [bytes] | [Shared with __, includes state variables] |
| ROM | [bytes] | [Flash partition constraint] |
| WCET | [µs] per invocation | [Must complete within sample period] |

### Scheduling

- **Base rate:** *[e.g., 1 ms]*
- **Multi-rate:** *[e.g., fast loop at 1 ms, slow loop at 10 ms]*
- **Rate transition handling:** *[Rate Transition blocks / single-rate design]*

### Compliance Requirements

*[e.g., MAAB style guidelines, MISRA C:2012, DO-178C objectives, ISO 26262 ASIL level]*

---

## 9. Open Questions

*Decisions not yet made. Move to Architecture "Key Decisions" when resolved.*

| # | Question | Options | Decision |
|---|----------|---------|----------|
| 1 | [Question] | (a) [option], (b) [option] | 🟡 Pending |
| 2 | [Question] | (a) [option], (b) [option] | ✅ Decided: [choice] |

---

## 10. Future Considerations

*Explicitly parked for later versions.*

- **[Feature/capability]**: [Why deferred, when might revisit]
- **[Feature/capability]**: [Why deferred]

---

## Appendix A: Related Documents

*Links to related specs, plant model specs, architecture specs, datasheets.*

- [Document name](path)

## Appendix B: Research Notes

*Background research, reference papers, prior controller designs that informed decisions.*

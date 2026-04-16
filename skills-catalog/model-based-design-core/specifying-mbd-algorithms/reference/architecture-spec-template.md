# MBD Algorithm Architecture Spec Template

Focus on functional decomposition, signal interfaces, mode logic, and algorithmic behavior — not Simulink block wiring.

---

# [Algorithm Name] Architecture

## Status: Draft
**Last Updated:** [Date]  
**Author:** [Name]  
**Parent Spec:** [Link to System Spec]

---

## 1. Overview

*1 paragraph: What algorithm does this cover, what system does it integrate with (plant model, vehicle controller, test harness), and what are its primary inputs and outputs?*

---

## 2. Goals, Non-Goals & Constraints

### 2.1 Design Goals

*Goals that shape the algorithm architecture.*

| ID | Goal |
|----|------|
| G1 | [Design goal — e.g., "Separate estimation from control logic for independent tuning"] |
| G2 | [Design goal — e.g., "All calibration parameters grouped by function for easy tuning"] |

### 2.2 Non-Goals

| ID | Non-Goal | Rationale |
|----|----------|-----------|
| NG1 | [Not doing — e.g., "No adaptive gain scheduling in this release"] | [Why not in scope] |

### 2.3 Constraints

*External limitations that shaped the design.*

| Constraint | Description |
|------------|-------------|
| C1 | [Constraint — e.g., "Fixed-step solver at 1 ms for HIL compatibility"] |
| C2 | [Constraint — e.g., "Must generate C code via Embedded Coder"] |
| C3 | [Constraint — e.g., "Controller sample time is 10 ms, sensor inputs arrive at 5 ms"] |
| C4 | [Constraint — e.g., "Target processor: single-precision float only"] |

---

## 3. Architecture

### 3.1 Functional Decomposition Diagram

*Show the algorithm's internal structure as a signal flow diagram. Annotate rates where components run at different sample times. Adapt to the algorithm type — the decomposition pattern depends on the domain.*

```
[Replace with actual decomposition diagram for this algorithm]
```

*Common patterns: feedback controller (error → control law → limiting → output), estimator (measurement → prediction/correction → estimate), diagnostic (signal → feature extraction → decision logic → fault flag), signal chain (input → conditioning → processing → output). Choose what fits.*

### 3.2 Component Catalog

*All components with their implementation type and interface summary.*

| Component | Implementation | Function | Ports (key I/O) | Rate / Sample Time | DFT | Dependencies |
|-----------|---------------|----------|------------------|--------------------|-----|--------------|
| **[Name]** | [Subsystem / Stateflow Chart / MATLAB Function / Library / Model Reference] | [What it computes] | [In: a, b → Out: c, d] | [e.g., 10 ms] | [Yes / No] | [What it uses] |
| **[Name]** | [Type] | [Function] | [Ports] | [Rate] | [Yes / No] | [Dependencies] |

*Implementation types:*
- *Subsystem: Inline subsystem within the model*
- *Stateflow Chart: State machine or flow chart for mode/event logic*
- *MATLAB Function: MATLAB Function block for algorithmic code*
- *Library: From Simulink or toolbox library (e.g., PID Controller block)*
- *Model Reference: Separate model file for reuse or incremental builds*

*DFT (Direct Feedthrough): Yes / No / Partial. "Yes" if all input→output paths are instantaneous, "No" if none are (state-holding), "Partial" if some ports are DFT and others are not. For Partial, document which input→output paths are DFT in the component's §4 details. A cycle of all-DFT paths forms an algebraic loop.*

### 3.3 Signal Flow

*Trace the primary input → processing → output path. Show where mode logic controls flow (enable/disable, gain switching, output selection).*

```
sensor ──→ [Preprocessing] ──→ [Estimator] ──→ [Control Law] ──→ [Limiting] ──→ cmd
                                                     ▲                │
                                                     │           anti-windup
                                              mode ──┘
                                         (from Mode Manager)
```

*For multi-path algorithms, show each path and the switching/blending logic.*

---

## 4. Component Details

*Per-component section. Define purpose, interface, and behavior.*

### 4.1 [Component Name]

**Purpose:** *One line — what this component computes*

**Implementation:** *Subsystem / Stateflow Chart / MATLAB Function / Library / Model Reference*

**Interface:**

| Port | Direction | Signal Name | Unit | Data Type | Sample Time |
|------|-----------|-------------|------|-----------|-------------|
| u1 | Input | [name] | [unit] | [e.g., single] | [e.g., 10 ms] |
| u2 | Input | [name] | [unit] | [type] | [rate] |
| y1 | Output | [name] | [unit] | [type] | [rate] |

**Behavior:**
- *Algorithm or equations that define what this component computes. Use parameter symbols (e.g., `Kp`, `tau_f`) — define in calibration table (§6.5).*
- *For control laws: governing equations (e.g., `u = Kp * e + Ki * ∫e dt`)*
- *For Stateflow charts: states, key transitions, temporal logic patterns (e.g., `after(500, msec)`)*
- *For estimators: filter structure, update equations, reset conditions*
- *Modes or conditional logic that affect computation*
- *Edge cases: what happens at saturation, at zero input, on first execution*

**Dependencies:** *What other components, bus signals, or calibration data it needs*

### 4.2 [Component Name]

*Continue for each component...*

---

## 5. Mode Logic

*Skip this section if the algorithm has a single operating mode.*

*How the algorithm's operating modes are managed. Typically implemented as a Stateflow chart.*

### 5.1 Mode Definitions

| Mode | Description | Entry Condition |
|------|-------------|-----------------|
| [Off / Standby] | [What the algorithm does in this mode] | [Condition — e.g., "enable == false"] |
| [Initialize] | [Description] | [Condition] |
| [Active] | [Description] | [Condition] |
| [Fault] | [Description] | [Condition] |

**Default mode:** *[Which mode on first execution]*

### 5.2 Transitions

*Key transition rules. For complex charts, describe the arbitration logic rather than listing every transition.*

| From | To | Condition | Action on Entry |
|------|----|-----------|-----------------|
| [Off] | [Initialize] | [Condition] | [e.g., "Reset integrators, load IC from NVM"] |
| [Initialize] | [Active] | [Condition] | [e.g., "Set output = last known value for bumpless transfer"] |
| [Active] | [Fault] | [Condition] | [e.g., "Freeze output, set fault flag"] |

### 5.3 Bumpless Transfer

*How the algorithm handles transitions without output discontinuities. Describe the strategy (e.g., integrator preloading, output tracking, ramp-to-new-setpoint).*

---

## 6. Cross-Cutting Concerns

### 6.1 Anti-Windup & Integrator Management

| Concern | Approach |
|---------|----------|
| **Anti-windup strategy** | [e.g., "Clamping — disable integration when output saturated"] |
| **Integrator reset** | [When and how integrators are reset — mode transitions, external command] |
| **Integrator IC** | [How initial conditions are set — zero, preloaded, from NVM] |

### 6.2 Saturation & Rate Limiting

| Signal | Limit Type | Values | Rationale |
|--------|-----------|--------|-----------|
| [cmd] | Saturation | [min, max] | [Why — actuator physical limits, safety] |
| [cmd] | Rate limit | [±rate/sec] | [Why — actuator slew rate, comfort] |

### 6.3 Numerical Safety

| Concern | Approach |
|---------|----------|
| **Division-by-zero** | [Where denominators can be zero, guard strategy — e.g., `max(x, eps)`] |
| **Overflow protection** | [Signals at risk, mitigation — saturation blocks, data type choice] |
| **Precision** | [Whether single-precision is sufficient, where double may be needed] |

### 6.4 Rate Transitions

*Skip if single-rate algorithm.*

| Fast Rate | Slow Rate | Signal(s) | Transition Method |
|-----------|-----------|-----------|-------------------|
| [5 ms] | [10 ms] | [sensor_filtered] | [e.g., "Rate Transition block, ensure data integrity"] |

### 6.5 Calibration Parameter Management

| Approach | Details |
|----------|---------|
| **Storage** | [MATLAB workspace / Data Dictionary / Simulink.Parameter objects] |
| **Naming convention** | [e.g., "Cal_<Component>_<Param>" — `Cal_PID_Kp`] |
| **Grouping** | [How parameters are organized — by component, by function, by tune-frequency] |
| **Tunability** | [Which parameters are tunable at run-time vs. compile-time constants] |

### 6.6 Code Generation Considerations

*Skip if simulation-only.*

| Concern | Approach |
|---------|----------|
| **Target data types** | [single / double / fixed-point] |
| **Function packaging** | [Reusable function / nonreusable / atomic subsystem] |
| **Storage classes** | [ExportedGlobal, ImportedExtern, etc. — for calibration and measurement signals] |
| **Header/source file naming** | [Convention if any] |

### 6.7 Algebraic Loop Prevention

*Skip if purely continuous plant model with no code generation target.*

| Concern | Approach |
|---------|----------|
| **Feedback paths** | [List each feedback loop and its delay mechanism — Unit Delay (discrete) or Integrator/Transfer Fcn (continuous)] |
| **Initial conditions** | [IC value and rationale for each delay element] |
| **Delay impact** | [Does the one-step delay affect stability or performance? Cite analysis if non-trivial] |
| **Stateflow in loops** | [Use Moore semantics for charts whose outputs feed back to their inputs] |

---

## 7. Key Decisions

*Important design decisions with rationale.*

| # | Decision | Options Considered | Choice | Rationale |
|---|----------|-------------------|--------|-----------|
| 1 | [What was decided] | (a) [option], (b) [option] | [choice] | [Why] |
| 2 | [What was decided] | ... | ... | ... |

---

## 8. Known Limitations & Deferred Items

| Item | Description | Rationale for Deferral |
|------|-------------|------------------------|
| [Limitation] | [What's limited and impact] | [Why acceptable for now] |
| [Deferred item] | [What's not implemented] | [Why deferred] |

---

## Appendix A: Related Documents

- [System Spec](path) — Requirements and operating scenarios
- [Implementation Plan](path) — Build phases and order
- [Test Plan](path) — Test cases and pass/fail criteria

## Appendix B: API Verification Notes

*For each API/function/block not already used in neighboring codebase files, record:*
- *API name and source (MATLAB built-in, toolbox, Simulink library block, external library)*
- *Confirmed signature and behavior (tested via `evaluate_matlab_code`, `web_search`, or `librarian`)*
- *Edge case behavior (empty inputs, error returns, missing dependencies)*
- *Any corrections made to §4 Component Details based on verification*

*If ALL APIs/blocks are already used in existing models or scripts, write: "All APIs verified by existing usage in: [list files]."*

*This appendix is required. It ensures builder agents have accurate patterns and prevents specs from assuming API behavior that doesn't match reality.*

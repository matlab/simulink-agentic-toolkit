# Plant Model Architecture Spec Template

Focus on physics decomposition, port-based interfaces, and equations of motion — not Simulink block details.

---

# [Plant Model Name] Architecture

## Status: Draft
**Last Updated:** [Date]  
**Author:** [Name]  
**Parent Spec:** [Link to System Spec]

---

## 1. Overview

*1 paragraph: Scope of this architecture. What plant model does this cover, what controller does it interface with, and what fidelity level was chosen?*

---

## 2. Goals, Non-Goals & Constraints

### 2.1 Design Goals

*Goals that shape the plant model architecture.*

| ID | Goal |
|----|------|
| G1 | [Design goal — e.g., "Clean separation between electrical and mechanical domains"] |
| G2 | [Design goal — e.g., "All parameters externally configurable for sensitivity analysis"] |

### 2.2 Non-Goals

| ID | Non-Goal | Rationale |
|----|----------|-----------|
| NG1 | [Not doing] | [Why not in scope] |

### 2.3 Constraints

*External limitations: solver requirements, real-time constraints, toolbox availability, controller interface fixed.*

| Constraint | Description |
|------------|-------------|
| C1 | [Constraint — e.g., "Must run with fixed-step solver for HIL compatibility"] |
| C2 | [Constraint — e.g., "Controller interface signals and sample times are fixed"] |

---

## 3. Architecture

### 3.1 Subsystem Diagram

*Draw the actual physics decomposition for this plant model. Show signal flow with u/w/y/z labels. Adapt to the domain — not all plants follow the actuator→dynamics→sensor pattern.*

```
[Replace with actual subsystem diagram]
```

### 3.2 Component Catalog

*All subsystems with their physics domain, states, and port interfaces.*

| Component | Implementation | Physics Domain | States | Port Interface | Dependencies |
|-----------|---------------|----------------|--------|----------------|--------------|
| **[Name]** | [Subsystem / Subsystem Ref / Model Ref / Library] | [Domain — e.g., "Electrical"] | [State list — e.g., "I_L, V_C"] | [Key ports — e.g., "In: D, V_in → Out: V_out, I_L"] | [What it uses] |
| **[Name]** | [Type] | [Domain] | [States] | [Ports] | [Dependencies] |

*Implementation types:*
- *Subsystem: Inline subsystem within the model*
- *Subsystem Reference: Reusable subsystem stored as separate .slx*
- *Model Reference: Separate model file, enables independent development and incremental builds*
- *Library block: From Simulink or toolbox library*

### 3.3 Signal Flow

*How signals flow through subsystems. Trace u → dynamics → y path, showing where w enters and z is tapped.*

```
u ──→ [Actuator] ──→ [Dynamics] ──→ [Sensor] ──→ y
                         ▲              │
                         │              └──→ z (truth)
                    w ───┘
```

---

## 4. Subsystem Details

*Per-subsystem section. Define the interface and behavior.*

### 4.1 [Subsystem Name]

**Purpose:** *One line — what physics this subsystem models*

**Implementation:** *Subsystem / Subsystem Reference / Model Reference / Library block*

**Interface:**

| Direction | Port | Signal Name | Unit | Description |
|-----------|------|-------------|------|-------------|
| Input | u1 | [name] | [unit] | [description] |
| Input | u2 | [name] | [unit] | [description] |
| Output | y1 | [name] | [unit] | [description] |
| Output | y2 | [name] | [unit] | [description] |

**Behavior:**
- *What physical behavior this subsystem captures (not how it's implemented in blocks)*
- *Key modes or operating regions*
- *What it does NOT model (simplifications)*

**Dependencies:** *What other subsystems or external data it needs*

### 4.2 [Subsystem Name]

*Continue for each subsystem...*

---

## 5. Equations of Motion

*Per-subsystem equations. This is the core technical content of the plant model architecture.*

### 5.1 [Subsystem Name]

**State Variables:**

| Symbol | Description | Unit | Initial Value |
|--------|-------------|------|---------------|
| [x₁] | [description] | [unit] | [value] |

**Differential Equations:**

```
ẋ₁ = f₁(x, u, w, p)
ẋ₂ = f₂(x, u, w, p)
```

*Write the actual equations with parameter symbols. Use consistent notation.*

**Algebraic Equations:**

*Any algebraic constraints (if DAE system).*

**Output Equations:**

```
y₁ = g₁(x, u, w, p)
```

### 5.2 [Subsystem Name]

*Continue for each subsystem...*

---

## 6. Nonlinearities & Constraints

*Explicit placement of nonlinear elements. Critical to get the right subsystem.*

| Nonlinearity | Type | Location (Subsystem) | Parameters | Physical Basis |
|-------------|------|---------------------|------------|----------------|
| [Name] | [Saturation / dead zone / backlash / rate limit / lookup table] | [Which subsystem] | [Limits, values] | [Why it exists physically] |

---

## 7. Cross-Cutting Concerns

### 7.1 Numerical Considerations

| Concern | Approach |
|---------|----------|
| **Solver selection** | [Recommended solver and why] |
| **Stiffness** | [Whether system is stiff, which subsystems, mitigation] |
| **Algebraic loops** | [Risk assessment and prevention strategy] |
| **Zero-crossing detection** | [If discontinuities exist, how handled] |

### 7.2 Parameter Management

| Approach | Details |
|----------|---------|
| **Storage** | [MATLAB workspace / Data Dictionary / mask parameters] |
| **Naming convention** | [How parameters are named — e.g., "subsystem_param" format] |
| **Units** | [How units are tracked — comments, Simulink units, variable names] |

### 7.3 Simulation Performance

| Concern | Approach |
|---------|----------|
| **Target speed** | [X× real-time] |
| **Bottleneck subsystems** | [Which subsystems are computationally expensive] |
| **Optimization opportunities** | [Lookup tables vs equations, sample time separation] |

---

## 8. Uncertainty & Sensitivity Hooks

*Parameters intended for sensitivity sweeps and robustness analysis.*

| Parameter | Nominal | Range | Subsystem | Rationale for Sweep |
|-----------|---------|-------|-----------|---------------------|
| [param] | [value] | [min – max] | [subsystem] | [Why this parameter matters for robustness] |

---

## 9. Key Decisions

| # | Decision | Options Considered | Choice | Rationale |
|---|----------|-------------------|--------|-----------|
| 1 | [What was decided] | (a) [option], (b) [option] | [choice] | [Why] |

---

## 10. Known Limitations & Deferred Items

| Item | Description | Rationale for Deferral |
|------|-------------|------------------------|
| [Limitation] | [What's limited and impact] | [Why acceptable] |

---

## Appendix A: Related Documents

- [System Spec](system.md) — Requirements and operating scenarios
- [Implementation Plan](implementation_plan.md) — Build phases and order
- [Test Plan](test_plan.md) — Validation maneuvers and criteria

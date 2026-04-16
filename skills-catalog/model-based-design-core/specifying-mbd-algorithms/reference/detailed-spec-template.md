# MBD Algorithm Detailed Spec Template

Create BEFORE architecture when architecture is blocked without this precise definition. Use when the control law, state machine, or interface contract must be worked out first.

**Skip when:** Architecture §4 Component Details can capture the definition inline.

---

# [Topic] Specification

## Status: Draft
**Last Updated:** [Date]  
**Author:** [Name]  
**Parent Spec:** [Link to System Spec]

---

## 1. Overview

*What this spec defines and why precise definition is needed before architecture. Name the components that depend on this contract.*

---

## 2. Design Rationale

*Why this approach vs alternatives. What constraints shaped the design?*

| Consideration | Approach | Rationale |
|---------------|----------|-----------|
| [Aspect] | [Choice made] | [Why] |

---

## 3. Specification

*The precise definition. Use the variant that fits — delete the others.*

### For Control Laws

#### 3.1 Governing Equations

*Control law equations with parameter symbols. Define all variables and their units.*

#### 3.2 Gain Scheduling

*Scheduling variable(s), breakpoints, interpolation method, gain values or lookup table structure.*

#### 3.3 Anti-Windup & Limiting

*Anti-windup scheme, saturation limits, rate limits — with values and rationale.*

#### 3.4 Tuning Parameters

| Parameter | Symbol | Unit | Default | Range | Tuning Guidance |
|-----------|--------|------|---------|-------|-----------------|
| [name] | [sym] | [unit] | [value] | [min, max] | [effect on behavior] |

### For State Machines

#### 3.1 States

| State | Description | Entry Action | During Action | Exit Action |
|-------|-------------|-------------|---------------|-------------|
| [name] | [meaning] | [action] | [action] | [action] |

#### 3.2 Transitions

| From | To | Condition | Priority | Action |
|------|----|-----------|----------|--------|
| [state] | [state] | [guard condition] | [1=highest] | [transition action] |

#### 3.3 Temporal Logic

*Debounce timers, delay-on/delay-off patterns, fault persistence counters.*

#### 3.4 Arbitration

*How conflicting transitions are resolved. Priority scheme, hierarchy, or explicit guards.*

### For Interface Contracts

#### 3.1 Bus Definition

| Signal | Direction | Unit | Data Type | Sample Time | Range | Description |
|--------|-----------|------|-----------|-------------|-------|-------------|
| [name] | [in/out] | [unit] | [type] | [rate] | [min, max] | [description] |

#### 3.2 Timing & Sequencing

*Signal ordering, initialization sequence, valid data indicators, first-execution behavior.*

#### 3.3 Coordinate Frames & Sign Conventions

*Reference frames, positive direction definitions, transformation conventions.*

---

## 4. Examples

*Concrete input/output examples showing expected behavior. Critical for implementers.*

### Example 1: [Case Name]

*Context: [Operating condition]*

| Input | Value |
|-------|-------|
| [signal] | [value with unit] |

| Output | Expected Value |
|--------|---------------|
| [signal] | [value with unit] |

*Explanation: [What this demonstrates]*

---

## 5. Boundary Conditions

*Behavior at edges — these are where bugs live.*

| Case | Input Condition | Expected Behavior |
|------|----------------|-------------------|
| [Saturation] | [signal at limit] | [what happens] |
| [Zero-crossing] | [signal crosses zero] | [what happens] |
| [Mode boundary] | [at enable/disable threshold] | [what happens] |
| [First execution] | [no prior state] | [initialization behavior] |

---

## Appendix A: Related Documents

- [System Spec](path) — Requirements and scenarios
- [Architecture Spec](path) — Components that implement this contract
